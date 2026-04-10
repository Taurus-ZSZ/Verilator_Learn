from asyncio import Queue
import cocotb

from cocotb.triggers import FallingEdge
from pyuvm import QueueEmpty


def get_int(signal):
    try:
        int_val = int(signal.value)
    except ValueError:
        int_val = 0
    return int_val


class alu_bfm:
    def __init__(self):
        self.dut = cocotb.top
        self.cmd_driver_queue = Queue(maxsize=1)
        self.cmd_mon_queue = Queue(maxsize=0)
        self.result_mon_queue = Queue(maxsize=0)

    async def reset(self):
        await FallingEdge(self.dut.clk)
        self.dut.reset_n.value = 0
        self.dut.A.value = 0
        self.dut.B.value = 0
        self.dut.op.value = 0
        await FallingEdge(self.dut.clk)
        self.dut.reset_n.value = 1
        await FallingEdge(self.dut.clk)

    async def result_mon(self):
        prev_done = 0
        while True:
            await FallingEdge(self.dut.clk)
            done = get_int(self.dut.done)
            if prev_done == 0 and done == 1:
                result = get_int(self.dut.result)
                self.result_mon_queue.put_nowait(result)
            prev_done = done

    async def cmd_mon(self):
        prev_start = 0
        while True:
            await FallingEdge(self.dut.clk)
            start = get_int(self.dut.start)
            if start == 1 and prev_start == 0:
                cmd_tuple = (
                    get_int(self.dut.A),
                    get_int(self.dut.B),
                    get_int(self.dut.op),
                )
                self.cmd_mon_queue.put_nowait(cmd_tuple)

            prev_start = start

    async def cmd_driver(self):
        self.dut.start.value = 0
        self.dut.A.value = 0
        self.dut.B.value = 0
        self.dut.op.value = 0
        while True:
            await FallingEdge(self.dut.clk)
            st = get_int(self.dut.start)
            dn = get_int(self.dut.done)
            if start == 0 and done == 0:
                try:
                    (aa, bb, op) = self.driver_queue.get_nowait()
                    self.dut.A <= aa
                    self.dut.B <= bb
                    self.dut.op <= op
                except QueueEmpty:
                    continue
            elif st == 1:
                if dn == 1:
                    self.dut.start.value = 0

    def start_tasks(self):
        cocotb.start_soon(self.cmd_driver())
        cocotb.start_soon(self.cmd_mon())
        cocotb.start_soon(self.result_mon())

    async def get_cmd(self):
        cmd = await self.cmd_mon_queue.get()
        return cmd

    async def get_result(self):
        result = await self.result_mon_queue.get()
        return result

    async def send_op(self, aa, bb, op):
        command_tuple = (aa, bb, op)
        await self.cmd_driver_queue.put(command_tuple)
