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
        
        # 执行写
        resp = await self.agent.write(addr, data)
        assert resp[0]['resp'].name == 'OKAY', f"写操作失败：{resp[0]['resp']}"
        
        self.agent.dut._log.info(f"运行单次读序列：Addr={hex(addr)}")
        
        # 执行读
        read_resp = await self.agent.read(addr)
        
        # 【关键修复】
        # 1. 获取返回的字典中的 'data' 字段 (这是一个字符串，如 "0xdeadbeef")
        raw_data_str = read_resp[0]['data']
        
        # 2. 将十六进制字符串转换为整数
        read_data_int = int(raw_data_str, 16)
        
        self.agent.dut._log.info(f"读取到的数据 (整型): {hex(read_data_int)}")
        
        # 3. 返回整数，这样测试函数里的 assert 就能正常工作了
        return read_data_int
