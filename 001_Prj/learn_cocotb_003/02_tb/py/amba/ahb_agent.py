# tests/ahb_agent.py
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotbext.ahb import AHBBus, AHBLiteMaster, AHBMonitor, AHBResp
from .config import AHBConfig

class AHBAgent:
    """
    AHB Agent: 封装总线的驱动和监视功能。
    类似于 UVM 中的 Agent 概念。
    """
    def __init__(self, dut, config: AHBConfig):
        self.dut = dut
        self.config = config
        self.bus = None
        self.master = None
        self.monitor = None
        self._initialized = False

    async def reset(self):
        """执行复位序列"""
        clk_sig = getattr(self.dut, self.config.signal_map["hclk"])
        rst_sig = getattr(self.dut, self.config.signal_map["hresetn"])
        
        self.dut._log.info("执行复位...")
        rst_sig.value = 0 # 假设低电平复位
        await ClockCycles(clk_sig, self.config.reset_cycles)
        rst_sig.value = 1
        await ClockCycles(clk_sig, 2) # 稳定期

    def start_clock(self):
        """启动时钟"""
        clk_sig = getattr(self.dut, self.config.signal_map["hclk"])
        cocotb.start_soon(Clock(clk_sig, self.config.clock_period_ns, units="ns").start())
        self.dut._log.info(f"时钟已启动，周期={self.config.clock_period_ns}ns")

    def build(self):
        """构建组件 (Bus, Master, Monitor)"""
        if self._initialized:
            return
        
        # 1. 创建 Bus 映射 (方式 C)
        try:
            self.bus = AHBBus.from_prefix(
                self.dut, 
                prefix="", 
                signals=self.config.signal_map,
                optional_signals=["hsel"]
            )
        except AttributeError as e:
            self.dut._log.error(f"信号映射失败：{e}")
            raise e

        clk_sig = getattr(self.dut, self.config.signal_map["hclk"])
        rst_sig = getattr(self.dut, self.config.signal_map["hresetn"])

        # 2. 实例化 Master (Driver)
        self.master = AHBLiteMaster(
            bus=self.bus,
            clock=clk_sig,
            reset=rst_sig,
            reset_active_level=1,
            timeout=self.config.timeout_cycles,
            name="ahb_master"
        )

        # 3. 实例化 Monitor (可选，用于自动收集事务)
        self.monitor = AHBMonitor(
            bus=self.bus,
            clock=clk_sig,
            reset=rst_sig,
            reset_active_level=1,
            callback=self._monitor_callback, # 可以定义回调处理捕获的数据
            name="ahb_monitor"
        )

        self._initialized = True
        self.dut._log.info("AHB Agent 构建完成 (Master + Monitor)")

    async def write(self, addr, data, size=4):
        """高级写接口"""
        if not self._initialized: self.build()
        if isinstance(addr, int): addr = [addr]
        if isinstance(data, int): data = [data]
        return await self.master.write(address=addr, value=data, size=size)

    async def read(self, addr, size=4):
        """高级读接口"""
        if not self._initialized: self.build()
        if isinstance(addr, int): addr = [addr]
        return await self.master.read(address=addr, size=size)

    def _monitor_callback(self, transaction):
        """Monitor 捕获到事务时的回调"""
        # 这里可以添加逻辑：打印日志、存入队列供 Scoreboard 使用
        pass
