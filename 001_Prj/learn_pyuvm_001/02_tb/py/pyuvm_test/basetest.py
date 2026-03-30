import pyuvm
from pyuvm import *


class BaseTest(uvm_test):
    async def run_phase(self):
        self.raise_objection()
        bfm = TinyAluBfm()
        scoreboard = Scoreboard()
        await bfm.reset()
        bfm.start_tasks()
        scoreboard.start_tasks()
        await self.tester.execute()
        passed = scoreboard.check_results()
        assert passed
        self.drop_objection()
