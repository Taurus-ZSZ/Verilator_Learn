# tests/sequences.py
import numpy as np
from amba.config import AHBConfig

class BaseSequence:
    def __init__(self, agent, config: AHBConfig):
        self.agent = agent
        self.config = config

class NoiseBurstSequence(BaseSequence):
    """
    专门用于生成和传输噪声数据的序列。
    封装了 NumPy 生成逻辑和 AHB 突发传输逻辑。
    """
    async def run(self, num_samples=64, bit_width=7, seed=None):
        self.agent.dut._log.info(f"运行噪声突发序列：样本数={num_samples}, 位宽={bit_width}")
        
        # 1. 生成数据 (NumPy)
        if seed: np.random.seed(seed)
        max_val = (1 << bit_width) - 1
        data = np.random.randint(0, max_val + 1, size=num_samples, dtype=np.uint32).tolist()
        
        # 2. 构造地址
        addr_list = [self.config.base_addr + i * self.config.data_width_bytes for i in range(num_samples)]
        
        # 3. 执行传输
        resp = await self.agent.write(addr_list, data, size=self.config.data_width_bytes)
        
        # 4. 简单自检 (也可以由 Test 层做详细比对)
        for i, r in enumerate(resp):
            if r['resp'].name != 'OKAY':
                raise AssertionError(f"序列执行失败 at index {i}: {r['resp']}")
        
        self.agent.dut._log.info("噪声突发序列执行成功")
        return data, addr_list

class SingleRWSequence(BaseSequence):
    """单次读写序列"""
    async def run(self, addr, data):
        self.agent.dut._log.info(f"运行单次写序列：Addr={hex(addr)}, Data={hex(data)}")
        resp = await self.agent.write(addr, data)
        assert resp[0]['resp'].name == 'OKAY'
        
        self.agent.dut._log.info(f"运行单次读序列：Addr={hex(addr)}")
        read_resp = await self.agent.read(addr)
        return read_resp[0]['data']
