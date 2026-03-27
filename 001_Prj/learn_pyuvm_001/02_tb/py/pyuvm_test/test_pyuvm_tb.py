#import uvm_pkg::*;
import pyuvm
from pyuvm import *




@pyuvm.test()
class AluTest(uvm_test):
    def build_phase(self):
        self.env = AluEnv("env",self)

    def end_of_elaboration_phase(self):
        self.test_all = TestAllSeq.create("test_all")

    async def run_phase(self):
        self.raise_objection("Description")
        await self.test_all.start()
        self.drop_objection("Another description")
    
