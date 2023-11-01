module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    vssa2,
    vdda2,
    vssa1,
    vdda1,
    vssd2,
    vccd2,
    vssd1,
    vccd1,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 input vssa2;
 input vdda2;
 input vssa1;
 input vdda1;
 input vssd2;
 input vccd2;
 input vssd1;
 input vccd1;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \a0s[10] ;
 wire \a0s[11] ;
 wire \a0s[12] ;
 wire \a0s[13] ;
 wire \a0s[14] ;
 wire \a0s[15] ;
 wire \a0s[8] ;
 wire \a0s[9] ;
 wire \a1s[0] ;
 wire \a1s[10] ;
 wire \a1s[11] ;
 wire \a1s[12] ;
 wire \a1s[13] ;
 wire \a1s[14] ;
 wire \a1s[15] ;
 wire \a1s[1] ;
 wire \a1s[2] ;
 wire \a1s[3] ;
 wire \a1s[4] ;
 wire \a1s[5] ;
 wire \a1s[6] ;
 wire \a1s[7] ;
 wire \a1s[8] ;
 wire \a1s[9] ;
 wire \anton_gpout[4] ;
 wire \anton_gpout[5] ;
 wire \anton_io_oeb[4] ;
 wire \anton_io_out[0] ;
 wire \anton_io_out[1] ;
 wire \anton_io_out[2] ;
 wire \anton_io_out[3] ;
 wire \anton_io_out[4] ;
 wire anton_o_reset;

 top_ew_algofoogle top_ew_algofoogle (.i_clk(user_clock2),
    .i_debug_map_overlay(la_data_in[98]),
    .i_debug_trace_overlay(la_data_in[91]),
    .i_debug_vec_overlay(la_data_in[75]),
    .i_la_invalid(la_oenb[64]),
    .i_reg_csb(la_data_in[76]),
    .i_reg_mosi(la_data_in[78]),
    .i_reg_outs_enb(la_data_in[114]),
    .i_reg_sclk(la_data_in[77]),
    .i_reset_lock_a(la_data_in[64]),
    .i_reset_lock_b(la_data_in[65]),
    .i_spare_0(la_data_in[115]),
    .i_spare_1(io_in[35]),
    .i_vec_csb(la_data_in[66]),
    .i_vec_mosi(la_data_in[68]),
    .i_vec_sclk(la_data_in[67]),
    .o_hsync(\anton_io_out[0] ),
    .o_reset(anton_o_reset),
    .o_tex_csb(\anton_io_out[2] ),
    .o_tex_oeb0(\anton_io_oeb[4] ),
    .o_tex_out0(\anton_io_out[4] ),
    .o_tex_sclk(\anton_io_out[3] ),
    .o_vsync(\anton_io_out[1] ),
    .vccd1(vccd1),
    .vssd1(vssd1),
    .i_gpout0_sel({la_data_in[74],
    la_data_in[73],
    la_data_in[72],
    la_data_in[71],
    la_data_in[70],
    la_data_in[69]}),
    .i_gpout1_sel({la_data_in[84],
    la_data_in[83],
    la_data_in[82],
    la_data_in[81],
    la_data_in[80],
    la_data_in[79]}),
    .i_gpout2_sel({la_data_in[90],
    la_data_in[89],
    la_data_in[88],
    la_data_in[87],
    la_data_in[86],
    la_data_in[85]}),
    .i_gpout3_sel({la_data_in[97],
    la_data_in[96],
    la_data_in[95],
    la_data_in[94],
    la_data_in[93],
    la_data_in[92]}),
    .i_gpout4_sel({la_data_in[104],
    la_data_in[103],
    la_data_in[102],
    la_data_in[101],
    la_data_in[100],
    la_data_in[99]}),
    .i_gpout5_sel({la_data_in[110],
    la_data_in[109],
    la_data_in[108],
    la_data_in[107],
    la_data_in[106],
    la_data_in[105]}),
    .i_mode({la_data_in[113],
    la_data_in[112],
    la_data_in[111]}),
    .i_tex_in({io_in[34],
    io_in[32],
    io_in[31],
    io_in[22]}),
    .o_gpout({\anton_gpout[5] ,
    \anton_gpout[4] ,
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23]}),
    .o_rgb({_NC1,
    _NC2,
    _NC3,
    _NC4,
    _NC5,
    _NC6,
    _NC7,
    _NC8,
    _NC9,
    _NC10,
    _NC11,
    _NC12,
    _NC13,
    _NC14,
    _NC15,
    _NC16,
    _NC17,
    _NC18,
    _NC19,
    _NC20,
    _NC21,
    _NC22,
    _NC23,
    _NC24}),
    .ones({\a1s[15] ,
    \a1s[14] ,
    \a1s[13] ,
    \a1s[12] ,
    \a1s[11] ,
    \a1s[10] ,
    \a1s[9] ,
    \a1s[8] ,
    \a1s[7] ,
    \a1s[6] ,
    \a1s[5] ,
    \a1s[4] ,
    \a1s[3] ,
    \a1s[2] ,
    \a1s[1] ,
    \a1s[0] }),
    .zeros({\a0s[15] ,
    \a0s[14] ,
    \a0s[13] ,
    \a0s[12] ,
    \a0s[11] ,
    \a0s[10] ,
    \a0s[9] ,
    \a0s[8] ,
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23]}));
 assign io_oeb[22] = \anton_io_oeb[4] ;
 assign io_out[18] = \anton_io_out[0] ;
 assign io_out[19] = \anton_io_out[1] ;
 assign io_out[20] = \anton_io_out[2] ;
 assign io_out[21] = \anton_io_out[3] ;
 assign io_out[22] = \anton_io_out[4] ;
endmodule
