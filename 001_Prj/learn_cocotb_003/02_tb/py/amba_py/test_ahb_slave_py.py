from __future__ import annotations

import logging
import cocotb
from cocotb import start_soon
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge,RisingEdge,NextTimeStep,Timer,ReadOnly

print("Enter ahb slave test by python")

class AHBbus:
    def __init__(self,dut):
        self.hclk       = dut.HCLK   
        self.hresetn    = dut.HRESETn
        self.hselx      = dut.HSELx  
        self.hwrite     = dut.HWRITE   
        self.hready     = dut.HREADY   
        self.hsize      = dut.HSIZE    
        self.hburst     = dut.HBURST   
        self.hprot      = dut.HPROT    
        self.htrans     = dut.HTRANS   
        self.hmastlock  = dut.HMASTLOCK
        self.haddr      = dut.HADDR    
        self.hwdata     = dut.HWDATA   
        self.ready_ctrl = dut.READY_CTRL
        self.hreadyout  = dut.HREADY    
        self.hresp      = dut.HRESP     
        self.hrdata     = dut.HRDATA    




