# tests/env.py
from amba.config import AHBConfig
from amba.ahb_agent import AHBAgent

class AHVEnv:
    """
    验证环境顶层。
    负责实例化 Agent 并协调全局行为。
    """
    def __init__(self, dut):
        self.dut = dut
        self.config = AHBConfig()
        self.agent = AHBAgent(dut, self.config)

    async def startup(self):
        """环境启动流程： 构建 -> 时钟 -> 复位"""
        self.agent.build()
        self.agent.start_clock()
        await self.agent.reset()
        self.dut._log.info("=== 验证环境启动完成 ===")
