import argparse
import sys
from pathlib import Path
from cocotb_tools.runner import get_runner

proj_path = Path(__file__).resolve().parent.parent

parser = argparse.ArgumentParser()
parser.add_argument('--module', choices=['counter', 'fifo', 'alu'], default='counter')
args = parser.parse_args()

if args.module == 'counter':
    hdl_toplevel = 'simple_counter'
    sources = [proj_path / 'hdl' / 'counter' / 'simple_counter.sv']
    test_module = 'counter.test_simple_counter'
elif args.module == 'fifo':
    hdl_toplevel = 'fifo'
    sources = [proj_path / 'hdl' / 'fifo' / 'fifo.sv',
               proj_path / 'hdl' / 'fifo' / 'fifo_ram.sv']
    test_module = 'fifo.test_fifo'
else: # alu
    hdl_toplevel = 'alu'
    sources = [proj_path / 'hdl' / 'alu' / 'alu.sv']
    test_module = 'alu.test_alu'

runner = get_runner('verilator')
runner.build(sources=sources, hdl_toplevel=hdl_toplevel, build_dir=f'sim/build/{args.module}')
runner.test(hdl_toplevel=hdl_toplevel, test_module=test_module, test_dir=f'sim/results/{args.module}')