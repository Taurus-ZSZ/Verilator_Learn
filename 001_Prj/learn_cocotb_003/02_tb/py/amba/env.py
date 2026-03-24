# tests/env.py
from .config import AHBConfig
from .ahb_agent import AHBAgent

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
        """环境启动流程：时钟 -> 复位 -> 构建"""
        self.agent.start_clock()
        await self.agent.reset()
        self.agent.build()
        self.dut._log.info("=== 验证环境启动完成 ===")
