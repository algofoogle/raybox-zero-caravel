import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, with_timeout
from cocotb.types import Logic
import random
import re

# Startup: Wait for the design to pulse gpio (to show firmware has started running)
# and then wait for our design's reset to be released to know it is starting from
# its known initial state.
@cocotb.test()
async def test_start(dut):
    # dut.VGND <= 0
    # dut.VPWR <= 1

    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())

    print("Clock started")
    
    # Start up with SOC reset asserted, and power off:
    dut.RSTB.value = 0
    dut.power1.value = 0
    dut.power2.value = 0
    dut.power3.value = 0
    dut.power4.value = 0

    print("Powering up")

    # Ramp up each of the power lines after 8 clock cycles, each:
    await ClockCycles(dut.clk, 8)
    dut.power1.value = 1
    await ClockCycles(dut.clk, 8)
    dut.power2.value = 1
    await ClockCycles(dut.clk, 8)
    dut.power3.value = 1
    await ClockCycles(dut.clk, 8)
    dut.power4.value = 1

    print("Powered up")

    # Keep SOC reset asserted for another 20 cycles, then release:
    await ClockCycles(dut.clk, 20)
    dut.RSTB.value = 1

    print("Coming out of reset")

    # SOC should now be running...

    # Wait for gpio pulse:
    await RisingEdge(dut.gpio)
    await FallingEdge(dut.gpio)

    print("Firmware is running")


# Basic test, follows test_start above.
# Renders 1 full frame (800x525 clocks) +1 clock to show
# that hpos/vpos reset.
@cocotb.test()
async def test_all(dut):
    print("Running PLL test...")
    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())
    for n in range(1,500):
        await ClockCycles(dut.clk, 1000)
        print(f"{n*1000} clocks")

    print("DONE")
