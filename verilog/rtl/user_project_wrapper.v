// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*--------------------------------------*/
/* User project is instantiated  here   */
/*--------------------------------------*/

    //// BEGIN: INSTANTIATION OF ANTON'S DESIGN (top_ew_algofoogle) (SNIPPET2_ShareIns) ---------------------

    // This snippet comes from here:
    // https://github.com/algofoogle/raybox-zero/blob/ew/src/rtl/ew_caravel_snippets/SNIPPET2_ShareIns.v

    // Shared INPUT pads: IO[35,34, 32,31]
    wire [3:0] shared_io_in = {io_in[35], io_in[34], /* skip 33 per EW */ io_in[32], io_in[31]};

    // Anton's assigned pads are IO[26:18]...
    // These allow easy renumbering of those pads, if necessary.
    assign anton_io_in = io_in[26:18];      // Map the 'in' side of our 9 pads.
    assign io_out[26:18] = anton_io_out;    // Map the 'out' side of our 9 pads.
    assign io_oeb[26:18] = anton_io_oeb;    // Map the IO OEBs for our pads.
    // Convenience mapping of LA[114:64] to anton_la_in[50:0]. All are INPUTS INTO our module:
    wire [50:0] anton_la_in   = la_data_in[114:64];
    wire [50:0] anton_la_oenb =    la_oenb[114:64]; // SoC should configure these all as its outputs (i.e. inputs to our design).

    // Abtractions between Anton's top design and the above pads.
    wire [8:0]  anton_io_in;                // 'In' side of abtracted pads. Only 1 ([4]) is used (bidirectional config).
    wire [8:0]  anton_io_out;               // Design-driven: 'Out' side of abstracted pads. Not all OUTs are used.
    wire [8:0]  anton_io_oeb;               // Design-driven: Direction control for each abstracted pad.
    // Splicing the various signals together into their respective abstracted pads:
    wire        anton_tex_oeb0;             // Design-driven: Controls dir of one specific IO pad (Texture QSPI io[0]).
    wire [5:0]  anton_gpout;                // Design-driven: We splice 4 LSB into anton_io_out, discard upper 2.
    wire [15:0] a0s, a1s;                   // Low and high signals from our design that we can use to mix constants.
    assign      anton_io_oeb = {a0s[3:0], anton_tex_oeb0, a0s[7:4]}; // 0000t0000 where 't' is anton_tex_oeb0.
    assign      anton_io_out[8:5] = anton_gpout[3:0]; // Only use lower 4 (of 6) 'gpout's, plug them into the top of Anton's OUTPUT pads.
    wire [3:0]  anton_tex_in = {shared_io_in[2:0], anton_io_in[4]}; // Top 3 are shared inputs, bottom 1 is Anton's bidir pin.
    wire        anton_o_reset;              // For now this is just used during cocotb tests.


    top_ew_algofoogle top_ew_algofoogle(
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),        // User area 1 1.8V power
        .vssd1(vssd1),        // User area 1 digital ground
    `endif

        .i_clk                  (user_clock2),
        .i_la_invalid           (anton_la_oenb[0]), // Check any one of our LA's OENBs. Should be 0 (i.e. driven by SoC) if valid.
        .i_reset_lock_a         (anton_la_in[0]),   // Hold design in reset if equal (both 0 or both 1)
        .i_reset_lock_b         (anton_la_in[1]),   // Hold design in reset if equal (both 0 or both 1)
        .o_reset                (anton_o_reset),    // OUTPUT from the design to allow simulation testing to see its actual reset state.

        .zeros                  (a0s),  // A source of 16 constant '0' signals.
        .ones                   (a1s),  // A source of 16 constant '1' signals.

        .o_hsync                (anton_io_out[0]),
        .o_vsync                (anton_io_out[1]),
        //.o_rgb([23:0]) not used, except to feed DAC.

        .o_tex_csb              (anton_io_out[2]),
        .o_tex_sclk             (anton_io_out[3]),

        .o_tex_oeb0             (anton_tex_oeb0), // My only bidirectional pad.
        .o_tex_out0             (anton_io_out[4]),
        .i_tex_in               (anton_tex_in),

        .o_gpout                (anton_gpout), //NOTE: Lower 4 bits are used, upper 2 are not.

        .i_vec_csb              (anton_la_in[2]),
        .i_vec_sclk             (anton_la_in[3]),
        .i_vec_mosi             (anton_la_in[4]),

        .i_gpout0_sel           (anton_la_in[10:5]),

        .i_debug_vec_overlay    (anton_la_in[11]),

        .i_reg_csb              (anton_la_in[12]),
        .i_reg_sclk             (anton_la_in[13]),
        .i_reg_mosi             (anton_la_in[14]),

        .i_gpout1_sel           (anton_la_in[20:15]),
        .i_gpout2_sel           (anton_la_in[26:21]),

        .i_debug_trace_overlay  (anton_la_in[27]),

        .i_gpout3_sel           (anton_la_in[33:28]),

        .i_debug_map_overlay    (anton_la_in[34]),

        .i_gpout4_sel           (anton_la_in[40:35]),
        .i_gpout5_sel           (anton_la_in[46:41]),

        .i_mode                 (anton_la_in[49:47])
    );

    //// END: INSTANTIATION OF ANTON'S DESIGN (top_ew_algofoogle) (SNIPPET1_NoShare) ---------------------


endmodule	// user_project_wrapper

`default_nettype wire
