from __future__ import annotations

import random
import logging
import cocotb
from cocotb import start_soon
from cocotb.clock import Clock 
from cocotb.triggers import FallingEdge,RisingEdge,NextTimeStep,Timer,ReadOnly

print("Loading apb test ")

class APB_Interface:
    def __init__(self, dut):
        self.clk  = dut.clk 
        self.PCLK = dut.clk
        self.PSEL = dut.PSEL
        self.PWRITE  = dut.PWRITE
        self.PENABLE = dut.PENABLE
        self.PREADY  = dut.PREADY
        self.PADDR   = dut.PADDR
        self.PWDATA  = dut.PWDATA
        self.PRDATA  = dut.PRDATA



def get_apb_signal(dut):
    return APB_Interface(dut)

async def gen_clk(clk):
    input_clk = Clock(clk,10,unit="ns")
    input_clk.start()
    while True:
        await RisingEdge(clk)

async def apb_write_once(PSELn,addr,wr_data, 
                         PCLK, PSEL, PWRITE, 
                         PENABLE, PREADY, PADDR,PWDATA):
    await FallingEdge(PCLK)
    #phase 1 
    await RisingEdge(PCLK)
    PWRITE.value = 1
    PSEL.value   = PSELn
    PADDR.value  = addr
    PWDATA.value = wr_data
    #phase 2 
    await RisingEdge(PCLK)
    PENABLE.value = 1
    
    await RisingEdge(PCLK)
    while(PREADY.value == 0):
        await RisingEdge(PCLK)
    #if PREADY = 1
    PSEL.value    = 0
    PENABLE.value = 0 
    
async def apb_read_once(PSELn,addr,rd_data, 
                        PCLK, PSEL, PWRITE, 
                        PENABLE, PREADY, PADDR,PRDATA):
    await FallingEdge(PCLK)
    #phase 1 
    await RisingEdge(PCLK)
    PWRITE.value = 0
    PSEL.value   = PSELn
    PADDR.value  = addr
    #phase 2 
    await RisingEdge(PCLK)
    PENABLE.value = 1
    
    await RisingEdge(PCLK)
    while(PREADY.value == 0):
        await RisingEdge(PCLK)
    #if PREADY = 1
    PSEL.value    = 0
    PENABLE.value = 0 
    rd_data       = PRDATA.value

@cocotb.test()
async def write_reg_sequence(dut):
    #PCLK = dut.clk
    #PSEL = dut.PSEL
    #PWRITE = dut.PWRITE
    #PENABLE = dut.PENABLE
    #PREADY  = dut.PREADY
    #PADDR   = dut.PADDR
    #PWDATA  = dut.PWDATA
    #PRDATA  = dut.PRDATA
    apb = get_apb_signal(dut)
    dut.clk.value = 0
    dut.i_a.value = 3
    dut.i_b.value = 9

    start_soon(gen_clk(apb.PCLK))

    await Timer(40,"ns")
    dut.rst_n.value = 1 
    await Timer(40,"ns")
    dut.i_a.value = 30
    dut.i_b.value = 60

    PSELn = 1
    for addr in range (16):
        wr_data = random.randint(0,9999)
        cocotb.log.info("PADDR={:4d},PWDATA={:4d},PWRITE={:1d}".format(addr,wr_data,1))
        await apb_write_once(PSELn,addr,wr_data,
                       apb.PCLK,apb.PSEL,apb.PWRITE,apb.PENABLE,
                       apb.PREADY,apb.PADDR,apb.PWDATA)
    await Timer(1,"us")

@cocotb.test()

async def read_reg_sequence(dut):
    await Timer(1,"us")
    PSELn = 1
    apb = get_apb_signal(dut)
    dut.clk.value = 0
    dut.i_a.value = 3
    dut.i_b.value = 9
    rd_data = 0
    start_soon(gen_clk(apb.PCLK))
    cocotb.log.info(" Start read reg test case")
    PSELn = 1
    for addr in range (16):
        wr_data = random.randint(0,9999)
        await apb_read_once(PSELn,addr,rd_data,
                       apb.PCLK,apb.PSEL,apb.PWRITE,apb.PENABLE,
                       apb.PREADY,apb.PADDR,apb.PWDATA)
        cocotb.log.info("PADDR={:4d},PRDATA={:4d},PWRITE={:1d}".format(addr,rd_data,0))
    await Timer(1,"us")



