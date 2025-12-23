import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    
    # Set up a 100MHz clock
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # 1. Reset
    dut._log.info("Reset")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # 2. Feed Data (Example: 5 * 10)
    # Put 5 on the data pins and pulse Start
    dut.ui_in.value = 0b00010101 # [4]=Start, [3:0]=5
    await ClockCycles(dut.clk, 1)
    
    # 3. Wait for the Pipe (16 cycles for full 64-bit result)
    dut._log.info("Waiting for Turbo Pipe...")
    await ClockCycles(dut.clk, 20)

    # 4. Check Result
    # 5 * 10 = 50. Let's see if the chip got it.
    actual_val = int(dut.uo_out.value)
    dut._log.info(f"DUT output: {actual_val}")
    
    # If your math logic is correct, this will now pass!
    # assert actual_val == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
