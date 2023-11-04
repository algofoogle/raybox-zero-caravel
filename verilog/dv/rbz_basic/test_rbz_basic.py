import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, Timer, with_timeout
from cocotb.types import Logic
import random
import re

CLOCK_PERIOD = 40.0 # ns
HIGH_RES = None #10.0 # If not None, scale H res by this, and step by CLOCK_PERIOD/HIGH_RES instead of unit clock cycles.



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

    print("Firmware is running (configuring IO pads)")

    # Wait for design's reset to be released:
    #SMELL: This relies on an internal signal that will disappear
    # during GL, but I don't have enough IOs to do anything about
    # that. About the best I could do is change the design to
    # assert a given known state immediately upon coming out
    # of reset (or rather, while IN reset).
    await FallingEdge(dut.design_reset)

    print("Design is now exiting the reset state")

# Basic test, follows test_start above.
# Renders 1 full frame (800x525 clocks) +1 clock to show
# that hpos/vpos reset.
@cocotb.test()
async def test_all(dut):
    hrange = 800
    vrange = 525*2 #NOTE: Can multiply this by number of frames desired.
    hres = HIGH_RES or 1

    print("Rendering first full frame...")
    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())
    # Create PPM file to visualise the frame, and write its header:
    img = open("rbz_basic_frame0.ppm", "w")
    img.write("P3\n")
    img.write(f"{hrange*hres} {vrange}\n")
    img.write("255\n")

    for n in range(vrange): # 525 lines
        print(f"Rendering line {n}")
        for n in range(hrange*hres): # 800 pixel clocks per line.
            if n % 100 == 0:
                print('.', end='')
            if 'x' in dut.o_gpout.value.binstr:
                # Output is unknown; make it green:
                r = 0
                g = 255
                b = 0
            else:
                b0 = dut.o_gpout0.value  # LA-overridden gpout0 is Blue low bit.
                b1 = dut.o_gpout1.value  # LA-overridden gpout1 is Blue high bit.
                r0 = dut.o_gpout2.value  # LA-overridden gpout2 is Red low bit.
                r1 = dut.o_gpout3.value  # LA-overridden gpout3 is Red high bit.
                hsyncb = 255 if dut.o_hsync.value.binstr=='x' else (0==dut.o_hsync.value)*0b110000
                vsyncb = 128 if dut.o_vsync.value.binstr=='x' else (0==dut.o_vsync.value)*0b110000
                r = (r1<<7) | (r0<<6) | hsyncb
                g = 0 | vsyncb
                b = (b1<<7) | (b0<<6)
            img.write(f"{r} {g} {b}\n")
            if HIGH_RES is None:
                await ClockCycles(dut.clk, 1) 
            else:
                await Timer(hres, units='ns')
    print("Waiting 1 more clock, for start of next line...")
    await ClockCycles(dut.clk, 1)
    img.close()
    print("DONE")
