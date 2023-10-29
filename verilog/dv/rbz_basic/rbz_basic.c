#include <defs.h>
#include <stub.c>

// raybox_zero basic test of SNIPPET1_NoShare

/*
IO Control Registers

| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
|--------|-------|-------|--------|--------|-------|---------|---------|-------|-------|---------|
| Output: GPIO_MODE_USER_STD_OUTPUT         = 0000_0110_0000_1110 (0x1808)                       |
| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
| Input:  GPIO_MODE_USER_STD_INPUT_NOPULL   = 0000_0001_0000_1111 (0x0402)                       |
| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |
*/

void main()
{
    // Signal via the SoC's single 'gpio' pin that we're starting our main code execution...
    // Start with gpio=0:
    reg_gpio_out = 0;
    // Enable gpio OUTPUT:
    reg_gpio_mode1 = 1;
    reg_gpio_mode0 = 0;
    reg_gpio_ien = 1;
    reg_gpio_oe = 1;
    // Pulse gpio:
    reg_gpio_out = 1;
    reg_gpio_out = 0;

    // Our design uses IO[26:18]...
    // Configure how we want our IOs to behave:
    reg_mprj_io_18  = GPIO_MODE_USER_STD_OUTPUT;        // o_hsync
    reg_mprj_io_19  = GPIO_MODE_USER_STD_OUTPUT;        // o_vsync
    reg_mprj_io_20  = GPIO_MODE_USER_STD_OUTPUT;        // o_tex_csb
    reg_mprj_io_21  = GPIO_MODE_USER_STD_OUTPUT;        // o_tex_sclk
    reg_mprj_io_22  = GPIO_MODE_USER_STD_BIDIRECTIONAL; // Texture SPI io[0]
    reg_mprj_io_23  = GPIO_MODE_USER_STD_OUTPUT;        // o_gpout[0]
    reg_mprj_io_24  = GPIO_MODE_USER_STD_OUTPUT;        // o_gpout[1]
    reg_mprj_io_25  = GPIO_MODE_USER_STD_INPUT_NOPULL;  // Texture SPI io[1]
    reg_mprj_io_26  = GPIO_MODE_USER_STD_INPUT_NOPULL;  // Texture SPI io[2]
    // Configure all other IOs that we don't care about to be inputs...
    //NOTE: We're skipping IOs that remain under normal SoC control.
    reg_mprj_io_8   = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_9   = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_10  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_11  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_12  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_13  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_14  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_15  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_16  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_17  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_27  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_28  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_29  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_30  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_31  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_32  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_33  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_34  = GPIO_MODE_USER_STD_INPUT_NOPULL;
    reg_mprj_io_35  = GPIO_MODE_USER_STD_INPUT_NOPULL;

    // Apply the above configuration:
    reg_mprj_xfer = 1;
    while (reg_mprj_xfer == 1);

    // Configure the LA outputs that we're sending into the design,
    // i.e. LA[114:64]
    reg_la2_oenb = reg_la2_iena = 0xffffffff; // Set 64..95 to outputs.
    reg_la3_oenb = reg_la3_iena = 0x0007ffff; // Set 96..114 to outputs too.
    //NOTE: It's confusing, but setting an la_oenb to 1 enables its output,
    // while setting the corresponding iena to 1 DISables its INPUT,
    // which is why we do both assignments at the same time.
    // It gets even more confusing that -- since VexRiscv/Litex -- setting an
    // la_oenb to HIGH here (which does indeed make it an output from
    // SoC=>design) will actually make that respective la_oenb signal LOW
    // as the design sees it. Hence, if the design senses la_oenb[100]==0,
    // for instance, then the design knows that the SoC is asserting a
    // signal on la_data_in[100], which the design must take in as an input.
    // In my case, I dont have to worry too much about what my design senses
    // on la_oenb, because it assumes all LAs are always asserted by the SoC,
    // and hence the design never tries to assert la_data_out.

    uint32_t la2;

    // Select upper 2 blue bits as our output for gpout[1:0]:
    // i_gpout0_sel <= 31 (rgb[22])
    // i_gpout1_sel <= 30 (rgb[23])
    // i_debug_vec_overlay <= 1
    reg_la2_data = la2 = 0b011111000101111000000;
    // 011111---------------    i_gpout1_sel: 31 (rgb[23])
    // ------0--------------    i_reg_mosi: 0
    // -------0-------------    i_reg_sclk: 0
    // --------0------------    i_reg_csb: 0
    // ---------1-----------    i_debug_vec_overlay: 1 (ON)
    // ----------011110-----    i_gpout0_sel: 30 (rgb[22])
    // ----------------0----    i_vec_mosi: 0
    // -----------------0---    i_vec_sclk: 0
    // ------------------0--    i_vec_csb: 0
    // -------------------00    i_reset_lock_b/a: same = hold in reset

    // Turn on auto-increment:
    // i_mode[1:0] <= 0b11
    reg_la3_data = 0b11000000000000000;

    // Now we'll make sure reset is asserted on our design's 'reset lock'.
    // The way this reset lock works is that if its lowest two LAs are both
    // the same value (whether both high, or both low), then we take it as
    // reset is asserted. When they DIFFER is when reset is released.
    
    // Assert our design's reset (it probably already is)
    // by making LA[65:64] both the same value (in this case, both 1):
    reg_la2_data = (la2 |= 0b11);
    // Now RELEASE reset by making them different (i.e. toggle the lowest bit):
    reg_la2_data = (la2 ^= 0b01);

    // Pulse gpio again to show that the firmware is finishing now:
    reg_gpio_out = 1;
    reg_gpio_out = 0;

    // No need for anything else as this design is free running and the
    // SoC knows to halt at the exit of main().

}

