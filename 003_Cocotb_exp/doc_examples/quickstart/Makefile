# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# Defaults
#SIM ?= icarus
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/simple_counter.sv
# use: VHDL_SOURCES for VHDL files

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = simple_counter

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = simple_counter_testcases


# ✅ 关键：将 trace 参数传递给 Verilator 的编译阶段
# Cocotb 会自动将这些参数传递给 verilator 命令
#EXTRA_ARGS += --trace --trace-fst
EXTRA_ARGS += --trace-fst
# 可选：优化编译速度 (Verilator 5.0 推荐)
#EXTRA_ARGS += --fst



# Enable waveform generation
WAVES = 1
#WAVE_FORMAT = fst


# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
