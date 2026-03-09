######################################################################
#
# DESCRIPTION: Verilator Example: --protect-lib Makefile
#
# This calls the object directory makefiles.  That allows the objects to
# be placed in the "current directory" which simplifies the Makefile.
#
# This file ONLY is placed under the Creative Commons Public Domain
# SPDX-FileCopyrightText: 2020 Wilson Snyder
# SPDX-License-Identifier: CC0-1.0
#
######################################################################
# Check for sanity to avoid later confusion

ifneq ($(words $(CURDIR)),1)
  $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

######################################################################
# Set up variables

# If $VERILATOR_ROOT isn't in the environment, we assume it is part of a
# package install, and verilator is in your path. Otherwise find the
# binary relative to $VERILATOR_ROOT (such as when inside the git sources).

ifeq ($(VERILATOR_ROOT),)
  VERILATOR = verilator
  VERILATOR_COVERAGE = verilator_coverage
else
  export VERILATOR_ROOT
  VERILATOR = $(VERILATOR_ROOT)/bin/verilator
  VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

VERILATOR_FLAGS =
# Generate C++
VERILATOR_FLAGS += -cc --exe
# Optimize
VERILATOR_FLAGS += -x-assign fast
# Warn abount lint issues; may not want this on less solid designs
VERILATOR_FLAGS += -Wall
# This example does not use vl_time_stamp but rather
# VerilatedContext::timeInc(), so to avoid a linker error on cygwin which
# does not support weak symbols, we need to define VL_TIME_CONTEXT *in CPP*
# to not compile in the vl_time_stamp using code.
VERILATOR_FLAGS += -CFLAGS -DVL_TIME_CONTEXT
# Make waveforms
VERILATOR_FLAGS += --trace-vcd
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert
# Generate coverage analysis
VERILATOR_FLAGS += --coverage

# Input files for Verilator
VERILATOR_INPUT =  ./src/top.sv ./src/adder_01.sv sim_main.cpp



######################################################################
default: run

run:
	@echo
	@echo "-- Verilator tracing example"

	@echo
	@echo "-- VERILATE ----------------"
	#调用 Verilator 转换设计，生成 obj_dir 目录及其中的 C++ 模型和 Vtop.mk
	
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)
	@echo
	@echo "-- BUILD -------------------"
# To compile, we can either
# 1. Pass --build to Verilator by editing VERILATOR_FLAGS above.
# 2. Or, run the make rules Verilator does:
#	$(MAKE) -j -C obj_dir -f Vtop.mk
# 3. Or, call a submakefile where we can override the rules ourselves:
	#进入 obj_dir 目录，使用 -f ../Makefile_obj 调用另一个 Makefile 来编译模型。
	$(MAKE) -j -C obj_dir -f ../Makefile_obj

	@echo
	@echo "-- RUN ---------------------"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/Vtop +trace

	@echo
	@echo "-- COVERAGE ----------------"
	@rm -rf logs/annotated
	$(VERILATOR_COVERAGE) --annotate logs/annotated logs/coverage.dat

	@echo
	@echo "-- DONE --------------------"
	@echo "To see waveforms, open vlt_dump.vcd in a waveform viewer"
	@echo

######################################################################
# Other targets

show-config:
	$(VERILATOR) -V

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir logs *.log *.dmp *.vpd coverage.dat core

