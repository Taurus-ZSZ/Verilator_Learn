SIM ?= verilator
TOPLEVEL_LANG ?= verilog

# 默认目标：仿真计数器
SIM_MODULE ?= apb_test
COCOTB_TOPLEVEL ?= top
COCOTB_TEST_MODULES ?= counter.tt_test_counter

# 根据模块设置 HDL 源文件路径
ifeq ($(SIM_MODULE),counter)
	COCOTB_TOPLEVEL = top
	COCOTB_TEST_MODULES = tt_test_counter
    VERILOG_SOURCES = $(PWD)/01_hdl/top.sv
    VERILOG_SOURCES += $(PWD)/01_hdl/counter/counter.sv
		export PYTHONPATH := $(PWD)/02_tb/py/counter:$(PYTHONPATH)
else ifeq ($(SIM_MODULE),apb_test)
    COCOTB_TOPLEVEL = top
    COCOTB_TEST_MODULES = test_test_apb
    VERILOG_SOURCES = $(PWD)/01_hdl/top.sv
    VERILOG_SOURCES += $(PWD)/01_hdl/counter/counter.sv
    VERILOG_SOURCES += $(PWD)/01_hdl/AMBA/APB/test_apb_wrapper.sv
    VERILOG_SOURCES += $(PWD)/01_hdl/AMBA/APB/apb_if.sv
    VERILOG_SOURCES += $(PWD)/01_hdl/AMBA/APB/regblock.sv
		export PYTHONPATH := $(PWD)/02_tb/py/counter:$(PYTHONPATH)
		export PYTHONPATH := $(PWD)/02_tb/py/apb:$(PYTHONPATH)
else ifeq ($(SIM_MODULE),fifo)
    COCOTB_TOPLEVEL = top
    COCOTB_TEST_MODULES = test_test_apb.py
    VERILOG_SOURCES = $(PWD)/hdl/fifo/fifo.sv $(PWD)/hdl/fifo/fifo_ram.sv
else ifeq ($(SIM_MODULE),alu)
    COCOTB_TOPLEVEL = alu
    COCOTB_TEST_MODULES = alu.test_alu
    VERILOG_SOURCES = $(PWD)/hdl/alu/alu.sv
endif

# Python 路径包含所有测试子目录
export PYTHONPATH := $(PWD)/02_tb/py/counter:$(PYTHONPATH)

# ✅ 新版推荐：通过 EXTRA_ARGS 传递所有波形选项
EXTRA_ARGS += --trace              # 启用波形跟踪
EXTRA_ARGS += --trace-fst           # 使用 FST 格式（更小更快）
EXTRA_ARGS += --trace-structs       # （可选）跟踪结构体信息


# 编译目录可以根据模块隔离
SIM_BUILD = 05_sim/build/$(SIM_MODULE)

include $(shell cocotb-config --makefiles)/Makefile.sim
