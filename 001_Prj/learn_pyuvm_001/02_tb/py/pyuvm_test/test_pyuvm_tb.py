# 在项目文件顶部
# flake8: noqa: F403, F405
# pylint: disable=wildcard-import, unused-wildcard-import
# import uvm_pkg::*;
import pyuvm
from pyuvm import *


@pyuvm.test()
class HellworldTest(uvm_test):
    async def run_phase(self):
        self.raise_objection()
        self.logger.info("Hell, world.")
        self.drop_objection()
