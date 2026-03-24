import cocotb
from .env import AHVEnv
from .sequences import SingleRWSequence, NoiseBurstSequence

@cocotb.test()
async def test_single_rw(dut):
    """测试 1：单次读写"""
    # 1. 实例化环境
    env = AHVEnv(dut)
    await env.startup()
    
    # 2. 实例化并运行序列
    seq = SingleRWSequence(env.agent, env.config)
    read_data = await seq.run(addr=0x1000, data=0xDEADBEEF)
    
    # 3. 断言
    assert read_data == 0xDEADBEEF, f"数据不匹配：期望 0xDEADBEEF, 实际 {hex(read_data)}"
    dut._log.info("✅ 单次读写测试通过")

@cocotb.test()
async def test_noise_burst(dut):
    """测试 2：噪声数据突发传输"""
    # 1. 实例化环境
    env = AHVEnv(dut)
    await env.startup()
    
    # 2. 运行噪声序列
    seq = NoiseBurstSequence(env.agent, env.config)
    original_data, addr_list = await seq.run(num_samples=100, bit_width=7, seed=42)
    
    # 3. 读回验证 (可以在序列里做，也可以在这里做，更灵活)
    dut._log.info("开始读回验证...")
    read_resp = await env.agent.read(addr_list, size=4)
    
    mask = (1 << 7) - 1
    for i in range(len(original_data)):
        expected = original_data[i]
        actual = read_resp[i]['data'] & mask
        assert actual == expected, f"索引 {i} 错误：期望 {expected}, 实际 {actual}"
        
    dut._log.info("✅ 噪声突发测试通过")
