# Makefile for Tiny Tapeout cocotb tests

# Simulation defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

# RTL Simulation: List all your Verilog files here
# $(PWD) is the test directory, so we go up one level to src
VERILOG_SOURCES += $(PWD)/../src/project.v

# TOPLEVEL is the name of the toplevel module in your Verilog file
TOPLEVEL = tt_um_aegis_x_turbo

# MODULE is the name of the Python test file (test.py)
MODULE = test

# Include the cocotb setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
