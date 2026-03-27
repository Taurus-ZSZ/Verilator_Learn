from __future__ import annotations

import random 
import logging
import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, RisingEdge, NextTimeStep, Timer, ReadOnly

print("Loading test_counter module")

async def gen_clk(clk):
    input_clk = Clock(clk,10,unit="ns")
    input_clk.start()
    while True:
        await RisingEdge(clk)
    


@cocotb.test()
async def test1(dut):
    logger = logging.getLogger("my_log")

    logger.debug("this is a debug message ") logger.info("this is an info message")
    logger.warning("this is a warning message")
    logger.error("this is an error message")
    logger.critical("this is an critical message")

    cocotb.log.info("This is an cocotb_log info message")
    cocotb.log.warning("This is a cocotb_log warning")
    cocotb.log.error("This is an cocotb_log error")

    cocotb.log.info("init system var")
    dut.clk.value = 0
    dut.rst_n.value= 0 
    dut.i_a.value =0
    dut.i_b.value =0
    # gen clk 
    start_soon(gen_clk(dut.clk))

    await Timer(6,"ns")
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1

    await Timer(20,"ns")
    dut.i_a.value =  23
    dut.i_b.value = -12
    cocotb.log.info("   a +   b = sum ")
    for _ in range(10):
        await Timer(20,"ns")
        a = random.randint(-30,60)
        b = random.randint(-30,60)
        dut.i_a.value = a
        dut.i_b.value = b
        #await Timer(2, units='ns')            # 等待组合逻辑稳定
        await ReadOnly()
        sum = dut.o_sum.value.to_signed()
        cocotb.log.info("{:3d} + {:3d} = {:4d}".format(a,b,(sum)))


    
