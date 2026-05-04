module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
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

 wire clk;
 wire fft_done;
 wire fft_error;
 wire \fft_sram_addr[0] ;
 wire \fft_sram_addr[1] ;
 wire \fft_sram_addr[2] ;
 wire \fft_sram_addr[3] ;
 wire \fft_sram_addr[4] ;
 wire \fft_sram_addr[5] ;
 wire \fft_sram_addr[6] ;
 wire \fft_sram_addr[7] ;
 wire \fft_sram_addr[8] ;
 wire \fft_sram_addr[9] ;
 wire \fft_sram_ben[0] ;
 wire \fft_sram_ben[10] ;
 wire \fft_sram_ben[11] ;
 wire \fft_sram_ben[12] ;
 wire \fft_sram_ben[13] ;
 wire \fft_sram_ben[14] ;
 wire \fft_sram_ben[15] ;
 wire \fft_sram_ben[16] ;
 wire \fft_sram_ben[17] ;
 wire \fft_sram_ben[18] ;
 wire \fft_sram_ben[19] ;
 wire \fft_sram_ben[1] ;
 wire \fft_sram_ben[20] ;
 wire \fft_sram_ben[21] ;
 wire \fft_sram_ben[22] ;
 wire \fft_sram_ben[23] ;
 wire \fft_sram_ben[24] ;
 wire \fft_sram_ben[25] ;
 wire \fft_sram_ben[26] ;
 wire \fft_sram_ben[27] ;
 wire \fft_sram_ben[28] ;
 wire \fft_sram_ben[29] ;
 wire \fft_sram_ben[2] ;
 wire \fft_sram_ben[30] ;
 wire \fft_sram_ben[31] ;
 wire \fft_sram_ben[3] ;
 wire \fft_sram_ben[4] ;
 wire \fft_sram_ben[5] ;
 wire \fft_sram_ben[6] ;
 wire \fft_sram_ben[7] ;
 wire \fft_sram_ben[8] ;
 wire \fft_sram_ben[9] ;
 wire fft_sram_clk;
 wire \fft_sram_en[0] ;
 wire \fft_sram_en[1] ;
 wire \fft_sram_rdata0[0] ;
 wire \fft_sram_rdata0[10] ;
 wire \fft_sram_rdata0[11] ;
 wire \fft_sram_rdata0[12] ;
 wire \fft_sram_rdata0[13] ;
 wire \fft_sram_rdata0[14] ;
 wire \fft_sram_rdata0[15] ;
 wire \fft_sram_rdata0[16] ;
 wire \fft_sram_rdata0[17] ;
 wire \fft_sram_rdata0[18] ;
 wire \fft_sram_rdata0[19] ;
 wire \fft_sram_rdata0[1] ;
 wire \fft_sram_rdata0[20] ;
 wire \fft_sram_rdata0[21] ;
 wire \fft_sram_rdata0[22] ;
 wire \fft_sram_rdata0[23] ;
 wire \fft_sram_rdata0[24] ;
 wire \fft_sram_rdata0[25] ;
 wire \fft_sram_rdata0[26] ;
 wire \fft_sram_rdata0[27] ;
 wire \fft_sram_rdata0[28] ;
 wire \fft_sram_rdata0[29] ;
 wire \fft_sram_rdata0[2] ;
 wire \fft_sram_rdata0[30] ;
 wire \fft_sram_rdata0[31] ;
 wire \fft_sram_rdata0[3] ;
 wire \fft_sram_rdata0[4] ;
 wire \fft_sram_rdata0[5] ;
 wire \fft_sram_rdata0[6] ;
 wire \fft_sram_rdata0[7] ;
 wire \fft_sram_rdata0[8] ;
 wire \fft_sram_rdata0[9] ;
 wire \fft_sram_rdata1[0] ;
 wire \fft_sram_rdata1[10] ;
 wire \fft_sram_rdata1[11] ;
 wire \fft_sram_rdata1[12] ;
 wire \fft_sram_rdata1[13] ;
 wire \fft_sram_rdata1[14] ;
 wire \fft_sram_rdata1[15] ;
 wire \fft_sram_rdata1[16] ;
 wire \fft_sram_rdata1[17] ;
 wire \fft_sram_rdata1[18] ;
 wire \fft_sram_rdata1[19] ;
 wire \fft_sram_rdata1[1] ;
 wire \fft_sram_rdata1[20] ;
 wire \fft_sram_rdata1[21] ;
 wire \fft_sram_rdata1[22] ;
 wire \fft_sram_rdata1[23] ;
 wire \fft_sram_rdata1[24] ;
 wire \fft_sram_rdata1[25] ;
 wire \fft_sram_rdata1[26] ;
 wire \fft_sram_rdata1[27] ;
 wire \fft_sram_rdata1[28] ;
 wire \fft_sram_rdata1[29] ;
 wire \fft_sram_rdata1[2] ;
 wire \fft_sram_rdata1[30] ;
 wire \fft_sram_rdata1[31] ;
 wire \fft_sram_rdata1[3] ;
 wire \fft_sram_rdata1[4] ;
 wire \fft_sram_rdata1[5] ;
 wire \fft_sram_rdata1[6] ;
 wire \fft_sram_rdata1[7] ;
 wire \fft_sram_rdata1[8] ;
 wire \fft_sram_rdata1[9] ;
 wire fft_sram_rwb;
 wire \fft_sram_wdata[0] ;
 wire \fft_sram_wdata[10] ;
 wire \fft_sram_wdata[11] ;
 wire \fft_sram_wdata[12] ;
 wire \fft_sram_wdata[13] ;
 wire \fft_sram_wdata[14] ;
 wire \fft_sram_wdata[15] ;
 wire \fft_sram_wdata[16] ;
 wire \fft_sram_wdata[17] ;
 wire \fft_sram_wdata[18] ;
 wire \fft_sram_wdata[19] ;
 wire \fft_sram_wdata[1] ;
 wire \fft_sram_wdata[20] ;
 wire \fft_sram_wdata[21] ;
 wire \fft_sram_wdata[22] ;
 wire \fft_sram_wdata[23] ;
 wire \fft_sram_wdata[24] ;
 wire \fft_sram_wdata[25] ;
 wire \fft_sram_wdata[26] ;
 wire \fft_sram_wdata[27] ;
 wire \fft_sram_wdata[28] ;
 wire \fft_sram_wdata[29] ;
 wire \fft_sram_wdata[2] ;
 wire \fft_sram_wdata[30] ;
 wire \fft_sram_wdata[31] ;
 wire \fft_sram_wdata[3] ;
 wire \fft_sram_wdata[4] ;
 wire \fft_sram_wdata[5] ;
 wire \fft_sram_wdata[6] ;
 wire \fft_sram_wdata[7] ;
 wire \fft_sram_wdata[8] ;
 wire \fft_sram_wdata[9] ;
 wire \fft_tl_o_unused[0] ;
 wire \fft_tl_o_unused[10] ;
 wire \fft_tl_o_unused[11] ;
 wire \fft_tl_o_unused[12] ;
 wire \fft_tl_o_unused[13] ;
 wire \fft_tl_o_unused[14] ;
 wire \fft_tl_o_unused[15] ;
 wire \fft_tl_o_unused[16] ;
 wire \fft_tl_o_unused[17] ;
 wire \fft_tl_o_unused[18] ;
 wire \fft_tl_o_unused[19] ;
 wire \fft_tl_o_unused[1] ;
 wire \fft_tl_o_unused[20] ;
 wire \fft_tl_o_unused[21] ;
 wire \fft_tl_o_unused[22] ;
 wire \fft_tl_o_unused[23] ;
 wire \fft_tl_o_unused[24] ;
 wire \fft_tl_o_unused[25] ;
 wire \fft_tl_o_unused[26] ;
 wire \fft_tl_o_unused[27] ;
 wire \fft_tl_o_unused[28] ;
 wire \fft_tl_o_unused[29] ;
 wire \fft_tl_o_unused[2] ;
 wire \fft_tl_o_unused[30] ;
 wire \fft_tl_o_unused[31] ;
 wire \fft_tl_o_unused[32] ;
 wire \fft_tl_o_unused[33] ;
 wire \fft_tl_o_unused[34] ;
 wire \fft_tl_o_unused[35] ;
 wire \fft_tl_o_unused[36] ;
 wire \fft_tl_o_unused[37] ;
 wire \fft_tl_o_unused[38] ;
 wire \fft_tl_o_unused[39] ;
 wire \fft_tl_o_unused[3] ;
 wire \fft_tl_o_unused[40] ;
 wire \fft_tl_o_unused[41] ;
 wire \fft_tl_o_unused[42] ;
 wire \fft_tl_o_unused[43] ;
 wire \fft_tl_o_unused[44] ;
 wire \fft_tl_o_unused[45] ;
 wire \fft_tl_o_unused[46] ;
 wire \fft_tl_o_unused[47] ;
 wire \fft_tl_o_unused[48] ;
 wire \fft_tl_o_unused[49] ;
 wire \fft_tl_o_unused[4] ;
 wire \fft_tl_o_unused[50] ;
 wire \fft_tl_o_unused[51] ;
 wire \fft_tl_o_unused[52] ;
 wire \fft_tl_o_unused[53] ;
 wire \fft_tl_o_unused[54] ;
 wire \fft_tl_o_unused[55] ;
 wire \fft_tl_o_unused[56] ;
 wire \fft_tl_o_unused[57] ;
 wire \fft_tl_o_unused[58] ;
 wire \fft_tl_o_unused[59] ;
 wire \fft_tl_o_unused[5] ;
 wire \fft_tl_o_unused[60] ;
 wire \fft_tl_o_unused[61] ;
 wire \fft_tl_o_unused[62] ;
 wire \fft_tl_o_unused[63] ;
 wire \fft_tl_o_unused[64] ;
 wire \fft_tl_o_unused[65] ;
 wire \fft_tl_o_unused[6] ;
 wire \fft_tl_o_unused[7] ;
 wire \fft_tl_o_unused[8] ;
 wire \fft_tl_o_unused[9] ;
 wire intr_spi_host_idle;
 wire intr_spi_host_rx_full;
 wire intr_spi_host_tx_empty;
 wire intr_uart_rx_break_err;
 wire intr_uart_rx_frame_err;
 wire intr_uart_rx_overflow;
 wire intr_uart_rx_parity_err;
 wire intr_uart_rx_timeout;
 wire intr_uart_rx_watermark;
 wire intr_uart_tx_done;
 wire intr_uart_tx_empty;
 wire intr_uart_tx_watermark;
 wire \intr_vec[0] ;
 wire \intr_vec[10] ;
 wire \intr_vec[11] ;
 wire \intr_vec[12] ;
 wire \intr_vec[13] ;
 wire \intr_vec[14] ;
 wire \intr_vec[15] ;
 wire \intr_vec[16] ;
 wire \intr_vec[17] ;
 wire \intr_vec[18] ;
 wire \intr_vec[19] ;
 wire \intr_vec[1] ;
 wire \intr_vec[20] ;
 wire \intr_vec[21] ;
 wire \intr_vec[22] ;
 wire \intr_vec[23] ;
 wire \intr_vec[24] ;
 wire \intr_vec[25] ;
 wire \intr_vec[26] ;
 wire \intr_vec[27] ;
 wire \intr_vec[28] ;
 wire \intr_vec[29] ;
 wire \intr_vec[2] ;
 wire \intr_vec[30] ;
 wire \intr_vec[31] ;
 wire \intr_vec[3] ;
 wire \intr_vec[4] ;
 wire \intr_vec[5] ;
 wire \intr_vec[6] ;
 wire \intr_vec[7] ;
 wire \intr_vec[8] ;
 wire \intr_vec[9] ;
 wire one_;
 wire plic_irq;
 wire rst_n;
 wire spi_cs_n;
 wire spi_miso;
 wire spi_mosi;
 wire spi_sclk;
 wire \tl_cpu_d2h[0] ;
 wire \tl_cpu_d2h[10] ;
 wire \tl_cpu_d2h[11] ;
 wire \tl_cpu_d2h[12] ;
 wire \tl_cpu_d2h[13] ;
 wire \tl_cpu_d2h[14] ;
 wire \tl_cpu_d2h[15] ;
 wire \tl_cpu_d2h[16] ;
 wire \tl_cpu_d2h[17] ;
 wire \tl_cpu_d2h[18] ;
 wire \tl_cpu_d2h[19] ;
 wire \tl_cpu_d2h[1] ;
 wire \tl_cpu_d2h[20] ;
 wire \tl_cpu_d2h[21] ;
 wire \tl_cpu_d2h[22] ;
 wire \tl_cpu_d2h[23] ;
 wire \tl_cpu_d2h[24] ;
 wire \tl_cpu_d2h[25] ;
 wire \tl_cpu_d2h[26] ;
 wire \tl_cpu_d2h[27] ;
 wire \tl_cpu_d2h[28] ;
 wire \tl_cpu_d2h[29] ;
 wire \tl_cpu_d2h[2] ;
 wire \tl_cpu_d2h[30] ;
 wire \tl_cpu_d2h[31] ;
 wire \tl_cpu_d2h[32] ;
 wire \tl_cpu_d2h[33] ;
 wire \tl_cpu_d2h[34] ;
 wire \tl_cpu_d2h[35] ;
 wire \tl_cpu_d2h[36] ;
 wire \tl_cpu_d2h[37] ;
 wire \tl_cpu_d2h[38] ;
 wire \tl_cpu_d2h[39] ;
 wire \tl_cpu_d2h[3] ;
 wire \tl_cpu_d2h[40] ;
 wire \tl_cpu_d2h[41] ;
 wire \tl_cpu_d2h[42] ;
 wire \tl_cpu_d2h[43] ;
 wire \tl_cpu_d2h[44] ;
 wire \tl_cpu_d2h[45] ;
 wire \tl_cpu_d2h[46] ;
 wire \tl_cpu_d2h[47] ;
 wire \tl_cpu_d2h[48] ;
 wire \tl_cpu_d2h[49] ;
 wire \tl_cpu_d2h[4] ;
 wire \tl_cpu_d2h[50] ;
 wire \tl_cpu_d2h[51] ;
 wire \tl_cpu_d2h[52] ;
 wire \tl_cpu_d2h[53] ;
 wire \tl_cpu_d2h[54] ;
 wire \tl_cpu_d2h[55] ;
 wire \tl_cpu_d2h[56] ;
 wire \tl_cpu_d2h[57] ;
 wire \tl_cpu_d2h[58] ;
 wire \tl_cpu_d2h[59] ;
 wire \tl_cpu_d2h[5] ;
 wire \tl_cpu_d2h[60] ;
 wire \tl_cpu_d2h[61] ;
 wire \tl_cpu_d2h[62] ;
 wire \tl_cpu_d2h[63] ;
 wire \tl_cpu_d2h[64] ;
 wire \tl_cpu_d2h[65] ;
 wire \tl_cpu_d2h[6] ;
 wire \tl_cpu_d2h[7] ;
 wire \tl_cpu_d2h[8] ;
 wire \tl_cpu_d2h[9] ;
 wire \tl_cpu_h2d[0] ;
 wire \tl_cpu_h2d[100] ;
 wire \tl_cpu_h2d[101] ;
 wire \tl_cpu_h2d[102] ;
 wire \tl_cpu_h2d[103] ;
 wire \tl_cpu_h2d[104] ;
 wire \tl_cpu_h2d[105] ;
 wire \tl_cpu_h2d[106] ;
 wire \tl_cpu_h2d[107] ;
 wire \tl_cpu_h2d[108] ;
 wire \tl_cpu_h2d[109] ;
 wire \tl_cpu_h2d[10] ;
 wire \tl_cpu_h2d[11] ;
 wire \tl_cpu_h2d[12] ;
 wire \tl_cpu_h2d[13] ;
 wire \tl_cpu_h2d[14] ;
 wire \tl_cpu_h2d[15] ;
 wire \tl_cpu_h2d[16] ;
 wire \tl_cpu_h2d[17] ;
 wire \tl_cpu_h2d[18] ;
 wire \tl_cpu_h2d[19] ;
 wire \tl_cpu_h2d[1] ;
 wire \tl_cpu_h2d[20] ;
 wire \tl_cpu_h2d[21] ;
 wire \tl_cpu_h2d[22] ;
 wire \tl_cpu_h2d[23] ;
 wire \tl_cpu_h2d[24] ;
 wire \tl_cpu_h2d[25] ;
 wire \tl_cpu_h2d[26] ;
 wire \tl_cpu_h2d[27] ;
 wire \tl_cpu_h2d[28] ;
 wire \tl_cpu_h2d[29] ;
 wire \tl_cpu_h2d[2] ;
 wire \tl_cpu_h2d[30] ;
 wire \tl_cpu_h2d[31] ;
 wire \tl_cpu_h2d[32] ;
 wire \tl_cpu_h2d[33] ;
 wire \tl_cpu_h2d[34] ;
 wire \tl_cpu_h2d[35] ;
 wire \tl_cpu_h2d[36] ;
 wire \tl_cpu_h2d[37] ;
 wire \tl_cpu_h2d[38] ;
 wire \tl_cpu_h2d[39] ;
 wire \tl_cpu_h2d[3] ;
 wire \tl_cpu_h2d[40] ;
 wire \tl_cpu_h2d[41] ;
 wire \tl_cpu_h2d[42] ;
 wire \tl_cpu_h2d[43] ;
 wire \tl_cpu_h2d[44] ;
 wire \tl_cpu_h2d[45] ;
 wire \tl_cpu_h2d[46] ;
 wire \tl_cpu_h2d[47] ;
 wire \tl_cpu_h2d[48] ;
 wire \tl_cpu_h2d[49] ;
 wire \tl_cpu_h2d[4] ;
 wire \tl_cpu_h2d[50] ;
 wire \tl_cpu_h2d[51] ;
 wire \tl_cpu_h2d[52] ;
 wire \tl_cpu_h2d[53] ;
 wire \tl_cpu_h2d[54] ;
 wire \tl_cpu_h2d[55] ;
 wire \tl_cpu_h2d[56] ;
 wire \tl_cpu_h2d[57] ;
 wire \tl_cpu_h2d[58] ;
 wire \tl_cpu_h2d[59] ;
 wire \tl_cpu_h2d[5] ;
 wire \tl_cpu_h2d[60] ;
 wire \tl_cpu_h2d[61] ;
 wire \tl_cpu_h2d[62] ;
 wire \tl_cpu_h2d[63] ;
 wire \tl_cpu_h2d[64] ;
 wire \tl_cpu_h2d[65] ;
 wire \tl_cpu_h2d[66] ;
 wire \tl_cpu_h2d[67] ;
 wire \tl_cpu_h2d[68] ;
 wire \tl_cpu_h2d[69] ;
 wire \tl_cpu_h2d[6] ;
 wire \tl_cpu_h2d[70] ;
 wire \tl_cpu_h2d[71] ;
 wire \tl_cpu_h2d[72] ;
 wire \tl_cpu_h2d[73] ;
 wire \tl_cpu_h2d[74] ;
 wire \tl_cpu_h2d[75] ;
 wire \tl_cpu_h2d[76] ;
 wire \tl_cpu_h2d[77] ;
 wire \tl_cpu_h2d[78] ;
 wire \tl_cpu_h2d[79] ;
 wire \tl_cpu_h2d[7] ;
 wire \tl_cpu_h2d[80] ;
 wire \tl_cpu_h2d[81] ;
 wire \tl_cpu_h2d[82] ;
 wire \tl_cpu_h2d[83] ;
 wire \tl_cpu_h2d[84] ;
 wire \tl_cpu_h2d[85] ;
 wire \tl_cpu_h2d[86] ;
 wire \tl_cpu_h2d[87] ;
 wire \tl_cpu_h2d[88] ;
 wire \tl_cpu_h2d[89] ;
 wire \tl_cpu_h2d[8] ;
 wire \tl_cpu_h2d[90] ;
 wire \tl_cpu_h2d[91] ;
 wire \tl_cpu_h2d[92] ;
 wire \tl_cpu_h2d[93] ;
 wire \tl_cpu_h2d[94] ;
 wire \tl_cpu_h2d[95] ;
 wire \tl_cpu_h2d[96] ;
 wire \tl_cpu_h2d[97] ;
 wire \tl_cpu_h2d[98] ;
 wire \tl_cpu_h2d[99] ;
 wire \tl_cpu_h2d[9] ;
 wire \tl_plic_d2h[0] ;
 wire \tl_plic_d2h[10] ;
 wire \tl_plic_d2h[11] ;
 wire \tl_plic_d2h[12] ;
 wire \tl_plic_d2h[13] ;
 wire \tl_plic_d2h[14] ;
 wire \tl_plic_d2h[15] ;
 wire \tl_plic_d2h[16] ;
 wire \tl_plic_d2h[17] ;
 wire \tl_plic_d2h[18] ;
 wire \tl_plic_d2h[19] ;
 wire \tl_plic_d2h[1] ;
 wire \tl_plic_d2h[20] ;
 wire \tl_plic_d2h[21] ;
 wire \tl_plic_d2h[22] ;
 wire \tl_plic_d2h[23] ;
 wire \tl_plic_d2h[24] ;
 wire \tl_plic_d2h[25] ;
 wire \tl_plic_d2h[26] ;
 wire \tl_plic_d2h[27] ;
 wire \tl_plic_d2h[28] ;
 wire \tl_plic_d2h[29] ;
 wire \tl_plic_d2h[2] ;
 wire \tl_plic_d2h[30] ;
 wire \tl_plic_d2h[31] ;
 wire \tl_plic_d2h[32] ;
 wire \tl_plic_d2h[33] ;
 wire \tl_plic_d2h[34] ;
 wire \tl_plic_d2h[35] ;
 wire \tl_plic_d2h[36] ;
 wire \tl_plic_d2h[37] ;
 wire \tl_plic_d2h[38] ;
 wire \tl_plic_d2h[39] ;
 wire \tl_plic_d2h[3] ;
 wire \tl_plic_d2h[40] ;
 wire \tl_plic_d2h[41] ;
 wire \tl_plic_d2h[42] ;
 wire \tl_plic_d2h[43] ;
 wire \tl_plic_d2h[44] ;
 wire \tl_plic_d2h[45] ;
 wire \tl_plic_d2h[46] ;
 wire \tl_plic_d2h[47] ;
 wire \tl_plic_d2h[48] ;
 wire \tl_plic_d2h[49] ;
 wire \tl_plic_d2h[4] ;
 wire \tl_plic_d2h[50] ;
 wire \tl_plic_d2h[51] ;
 wire \tl_plic_d2h[52] ;
 wire \tl_plic_d2h[53] ;
 wire \tl_plic_d2h[54] ;
 wire \tl_plic_d2h[55] ;
 wire \tl_plic_d2h[56] ;
 wire \tl_plic_d2h[57] ;
 wire \tl_plic_d2h[58] ;
 wire \tl_plic_d2h[59] ;
 wire \tl_plic_d2h[5] ;
 wire \tl_plic_d2h[60] ;
 wire \tl_plic_d2h[61] ;
 wire \tl_plic_d2h[62] ;
 wire \tl_plic_d2h[63] ;
 wire \tl_plic_d2h[64] ;
 wire \tl_plic_d2h[65] ;
 wire \tl_plic_d2h[6] ;
 wire \tl_plic_d2h[7] ;
 wire \tl_plic_d2h[8] ;
 wire \tl_plic_d2h[9] ;
 wire \tl_plic_h2d[0] ;
 wire \tl_plic_h2d[100] ;
 wire \tl_plic_h2d[101] ;
 wire \tl_plic_h2d[102] ;
 wire \tl_plic_h2d[103] ;
 wire \tl_plic_h2d[104] ;
 wire \tl_plic_h2d[105] ;
 wire \tl_plic_h2d[106] ;
 wire \tl_plic_h2d[107] ;
 wire \tl_plic_h2d[108] ;
 wire \tl_plic_h2d[109] ;
 wire \tl_plic_h2d[10] ;
 wire \tl_plic_h2d[11] ;
 wire \tl_plic_h2d[12] ;
 wire \tl_plic_h2d[13] ;
 wire \tl_plic_h2d[14] ;
 wire \tl_plic_h2d[15] ;
 wire \tl_plic_h2d[16] ;
 wire \tl_plic_h2d[17] ;
 wire \tl_plic_h2d[18] ;
 wire \tl_plic_h2d[19] ;
 wire \tl_plic_h2d[1] ;
 wire \tl_plic_h2d[20] ;
 wire \tl_plic_h2d[21] ;
 wire \tl_plic_h2d[22] ;
 wire \tl_plic_h2d[23] ;
 wire \tl_plic_h2d[24] ;
 wire \tl_plic_h2d[25] ;
 wire \tl_plic_h2d[26] ;
 wire \tl_plic_h2d[27] ;
 wire \tl_plic_h2d[28] ;
 wire \tl_plic_h2d[29] ;
 wire \tl_plic_h2d[2] ;
 wire \tl_plic_h2d[30] ;
 wire \tl_plic_h2d[31] ;
 wire \tl_plic_h2d[32] ;
 wire \tl_plic_h2d[33] ;
 wire \tl_plic_h2d[34] ;
 wire \tl_plic_h2d[35] ;
 wire \tl_plic_h2d[36] ;
 wire \tl_plic_h2d[37] ;
 wire \tl_plic_h2d[38] ;
 wire \tl_plic_h2d[39] ;
 wire \tl_plic_h2d[3] ;
 wire \tl_plic_h2d[40] ;
 wire \tl_plic_h2d[41] ;
 wire \tl_plic_h2d[42] ;
 wire \tl_plic_h2d[43] ;
 wire \tl_plic_h2d[44] ;
 wire \tl_plic_h2d[45] ;
 wire \tl_plic_h2d[46] ;
 wire \tl_plic_h2d[47] ;
 wire \tl_plic_h2d[48] ;
 wire \tl_plic_h2d[49] ;
 wire \tl_plic_h2d[4] ;
 wire \tl_plic_h2d[50] ;
 wire \tl_plic_h2d[51] ;
 wire \tl_plic_h2d[52] ;
 wire \tl_plic_h2d[53] ;
 wire \tl_plic_h2d[54] ;
 wire \tl_plic_h2d[55] ;
 wire \tl_plic_h2d[56] ;
 wire \tl_plic_h2d[57] ;
 wire \tl_plic_h2d[58] ;
 wire \tl_plic_h2d[59] ;
 wire \tl_plic_h2d[5] ;
 wire \tl_plic_h2d[60] ;
 wire \tl_plic_h2d[61] ;
 wire \tl_plic_h2d[62] ;
 wire \tl_plic_h2d[63] ;
 wire \tl_plic_h2d[64] ;
 wire \tl_plic_h2d[65] ;
 wire \tl_plic_h2d[66] ;
 wire \tl_plic_h2d[67] ;
 wire \tl_plic_h2d[68] ;
 wire \tl_plic_h2d[69] ;
 wire \tl_plic_h2d[6] ;
 wire \tl_plic_h2d[70] ;
 wire \tl_plic_h2d[71] ;
 wire \tl_plic_h2d[72] ;
 wire \tl_plic_h2d[73] ;
 wire \tl_plic_h2d[74] ;
 wire \tl_plic_h2d[75] ;
 wire \tl_plic_h2d[76] ;
 wire \tl_plic_h2d[77] ;
 wire \tl_plic_h2d[78] ;
 wire \tl_plic_h2d[79] ;
 wire \tl_plic_h2d[7] ;
 wire \tl_plic_h2d[80] ;
 wire \tl_plic_h2d[81] ;
 wire \tl_plic_h2d[82] ;
 wire \tl_plic_h2d[83] ;
 wire \tl_plic_h2d[84] ;
 wire \tl_plic_h2d[85] ;
 wire \tl_plic_h2d[86] ;
 wire \tl_plic_h2d[87] ;
 wire \tl_plic_h2d[88] ;
 wire \tl_plic_h2d[89] ;
 wire \tl_plic_h2d[8] ;
 wire \tl_plic_h2d[90] ;
 wire \tl_plic_h2d[91] ;
 wire \tl_plic_h2d[92] ;
 wire \tl_plic_h2d[93] ;
 wire \tl_plic_h2d[94] ;
 wire \tl_plic_h2d[95] ;
 wire \tl_plic_h2d[96] ;
 wire \tl_plic_h2d[97] ;
 wire \tl_plic_h2d[98] ;
 wire \tl_plic_h2d[99] ;
 wire \tl_plic_h2d[9] ;
 wire \tl_ram_h2d[0] ;
 wire \tl_ram_h2d[100] ;
 wire \tl_ram_h2d[101] ;
 wire \tl_ram_h2d[102] ;
 wire \tl_ram_h2d[103] ;
 wire \tl_ram_h2d[104] ;
 wire \tl_ram_h2d[105] ;
 wire \tl_ram_h2d[106] ;
 wire \tl_ram_h2d[107] ;
 wire \tl_ram_h2d[108] ;
 wire \tl_ram_h2d[109] ;
 wire \tl_ram_h2d[10] ;
 wire \tl_ram_h2d[11] ;
 wire \tl_ram_h2d[12] ;
 wire \tl_ram_h2d[13] ;
 wire \tl_ram_h2d[14] ;
 wire \tl_ram_h2d[15] ;
 wire \tl_ram_h2d[16] ;
 wire \tl_ram_h2d[17] ;
 wire \tl_ram_h2d[18] ;
 wire \tl_ram_h2d[19] ;
 wire \tl_ram_h2d[1] ;
 wire \tl_ram_h2d[20] ;
 wire \tl_ram_h2d[21] ;
 wire \tl_ram_h2d[22] ;
 wire \tl_ram_h2d[23] ;
 wire \tl_ram_h2d[24] ;
 wire \tl_ram_h2d[25] ;
 wire \tl_ram_h2d[26] ;
 wire \tl_ram_h2d[27] ;
 wire \tl_ram_h2d[28] ;
 wire \tl_ram_h2d[29] ;
 wire \tl_ram_h2d[2] ;
 wire \tl_ram_h2d[30] ;
 wire \tl_ram_h2d[31] ;
 wire \tl_ram_h2d[32] ;
 wire \tl_ram_h2d[33] ;
 wire \tl_ram_h2d[34] ;
 wire \tl_ram_h2d[35] ;
 wire \tl_ram_h2d[36] ;
 wire \tl_ram_h2d[37] ;
 wire \tl_ram_h2d[38] ;
 wire \tl_ram_h2d[39] ;
 wire \tl_ram_h2d[3] ;
 wire \tl_ram_h2d[40] ;
 wire \tl_ram_h2d[41] ;
 wire \tl_ram_h2d[42] ;
 wire \tl_ram_h2d[43] ;
 wire \tl_ram_h2d[44] ;
 wire \tl_ram_h2d[45] ;
 wire \tl_ram_h2d[46] ;
 wire \tl_ram_h2d[47] ;
 wire \tl_ram_h2d[48] ;
 wire \tl_ram_h2d[49] ;
 wire \tl_ram_h2d[4] ;
 wire \tl_ram_h2d[50] ;
 wire \tl_ram_h2d[51] ;
 wire \tl_ram_h2d[52] ;
 wire \tl_ram_h2d[53] ;
 wire \tl_ram_h2d[54] ;
 wire \tl_ram_h2d[55] ;
 wire \tl_ram_h2d[56] ;
 wire \tl_ram_h2d[57] ;
 wire \tl_ram_h2d[58] ;
 wire \tl_ram_h2d[59] ;
 wire \tl_ram_h2d[5] ;
 wire \tl_ram_h2d[60] ;
 wire \tl_ram_h2d[61] ;
 wire \tl_ram_h2d[62] ;
 wire \tl_ram_h2d[63] ;
 wire \tl_ram_h2d[64] ;
 wire \tl_ram_h2d[65] ;
 wire \tl_ram_h2d[66] ;
 wire \tl_ram_h2d[67] ;
 wire \tl_ram_h2d[68] ;
 wire \tl_ram_h2d[69] ;
 wire \tl_ram_h2d[6] ;
 wire \tl_ram_h2d[70] ;
 wire \tl_ram_h2d[71] ;
 wire \tl_ram_h2d[72] ;
 wire \tl_ram_h2d[73] ;
 wire \tl_ram_h2d[74] ;
 wire \tl_ram_h2d[75] ;
 wire \tl_ram_h2d[76] ;
 wire \tl_ram_h2d[77] ;
 wire \tl_ram_h2d[78] ;
 wire \tl_ram_h2d[79] ;
 wire \tl_ram_h2d[7] ;
 wire \tl_ram_h2d[80] ;
 wire \tl_ram_h2d[81] ;
 wire \tl_ram_h2d[82] ;
 wire \tl_ram_h2d[83] ;
 wire \tl_ram_h2d[84] ;
 wire \tl_ram_h2d[85] ;
 wire \tl_ram_h2d[86] ;
 wire \tl_ram_h2d[87] ;
 wire \tl_ram_h2d[88] ;
 wire \tl_ram_h2d[89] ;
 wire \tl_ram_h2d[8] ;
 wire \tl_ram_h2d[90] ;
 wire \tl_ram_h2d[91] ;
 wire \tl_ram_h2d[92] ;
 wire \tl_ram_h2d[93] ;
 wire \tl_ram_h2d[94] ;
 wire \tl_ram_h2d[95] ;
 wire \tl_ram_h2d[96] ;
 wire \tl_ram_h2d[97] ;
 wire \tl_ram_h2d[98] ;
 wire \tl_ram_h2d[99] ;
 wire \tl_ram_h2d[9] ;
 wire \tl_rom_h2d[0] ;
 wire \tl_rom_h2d[100] ;
 wire \tl_rom_h2d[101] ;
 wire \tl_rom_h2d[102] ;
 wire \tl_rom_h2d[103] ;
 wire \tl_rom_h2d[104] ;
 wire \tl_rom_h2d[105] ;
 wire \tl_rom_h2d[106] ;
 wire \tl_rom_h2d[107] ;
 wire \tl_rom_h2d[108] ;
 wire \tl_rom_h2d[109] ;
 wire \tl_rom_h2d[10] ;
 wire \tl_rom_h2d[11] ;
 wire \tl_rom_h2d[12] ;
 wire \tl_rom_h2d[13] ;
 wire \tl_rom_h2d[14] ;
 wire \tl_rom_h2d[15] ;
 wire \tl_rom_h2d[16] ;
 wire \tl_rom_h2d[17] ;
 wire \tl_rom_h2d[18] ;
 wire \tl_rom_h2d[19] ;
 wire \tl_rom_h2d[1] ;
 wire \tl_rom_h2d[20] ;
 wire \tl_rom_h2d[21] ;
 wire \tl_rom_h2d[22] ;
 wire \tl_rom_h2d[23] ;
 wire \tl_rom_h2d[24] ;
 wire \tl_rom_h2d[25] ;
 wire \tl_rom_h2d[26] ;
 wire \tl_rom_h2d[27] ;
 wire \tl_rom_h2d[28] ;
 wire \tl_rom_h2d[29] ;
 wire \tl_rom_h2d[2] ;
 wire \tl_rom_h2d[30] ;
 wire \tl_rom_h2d[31] ;
 wire \tl_rom_h2d[32] ;
 wire \tl_rom_h2d[33] ;
 wire \tl_rom_h2d[34] ;
 wire \tl_rom_h2d[35] ;
 wire \tl_rom_h2d[36] ;
 wire \tl_rom_h2d[37] ;
 wire \tl_rom_h2d[38] ;
 wire \tl_rom_h2d[39] ;
 wire \tl_rom_h2d[3] ;
 wire \tl_rom_h2d[40] ;
 wire \tl_rom_h2d[41] ;
 wire \tl_rom_h2d[42] ;
 wire \tl_rom_h2d[43] ;
 wire \tl_rom_h2d[44] ;
 wire \tl_rom_h2d[45] ;
 wire \tl_rom_h2d[46] ;
 wire \tl_rom_h2d[47] ;
 wire \tl_rom_h2d[48] ;
 wire \tl_rom_h2d[49] ;
 wire \tl_rom_h2d[4] ;
 wire \tl_rom_h2d[50] ;
 wire \tl_rom_h2d[51] ;
 wire \tl_rom_h2d[52] ;
 wire \tl_rom_h2d[53] ;
 wire \tl_rom_h2d[54] ;
 wire \tl_rom_h2d[55] ;
 wire \tl_rom_h2d[56] ;
 wire \tl_rom_h2d[57] ;
 wire \tl_rom_h2d[58] ;
 wire \tl_rom_h2d[59] ;
 wire \tl_rom_h2d[5] ;
 wire \tl_rom_h2d[60] ;
 wire \tl_rom_h2d[61] ;
 wire \tl_rom_h2d[62] ;
 wire \tl_rom_h2d[63] ;
 wire \tl_rom_h2d[64] ;
 wire \tl_rom_h2d[65] ;
 wire \tl_rom_h2d[66] ;
 wire \tl_rom_h2d[67] ;
 wire \tl_rom_h2d[68] ;
 wire \tl_rom_h2d[69] ;
 wire \tl_rom_h2d[6] ;
 wire \tl_rom_h2d[70] ;
 wire \tl_rom_h2d[71] ;
 wire \tl_rom_h2d[72] ;
 wire \tl_rom_h2d[73] ;
 wire \tl_rom_h2d[74] ;
 wire \tl_rom_h2d[75] ;
 wire \tl_rom_h2d[76] ;
 wire \tl_rom_h2d[77] ;
 wire \tl_rom_h2d[78] ;
 wire \tl_rom_h2d[79] ;
 wire \tl_rom_h2d[7] ;
 wire \tl_rom_h2d[80] ;
 wire \tl_rom_h2d[81] ;
 wire \tl_rom_h2d[82] ;
 wire \tl_rom_h2d[83] ;
 wire \tl_rom_h2d[84] ;
 wire \tl_rom_h2d[85] ;
 wire \tl_rom_h2d[86] ;
 wire \tl_rom_h2d[87] ;
 wire \tl_rom_h2d[88] ;
 wire \tl_rom_h2d[89] ;
 wire \tl_rom_h2d[8] ;
 wire \tl_rom_h2d[90] ;
 wire \tl_rom_h2d[91] ;
 wire \tl_rom_h2d[92] ;
 wire \tl_rom_h2d[93] ;
 wire \tl_rom_h2d[94] ;
 wire \tl_rom_h2d[95] ;
 wire \tl_rom_h2d[96] ;
 wire \tl_rom_h2d[97] ;
 wire \tl_rom_h2d[98] ;
 wire \tl_rom_h2d[99] ;
 wire \tl_rom_h2d[9] ;
 wire \tl_spi_d2h[0] ;
 wire \tl_spi_d2h[10] ;
 wire \tl_spi_d2h[11] ;
 wire \tl_spi_d2h[12] ;
 wire \tl_spi_d2h[13] ;
 wire \tl_spi_d2h[14] ;
 wire \tl_spi_d2h[15] ;
 wire \tl_spi_d2h[16] ;
 wire \tl_spi_d2h[17] ;
 wire \tl_spi_d2h[18] ;
 wire \tl_spi_d2h[19] ;
 wire \tl_spi_d2h[1] ;
 wire \tl_spi_d2h[20] ;
 wire \tl_spi_d2h[21] ;
 wire \tl_spi_d2h[22] ;
 wire \tl_spi_d2h[23] ;
 wire \tl_spi_d2h[24] ;
 wire \tl_spi_d2h[25] ;
 wire \tl_spi_d2h[26] ;
 wire \tl_spi_d2h[27] ;
 wire \tl_spi_d2h[28] ;
 wire \tl_spi_d2h[29] ;
 wire \tl_spi_d2h[2] ;
 wire \tl_spi_d2h[30] ;
 wire \tl_spi_d2h[31] ;
 wire \tl_spi_d2h[32] ;
 wire \tl_spi_d2h[33] ;
 wire \tl_spi_d2h[34] ;
 wire \tl_spi_d2h[35] ;
 wire \tl_spi_d2h[36] ;
 wire \tl_spi_d2h[37] ;
 wire \tl_spi_d2h[38] ;
 wire \tl_spi_d2h[39] ;
 wire \tl_spi_d2h[3] ;
 wire \tl_spi_d2h[40] ;
 wire \tl_spi_d2h[41] ;
 wire \tl_spi_d2h[42] ;
 wire \tl_spi_d2h[43] ;
 wire \tl_spi_d2h[44] ;
 wire \tl_spi_d2h[45] ;
 wire \tl_spi_d2h[46] ;
 wire \tl_spi_d2h[47] ;
 wire \tl_spi_d2h[48] ;
 wire \tl_spi_d2h[49] ;
 wire \tl_spi_d2h[4] ;
 wire \tl_spi_d2h[50] ;
 wire \tl_spi_d2h[51] ;
 wire \tl_spi_d2h[52] ;
 wire \tl_spi_d2h[53] ;
 wire \tl_spi_d2h[54] ;
 wire \tl_spi_d2h[55] ;
 wire \tl_spi_d2h[56] ;
 wire \tl_spi_d2h[57] ;
 wire \tl_spi_d2h[58] ;
 wire \tl_spi_d2h[59] ;
 wire \tl_spi_d2h[5] ;
 wire \tl_spi_d2h[60] ;
 wire \tl_spi_d2h[61] ;
 wire \tl_spi_d2h[62] ;
 wire \tl_spi_d2h[63] ;
 wire \tl_spi_d2h[64] ;
 wire \tl_spi_d2h[65] ;
 wire \tl_spi_d2h[6] ;
 wire \tl_spi_d2h[7] ;
 wire \tl_spi_d2h[8] ;
 wire \tl_spi_d2h[9] ;
 wire \tl_spi_h2d[0] ;
 wire \tl_spi_h2d[100] ;
 wire \tl_spi_h2d[101] ;
 wire \tl_spi_h2d[102] ;
 wire \tl_spi_h2d[103] ;
 wire \tl_spi_h2d[104] ;
 wire \tl_spi_h2d[105] ;
 wire \tl_spi_h2d[106] ;
 wire \tl_spi_h2d[107] ;
 wire \tl_spi_h2d[108] ;
 wire \tl_spi_h2d[109] ;
 wire \tl_spi_h2d[10] ;
 wire \tl_spi_h2d[11] ;
 wire \tl_spi_h2d[12] ;
 wire \tl_spi_h2d[13] ;
 wire \tl_spi_h2d[14] ;
 wire \tl_spi_h2d[15] ;
 wire \tl_spi_h2d[16] ;
 wire \tl_spi_h2d[17] ;
 wire \tl_spi_h2d[18] ;
 wire \tl_spi_h2d[19] ;
 wire \tl_spi_h2d[1] ;
 wire \tl_spi_h2d[20] ;
 wire \tl_spi_h2d[21] ;
 wire \tl_spi_h2d[22] ;
 wire \tl_spi_h2d[23] ;
 wire \tl_spi_h2d[24] ;
 wire \tl_spi_h2d[25] ;
 wire \tl_spi_h2d[26] ;
 wire \tl_spi_h2d[27] ;
 wire \tl_spi_h2d[28] ;
 wire \tl_spi_h2d[29] ;
 wire \tl_spi_h2d[2] ;
 wire \tl_spi_h2d[30] ;
 wire \tl_spi_h2d[31] ;
 wire \tl_spi_h2d[32] ;
 wire \tl_spi_h2d[33] ;
 wire \tl_spi_h2d[34] ;
 wire \tl_spi_h2d[35] ;
 wire \tl_spi_h2d[36] ;
 wire \tl_spi_h2d[37] ;
 wire \tl_spi_h2d[38] ;
 wire \tl_spi_h2d[39] ;
 wire \tl_spi_h2d[3] ;
 wire \tl_spi_h2d[40] ;
 wire \tl_spi_h2d[41] ;
 wire \tl_spi_h2d[42] ;
 wire \tl_spi_h2d[43] ;
 wire \tl_spi_h2d[44] ;
 wire \tl_spi_h2d[45] ;
 wire \tl_spi_h2d[46] ;
 wire \tl_spi_h2d[47] ;
 wire \tl_spi_h2d[48] ;
 wire \tl_spi_h2d[49] ;
 wire \tl_spi_h2d[4] ;
 wire \tl_spi_h2d[50] ;
 wire \tl_spi_h2d[51] ;
 wire \tl_spi_h2d[52] ;
 wire \tl_spi_h2d[53] ;
 wire \tl_spi_h2d[54] ;
 wire \tl_spi_h2d[55] ;
 wire \tl_spi_h2d[56] ;
 wire \tl_spi_h2d[57] ;
 wire \tl_spi_h2d[58] ;
 wire \tl_spi_h2d[59] ;
 wire \tl_spi_h2d[5] ;
 wire \tl_spi_h2d[60] ;
 wire \tl_spi_h2d[61] ;
 wire \tl_spi_h2d[62] ;
 wire \tl_spi_h2d[63] ;
 wire \tl_spi_h2d[64] ;
 wire \tl_spi_h2d[65] ;
 wire \tl_spi_h2d[66] ;
 wire \tl_spi_h2d[67] ;
 wire \tl_spi_h2d[68] ;
 wire \tl_spi_h2d[69] ;
 wire \tl_spi_h2d[6] ;
 wire \tl_spi_h2d[70] ;
 wire \tl_spi_h2d[71] ;
 wire \tl_spi_h2d[72] ;
 wire \tl_spi_h2d[73] ;
 wire \tl_spi_h2d[74] ;
 wire \tl_spi_h2d[75] ;
 wire \tl_spi_h2d[76] ;
 wire \tl_spi_h2d[77] ;
 wire \tl_spi_h2d[78] ;
 wire \tl_spi_h2d[79] ;
 wire \tl_spi_h2d[7] ;
 wire \tl_spi_h2d[80] ;
 wire \tl_spi_h2d[81] ;
 wire \tl_spi_h2d[82] ;
 wire \tl_spi_h2d[83] ;
 wire \tl_spi_h2d[84] ;
 wire \tl_spi_h2d[85] ;
 wire \tl_spi_h2d[86] ;
 wire \tl_spi_h2d[87] ;
 wire \tl_spi_h2d[88] ;
 wire \tl_spi_h2d[89] ;
 wire \tl_spi_h2d[8] ;
 wire \tl_spi_h2d[90] ;
 wire \tl_spi_h2d[91] ;
 wire \tl_spi_h2d[92] ;
 wire \tl_spi_h2d[93] ;
 wire \tl_spi_h2d[94] ;
 wire \tl_spi_h2d[95] ;
 wire \tl_spi_h2d[96] ;
 wire \tl_spi_h2d[97] ;
 wire \tl_spi_h2d[98] ;
 wire \tl_spi_h2d[99] ;
 wire \tl_spi_h2d[9] ;
 wire \tl_uart_d2h[0] ;
 wire \tl_uart_d2h[10] ;
 wire \tl_uart_d2h[11] ;
 wire \tl_uart_d2h[12] ;
 wire \tl_uart_d2h[13] ;
 wire \tl_uart_d2h[14] ;
 wire \tl_uart_d2h[15] ;
 wire \tl_uart_d2h[16] ;
 wire \tl_uart_d2h[17] ;
 wire \tl_uart_d2h[18] ;
 wire \tl_uart_d2h[19] ;
 wire \tl_uart_d2h[1] ;
 wire \tl_uart_d2h[20] ;
 wire \tl_uart_d2h[21] ;
 wire \tl_uart_d2h[22] ;
 wire \tl_uart_d2h[23] ;
 wire \tl_uart_d2h[24] ;
 wire \tl_uart_d2h[25] ;
 wire \tl_uart_d2h[26] ;
 wire \tl_uart_d2h[27] ;
 wire \tl_uart_d2h[28] ;
 wire \tl_uart_d2h[29] ;
 wire \tl_uart_d2h[2] ;
 wire \tl_uart_d2h[30] ;
 wire \tl_uart_d2h[31] ;
 wire \tl_uart_d2h[32] ;
 wire \tl_uart_d2h[33] ;
 wire \tl_uart_d2h[34] ;
 wire \tl_uart_d2h[35] ;
 wire \tl_uart_d2h[36] ;
 wire \tl_uart_d2h[37] ;
 wire \tl_uart_d2h[38] ;
 wire \tl_uart_d2h[39] ;
 wire \tl_uart_d2h[3] ;
 wire \tl_uart_d2h[40] ;
 wire \tl_uart_d2h[41] ;
 wire \tl_uart_d2h[42] ;
 wire \tl_uart_d2h[43] ;
 wire \tl_uart_d2h[44] ;
 wire \tl_uart_d2h[45] ;
 wire \tl_uart_d2h[46] ;
 wire \tl_uart_d2h[47] ;
 wire \tl_uart_d2h[48] ;
 wire \tl_uart_d2h[49] ;
 wire \tl_uart_d2h[4] ;
 wire \tl_uart_d2h[50] ;
 wire \tl_uart_d2h[51] ;
 wire \tl_uart_d2h[52] ;
 wire \tl_uart_d2h[53] ;
 wire \tl_uart_d2h[54] ;
 wire \tl_uart_d2h[55] ;
 wire \tl_uart_d2h[56] ;
 wire \tl_uart_d2h[57] ;
 wire \tl_uart_d2h[58] ;
 wire \tl_uart_d2h[59] ;
 wire \tl_uart_d2h[5] ;
 wire \tl_uart_d2h[60] ;
 wire \tl_uart_d2h[61] ;
 wire \tl_uart_d2h[62] ;
 wire \tl_uart_d2h[63] ;
 wire \tl_uart_d2h[64] ;
 wire \tl_uart_d2h[65] ;
 wire \tl_uart_d2h[6] ;
 wire \tl_uart_d2h[7] ;
 wire \tl_uart_d2h[8] ;
 wire \tl_uart_d2h[9] ;
 wire \tl_uart_h2d[0] ;
 wire \tl_uart_h2d[100] ;
 wire \tl_uart_h2d[101] ;
 wire \tl_uart_h2d[102] ;
 wire \tl_uart_h2d[103] ;
 wire \tl_uart_h2d[104] ;
 wire \tl_uart_h2d[105] ;
 wire \tl_uart_h2d[106] ;
 wire \tl_uart_h2d[107] ;
 wire \tl_uart_h2d[108] ;
 wire \tl_uart_h2d[109] ;
 wire \tl_uart_h2d[10] ;
 wire \tl_uart_h2d[11] ;
 wire \tl_uart_h2d[12] ;
 wire \tl_uart_h2d[13] ;
 wire \tl_uart_h2d[14] ;
 wire \tl_uart_h2d[15] ;
 wire \tl_uart_h2d[16] ;
 wire \tl_uart_h2d[17] ;
 wire \tl_uart_h2d[18] ;
 wire \tl_uart_h2d[19] ;
 wire \tl_uart_h2d[1] ;
 wire \tl_uart_h2d[20] ;
 wire \tl_uart_h2d[21] ;
 wire \tl_uart_h2d[22] ;
 wire \tl_uart_h2d[23] ;
 wire \tl_uart_h2d[24] ;
 wire \tl_uart_h2d[25] ;
 wire \tl_uart_h2d[26] ;
 wire \tl_uart_h2d[27] ;
 wire \tl_uart_h2d[28] ;
 wire \tl_uart_h2d[29] ;
 wire \tl_uart_h2d[2] ;
 wire \tl_uart_h2d[30] ;
 wire \tl_uart_h2d[31] ;
 wire \tl_uart_h2d[32] ;
 wire \tl_uart_h2d[33] ;
 wire \tl_uart_h2d[34] ;
 wire \tl_uart_h2d[35] ;
 wire \tl_uart_h2d[36] ;
 wire \tl_uart_h2d[37] ;
 wire \tl_uart_h2d[38] ;
 wire \tl_uart_h2d[39] ;
 wire \tl_uart_h2d[3] ;
 wire \tl_uart_h2d[40] ;
 wire \tl_uart_h2d[41] ;
 wire \tl_uart_h2d[42] ;
 wire \tl_uart_h2d[43] ;
 wire \tl_uart_h2d[44] ;
 wire \tl_uart_h2d[45] ;
 wire \tl_uart_h2d[46] ;
 wire \tl_uart_h2d[47] ;
 wire \tl_uart_h2d[48] ;
 wire \tl_uart_h2d[49] ;
 wire \tl_uart_h2d[4] ;
 wire \tl_uart_h2d[50] ;
 wire \tl_uart_h2d[51] ;
 wire \tl_uart_h2d[52] ;
 wire \tl_uart_h2d[53] ;
 wire \tl_uart_h2d[54] ;
 wire \tl_uart_h2d[55] ;
 wire \tl_uart_h2d[56] ;
 wire \tl_uart_h2d[57] ;
 wire \tl_uart_h2d[58] ;
 wire \tl_uart_h2d[59] ;
 wire \tl_uart_h2d[5] ;
 wire \tl_uart_h2d[60] ;
 wire \tl_uart_h2d[61] ;
 wire \tl_uart_h2d[62] ;
 wire \tl_uart_h2d[63] ;
 wire \tl_uart_h2d[64] ;
 wire \tl_uart_h2d[65] ;
 wire \tl_uart_h2d[66] ;
 wire \tl_uart_h2d[67] ;
 wire \tl_uart_h2d[68] ;
 wire \tl_uart_h2d[69] ;
 wire \tl_uart_h2d[6] ;
 wire \tl_uart_h2d[70] ;
 wire \tl_uart_h2d[71] ;
 wire \tl_uart_h2d[72] ;
 wire \tl_uart_h2d[73] ;
 wire \tl_uart_h2d[74] ;
 wire \tl_uart_h2d[75] ;
 wire \tl_uart_h2d[76] ;
 wire \tl_uart_h2d[77] ;
 wire \tl_uart_h2d[78] ;
 wire \tl_uart_h2d[79] ;
 wire \tl_uart_h2d[7] ;
 wire \tl_uart_h2d[80] ;
 wire \tl_uart_h2d[81] ;
 wire \tl_uart_h2d[82] ;
 wire \tl_uart_h2d[83] ;
 wire \tl_uart_h2d[84] ;
 wire \tl_uart_h2d[85] ;
 wire \tl_uart_h2d[86] ;
 wire \tl_uart_h2d[87] ;
 wire \tl_uart_h2d[88] ;
 wire \tl_uart_h2d[89] ;
 wire \tl_uart_h2d[8] ;
 wire \tl_uart_h2d[90] ;
 wire \tl_uart_h2d[91] ;
 wire \tl_uart_h2d[92] ;
 wire \tl_uart_h2d[93] ;
 wire \tl_uart_h2d[94] ;
 wire \tl_uart_h2d[95] ;
 wire \tl_uart_h2d[96] ;
 wire \tl_uart_h2d[97] ;
 wire \tl_uart_h2d[98] ;
 wire \tl_uart_h2d[99] ;
 wire \tl_uart_h2d[9] ;
 wire \tl_xbar_apb_h2d[0] ;
 wire \tl_xbar_apb_h2d[100] ;
 wire \tl_xbar_apb_h2d[101] ;
 wire \tl_xbar_apb_h2d[102] ;
 wire \tl_xbar_apb_h2d[103] ;
 wire \tl_xbar_apb_h2d[104] ;
 wire \tl_xbar_apb_h2d[105] ;
 wire \tl_xbar_apb_h2d[106] ;
 wire \tl_xbar_apb_h2d[107] ;
 wire \tl_xbar_apb_h2d[108] ;
 wire \tl_xbar_apb_h2d[109] ;
 wire \tl_xbar_apb_h2d[10] ;
 wire \tl_xbar_apb_h2d[11] ;
 wire \tl_xbar_apb_h2d[12] ;
 wire \tl_xbar_apb_h2d[13] ;
 wire \tl_xbar_apb_h2d[14] ;
 wire \tl_xbar_apb_h2d[15] ;
 wire \tl_xbar_apb_h2d[16] ;
 wire \tl_xbar_apb_h2d[17] ;
 wire \tl_xbar_apb_h2d[18] ;
 wire \tl_xbar_apb_h2d[19] ;
 wire \tl_xbar_apb_h2d[1] ;
 wire \tl_xbar_apb_h2d[20] ;
 wire \tl_xbar_apb_h2d[21] ;
 wire \tl_xbar_apb_h2d[22] ;
 wire \tl_xbar_apb_h2d[23] ;
 wire \tl_xbar_apb_h2d[24] ;
 wire \tl_xbar_apb_h2d[25] ;
 wire \tl_xbar_apb_h2d[26] ;
 wire \tl_xbar_apb_h2d[27] ;
 wire \tl_xbar_apb_h2d[28] ;
 wire \tl_xbar_apb_h2d[29] ;
 wire \tl_xbar_apb_h2d[2] ;
 wire \tl_xbar_apb_h2d[30] ;
 wire \tl_xbar_apb_h2d[31] ;
 wire \tl_xbar_apb_h2d[32] ;
 wire \tl_xbar_apb_h2d[33] ;
 wire \tl_xbar_apb_h2d[34] ;
 wire \tl_xbar_apb_h2d[35] ;
 wire \tl_xbar_apb_h2d[36] ;
 wire \tl_xbar_apb_h2d[37] ;
 wire \tl_xbar_apb_h2d[38] ;
 wire \tl_xbar_apb_h2d[39] ;
 wire \tl_xbar_apb_h2d[3] ;
 wire \tl_xbar_apb_h2d[40] ;
 wire \tl_xbar_apb_h2d[41] ;
 wire \tl_xbar_apb_h2d[42] ;
 wire \tl_xbar_apb_h2d[43] ;
 wire \tl_xbar_apb_h2d[44] ;
 wire \tl_xbar_apb_h2d[45] ;
 wire \tl_xbar_apb_h2d[46] ;
 wire \tl_xbar_apb_h2d[47] ;
 wire \tl_xbar_apb_h2d[48] ;
 wire \tl_xbar_apb_h2d[49] ;
 wire \tl_xbar_apb_h2d[4] ;
 wire \tl_xbar_apb_h2d[50] ;
 wire \tl_xbar_apb_h2d[51] ;
 wire \tl_xbar_apb_h2d[52] ;
 wire \tl_xbar_apb_h2d[53] ;
 wire \tl_xbar_apb_h2d[54] ;
 wire \tl_xbar_apb_h2d[55] ;
 wire \tl_xbar_apb_h2d[56] ;
 wire \tl_xbar_apb_h2d[57] ;
 wire \tl_xbar_apb_h2d[58] ;
 wire \tl_xbar_apb_h2d[59] ;
 wire \tl_xbar_apb_h2d[5] ;
 wire \tl_xbar_apb_h2d[60] ;
 wire \tl_xbar_apb_h2d[61] ;
 wire \tl_xbar_apb_h2d[62] ;
 wire \tl_xbar_apb_h2d[63] ;
 wire \tl_xbar_apb_h2d[64] ;
 wire \tl_xbar_apb_h2d[65] ;
 wire \tl_xbar_apb_h2d[66] ;
 wire \tl_xbar_apb_h2d[67] ;
 wire \tl_xbar_apb_h2d[68] ;
 wire \tl_xbar_apb_h2d[69] ;
 wire \tl_xbar_apb_h2d[6] ;
 wire \tl_xbar_apb_h2d[70] ;
 wire \tl_xbar_apb_h2d[71] ;
 wire \tl_xbar_apb_h2d[72] ;
 wire \tl_xbar_apb_h2d[73] ;
 wire \tl_xbar_apb_h2d[74] ;
 wire \tl_xbar_apb_h2d[75] ;
 wire \tl_xbar_apb_h2d[76] ;
 wire \tl_xbar_apb_h2d[77] ;
 wire \tl_xbar_apb_h2d[78] ;
 wire \tl_xbar_apb_h2d[79] ;
 wire \tl_xbar_apb_h2d[7] ;
 wire \tl_xbar_apb_h2d[80] ;
 wire \tl_xbar_apb_h2d[81] ;
 wire \tl_xbar_apb_h2d[82] ;
 wire \tl_xbar_apb_h2d[83] ;
 wire \tl_xbar_apb_h2d[84] ;
 wire \tl_xbar_apb_h2d[85] ;
 wire \tl_xbar_apb_h2d[86] ;
 wire \tl_xbar_apb_h2d[87] ;
 wire \tl_xbar_apb_h2d[88] ;
 wire \tl_xbar_apb_h2d[89] ;
 wire \tl_xbar_apb_h2d[8] ;
 wire \tl_xbar_apb_h2d[90] ;
 wire \tl_xbar_apb_h2d[91] ;
 wire \tl_xbar_apb_h2d[92] ;
 wire \tl_xbar_apb_h2d[93] ;
 wire \tl_xbar_apb_h2d[94] ;
 wire \tl_xbar_apb_h2d[95] ;
 wire \tl_xbar_apb_h2d[96] ;
 wire \tl_xbar_apb_h2d[97] ;
 wire \tl_xbar_apb_h2d[98] ;
 wire \tl_xbar_apb_h2d[99] ;
 wire \tl_xbar_apb_h2d[9] ;
 wire uart_rx;
 wire uart_tx;
 wire zero_;

 fft_ctrl_tlul u_fft (.clk_i(clk),
    .fft_done_o(fft_done),
    .fft_error_o(fft_error),
    .rst_ni(rst_n),
    .sram_clk_o(fft_sram_clk),
    .sram_rwb_o(fft_sram_rwb),
    .sram_addr_o({\fft_sram_addr[9] ,
    \fft_sram_addr[8] ,
    \fft_sram_addr[7] ,
    \fft_sram_addr[6] ,
    \fft_sram_addr[5] ,
    \fft_sram_addr[4] ,
    \fft_sram_addr[3] ,
    \fft_sram_addr[2] ,
    \fft_sram_addr[1] ,
    \fft_sram_addr[0] }),
    .sram_ben_o({\fft_sram_ben[31] ,
    \fft_sram_ben[30] ,
    \fft_sram_ben[29] ,
    \fft_sram_ben[28] ,
    \fft_sram_ben[27] ,
    \fft_sram_ben[26] ,
    \fft_sram_ben[25] ,
    \fft_sram_ben[24] ,
    \fft_sram_ben[23] ,
    \fft_sram_ben[22] ,
    \fft_sram_ben[21] ,
    \fft_sram_ben[20] ,
    \fft_sram_ben[19] ,
    \fft_sram_ben[18] ,
    \fft_sram_ben[17] ,
    \fft_sram_ben[16] ,
    \fft_sram_ben[15] ,
    \fft_sram_ben[14] ,
    \fft_sram_ben[13] ,
    \fft_sram_ben[12] ,
    \fft_sram_ben[11] ,
    \fft_sram_ben[10] ,
    \fft_sram_ben[9] ,
    \fft_sram_ben[8] ,
    \fft_sram_ben[7] ,
    \fft_sram_ben[6] ,
    \fft_sram_ben[5] ,
    \fft_sram_ben[4] ,
    \fft_sram_ben[3] ,
    \fft_sram_ben[2] ,
    \fft_sram_ben[1] ,
    \fft_sram_ben[0] }),
    .sram_en_o({\fft_sram_en[1] ,
    \fft_sram_en[0] }),
    .sram_rdata0_i({\fft_sram_rdata0[31] ,
    \fft_sram_rdata0[30] ,
    \fft_sram_rdata0[29] ,
    \fft_sram_rdata0[28] ,
    \fft_sram_rdata0[27] ,
    \fft_sram_rdata0[26] ,
    \fft_sram_rdata0[25] ,
    \fft_sram_rdata0[24] ,
    \fft_sram_rdata0[23] ,
    \fft_sram_rdata0[22] ,
    \fft_sram_rdata0[21] ,
    \fft_sram_rdata0[20] ,
    \fft_sram_rdata0[19] ,
    \fft_sram_rdata0[18] ,
    \fft_sram_rdata0[17] ,
    \fft_sram_rdata0[16] ,
    \fft_sram_rdata0[15] ,
    \fft_sram_rdata0[14] ,
    \fft_sram_rdata0[13] ,
    \fft_sram_rdata0[12] ,
    \fft_sram_rdata0[11] ,
    \fft_sram_rdata0[10] ,
    \fft_sram_rdata0[9] ,
    \fft_sram_rdata0[8] ,
    \fft_sram_rdata0[7] ,
    \fft_sram_rdata0[6] ,
    \fft_sram_rdata0[5] ,
    \fft_sram_rdata0[4] ,
    \fft_sram_rdata0[3] ,
    \fft_sram_rdata0[2] ,
    \fft_sram_rdata0[1] ,
    \fft_sram_rdata0[0] }),
    .sram_rdata1_i({\fft_sram_rdata1[31] ,
    \fft_sram_rdata1[30] ,
    \fft_sram_rdata1[29] ,
    \fft_sram_rdata1[28] ,
    \fft_sram_rdata1[27] ,
    \fft_sram_rdata1[26] ,
    \fft_sram_rdata1[25] ,
    \fft_sram_rdata1[24] ,
    \fft_sram_rdata1[23] ,
    \fft_sram_rdata1[22] ,
    \fft_sram_rdata1[21] ,
    \fft_sram_rdata1[20] ,
    \fft_sram_rdata1[19] ,
    \fft_sram_rdata1[18] ,
    \fft_sram_rdata1[17] ,
    \fft_sram_rdata1[16] ,
    \fft_sram_rdata1[15] ,
    \fft_sram_rdata1[14] ,
    \fft_sram_rdata1[13] ,
    \fft_sram_rdata1[12] ,
    \fft_sram_rdata1[11] ,
    \fft_sram_rdata1[10] ,
    \fft_sram_rdata1[9] ,
    \fft_sram_rdata1[8] ,
    \fft_sram_rdata1[7] ,
    \fft_sram_rdata1[6] ,
    \fft_sram_rdata1[5] ,
    \fft_sram_rdata1[4] ,
    \fft_sram_rdata1[3] ,
    \fft_sram_rdata1[2] ,
    \fft_sram_rdata1[1] ,
    \fft_sram_rdata1[0] }),
    .sram_wdata_o({\fft_sram_wdata[31] ,
    \fft_sram_wdata[30] ,
    \fft_sram_wdata[29] ,
    \fft_sram_wdata[28] ,
    \fft_sram_wdata[27] ,
    \fft_sram_wdata[26] ,
    \fft_sram_wdata[25] ,
    \fft_sram_wdata[24] ,
    \fft_sram_wdata[23] ,
    \fft_sram_wdata[22] ,
    \fft_sram_wdata[21] ,
    \fft_sram_wdata[20] ,
    \fft_sram_wdata[19] ,
    \fft_sram_wdata[18] ,
    \fft_sram_wdata[17] ,
    \fft_sram_wdata[16] ,
    \fft_sram_wdata[15] ,
    \fft_sram_wdata[14] ,
    \fft_sram_wdata[13] ,
    \fft_sram_wdata[12] ,
    \fft_sram_wdata[11] ,
    \fft_sram_wdata[10] ,
    \fft_sram_wdata[9] ,
    \fft_sram_wdata[8] ,
    \fft_sram_wdata[7] ,
    \fft_sram_wdata[6] ,
    \fft_sram_wdata[5] ,
    \fft_sram_wdata[4] ,
    \fft_sram_wdata[3] ,
    \fft_sram_wdata[2] ,
    \fft_sram_wdata[1] ,
    \fft_sram_wdata[0] }),
    .tl_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_o({\fft_tl_o_unused[65] ,
    \fft_tl_o_unused[64] ,
    \fft_tl_o_unused[63] ,
    \fft_tl_o_unused[62] ,
    \fft_tl_o_unused[61] ,
    \fft_tl_o_unused[60] ,
    \fft_tl_o_unused[59] ,
    \fft_tl_o_unused[58] ,
    \fft_tl_o_unused[57] ,
    \fft_tl_o_unused[56] ,
    \fft_tl_o_unused[55] ,
    \fft_tl_o_unused[54] ,
    \fft_tl_o_unused[53] ,
    \fft_tl_o_unused[52] ,
    \fft_tl_o_unused[51] ,
    \fft_tl_o_unused[50] ,
    \fft_tl_o_unused[49] ,
    \fft_tl_o_unused[48] ,
    \fft_tl_o_unused[47] ,
    \fft_tl_o_unused[46] ,
    \fft_tl_o_unused[45] ,
    \fft_tl_o_unused[44] ,
    \fft_tl_o_unused[43] ,
    \fft_tl_o_unused[42] ,
    \fft_tl_o_unused[41] ,
    \fft_tl_o_unused[40] ,
    \fft_tl_o_unused[39] ,
    \fft_tl_o_unused[38] ,
    \fft_tl_o_unused[37] ,
    \fft_tl_o_unused[36] ,
    \fft_tl_o_unused[35] ,
    \fft_tl_o_unused[34] ,
    \fft_tl_o_unused[33] ,
    \fft_tl_o_unused[32] ,
    \fft_tl_o_unused[31] ,
    \fft_tl_o_unused[30] ,
    \fft_tl_o_unused[29] ,
    \fft_tl_o_unused[28] ,
    \fft_tl_o_unused[27] ,
    \fft_tl_o_unused[26] ,
    \fft_tl_o_unused[25] ,
    \fft_tl_o_unused[24] ,
    \fft_tl_o_unused[23] ,
    \fft_tl_o_unused[22] ,
    \fft_tl_o_unused[21] ,
    \fft_tl_o_unused[20] ,
    \fft_tl_o_unused[19] ,
    \fft_tl_o_unused[18] ,
    \fft_tl_o_unused[17] ,
    \fft_tl_o_unused[16] ,
    \fft_tl_o_unused[15] ,
    \fft_tl_o_unused[14] ,
    \fft_tl_o_unused[13] ,
    \fft_tl_o_unused[12] ,
    \fft_tl_o_unused[11] ,
    \fft_tl_o_unused[10] ,
    \fft_tl_o_unused[9] ,
    \fft_tl_o_unused[8] ,
    \fft_tl_o_unused[7] ,
    \fft_tl_o_unused[6] ,
    \fft_tl_o_unused[5] ,
    \fft_tl_o_unused[4] ,
    \fft_tl_o_unused[3] ,
    \fft_tl_o_unused[2] ,
    \fft_tl_o_unused[1] ,
    \fft_tl_o_unused[0] }));
 CF_SRAM_1024x32 u_fft_bank0 (.WLBI(zero_),
    .WLOFF(zero_),
    .CLKin(fft_sram_clk),
    .EN(\fft_sram_en[0] ),
    .R_WB(fft_sram_rwb),
    .SM(zero_),
    .TM(zero_),
    .ScanInDR(zero_),
    .ScanInDL(zero_),
    .ScanInCC(zero_),
    .vpwrpc(vccd1),
    .vpwrac(vccd1),
    .AD({\fft_sram_addr[9] ,
    \fft_sram_addr[8] ,
    \fft_sram_addr[7] ,
    \fft_sram_addr[6] ,
    \fft_sram_addr[5] ,
    \fft_sram_addr[4] ,
    \fft_sram_addr[3] ,
    \fft_sram_addr[2] ,
    \fft_sram_addr[1] ,
    \fft_sram_addr[0] }),
    .BEN({\fft_sram_ben[31] ,
    \fft_sram_ben[30] ,
    \fft_sram_ben[29] ,
    \fft_sram_ben[28] ,
    \fft_sram_ben[27] ,
    \fft_sram_ben[26] ,
    \fft_sram_ben[25] ,
    \fft_sram_ben[24] ,
    \fft_sram_ben[23] ,
    \fft_sram_ben[22] ,
    \fft_sram_ben[21] ,
    \fft_sram_ben[20] ,
    \fft_sram_ben[19] ,
    \fft_sram_ben[18] ,
    \fft_sram_ben[17] ,
    \fft_sram_ben[16] ,
    \fft_sram_ben[15] ,
    \fft_sram_ben[14] ,
    \fft_sram_ben[13] ,
    \fft_sram_ben[12] ,
    \fft_sram_ben[11] ,
    \fft_sram_ben[10] ,
    \fft_sram_ben[9] ,
    \fft_sram_ben[8] ,
    \fft_sram_ben[7] ,
    \fft_sram_ben[6] ,
    \fft_sram_ben[5] ,
    \fft_sram_ben[4] ,
    \fft_sram_ben[3] ,
    \fft_sram_ben[2] ,
    \fft_sram_ben[1] ,
    \fft_sram_ben[0] }),
    .DI({\fft_sram_wdata[31] ,
    \fft_sram_wdata[30] ,
    \fft_sram_wdata[29] ,
    \fft_sram_wdata[28] ,
    \fft_sram_wdata[27] ,
    \fft_sram_wdata[26] ,
    \fft_sram_wdata[25] ,
    \fft_sram_wdata[24] ,
    \fft_sram_wdata[23] ,
    \fft_sram_wdata[22] ,
    \fft_sram_wdata[21] ,
    \fft_sram_wdata[20] ,
    \fft_sram_wdata[19] ,
    \fft_sram_wdata[18] ,
    \fft_sram_wdata[17] ,
    \fft_sram_wdata[16] ,
    \fft_sram_wdata[15] ,
    \fft_sram_wdata[14] ,
    \fft_sram_wdata[13] ,
    \fft_sram_wdata[12] ,
    \fft_sram_wdata[11] ,
    \fft_sram_wdata[10] ,
    \fft_sram_wdata[9] ,
    \fft_sram_wdata[8] ,
    \fft_sram_wdata[7] ,
    \fft_sram_wdata[6] ,
    \fft_sram_wdata[5] ,
    \fft_sram_wdata[4] ,
    \fft_sram_wdata[3] ,
    \fft_sram_wdata[2] ,
    \fft_sram_wdata[1] ,
    \fft_sram_wdata[0] }),
    .DO({\fft_sram_rdata0[31] ,
    \fft_sram_rdata0[30] ,
    \fft_sram_rdata0[29] ,
    \fft_sram_rdata0[28] ,
    \fft_sram_rdata0[27] ,
    \fft_sram_rdata0[26] ,
    \fft_sram_rdata0[25] ,
    \fft_sram_rdata0[24] ,
    \fft_sram_rdata0[23] ,
    \fft_sram_rdata0[22] ,
    \fft_sram_rdata0[21] ,
    \fft_sram_rdata0[20] ,
    \fft_sram_rdata0[19] ,
    \fft_sram_rdata0[18] ,
    \fft_sram_rdata0[17] ,
    \fft_sram_rdata0[16] ,
    \fft_sram_rdata0[15] ,
    \fft_sram_rdata0[14] ,
    \fft_sram_rdata0[13] ,
    \fft_sram_rdata0[12] ,
    \fft_sram_rdata0[11] ,
    \fft_sram_rdata0[10] ,
    \fft_sram_rdata0[9] ,
    \fft_sram_rdata0[8] ,
    \fft_sram_rdata0[7] ,
    \fft_sram_rdata0[6] ,
    \fft_sram_rdata0[5] ,
    \fft_sram_rdata0[4] ,
    \fft_sram_rdata0[3] ,
    \fft_sram_rdata0[2] ,
    \fft_sram_rdata0[1] ,
    \fft_sram_rdata0[0] }));
 CF_SRAM_1024x32 u_fft_bank1 (.WLBI(zero_),
    .WLOFF(zero_),
    .CLKin(fft_sram_clk),
    .EN(\fft_sram_en[1] ),
    .R_WB(fft_sram_rwb),
    .SM(zero_),
    .TM(zero_),
    .ScanInDR(zero_),
    .ScanInDL(zero_),
    .ScanInCC(zero_),
    .vpwrpc(vccd1),
    .vpwrac(vccd1),
    .AD({\fft_sram_addr[9] ,
    \fft_sram_addr[8] ,
    \fft_sram_addr[7] ,
    \fft_sram_addr[6] ,
    \fft_sram_addr[5] ,
    \fft_sram_addr[4] ,
    \fft_sram_addr[3] ,
    \fft_sram_addr[2] ,
    \fft_sram_addr[1] ,
    \fft_sram_addr[0] }),
    .BEN({\fft_sram_ben[31] ,
    \fft_sram_ben[30] ,
    \fft_sram_ben[29] ,
    \fft_sram_ben[28] ,
    \fft_sram_ben[27] ,
    \fft_sram_ben[26] ,
    \fft_sram_ben[25] ,
    \fft_sram_ben[24] ,
    \fft_sram_ben[23] ,
    \fft_sram_ben[22] ,
    \fft_sram_ben[21] ,
    \fft_sram_ben[20] ,
    \fft_sram_ben[19] ,
    \fft_sram_ben[18] ,
    \fft_sram_ben[17] ,
    \fft_sram_ben[16] ,
    \fft_sram_ben[15] ,
    \fft_sram_ben[14] ,
    \fft_sram_ben[13] ,
    \fft_sram_ben[12] ,
    \fft_sram_ben[11] ,
    \fft_sram_ben[10] ,
    \fft_sram_ben[9] ,
    \fft_sram_ben[8] ,
    \fft_sram_ben[7] ,
    \fft_sram_ben[6] ,
    \fft_sram_ben[5] ,
    \fft_sram_ben[4] ,
    \fft_sram_ben[3] ,
    \fft_sram_ben[2] ,
    \fft_sram_ben[1] ,
    \fft_sram_ben[0] }),
    .DI({\fft_sram_wdata[31] ,
    \fft_sram_wdata[30] ,
    \fft_sram_wdata[29] ,
    \fft_sram_wdata[28] ,
    \fft_sram_wdata[27] ,
    \fft_sram_wdata[26] ,
    \fft_sram_wdata[25] ,
    \fft_sram_wdata[24] ,
    \fft_sram_wdata[23] ,
    \fft_sram_wdata[22] ,
    \fft_sram_wdata[21] ,
    \fft_sram_wdata[20] ,
    \fft_sram_wdata[19] ,
    \fft_sram_wdata[18] ,
    \fft_sram_wdata[17] ,
    \fft_sram_wdata[16] ,
    \fft_sram_wdata[15] ,
    \fft_sram_wdata[14] ,
    \fft_sram_wdata[13] ,
    \fft_sram_wdata[12] ,
    \fft_sram_wdata[11] ,
    \fft_sram_wdata[10] ,
    \fft_sram_wdata[9] ,
    \fft_sram_wdata[8] ,
    \fft_sram_wdata[7] ,
    \fft_sram_wdata[6] ,
    \fft_sram_wdata[5] ,
    \fft_sram_wdata[4] ,
    \fft_sram_wdata[3] ,
    \fft_sram_wdata[2] ,
    \fft_sram_wdata[1] ,
    \fft_sram_wdata[0] }),
    .DO({\fft_sram_rdata1[31] ,
    \fft_sram_rdata1[30] ,
    \fft_sram_rdata1[29] ,
    \fft_sram_rdata1[28] ,
    \fft_sram_rdata1[27] ,
    \fft_sram_rdata1[26] ,
    \fft_sram_rdata1[25] ,
    \fft_sram_rdata1[24] ,
    \fft_sram_rdata1[23] ,
    \fft_sram_rdata1[22] ,
    \fft_sram_rdata1[21] ,
    \fft_sram_rdata1[20] ,
    \fft_sram_rdata1[19] ,
    \fft_sram_rdata1[18] ,
    \fft_sram_rdata1[17] ,
    \fft_sram_rdata1[16] ,
    \fft_sram_rdata1[15] ,
    \fft_sram_rdata1[14] ,
    \fft_sram_rdata1[13] ,
    \fft_sram_rdata1[12] ,
    \fft_sram_rdata1[11] ,
    \fft_sram_rdata1[10] ,
    \fft_sram_rdata1[9] ,
    \fft_sram_rdata1[8] ,
    \fft_sram_rdata1[7] ,
    \fft_sram_rdata1[6] ,
    \fft_sram_rdata1[5] ,
    \fft_sram_rdata1[4] ,
    \fft_sram_rdata1[3] ,
    \fft_sram_rdata1[2] ,
    \fft_sram_rdata1[1] ,
    \fft_sram_rdata1[0] }));
 edge_sensor_glue u_glue (.clk_o(clk),
    .fft_done_i(fft_done),
    .fft_error_i(fft_error),
    .intr_spi_host_idle_i(intr_spi_host_idle),
    .intr_spi_host_rx_full_i(intr_spi_host_rx_full),
    .intr_spi_host_tx_empty_i(intr_spi_host_tx_empty),
    .intr_uart_rx_break_err_i(intr_uart_rx_break_err),
    .intr_uart_rx_frame_err_i(intr_uart_rx_frame_err),
    .intr_uart_rx_overflow_i(intr_uart_rx_overflow),
    .intr_uart_rx_parity_err_i(intr_uart_rx_parity_err),
    .intr_uart_rx_timeout_i(intr_uart_rx_timeout),
    .intr_uart_rx_watermark_i(intr_uart_rx_watermark),
    .intr_uart_tx_done_i(intr_uart_tx_done),
    .intr_uart_tx_empty_i(intr_uart_tx_empty),
    .intr_uart_tx_watermark_i(intr_uart_tx_watermark),
    .plic_irq_i(plic_irq),
    .rst_no(rst_n),
    .spi_cs_n_i(spi_cs_n),
    .spi_miso_o(spi_miso),
    .spi_mosi_i(spi_mosi),
    .spi_sclk_i(spi_sclk),
    .uart_rx_o(uart_rx),
    .uart_tx_i(uart_tx),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .intr_vec_o({\intr_vec[31] ,
    \intr_vec[30] ,
    \intr_vec[29] ,
    \intr_vec[28] ,
    \intr_vec[27] ,
    \intr_vec[26] ,
    \intr_vec[25] ,
    \intr_vec[24] ,
    \intr_vec[23] ,
    \intr_vec[22] ,
    \intr_vec[21] ,
    \intr_vec[20] ,
    \intr_vec[19] ,
    \intr_vec[18] ,
    \intr_vec[17] ,
    \intr_vec[16] ,
    \intr_vec[15] ,
    \intr_vec[14] ,
    \intr_vec[13] ,
    \intr_vec[12] ,
    \intr_vec[11] ,
    \intr_vec[10] ,
    \intr_vec[9] ,
    \intr_vec[8] ,
    \intr_vec[7] ,
    \intr_vec[6] ,
    \intr_vec[5] ,
    \intr_vec[4] ,
    \intr_vec[3] ,
    \intr_vec[2] ,
    \intr_vec[1] ,
    \intr_vec[0] }),
    .io_in({io_in[37],
    io_in[36],
    io_in[35],
    io_in[34],
    io_in[33],
    io_in[32],
    io_in[31],
    io_in[30],
    io_in[29],
    io_in[28],
    io_in[27],
    io_in[26],
    io_in[25],
    io_in[24],
    io_in[23],
    io_in[22],
    io_in[21],
    io_in[20],
    io_in[19],
    io_in[18],
    io_in[17],
    io_in[16],
    io_in[15],
    io_in[14],
    io_in[13],
    io_in[12],
    io_in[11],
    io_in[10],
    io_in[9],
    io_in[8],
    io_in[7],
    io_in[6],
    io_in[5],
    io_in[4],
    io_in[3],
    io_in[2],
    io_in[1],
    io_in[0]}),
    .io_oeb({io_oeb[37],
    io_oeb[36],
    io_oeb[35],
    io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7],
    io_oeb[6],
    io_oeb[5],
    io_oeb[4],
    io_oeb[3],
    io_oeb[2],
    io_oeb[1],
    io_oeb[0]}),
    .io_out({io_out[37],
    io_out[36],
    io_out[35],
    io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7],
    io_out[6],
    io_out[5],
    io_out[4],
    io_out[3],
    io_out[2],
    io_out[1],
    io_out[0]}),
    .la_data_in({la_data_in[127],
    la_data_in[126],
    la_data_in[125],
    la_data_in[124],
    la_data_in[123],
    la_data_in[122],
    la_data_in[121],
    la_data_in[120],
    la_data_in[119],
    la_data_in[118],
    la_data_in[117],
    la_data_in[116],
    la_data_in[115],
    la_data_in[114],
    la_data_in[113],
    la_data_in[112],
    la_data_in[111],
    la_data_in[110],
    la_data_in[109],
    la_data_in[108],
    la_data_in[107],
    la_data_in[106],
    la_data_in[105],
    la_data_in[104],
    la_data_in[103],
    la_data_in[102],
    la_data_in[101],
    la_data_in[100],
    la_data_in[99],
    la_data_in[98],
    la_data_in[97],
    la_data_in[96],
    la_data_in[95],
    la_data_in[94],
    la_data_in[93],
    la_data_in[92],
    la_data_in[91],
    la_data_in[90],
    la_data_in[89],
    la_data_in[88],
    la_data_in[87],
    la_data_in[86],
    la_data_in[85],
    la_data_in[84],
    la_data_in[83],
    la_data_in[82],
    la_data_in[81],
    la_data_in[80],
    la_data_in[79],
    la_data_in[78],
    la_data_in[77],
    la_data_in[76],
    la_data_in[75],
    la_data_in[74],
    la_data_in[73],
    la_data_in[72],
    la_data_in[71],
    la_data_in[70],
    la_data_in[69],
    la_data_in[68],
    la_data_in[67],
    la_data_in[66],
    la_data_in[65],
    la_data_in[64],
    la_data_in[63],
    la_data_in[62],
    la_data_in[61],
    la_data_in[60],
    la_data_in[59],
    la_data_in[58],
    la_data_in[57],
    la_data_in[56],
    la_data_in[55],
    la_data_in[54],
    la_data_in[53],
    la_data_in[52],
    la_data_in[51],
    la_data_in[50],
    la_data_in[49],
    la_data_in[48],
    la_data_in[47],
    la_data_in[46],
    la_data_in[45],
    la_data_in[44],
    la_data_in[43],
    la_data_in[42],
    la_data_in[41],
    la_data_in[40],
    la_data_in[39],
    la_data_in[38],
    la_data_in[37],
    la_data_in[36],
    la_data_in[35],
    la_data_in[34],
    la_data_in[33],
    la_data_in[32],
    la_data_in[31],
    la_data_in[30],
    la_data_in[29],
    la_data_in[28],
    la_data_in[27],
    la_data_in[26],
    la_data_in[25],
    la_data_in[24],
    la_data_in[23],
    la_data_in[22],
    la_data_in[21],
    la_data_in[20],
    la_data_in[19],
    la_data_in[18],
    la_data_in[17],
    la_data_in[16],
    la_data_in[15],
    la_data_in[14],
    la_data_in[13],
    la_data_in[12],
    la_data_in[11],
    la_data_in[10],
    la_data_in[9],
    la_data_in[8],
    la_data_in[7],
    la_data_in[6],
    la_data_in[5],
    la_data_in[4],
    la_data_in[3],
    la_data_in[2],
    la_data_in[1],
    la_data_in[0]}),
    .la_data_out({la_data_out[127],
    la_data_out[126],
    la_data_out[125],
    la_data_out[124],
    la_data_out[123],
    la_data_out[122],
    la_data_out[121],
    la_data_out[120],
    la_data_out[119],
    la_data_out[118],
    la_data_out[117],
    la_data_out[116],
    la_data_out[115],
    la_data_out[114],
    la_data_out[113],
    la_data_out[112],
    la_data_out[111],
    la_data_out[110],
    la_data_out[109],
    la_data_out[108],
    la_data_out[107],
    la_data_out[106],
    la_data_out[105],
    la_data_out[104],
    la_data_out[103],
    la_data_out[102],
    la_data_out[101],
    la_data_out[100],
    la_data_out[99],
    la_data_out[98],
    la_data_out[97],
    la_data_out[96],
    la_data_out[95],
    la_data_out[94],
    la_data_out[93],
    la_data_out[92],
    la_data_out[91],
    la_data_out[90],
    la_data_out[89],
    la_data_out[88],
    la_data_out[87],
    la_data_out[86],
    la_data_out[85],
    la_data_out[84],
    la_data_out[83],
    la_data_out[82],
    la_data_out[81],
    la_data_out[80],
    la_data_out[79],
    la_data_out[78],
    la_data_out[77],
    la_data_out[76],
    la_data_out[75],
    la_data_out[74],
    la_data_out[73],
    la_data_out[72],
    la_data_out[71],
    la_data_out[70],
    la_data_out[69],
    la_data_out[68],
    la_data_out[67],
    la_data_out[66],
    la_data_out[65],
    la_data_out[64],
    la_data_out[63],
    la_data_out[62],
    la_data_out[61],
    la_data_out[60],
    la_data_out[59],
    la_data_out[58],
    la_data_out[57],
    la_data_out[56],
    la_data_out[55],
    la_data_out[54],
    la_data_out[53],
    la_data_out[52],
    la_data_out[51],
    la_data_out[50],
    la_data_out[49],
    la_data_out[48],
    la_data_out[47],
    la_data_out[46],
    la_data_out[45],
    la_data_out[44],
    la_data_out[43],
    la_data_out[42],
    la_data_out[41],
    la_data_out[40],
    la_data_out[39],
    la_data_out[38],
    la_data_out[37],
    la_data_out[36],
    la_data_out[35],
    la_data_out[34],
    la_data_out[33],
    la_data_out[32],
    la_data_out[31],
    la_data_out[30],
    la_data_out[29],
    la_data_out[28],
    la_data_out[27],
    la_data_out[26],
    la_data_out[25],
    la_data_out[24],
    la_data_out[23],
    la_data_out[22],
    la_data_out[21],
    la_data_out[20],
    la_data_out[19],
    la_data_out[18],
    la_data_out[17],
    la_data_out[16],
    la_data_out[15],
    la_data_out[14],
    la_data_out[13],
    la_data_out[12],
    la_data_out[11],
    la_data_out[10],
    la_data_out[9],
    la_data_out[8],
    la_data_out[7],
    la_data_out[6],
    la_data_out[5],
    la_data_out[4],
    la_data_out[3],
    la_data_out[2],
    la_data_out[1],
    la_data_out[0]}),
    .la_oenb({la_oenb[127],
    la_oenb[126],
    la_oenb[125],
    la_oenb[124],
    la_oenb[123],
    la_oenb[122],
    la_oenb[121],
    la_oenb[120],
    la_oenb[119],
    la_oenb[118],
    la_oenb[117],
    la_oenb[116],
    la_oenb[115],
    la_oenb[114],
    la_oenb[113],
    la_oenb[112],
    la_oenb[111],
    la_oenb[110],
    la_oenb[109],
    la_oenb[108],
    la_oenb[107],
    la_oenb[106],
    la_oenb[105],
    la_oenb[104],
    la_oenb[103],
    la_oenb[102],
    la_oenb[101],
    la_oenb[100],
    la_oenb[99],
    la_oenb[98],
    la_oenb[97],
    la_oenb[96],
    la_oenb[95],
    la_oenb[94],
    la_oenb[93],
    la_oenb[92],
    la_oenb[91],
    la_oenb[90],
    la_oenb[89],
    la_oenb[88],
    la_oenb[87],
    la_oenb[86],
    la_oenb[85],
    la_oenb[84],
    la_oenb[83],
    la_oenb[82],
    la_oenb[81],
    la_oenb[80],
    la_oenb[79],
    la_oenb[78],
    la_oenb[77],
    la_oenb[76],
    la_oenb[75],
    la_oenb[74],
    la_oenb[73],
    la_oenb[72],
    la_oenb[71],
    la_oenb[70],
    la_oenb[69],
    la_oenb[68],
    la_oenb[67],
    la_oenb[66],
    la_oenb[65],
    la_oenb[64],
    la_oenb[63],
    la_oenb[62],
    la_oenb[61],
    la_oenb[60],
    la_oenb[59],
    la_oenb[58],
    la_oenb[57],
    la_oenb[56],
    la_oenb[55],
    la_oenb[54],
    la_oenb[53],
    la_oenb[52],
    la_oenb[51],
    la_oenb[50],
    la_oenb[49],
    la_oenb[48],
    la_oenb[47],
    la_oenb[46],
    la_oenb[45],
    la_oenb[44],
    la_oenb[43],
    la_oenb[42],
    la_oenb[41],
    la_oenb[40],
    la_oenb[39],
    la_oenb[38],
    la_oenb[37],
    la_oenb[36],
    la_oenb[35],
    la_oenb[34],
    la_oenb[33],
    la_oenb[32],
    la_oenb[31],
    la_oenb[30],
    la_oenb[29],
    la_oenb[28],
    la_oenb[27],
    la_oenb[26],
    la_oenb[25],
    la_oenb[24],
    la_oenb[23],
    la_oenb[22],
    la_oenb[21],
    la_oenb[20],
    la_oenb[19],
    la_oenb[18],
    la_oenb[17],
    la_oenb[16],
    la_oenb[15],
    la_oenb[14],
    la_oenb[13],
    la_oenb[12],
    la_oenb[11],
    la_oenb[10],
    la_oenb[9],
    la_oenb[8],
    la_oenb[7],
    la_oenb[6],
    la_oenb[5],
    la_oenb[4],
    la_oenb[3],
    la_oenb[2],
    la_oenb[1],
    la_oenb[0]}),
    .user_irq({user_irq[2],
    user_irq[1],
    user_irq[0]}),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_dat_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wbs_sel_i({wbs_sel_i[3],
    wbs_sel_i[2],
    wbs_sel_i[1],
    wbs_sel_i[0]}));
 rv_core_ibex_tlul u_ibex (.clk_i(clk),
    .irq_external_i(plic_irq),
    .irq_software_i(zero_),
    .irq_timer_i(zero_),
    .rst_ni(rst_n),
    .boot_addr_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    one_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .hart_id_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_i({\tl_cpu_d2h[65] ,
    \tl_cpu_d2h[64] ,
    \tl_cpu_d2h[63] ,
    \tl_cpu_d2h[62] ,
    \tl_cpu_d2h[61] ,
    \tl_cpu_d2h[60] ,
    \tl_cpu_d2h[59] ,
    \tl_cpu_d2h[58] ,
    \tl_cpu_d2h[57] ,
    \tl_cpu_d2h[56] ,
    \tl_cpu_d2h[55] ,
    \tl_cpu_d2h[54] ,
    \tl_cpu_d2h[53] ,
    \tl_cpu_d2h[52] ,
    \tl_cpu_d2h[51] ,
    \tl_cpu_d2h[50] ,
    \tl_cpu_d2h[49] ,
    \tl_cpu_d2h[48] ,
    \tl_cpu_d2h[47] ,
    \tl_cpu_d2h[46] ,
    \tl_cpu_d2h[45] ,
    \tl_cpu_d2h[44] ,
    \tl_cpu_d2h[43] ,
    \tl_cpu_d2h[42] ,
    \tl_cpu_d2h[41] ,
    \tl_cpu_d2h[40] ,
    \tl_cpu_d2h[39] ,
    \tl_cpu_d2h[38] ,
    \tl_cpu_d2h[37] ,
    \tl_cpu_d2h[36] ,
    \tl_cpu_d2h[35] ,
    \tl_cpu_d2h[34] ,
    \tl_cpu_d2h[33] ,
    \tl_cpu_d2h[32] ,
    \tl_cpu_d2h[31] ,
    \tl_cpu_d2h[30] ,
    \tl_cpu_d2h[29] ,
    \tl_cpu_d2h[28] ,
    \tl_cpu_d2h[27] ,
    \tl_cpu_d2h[26] ,
    \tl_cpu_d2h[25] ,
    \tl_cpu_d2h[24] ,
    \tl_cpu_d2h[23] ,
    \tl_cpu_d2h[22] ,
    \tl_cpu_d2h[21] ,
    \tl_cpu_d2h[20] ,
    \tl_cpu_d2h[19] ,
    \tl_cpu_d2h[18] ,
    \tl_cpu_d2h[17] ,
    \tl_cpu_d2h[16] ,
    \tl_cpu_d2h[15] ,
    \tl_cpu_d2h[14] ,
    \tl_cpu_d2h[13] ,
    \tl_cpu_d2h[12] ,
    \tl_cpu_d2h[11] ,
    \tl_cpu_d2h[10] ,
    \tl_cpu_d2h[9] ,
    \tl_cpu_d2h[8] ,
    \tl_cpu_d2h[7] ,
    \tl_cpu_d2h[6] ,
    \tl_cpu_d2h[5] ,
    \tl_cpu_d2h[4] ,
    \tl_cpu_d2h[3] ,
    \tl_cpu_d2h[2] ,
    \tl_cpu_d2h[1] ,
    \tl_cpu_d2h[0] }),
    .tl_o({\tl_cpu_h2d[109] ,
    \tl_cpu_h2d[108] ,
    \tl_cpu_h2d[107] ,
    \tl_cpu_h2d[106] ,
    \tl_cpu_h2d[105] ,
    \tl_cpu_h2d[104] ,
    \tl_cpu_h2d[103] ,
    \tl_cpu_h2d[102] ,
    \tl_cpu_h2d[101] ,
    \tl_cpu_h2d[100] ,
    \tl_cpu_h2d[99] ,
    \tl_cpu_h2d[98] ,
    \tl_cpu_h2d[97] ,
    \tl_cpu_h2d[96] ,
    \tl_cpu_h2d[95] ,
    \tl_cpu_h2d[94] ,
    \tl_cpu_h2d[93] ,
    \tl_cpu_h2d[92] ,
    \tl_cpu_h2d[91] ,
    \tl_cpu_h2d[90] ,
    \tl_cpu_h2d[89] ,
    \tl_cpu_h2d[88] ,
    \tl_cpu_h2d[87] ,
    \tl_cpu_h2d[86] ,
    \tl_cpu_h2d[85] ,
    \tl_cpu_h2d[84] ,
    \tl_cpu_h2d[83] ,
    \tl_cpu_h2d[82] ,
    \tl_cpu_h2d[81] ,
    \tl_cpu_h2d[80] ,
    \tl_cpu_h2d[79] ,
    \tl_cpu_h2d[78] ,
    \tl_cpu_h2d[77] ,
    \tl_cpu_h2d[76] ,
    \tl_cpu_h2d[75] ,
    \tl_cpu_h2d[74] ,
    \tl_cpu_h2d[73] ,
    \tl_cpu_h2d[72] ,
    \tl_cpu_h2d[71] ,
    \tl_cpu_h2d[70] ,
    \tl_cpu_h2d[69] ,
    \tl_cpu_h2d[68] ,
    \tl_cpu_h2d[67] ,
    \tl_cpu_h2d[66] ,
    \tl_cpu_h2d[65] ,
    \tl_cpu_h2d[64] ,
    \tl_cpu_h2d[63] ,
    \tl_cpu_h2d[62] ,
    \tl_cpu_h2d[61] ,
    \tl_cpu_h2d[60] ,
    \tl_cpu_h2d[59] ,
    \tl_cpu_h2d[58] ,
    \tl_cpu_h2d[57] ,
    \tl_cpu_h2d[56] ,
    \tl_cpu_h2d[55] ,
    \tl_cpu_h2d[54] ,
    \tl_cpu_h2d[53] ,
    \tl_cpu_h2d[52] ,
    \tl_cpu_h2d[51] ,
    \tl_cpu_h2d[50] ,
    \tl_cpu_h2d[49] ,
    \tl_cpu_h2d[48] ,
    \tl_cpu_h2d[47] ,
    \tl_cpu_h2d[46] ,
    \tl_cpu_h2d[45] ,
    \tl_cpu_h2d[44] ,
    \tl_cpu_h2d[43] ,
    \tl_cpu_h2d[42] ,
    \tl_cpu_h2d[41] ,
    \tl_cpu_h2d[40] ,
    \tl_cpu_h2d[39] ,
    \tl_cpu_h2d[38] ,
    \tl_cpu_h2d[37] ,
    \tl_cpu_h2d[36] ,
    \tl_cpu_h2d[35] ,
    \tl_cpu_h2d[34] ,
    \tl_cpu_h2d[33] ,
    \tl_cpu_h2d[32] ,
    \tl_cpu_h2d[31] ,
    \tl_cpu_h2d[30] ,
    \tl_cpu_h2d[29] ,
    \tl_cpu_h2d[28] ,
    \tl_cpu_h2d[27] ,
    \tl_cpu_h2d[26] ,
    \tl_cpu_h2d[25] ,
    \tl_cpu_h2d[24] ,
    \tl_cpu_h2d[23] ,
    \tl_cpu_h2d[22] ,
    \tl_cpu_h2d[21] ,
    \tl_cpu_h2d[20] ,
    \tl_cpu_h2d[19] ,
    \tl_cpu_h2d[18] ,
    \tl_cpu_h2d[17] ,
    \tl_cpu_h2d[16] ,
    \tl_cpu_h2d[15] ,
    \tl_cpu_h2d[14] ,
    \tl_cpu_h2d[13] ,
    \tl_cpu_h2d[12] ,
    \tl_cpu_h2d[11] ,
    \tl_cpu_h2d[10] ,
    \tl_cpu_h2d[9] ,
    \tl_cpu_h2d[8] ,
    \tl_cpu_h2d[7] ,
    \tl_cpu_h2d[6] ,
    \tl_cpu_h2d[5] ,
    \tl_cpu_h2d[4] ,
    \tl_cpu_h2d[3] ,
    \tl_cpu_h2d[2] ,
    \tl_cpu_h2d[1] ,
    \tl_cpu_h2d[0] }));
 rv_plic_lite u_plic (.clk_i(clk),
    .irq_o(plic_irq),
    .rst_ni(rst_n),
    .intr_src_i({\intr_vec[31] ,
    \intr_vec[30] ,
    \intr_vec[29] ,
    \intr_vec[28] ,
    \intr_vec[27] ,
    \intr_vec[26] ,
    \intr_vec[25] ,
    \intr_vec[24] ,
    \intr_vec[23] ,
    \intr_vec[22] ,
    \intr_vec[21] ,
    \intr_vec[20] ,
    \intr_vec[19] ,
    \intr_vec[18] ,
    \intr_vec[17] ,
    \intr_vec[16] ,
    \intr_vec[15] ,
    \intr_vec[14] ,
    \intr_vec[13] ,
    \intr_vec[12] ,
    \intr_vec[11] ,
    \intr_vec[10] ,
    \intr_vec[9] ,
    \intr_vec[8] ,
    \intr_vec[7] ,
    \intr_vec[6] ,
    \intr_vec[5] ,
    \intr_vec[4] ,
    \intr_vec[3] ,
    \intr_vec[2] ,
    \intr_vec[1] ,
    \intr_vec[0] }),
    .tl_i({\tl_plic_h2d[109] ,
    \tl_plic_h2d[108] ,
    \tl_plic_h2d[107] ,
    \tl_plic_h2d[106] ,
    \tl_plic_h2d[105] ,
    \tl_plic_h2d[104] ,
    \tl_plic_h2d[103] ,
    \tl_plic_h2d[102] ,
    \tl_plic_h2d[101] ,
    \tl_plic_h2d[100] ,
    \tl_plic_h2d[99] ,
    \tl_plic_h2d[98] ,
    \tl_plic_h2d[97] ,
    \tl_plic_h2d[96] ,
    \tl_plic_h2d[95] ,
    \tl_plic_h2d[94] ,
    \tl_plic_h2d[93] ,
    \tl_plic_h2d[92] ,
    \tl_plic_h2d[91] ,
    \tl_plic_h2d[90] ,
    \tl_plic_h2d[89] ,
    \tl_plic_h2d[88] ,
    \tl_plic_h2d[87] ,
    \tl_plic_h2d[86] ,
    \tl_plic_h2d[85] ,
    \tl_plic_h2d[84] ,
    \tl_plic_h2d[83] ,
    \tl_plic_h2d[82] ,
    \tl_plic_h2d[81] ,
    \tl_plic_h2d[80] ,
    \tl_plic_h2d[79] ,
    \tl_plic_h2d[78] ,
    \tl_plic_h2d[77] ,
    \tl_plic_h2d[76] ,
    \tl_plic_h2d[75] ,
    \tl_plic_h2d[74] ,
    \tl_plic_h2d[73] ,
    \tl_plic_h2d[72] ,
    \tl_plic_h2d[71] ,
    \tl_plic_h2d[70] ,
    \tl_plic_h2d[69] ,
    \tl_plic_h2d[68] ,
    \tl_plic_h2d[67] ,
    \tl_plic_h2d[66] ,
    \tl_plic_h2d[65] ,
    \tl_plic_h2d[64] ,
    \tl_plic_h2d[63] ,
    \tl_plic_h2d[62] ,
    \tl_plic_h2d[61] ,
    \tl_plic_h2d[60] ,
    \tl_plic_h2d[59] ,
    \tl_plic_h2d[58] ,
    \tl_plic_h2d[57] ,
    \tl_plic_h2d[56] ,
    \tl_plic_h2d[55] ,
    \tl_plic_h2d[54] ,
    \tl_plic_h2d[53] ,
    \tl_plic_h2d[52] ,
    \tl_plic_h2d[51] ,
    \tl_plic_h2d[50] ,
    \tl_plic_h2d[49] ,
    \tl_plic_h2d[48] ,
    \tl_plic_h2d[47] ,
    \tl_plic_h2d[46] ,
    \tl_plic_h2d[45] ,
    \tl_plic_h2d[44] ,
    \tl_plic_h2d[43] ,
    \tl_plic_h2d[42] ,
    \tl_plic_h2d[41] ,
    \tl_plic_h2d[40] ,
    \tl_plic_h2d[39] ,
    \tl_plic_h2d[38] ,
    \tl_plic_h2d[37] ,
    \tl_plic_h2d[36] ,
    \tl_plic_h2d[35] ,
    \tl_plic_h2d[34] ,
    \tl_plic_h2d[33] ,
    \tl_plic_h2d[32] ,
    \tl_plic_h2d[31] ,
    \tl_plic_h2d[30] ,
    \tl_plic_h2d[29] ,
    \tl_plic_h2d[28] ,
    \tl_plic_h2d[27] ,
    \tl_plic_h2d[26] ,
    \tl_plic_h2d[25] ,
    \tl_plic_h2d[24] ,
    \tl_plic_h2d[23] ,
    \tl_plic_h2d[22] ,
    \tl_plic_h2d[21] ,
    \tl_plic_h2d[20] ,
    \tl_plic_h2d[19] ,
    \tl_plic_h2d[18] ,
    \tl_plic_h2d[17] ,
    \tl_plic_h2d[16] ,
    \tl_plic_h2d[15] ,
    \tl_plic_h2d[14] ,
    \tl_plic_h2d[13] ,
    \tl_plic_h2d[12] ,
    \tl_plic_h2d[11] ,
    \tl_plic_h2d[10] ,
    \tl_plic_h2d[9] ,
    \tl_plic_h2d[8] ,
    \tl_plic_h2d[7] ,
    \tl_plic_h2d[6] ,
    \tl_plic_h2d[5] ,
    \tl_plic_h2d[4] ,
    \tl_plic_h2d[3] ,
    \tl_plic_h2d[2] ,
    \tl_plic_h2d[1] ,
    \tl_plic_h2d[0] }),
    .tl_o({\tl_plic_d2h[65] ,
    \tl_plic_d2h[64] ,
    \tl_plic_d2h[63] ,
    \tl_plic_d2h[62] ,
    \tl_plic_d2h[61] ,
    \tl_plic_d2h[60] ,
    \tl_plic_d2h[59] ,
    \tl_plic_d2h[58] ,
    \tl_plic_d2h[57] ,
    \tl_plic_d2h[56] ,
    \tl_plic_d2h[55] ,
    \tl_plic_d2h[54] ,
    \tl_plic_d2h[53] ,
    \tl_plic_d2h[52] ,
    \tl_plic_d2h[51] ,
    \tl_plic_d2h[50] ,
    \tl_plic_d2h[49] ,
    \tl_plic_d2h[48] ,
    \tl_plic_d2h[47] ,
    \tl_plic_d2h[46] ,
    \tl_plic_d2h[45] ,
    \tl_plic_d2h[44] ,
    \tl_plic_d2h[43] ,
    \tl_plic_d2h[42] ,
    \tl_plic_d2h[41] ,
    \tl_plic_d2h[40] ,
    \tl_plic_d2h[39] ,
    \tl_plic_d2h[38] ,
    \tl_plic_d2h[37] ,
    \tl_plic_d2h[36] ,
    \tl_plic_d2h[35] ,
    \tl_plic_d2h[34] ,
    \tl_plic_d2h[33] ,
    \tl_plic_d2h[32] ,
    \tl_plic_d2h[31] ,
    \tl_plic_d2h[30] ,
    \tl_plic_d2h[29] ,
    \tl_plic_d2h[28] ,
    \tl_plic_d2h[27] ,
    \tl_plic_d2h[26] ,
    \tl_plic_d2h[25] ,
    \tl_plic_d2h[24] ,
    \tl_plic_d2h[23] ,
    \tl_plic_d2h[22] ,
    \tl_plic_d2h[21] ,
    \tl_plic_d2h[20] ,
    \tl_plic_d2h[19] ,
    \tl_plic_d2h[18] ,
    \tl_plic_d2h[17] ,
    \tl_plic_d2h[16] ,
    \tl_plic_d2h[15] ,
    \tl_plic_d2h[14] ,
    \tl_plic_d2h[13] ,
    \tl_plic_d2h[12] ,
    \tl_plic_d2h[11] ,
    \tl_plic_d2h[10] ,
    \tl_plic_d2h[9] ,
    \tl_plic_d2h[8] ,
    \tl_plic_d2h[7] ,
    \tl_plic_d2h[6] ,
    \tl_plic_d2h[5] ,
    \tl_plic_d2h[4] ,
    \tl_plic_d2h[3] ,
    \tl_plic_d2h[2] ,
    \tl_plic_d2h[1] ,
    \tl_plic_d2h[0] }));
 spi_host_lite u_spi_host (.clk_i(clk),
    .intr_idle_o(intr_spi_host_idle),
    .intr_rx_full_o(intr_spi_host_rx_full),
    .intr_tx_empty_o(intr_spi_host_tx_empty),
    .rst_ni(rst_n),
    .spi_cs_no(spi_cs_n),
    .spi_miso_i(spi_miso),
    .spi_mosi_o(spi_mosi),
    .spi_sclk_o(spi_sclk),
    .tl_i({\tl_spi_h2d[109] ,
    \tl_spi_h2d[108] ,
    \tl_spi_h2d[107] ,
    \tl_spi_h2d[106] ,
    \tl_spi_h2d[105] ,
    \tl_spi_h2d[104] ,
    \tl_spi_h2d[103] ,
    \tl_spi_h2d[102] ,
    \tl_spi_h2d[101] ,
    \tl_spi_h2d[100] ,
    \tl_spi_h2d[99] ,
    \tl_spi_h2d[98] ,
    \tl_spi_h2d[97] ,
    \tl_spi_h2d[96] ,
    \tl_spi_h2d[95] ,
    \tl_spi_h2d[94] ,
    \tl_spi_h2d[93] ,
    \tl_spi_h2d[92] ,
    \tl_spi_h2d[91] ,
    \tl_spi_h2d[90] ,
    \tl_spi_h2d[89] ,
    \tl_spi_h2d[88] ,
    \tl_spi_h2d[87] ,
    \tl_spi_h2d[86] ,
    \tl_spi_h2d[85] ,
    \tl_spi_h2d[84] ,
    \tl_spi_h2d[83] ,
    \tl_spi_h2d[82] ,
    \tl_spi_h2d[81] ,
    \tl_spi_h2d[80] ,
    \tl_spi_h2d[79] ,
    \tl_spi_h2d[78] ,
    \tl_spi_h2d[77] ,
    \tl_spi_h2d[76] ,
    \tl_spi_h2d[75] ,
    \tl_spi_h2d[74] ,
    \tl_spi_h2d[73] ,
    \tl_spi_h2d[72] ,
    \tl_spi_h2d[71] ,
    \tl_spi_h2d[70] ,
    \tl_spi_h2d[69] ,
    \tl_spi_h2d[68] ,
    \tl_spi_h2d[67] ,
    \tl_spi_h2d[66] ,
    \tl_spi_h2d[65] ,
    \tl_spi_h2d[64] ,
    \tl_spi_h2d[63] ,
    \tl_spi_h2d[62] ,
    \tl_spi_h2d[61] ,
    \tl_spi_h2d[60] ,
    \tl_spi_h2d[59] ,
    \tl_spi_h2d[58] ,
    \tl_spi_h2d[57] ,
    \tl_spi_h2d[56] ,
    \tl_spi_h2d[55] ,
    \tl_spi_h2d[54] ,
    \tl_spi_h2d[53] ,
    \tl_spi_h2d[52] ,
    \tl_spi_h2d[51] ,
    \tl_spi_h2d[50] ,
    \tl_spi_h2d[49] ,
    \tl_spi_h2d[48] ,
    \tl_spi_h2d[47] ,
    \tl_spi_h2d[46] ,
    \tl_spi_h2d[45] ,
    \tl_spi_h2d[44] ,
    \tl_spi_h2d[43] ,
    \tl_spi_h2d[42] ,
    \tl_spi_h2d[41] ,
    \tl_spi_h2d[40] ,
    \tl_spi_h2d[39] ,
    \tl_spi_h2d[38] ,
    \tl_spi_h2d[37] ,
    \tl_spi_h2d[36] ,
    \tl_spi_h2d[35] ,
    \tl_spi_h2d[34] ,
    \tl_spi_h2d[33] ,
    \tl_spi_h2d[32] ,
    \tl_spi_h2d[31] ,
    \tl_spi_h2d[30] ,
    \tl_spi_h2d[29] ,
    \tl_spi_h2d[28] ,
    \tl_spi_h2d[27] ,
    \tl_spi_h2d[26] ,
    \tl_spi_h2d[25] ,
    \tl_spi_h2d[24] ,
    \tl_spi_h2d[23] ,
    \tl_spi_h2d[22] ,
    \tl_spi_h2d[21] ,
    \tl_spi_h2d[20] ,
    \tl_spi_h2d[19] ,
    \tl_spi_h2d[18] ,
    \tl_spi_h2d[17] ,
    \tl_spi_h2d[16] ,
    \tl_spi_h2d[15] ,
    \tl_spi_h2d[14] ,
    \tl_spi_h2d[13] ,
    \tl_spi_h2d[12] ,
    \tl_spi_h2d[11] ,
    \tl_spi_h2d[10] ,
    \tl_spi_h2d[9] ,
    \tl_spi_h2d[8] ,
    \tl_spi_h2d[7] ,
    \tl_spi_h2d[6] ,
    \tl_spi_h2d[5] ,
    \tl_spi_h2d[4] ,
    \tl_spi_h2d[3] ,
    \tl_spi_h2d[2] ,
    \tl_spi_h2d[1] ,
    \tl_spi_h2d[0] }),
    .tl_o({\tl_spi_d2h[65] ,
    \tl_spi_d2h[64] ,
    \tl_spi_d2h[63] ,
    \tl_spi_d2h[62] ,
    \tl_spi_d2h[61] ,
    \tl_spi_d2h[60] ,
    \tl_spi_d2h[59] ,
    \tl_spi_d2h[58] ,
    \tl_spi_d2h[57] ,
    \tl_spi_d2h[56] ,
    \tl_spi_d2h[55] ,
    \tl_spi_d2h[54] ,
    \tl_spi_d2h[53] ,
    \tl_spi_d2h[52] ,
    \tl_spi_d2h[51] ,
    \tl_spi_d2h[50] ,
    \tl_spi_d2h[49] ,
    \tl_spi_d2h[48] ,
    \tl_spi_d2h[47] ,
    \tl_spi_d2h[46] ,
    \tl_spi_d2h[45] ,
    \tl_spi_d2h[44] ,
    \tl_spi_d2h[43] ,
    \tl_spi_d2h[42] ,
    \tl_spi_d2h[41] ,
    \tl_spi_d2h[40] ,
    \tl_spi_d2h[39] ,
    \tl_spi_d2h[38] ,
    \tl_spi_d2h[37] ,
    \tl_spi_d2h[36] ,
    \tl_spi_d2h[35] ,
    \tl_spi_d2h[34] ,
    \tl_spi_d2h[33] ,
    \tl_spi_d2h[32] ,
    \tl_spi_d2h[31] ,
    \tl_spi_d2h[30] ,
    \tl_spi_d2h[29] ,
    \tl_spi_d2h[28] ,
    \tl_spi_d2h[27] ,
    \tl_spi_d2h[26] ,
    \tl_spi_d2h[25] ,
    \tl_spi_d2h[24] ,
    \tl_spi_d2h[23] ,
    \tl_spi_d2h[22] ,
    \tl_spi_d2h[21] ,
    \tl_spi_d2h[20] ,
    \tl_spi_d2h[19] ,
    \tl_spi_d2h[18] ,
    \tl_spi_d2h[17] ,
    \tl_spi_d2h[16] ,
    \tl_spi_d2h[15] ,
    \tl_spi_d2h[14] ,
    \tl_spi_d2h[13] ,
    \tl_spi_d2h[12] ,
    \tl_spi_d2h[11] ,
    \tl_spi_d2h[10] ,
    \tl_spi_d2h[9] ,
    \tl_spi_d2h[8] ,
    \tl_spi_d2h[7] ,
    \tl_spi_d2h[6] ,
    \tl_spi_d2h[5] ,
    \tl_spi_d2h[4] ,
    \tl_spi_d2h[3] ,
    \tl_spi_d2h[2] ,
    \tl_spi_d2h[1] ,
    \tl_spi_d2h[0] }));
 uart u_uart (.cio_rx_i(uart_rx),
    .cio_tx_o(uart_tx),
    .clk_i(clk),
    .intr_rx_break_err_o(intr_uart_rx_break_err),
    .intr_rx_frame_err_o(intr_uart_rx_frame_err),
    .intr_rx_overflow_o(intr_uart_rx_overflow),
    .intr_rx_parity_err_o(intr_uart_rx_parity_err),
    .intr_rx_timeout_o(intr_uart_rx_timeout),
    .intr_rx_watermark_o(intr_uart_rx_watermark),
    .intr_tx_done_o(intr_uart_tx_done),
    .intr_tx_empty_o(intr_uart_tx_empty),
    .intr_tx_watermark_o(intr_uart_tx_watermark),
    .rst_ni(rst_n),
    .alert_rx_i({zero_,
    zero_,
    zero_,
    zero_}),
    .alert_tx_o({_NC1,
    _NC2}),
    .racl_error_o({_NC3,
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
    _NC24,
    _NC25,
    _NC26,
    _NC27,
    _NC28,
    _NC29,
    _NC30,
    _NC31,
    _NC32,
    _NC33,
    _NC34,
    _NC35,
    _NC36,
    _NC37,
    _NC38,
    _NC39,
    _NC40,
    _NC41,
    _NC42,
    _NC43,
    _NC44,
    _NC45,
    _NC46,
    _NC47,
    _NC48,
    _NC49,
    _NC50,
    _NC51,
    _NC52,
    _NC53,
    _NC54}),
    .racl_policies_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_i({\tl_uart_h2d[109] ,
    \tl_uart_h2d[108] ,
    \tl_uart_h2d[107] ,
    \tl_uart_h2d[106] ,
    \tl_uart_h2d[105] ,
    \tl_uart_h2d[104] ,
    \tl_uart_h2d[103] ,
    \tl_uart_h2d[102] ,
    \tl_uart_h2d[101] ,
    \tl_uart_h2d[100] ,
    \tl_uart_h2d[99] ,
    \tl_uart_h2d[98] ,
    \tl_uart_h2d[97] ,
    \tl_uart_h2d[96] ,
    \tl_uart_h2d[95] ,
    \tl_uart_h2d[94] ,
    \tl_uart_h2d[93] ,
    \tl_uart_h2d[92] ,
    \tl_uart_h2d[91] ,
    \tl_uart_h2d[90] ,
    \tl_uart_h2d[89] ,
    \tl_uart_h2d[88] ,
    \tl_uart_h2d[87] ,
    \tl_uart_h2d[86] ,
    \tl_uart_h2d[85] ,
    \tl_uart_h2d[84] ,
    \tl_uart_h2d[83] ,
    \tl_uart_h2d[82] ,
    \tl_uart_h2d[81] ,
    \tl_uart_h2d[80] ,
    \tl_uart_h2d[79] ,
    \tl_uart_h2d[78] ,
    \tl_uart_h2d[77] ,
    \tl_uart_h2d[76] ,
    \tl_uart_h2d[75] ,
    \tl_uart_h2d[74] ,
    \tl_uart_h2d[73] ,
    \tl_uart_h2d[72] ,
    \tl_uart_h2d[71] ,
    \tl_uart_h2d[70] ,
    \tl_uart_h2d[69] ,
    \tl_uart_h2d[68] ,
    \tl_uart_h2d[67] ,
    \tl_uart_h2d[66] ,
    \tl_uart_h2d[65] ,
    \tl_uart_h2d[64] ,
    \tl_uart_h2d[63] ,
    \tl_uart_h2d[62] ,
    \tl_uart_h2d[61] ,
    \tl_uart_h2d[60] ,
    \tl_uart_h2d[59] ,
    \tl_uart_h2d[58] ,
    \tl_uart_h2d[57] ,
    \tl_uart_h2d[56] ,
    \tl_uart_h2d[55] ,
    \tl_uart_h2d[54] ,
    \tl_uart_h2d[53] ,
    \tl_uart_h2d[52] ,
    \tl_uart_h2d[51] ,
    \tl_uart_h2d[50] ,
    \tl_uart_h2d[49] ,
    \tl_uart_h2d[48] ,
    \tl_uart_h2d[47] ,
    \tl_uart_h2d[46] ,
    \tl_uart_h2d[45] ,
    \tl_uart_h2d[44] ,
    \tl_uart_h2d[43] ,
    \tl_uart_h2d[42] ,
    \tl_uart_h2d[41] ,
    \tl_uart_h2d[40] ,
    \tl_uart_h2d[39] ,
    \tl_uart_h2d[38] ,
    \tl_uart_h2d[37] ,
    \tl_uart_h2d[36] ,
    \tl_uart_h2d[35] ,
    \tl_uart_h2d[34] ,
    \tl_uart_h2d[33] ,
    \tl_uart_h2d[32] ,
    \tl_uart_h2d[31] ,
    \tl_uart_h2d[30] ,
    \tl_uart_h2d[29] ,
    \tl_uart_h2d[28] ,
    \tl_uart_h2d[27] ,
    \tl_uart_h2d[26] ,
    \tl_uart_h2d[25] ,
    \tl_uart_h2d[24] ,
    \tl_uart_h2d[23] ,
    \tl_uart_h2d[22] ,
    \tl_uart_h2d[21] ,
    \tl_uart_h2d[20] ,
    \tl_uart_h2d[19] ,
    \tl_uart_h2d[18] ,
    \tl_uart_h2d[17] ,
    \tl_uart_h2d[16] ,
    \tl_uart_h2d[15] ,
    \tl_uart_h2d[14] ,
    \tl_uart_h2d[13] ,
    \tl_uart_h2d[12] ,
    \tl_uart_h2d[11] ,
    \tl_uart_h2d[10] ,
    \tl_uart_h2d[9] ,
    \tl_uart_h2d[8] ,
    \tl_uart_h2d[7] ,
    \tl_uart_h2d[6] ,
    \tl_uart_h2d[5] ,
    \tl_uart_h2d[4] ,
    \tl_uart_h2d[3] ,
    \tl_uart_h2d[2] ,
    \tl_uart_h2d[1] ,
    \tl_uart_h2d[0] }),
    .tl_o({\tl_uart_d2h[65] ,
    \tl_uart_d2h[64] ,
    \tl_uart_d2h[63] ,
    \tl_uart_d2h[62] ,
    \tl_uart_d2h[61] ,
    \tl_uart_d2h[60] ,
    \tl_uart_d2h[59] ,
    \tl_uart_d2h[58] ,
    \tl_uart_d2h[57] ,
    \tl_uart_d2h[56] ,
    \tl_uart_d2h[55] ,
    \tl_uart_d2h[54] ,
    \tl_uart_d2h[53] ,
    \tl_uart_d2h[52] ,
    \tl_uart_d2h[51] ,
    \tl_uart_d2h[50] ,
    \tl_uart_d2h[49] ,
    \tl_uart_d2h[48] ,
    \tl_uart_d2h[47] ,
    \tl_uart_d2h[46] ,
    \tl_uart_d2h[45] ,
    \tl_uart_d2h[44] ,
    \tl_uart_d2h[43] ,
    \tl_uart_d2h[42] ,
    \tl_uart_d2h[41] ,
    \tl_uart_d2h[40] ,
    \tl_uart_d2h[39] ,
    \tl_uart_d2h[38] ,
    \tl_uart_d2h[37] ,
    \tl_uart_d2h[36] ,
    \tl_uart_d2h[35] ,
    \tl_uart_d2h[34] ,
    \tl_uart_d2h[33] ,
    \tl_uart_d2h[32] ,
    \tl_uart_d2h[31] ,
    \tl_uart_d2h[30] ,
    \tl_uart_d2h[29] ,
    \tl_uart_d2h[28] ,
    \tl_uart_d2h[27] ,
    \tl_uart_d2h[26] ,
    \tl_uart_d2h[25] ,
    \tl_uart_d2h[24] ,
    \tl_uart_d2h[23] ,
    \tl_uart_d2h[22] ,
    \tl_uart_d2h[21] ,
    \tl_uart_d2h[20] ,
    \tl_uart_d2h[19] ,
    \tl_uart_d2h[18] ,
    \tl_uart_d2h[17] ,
    \tl_uart_d2h[16] ,
    \tl_uart_d2h[15] ,
    \tl_uart_d2h[14] ,
    \tl_uart_d2h[13] ,
    \tl_uart_d2h[12] ,
    \tl_uart_d2h[11] ,
    \tl_uart_d2h[10] ,
    \tl_uart_d2h[9] ,
    \tl_uart_d2h[8] ,
    \tl_uart_d2h[7] ,
    \tl_uart_d2h[6] ,
    \tl_uart_d2h[5] ,
    \tl_uart_d2h[4] ,
    \tl_uart_d2h[3] ,
    \tl_uart_d2h[2] ,
    \tl_uart_d2h[1] ,
    \tl_uart_d2h[0] }));
 xbar_main u_xbar (.clk_i(clk),
    .rst_ni(rst_n),
    .tl_host_i({\tl_cpu_h2d[109] ,
    \tl_cpu_h2d[108] ,
    \tl_cpu_h2d[107] ,
    \tl_cpu_h2d[106] ,
    \tl_cpu_h2d[105] ,
    \tl_cpu_h2d[104] ,
    \tl_cpu_h2d[103] ,
    \tl_cpu_h2d[102] ,
    \tl_cpu_h2d[101] ,
    \tl_cpu_h2d[100] ,
    \tl_cpu_h2d[99] ,
    \tl_cpu_h2d[98] ,
    \tl_cpu_h2d[97] ,
    \tl_cpu_h2d[96] ,
    \tl_cpu_h2d[95] ,
    \tl_cpu_h2d[94] ,
    \tl_cpu_h2d[93] ,
    \tl_cpu_h2d[92] ,
    \tl_cpu_h2d[91] ,
    \tl_cpu_h2d[90] ,
    \tl_cpu_h2d[89] ,
    \tl_cpu_h2d[88] ,
    \tl_cpu_h2d[87] ,
    \tl_cpu_h2d[86] ,
    \tl_cpu_h2d[85] ,
    \tl_cpu_h2d[84] ,
    \tl_cpu_h2d[83] ,
    \tl_cpu_h2d[82] ,
    \tl_cpu_h2d[81] ,
    \tl_cpu_h2d[80] ,
    \tl_cpu_h2d[79] ,
    \tl_cpu_h2d[78] ,
    \tl_cpu_h2d[77] ,
    \tl_cpu_h2d[76] ,
    \tl_cpu_h2d[75] ,
    \tl_cpu_h2d[74] ,
    \tl_cpu_h2d[73] ,
    \tl_cpu_h2d[72] ,
    \tl_cpu_h2d[71] ,
    \tl_cpu_h2d[70] ,
    \tl_cpu_h2d[69] ,
    \tl_cpu_h2d[68] ,
    \tl_cpu_h2d[67] ,
    \tl_cpu_h2d[66] ,
    \tl_cpu_h2d[65] ,
    \tl_cpu_h2d[64] ,
    \tl_cpu_h2d[63] ,
    \tl_cpu_h2d[62] ,
    \tl_cpu_h2d[61] ,
    \tl_cpu_h2d[60] ,
    \tl_cpu_h2d[59] ,
    \tl_cpu_h2d[58] ,
    \tl_cpu_h2d[57] ,
    \tl_cpu_h2d[56] ,
    \tl_cpu_h2d[55] ,
    \tl_cpu_h2d[54] ,
    \tl_cpu_h2d[53] ,
    \tl_cpu_h2d[52] ,
    \tl_cpu_h2d[51] ,
    \tl_cpu_h2d[50] ,
    \tl_cpu_h2d[49] ,
    \tl_cpu_h2d[48] ,
    \tl_cpu_h2d[47] ,
    \tl_cpu_h2d[46] ,
    \tl_cpu_h2d[45] ,
    \tl_cpu_h2d[44] ,
    \tl_cpu_h2d[43] ,
    \tl_cpu_h2d[42] ,
    \tl_cpu_h2d[41] ,
    \tl_cpu_h2d[40] ,
    \tl_cpu_h2d[39] ,
    \tl_cpu_h2d[38] ,
    \tl_cpu_h2d[37] ,
    \tl_cpu_h2d[36] ,
    \tl_cpu_h2d[35] ,
    \tl_cpu_h2d[34] ,
    \tl_cpu_h2d[33] ,
    \tl_cpu_h2d[32] ,
    \tl_cpu_h2d[31] ,
    \tl_cpu_h2d[30] ,
    \tl_cpu_h2d[29] ,
    \tl_cpu_h2d[28] ,
    \tl_cpu_h2d[27] ,
    \tl_cpu_h2d[26] ,
    \tl_cpu_h2d[25] ,
    \tl_cpu_h2d[24] ,
    \tl_cpu_h2d[23] ,
    \tl_cpu_h2d[22] ,
    \tl_cpu_h2d[21] ,
    \tl_cpu_h2d[20] ,
    \tl_cpu_h2d[19] ,
    \tl_cpu_h2d[18] ,
    \tl_cpu_h2d[17] ,
    \tl_cpu_h2d[16] ,
    \tl_cpu_h2d[15] ,
    \tl_cpu_h2d[14] ,
    \tl_cpu_h2d[13] ,
    \tl_cpu_h2d[12] ,
    \tl_cpu_h2d[11] ,
    \tl_cpu_h2d[10] ,
    \tl_cpu_h2d[9] ,
    \tl_cpu_h2d[8] ,
    \tl_cpu_h2d[7] ,
    \tl_cpu_h2d[6] ,
    \tl_cpu_h2d[5] ,
    \tl_cpu_h2d[4] ,
    \tl_cpu_h2d[3] ,
    \tl_cpu_h2d[2] ,
    \tl_cpu_h2d[1] ,
    \tl_cpu_h2d[0] }),
    .tl_host_o({\tl_cpu_d2h[65] ,
    \tl_cpu_d2h[64] ,
    \tl_cpu_d2h[63] ,
    \tl_cpu_d2h[62] ,
    \tl_cpu_d2h[61] ,
    \tl_cpu_d2h[60] ,
    \tl_cpu_d2h[59] ,
    \tl_cpu_d2h[58] ,
    \tl_cpu_d2h[57] ,
    \tl_cpu_d2h[56] ,
    \tl_cpu_d2h[55] ,
    \tl_cpu_d2h[54] ,
    \tl_cpu_d2h[53] ,
    \tl_cpu_d2h[52] ,
    \tl_cpu_d2h[51] ,
    \tl_cpu_d2h[50] ,
    \tl_cpu_d2h[49] ,
    \tl_cpu_d2h[48] ,
    \tl_cpu_d2h[47] ,
    \tl_cpu_d2h[46] ,
    \tl_cpu_d2h[45] ,
    \tl_cpu_d2h[44] ,
    \tl_cpu_d2h[43] ,
    \tl_cpu_d2h[42] ,
    \tl_cpu_d2h[41] ,
    \tl_cpu_d2h[40] ,
    \tl_cpu_d2h[39] ,
    \tl_cpu_d2h[38] ,
    \tl_cpu_d2h[37] ,
    \tl_cpu_d2h[36] ,
    \tl_cpu_d2h[35] ,
    \tl_cpu_d2h[34] ,
    \tl_cpu_d2h[33] ,
    \tl_cpu_d2h[32] ,
    \tl_cpu_d2h[31] ,
    \tl_cpu_d2h[30] ,
    \tl_cpu_d2h[29] ,
    \tl_cpu_d2h[28] ,
    \tl_cpu_d2h[27] ,
    \tl_cpu_d2h[26] ,
    \tl_cpu_d2h[25] ,
    \tl_cpu_d2h[24] ,
    \tl_cpu_d2h[23] ,
    \tl_cpu_d2h[22] ,
    \tl_cpu_d2h[21] ,
    \tl_cpu_d2h[20] ,
    \tl_cpu_d2h[19] ,
    \tl_cpu_d2h[18] ,
    \tl_cpu_d2h[17] ,
    \tl_cpu_d2h[16] ,
    \tl_cpu_d2h[15] ,
    \tl_cpu_d2h[14] ,
    \tl_cpu_d2h[13] ,
    \tl_cpu_d2h[12] ,
    \tl_cpu_d2h[11] ,
    \tl_cpu_d2h[10] ,
    \tl_cpu_d2h[9] ,
    \tl_cpu_d2h[8] ,
    \tl_cpu_d2h[7] ,
    \tl_cpu_d2h[6] ,
    \tl_cpu_d2h[5] ,
    \tl_cpu_d2h[4] ,
    \tl_cpu_d2h[3] ,
    \tl_cpu_d2h[2] ,
    \tl_cpu_d2h[1] ,
    \tl_cpu_d2h[0] }),
    .tl_u_plic_i({\tl_plic_d2h[65] ,
    \tl_plic_d2h[64] ,
    \tl_plic_d2h[63] ,
    \tl_plic_d2h[62] ,
    \tl_plic_d2h[61] ,
    \tl_plic_d2h[60] ,
    \tl_plic_d2h[59] ,
    \tl_plic_d2h[58] ,
    \tl_plic_d2h[57] ,
    \tl_plic_d2h[56] ,
    \tl_plic_d2h[55] ,
    \tl_plic_d2h[54] ,
    \tl_plic_d2h[53] ,
    \tl_plic_d2h[52] ,
    \tl_plic_d2h[51] ,
    \tl_plic_d2h[50] ,
    \tl_plic_d2h[49] ,
    \tl_plic_d2h[48] ,
    \tl_plic_d2h[47] ,
    \tl_plic_d2h[46] ,
    \tl_plic_d2h[45] ,
    \tl_plic_d2h[44] ,
    \tl_plic_d2h[43] ,
    \tl_plic_d2h[42] ,
    \tl_plic_d2h[41] ,
    \tl_plic_d2h[40] ,
    \tl_plic_d2h[39] ,
    \tl_plic_d2h[38] ,
    \tl_plic_d2h[37] ,
    \tl_plic_d2h[36] ,
    \tl_plic_d2h[35] ,
    \tl_plic_d2h[34] ,
    \tl_plic_d2h[33] ,
    \tl_plic_d2h[32] ,
    \tl_plic_d2h[31] ,
    \tl_plic_d2h[30] ,
    \tl_plic_d2h[29] ,
    \tl_plic_d2h[28] ,
    \tl_plic_d2h[27] ,
    \tl_plic_d2h[26] ,
    \tl_plic_d2h[25] ,
    \tl_plic_d2h[24] ,
    \tl_plic_d2h[23] ,
    \tl_plic_d2h[22] ,
    \tl_plic_d2h[21] ,
    \tl_plic_d2h[20] ,
    \tl_plic_d2h[19] ,
    \tl_plic_d2h[18] ,
    \tl_plic_d2h[17] ,
    \tl_plic_d2h[16] ,
    \tl_plic_d2h[15] ,
    \tl_plic_d2h[14] ,
    \tl_plic_d2h[13] ,
    \tl_plic_d2h[12] ,
    \tl_plic_d2h[11] ,
    \tl_plic_d2h[10] ,
    \tl_plic_d2h[9] ,
    \tl_plic_d2h[8] ,
    \tl_plic_d2h[7] ,
    \tl_plic_d2h[6] ,
    \tl_plic_d2h[5] ,
    \tl_plic_d2h[4] ,
    \tl_plic_d2h[3] ,
    \tl_plic_d2h[2] ,
    \tl_plic_d2h[1] ,
    \tl_plic_d2h[0] }),
    .tl_u_plic_o({\tl_plic_h2d[109] ,
    \tl_plic_h2d[108] ,
    \tl_plic_h2d[107] ,
    \tl_plic_h2d[106] ,
    \tl_plic_h2d[105] ,
    \tl_plic_h2d[104] ,
    \tl_plic_h2d[103] ,
    \tl_plic_h2d[102] ,
    \tl_plic_h2d[101] ,
    \tl_plic_h2d[100] ,
    \tl_plic_h2d[99] ,
    \tl_plic_h2d[98] ,
    \tl_plic_h2d[97] ,
    \tl_plic_h2d[96] ,
    \tl_plic_h2d[95] ,
    \tl_plic_h2d[94] ,
    \tl_plic_h2d[93] ,
    \tl_plic_h2d[92] ,
    \tl_plic_h2d[91] ,
    \tl_plic_h2d[90] ,
    \tl_plic_h2d[89] ,
    \tl_plic_h2d[88] ,
    \tl_plic_h2d[87] ,
    \tl_plic_h2d[86] ,
    \tl_plic_h2d[85] ,
    \tl_plic_h2d[84] ,
    \tl_plic_h2d[83] ,
    \tl_plic_h2d[82] ,
    \tl_plic_h2d[81] ,
    \tl_plic_h2d[80] ,
    \tl_plic_h2d[79] ,
    \tl_plic_h2d[78] ,
    \tl_plic_h2d[77] ,
    \tl_plic_h2d[76] ,
    \tl_plic_h2d[75] ,
    \tl_plic_h2d[74] ,
    \tl_plic_h2d[73] ,
    \tl_plic_h2d[72] ,
    \tl_plic_h2d[71] ,
    \tl_plic_h2d[70] ,
    \tl_plic_h2d[69] ,
    \tl_plic_h2d[68] ,
    \tl_plic_h2d[67] ,
    \tl_plic_h2d[66] ,
    \tl_plic_h2d[65] ,
    \tl_plic_h2d[64] ,
    \tl_plic_h2d[63] ,
    \tl_plic_h2d[62] ,
    \tl_plic_h2d[61] ,
    \tl_plic_h2d[60] ,
    \tl_plic_h2d[59] ,
    \tl_plic_h2d[58] ,
    \tl_plic_h2d[57] ,
    \tl_plic_h2d[56] ,
    \tl_plic_h2d[55] ,
    \tl_plic_h2d[54] ,
    \tl_plic_h2d[53] ,
    \tl_plic_h2d[52] ,
    \tl_plic_h2d[51] ,
    \tl_plic_h2d[50] ,
    \tl_plic_h2d[49] ,
    \tl_plic_h2d[48] ,
    \tl_plic_h2d[47] ,
    \tl_plic_h2d[46] ,
    \tl_plic_h2d[45] ,
    \tl_plic_h2d[44] ,
    \tl_plic_h2d[43] ,
    \tl_plic_h2d[42] ,
    \tl_plic_h2d[41] ,
    \tl_plic_h2d[40] ,
    \tl_plic_h2d[39] ,
    \tl_plic_h2d[38] ,
    \tl_plic_h2d[37] ,
    \tl_plic_h2d[36] ,
    \tl_plic_h2d[35] ,
    \tl_plic_h2d[34] ,
    \tl_plic_h2d[33] ,
    \tl_plic_h2d[32] ,
    \tl_plic_h2d[31] ,
    \tl_plic_h2d[30] ,
    \tl_plic_h2d[29] ,
    \tl_plic_h2d[28] ,
    \tl_plic_h2d[27] ,
    \tl_plic_h2d[26] ,
    \tl_plic_h2d[25] ,
    \tl_plic_h2d[24] ,
    \tl_plic_h2d[23] ,
    \tl_plic_h2d[22] ,
    \tl_plic_h2d[21] ,
    \tl_plic_h2d[20] ,
    \tl_plic_h2d[19] ,
    \tl_plic_h2d[18] ,
    \tl_plic_h2d[17] ,
    \tl_plic_h2d[16] ,
    \tl_plic_h2d[15] ,
    \tl_plic_h2d[14] ,
    \tl_plic_h2d[13] ,
    \tl_plic_h2d[12] ,
    \tl_plic_h2d[11] ,
    \tl_plic_h2d[10] ,
    \tl_plic_h2d[9] ,
    \tl_plic_h2d[8] ,
    \tl_plic_h2d[7] ,
    \tl_plic_h2d[6] ,
    \tl_plic_h2d[5] ,
    \tl_plic_h2d[4] ,
    \tl_plic_h2d[3] ,
    \tl_plic_h2d[2] ,
    \tl_plic_h2d[1] ,
    \tl_plic_h2d[0] }),
    .tl_u_ram_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_u_ram_o({\tl_ram_h2d[109] ,
    \tl_ram_h2d[108] ,
    \tl_ram_h2d[107] ,
    \tl_ram_h2d[106] ,
    \tl_ram_h2d[105] ,
    \tl_ram_h2d[104] ,
    \tl_ram_h2d[103] ,
    \tl_ram_h2d[102] ,
    \tl_ram_h2d[101] ,
    \tl_ram_h2d[100] ,
    \tl_ram_h2d[99] ,
    \tl_ram_h2d[98] ,
    \tl_ram_h2d[97] ,
    \tl_ram_h2d[96] ,
    \tl_ram_h2d[95] ,
    \tl_ram_h2d[94] ,
    \tl_ram_h2d[93] ,
    \tl_ram_h2d[92] ,
    \tl_ram_h2d[91] ,
    \tl_ram_h2d[90] ,
    \tl_ram_h2d[89] ,
    \tl_ram_h2d[88] ,
    \tl_ram_h2d[87] ,
    \tl_ram_h2d[86] ,
    \tl_ram_h2d[85] ,
    \tl_ram_h2d[84] ,
    \tl_ram_h2d[83] ,
    \tl_ram_h2d[82] ,
    \tl_ram_h2d[81] ,
    \tl_ram_h2d[80] ,
    \tl_ram_h2d[79] ,
    \tl_ram_h2d[78] ,
    \tl_ram_h2d[77] ,
    \tl_ram_h2d[76] ,
    \tl_ram_h2d[75] ,
    \tl_ram_h2d[74] ,
    \tl_ram_h2d[73] ,
    \tl_ram_h2d[72] ,
    \tl_ram_h2d[71] ,
    \tl_ram_h2d[70] ,
    \tl_ram_h2d[69] ,
    \tl_ram_h2d[68] ,
    \tl_ram_h2d[67] ,
    \tl_ram_h2d[66] ,
    \tl_ram_h2d[65] ,
    \tl_ram_h2d[64] ,
    \tl_ram_h2d[63] ,
    \tl_ram_h2d[62] ,
    \tl_ram_h2d[61] ,
    \tl_ram_h2d[60] ,
    \tl_ram_h2d[59] ,
    \tl_ram_h2d[58] ,
    \tl_ram_h2d[57] ,
    \tl_ram_h2d[56] ,
    \tl_ram_h2d[55] ,
    \tl_ram_h2d[54] ,
    \tl_ram_h2d[53] ,
    \tl_ram_h2d[52] ,
    \tl_ram_h2d[51] ,
    \tl_ram_h2d[50] ,
    \tl_ram_h2d[49] ,
    \tl_ram_h2d[48] ,
    \tl_ram_h2d[47] ,
    \tl_ram_h2d[46] ,
    \tl_ram_h2d[45] ,
    \tl_ram_h2d[44] ,
    \tl_ram_h2d[43] ,
    \tl_ram_h2d[42] ,
    \tl_ram_h2d[41] ,
    \tl_ram_h2d[40] ,
    \tl_ram_h2d[39] ,
    \tl_ram_h2d[38] ,
    \tl_ram_h2d[37] ,
    \tl_ram_h2d[36] ,
    \tl_ram_h2d[35] ,
    \tl_ram_h2d[34] ,
    \tl_ram_h2d[33] ,
    \tl_ram_h2d[32] ,
    \tl_ram_h2d[31] ,
    \tl_ram_h2d[30] ,
    \tl_ram_h2d[29] ,
    \tl_ram_h2d[28] ,
    \tl_ram_h2d[27] ,
    \tl_ram_h2d[26] ,
    \tl_ram_h2d[25] ,
    \tl_ram_h2d[24] ,
    \tl_ram_h2d[23] ,
    \tl_ram_h2d[22] ,
    \tl_ram_h2d[21] ,
    \tl_ram_h2d[20] ,
    \tl_ram_h2d[19] ,
    \tl_ram_h2d[18] ,
    \tl_ram_h2d[17] ,
    \tl_ram_h2d[16] ,
    \tl_ram_h2d[15] ,
    \tl_ram_h2d[14] ,
    \tl_ram_h2d[13] ,
    \tl_ram_h2d[12] ,
    \tl_ram_h2d[11] ,
    \tl_ram_h2d[10] ,
    \tl_ram_h2d[9] ,
    \tl_ram_h2d[8] ,
    \tl_ram_h2d[7] ,
    \tl_ram_h2d[6] ,
    \tl_ram_h2d[5] ,
    \tl_ram_h2d[4] ,
    \tl_ram_h2d[3] ,
    \tl_ram_h2d[2] ,
    \tl_ram_h2d[1] ,
    \tl_ram_h2d[0] }),
    .tl_u_rom_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_u_rom_o({\tl_rom_h2d[109] ,
    \tl_rom_h2d[108] ,
    \tl_rom_h2d[107] ,
    \tl_rom_h2d[106] ,
    \tl_rom_h2d[105] ,
    \tl_rom_h2d[104] ,
    \tl_rom_h2d[103] ,
    \tl_rom_h2d[102] ,
    \tl_rom_h2d[101] ,
    \tl_rom_h2d[100] ,
    \tl_rom_h2d[99] ,
    \tl_rom_h2d[98] ,
    \tl_rom_h2d[97] ,
    \tl_rom_h2d[96] ,
    \tl_rom_h2d[95] ,
    \tl_rom_h2d[94] ,
    \tl_rom_h2d[93] ,
    \tl_rom_h2d[92] ,
    \tl_rom_h2d[91] ,
    \tl_rom_h2d[90] ,
    \tl_rom_h2d[89] ,
    \tl_rom_h2d[88] ,
    \tl_rom_h2d[87] ,
    \tl_rom_h2d[86] ,
    \tl_rom_h2d[85] ,
    \tl_rom_h2d[84] ,
    \tl_rom_h2d[83] ,
    \tl_rom_h2d[82] ,
    \tl_rom_h2d[81] ,
    \tl_rom_h2d[80] ,
    \tl_rom_h2d[79] ,
    \tl_rom_h2d[78] ,
    \tl_rom_h2d[77] ,
    \tl_rom_h2d[76] ,
    \tl_rom_h2d[75] ,
    \tl_rom_h2d[74] ,
    \tl_rom_h2d[73] ,
    \tl_rom_h2d[72] ,
    \tl_rom_h2d[71] ,
    \tl_rom_h2d[70] ,
    \tl_rom_h2d[69] ,
    \tl_rom_h2d[68] ,
    \tl_rom_h2d[67] ,
    \tl_rom_h2d[66] ,
    \tl_rom_h2d[65] ,
    \tl_rom_h2d[64] ,
    \tl_rom_h2d[63] ,
    \tl_rom_h2d[62] ,
    \tl_rom_h2d[61] ,
    \tl_rom_h2d[60] ,
    \tl_rom_h2d[59] ,
    \tl_rom_h2d[58] ,
    \tl_rom_h2d[57] ,
    \tl_rom_h2d[56] ,
    \tl_rom_h2d[55] ,
    \tl_rom_h2d[54] ,
    \tl_rom_h2d[53] ,
    \tl_rom_h2d[52] ,
    \tl_rom_h2d[51] ,
    \tl_rom_h2d[50] ,
    \tl_rom_h2d[49] ,
    \tl_rom_h2d[48] ,
    \tl_rom_h2d[47] ,
    \tl_rom_h2d[46] ,
    \tl_rom_h2d[45] ,
    \tl_rom_h2d[44] ,
    \tl_rom_h2d[43] ,
    \tl_rom_h2d[42] ,
    \tl_rom_h2d[41] ,
    \tl_rom_h2d[40] ,
    \tl_rom_h2d[39] ,
    \tl_rom_h2d[38] ,
    \tl_rom_h2d[37] ,
    \tl_rom_h2d[36] ,
    \tl_rom_h2d[35] ,
    \tl_rom_h2d[34] ,
    \tl_rom_h2d[33] ,
    \tl_rom_h2d[32] ,
    \tl_rom_h2d[31] ,
    \tl_rom_h2d[30] ,
    \tl_rom_h2d[29] ,
    \tl_rom_h2d[28] ,
    \tl_rom_h2d[27] ,
    \tl_rom_h2d[26] ,
    \tl_rom_h2d[25] ,
    \tl_rom_h2d[24] ,
    \tl_rom_h2d[23] ,
    \tl_rom_h2d[22] ,
    \tl_rom_h2d[21] ,
    \tl_rom_h2d[20] ,
    \tl_rom_h2d[19] ,
    \tl_rom_h2d[18] ,
    \tl_rom_h2d[17] ,
    \tl_rom_h2d[16] ,
    \tl_rom_h2d[15] ,
    \tl_rom_h2d[14] ,
    \tl_rom_h2d[13] ,
    \tl_rom_h2d[12] ,
    \tl_rom_h2d[11] ,
    \tl_rom_h2d[10] ,
    \tl_rom_h2d[9] ,
    \tl_rom_h2d[8] ,
    \tl_rom_h2d[7] ,
    \tl_rom_h2d[6] ,
    \tl_rom_h2d[5] ,
    \tl_rom_h2d[4] ,
    \tl_rom_h2d[3] ,
    \tl_rom_h2d[2] ,
    \tl_rom_h2d[1] ,
    \tl_rom_h2d[0] }),
    .tl_u_spi_host_i({\tl_spi_d2h[65] ,
    \tl_spi_d2h[64] ,
    \tl_spi_d2h[63] ,
    \tl_spi_d2h[62] ,
    \tl_spi_d2h[61] ,
    \tl_spi_d2h[60] ,
    \tl_spi_d2h[59] ,
    \tl_spi_d2h[58] ,
    \tl_spi_d2h[57] ,
    \tl_spi_d2h[56] ,
    \tl_spi_d2h[55] ,
    \tl_spi_d2h[54] ,
    \tl_spi_d2h[53] ,
    \tl_spi_d2h[52] ,
    \tl_spi_d2h[51] ,
    \tl_spi_d2h[50] ,
    \tl_spi_d2h[49] ,
    \tl_spi_d2h[48] ,
    \tl_spi_d2h[47] ,
    \tl_spi_d2h[46] ,
    \tl_spi_d2h[45] ,
    \tl_spi_d2h[44] ,
    \tl_spi_d2h[43] ,
    \tl_spi_d2h[42] ,
    \tl_spi_d2h[41] ,
    \tl_spi_d2h[40] ,
    \tl_spi_d2h[39] ,
    \tl_spi_d2h[38] ,
    \tl_spi_d2h[37] ,
    \tl_spi_d2h[36] ,
    \tl_spi_d2h[35] ,
    \tl_spi_d2h[34] ,
    \tl_spi_d2h[33] ,
    \tl_spi_d2h[32] ,
    \tl_spi_d2h[31] ,
    \tl_spi_d2h[30] ,
    \tl_spi_d2h[29] ,
    \tl_spi_d2h[28] ,
    \tl_spi_d2h[27] ,
    \tl_spi_d2h[26] ,
    \tl_spi_d2h[25] ,
    \tl_spi_d2h[24] ,
    \tl_spi_d2h[23] ,
    \tl_spi_d2h[22] ,
    \tl_spi_d2h[21] ,
    \tl_spi_d2h[20] ,
    \tl_spi_d2h[19] ,
    \tl_spi_d2h[18] ,
    \tl_spi_d2h[17] ,
    \tl_spi_d2h[16] ,
    \tl_spi_d2h[15] ,
    \tl_spi_d2h[14] ,
    \tl_spi_d2h[13] ,
    \tl_spi_d2h[12] ,
    \tl_spi_d2h[11] ,
    \tl_spi_d2h[10] ,
    \tl_spi_d2h[9] ,
    \tl_spi_d2h[8] ,
    \tl_spi_d2h[7] ,
    \tl_spi_d2h[6] ,
    \tl_spi_d2h[5] ,
    \tl_spi_d2h[4] ,
    \tl_spi_d2h[3] ,
    \tl_spi_d2h[2] ,
    \tl_spi_d2h[1] ,
    \tl_spi_d2h[0] }),
    .tl_u_spi_host_o({\tl_spi_h2d[109] ,
    \tl_spi_h2d[108] ,
    \tl_spi_h2d[107] ,
    \tl_spi_h2d[106] ,
    \tl_spi_h2d[105] ,
    \tl_spi_h2d[104] ,
    \tl_spi_h2d[103] ,
    \tl_spi_h2d[102] ,
    \tl_spi_h2d[101] ,
    \tl_spi_h2d[100] ,
    \tl_spi_h2d[99] ,
    \tl_spi_h2d[98] ,
    \tl_spi_h2d[97] ,
    \tl_spi_h2d[96] ,
    \tl_spi_h2d[95] ,
    \tl_spi_h2d[94] ,
    \tl_spi_h2d[93] ,
    \tl_spi_h2d[92] ,
    \tl_spi_h2d[91] ,
    \tl_spi_h2d[90] ,
    \tl_spi_h2d[89] ,
    \tl_spi_h2d[88] ,
    \tl_spi_h2d[87] ,
    \tl_spi_h2d[86] ,
    \tl_spi_h2d[85] ,
    \tl_spi_h2d[84] ,
    \tl_spi_h2d[83] ,
    \tl_spi_h2d[82] ,
    \tl_spi_h2d[81] ,
    \tl_spi_h2d[80] ,
    \tl_spi_h2d[79] ,
    \tl_spi_h2d[78] ,
    \tl_spi_h2d[77] ,
    \tl_spi_h2d[76] ,
    \tl_spi_h2d[75] ,
    \tl_spi_h2d[74] ,
    \tl_spi_h2d[73] ,
    \tl_spi_h2d[72] ,
    \tl_spi_h2d[71] ,
    \tl_spi_h2d[70] ,
    \tl_spi_h2d[69] ,
    \tl_spi_h2d[68] ,
    \tl_spi_h2d[67] ,
    \tl_spi_h2d[66] ,
    \tl_spi_h2d[65] ,
    \tl_spi_h2d[64] ,
    \tl_spi_h2d[63] ,
    \tl_spi_h2d[62] ,
    \tl_spi_h2d[61] ,
    \tl_spi_h2d[60] ,
    \tl_spi_h2d[59] ,
    \tl_spi_h2d[58] ,
    \tl_spi_h2d[57] ,
    \tl_spi_h2d[56] ,
    \tl_spi_h2d[55] ,
    \tl_spi_h2d[54] ,
    \tl_spi_h2d[53] ,
    \tl_spi_h2d[52] ,
    \tl_spi_h2d[51] ,
    \tl_spi_h2d[50] ,
    \tl_spi_h2d[49] ,
    \tl_spi_h2d[48] ,
    \tl_spi_h2d[47] ,
    \tl_spi_h2d[46] ,
    \tl_spi_h2d[45] ,
    \tl_spi_h2d[44] ,
    \tl_spi_h2d[43] ,
    \tl_spi_h2d[42] ,
    \tl_spi_h2d[41] ,
    \tl_spi_h2d[40] ,
    \tl_spi_h2d[39] ,
    \tl_spi_h2d[38] ,
    \tl_spi_h2d[37] ,
    \tl_spi_h2d[36] ,
    \tl_spi_h2d[35] ,
    \tl_spi_h2d[34] ,
    \tl_spi_h2d[33] ,
    \tl_spi_h2d[32] ,
    \tl_spi_h2d[31] ,
    \tl_spi_h2d[30] ,
    \tl_spi_h2d[29] ,
    \tl_spi_h2d[28] ,
    \tl_spi_h2d[27] ,
    \tl_spi_h2d[26] ,
    \tl_spi_h2d[25] ,
    \tl_spi_h2d[24] ,
    \tl_spi_h2d[23] ,
    \tl_spi_h2d[22] ,
    \tl_spi_h2d[21] ,
    \tl_spi_h2d[20] ,
    \tl_spi_h2d[19] ,
    \tl_spi_h2d[18] ,
    \tl_spi_h2d[17] ,
    \tl_spi_h2d[16] ,
    \tl_spi_h2d[15] ,
    \tl_spi_h2d[14] ,
    \tl_spi_h2d[13] ,
    \tl_spi_h2d[12] ,
    \tl_spi_h2d[11] ,
    \tl_spi_h2d[10] ,
    \tl_spi_h2d[9] ,
    \tl_spi_h2d[8] ,
    \tl_spi_h2d[7] ,
    \tl_spi_h2d[6] ,
    \tl_spi_h2d[5] ,
    \tl_spi_h2d[4] ,
    \tl_spi_h2d[3] ,
    \tl_spi_h2d[2] ,
    \tl_spi_h2d[1] ,
    \tl_spi_h2d[0] }),
    .tl_u_uart_i({\tl_uart_d2h[65] ,
    \tl_uart_d2h[64] ,
    \tl_uart_d2h[63] ,
    \tl_uart_d2h[62] ,
    \tl_uart_d2h[61] ,
    \tl_uart_d2h[60] ,
    \tl_uart_d2h[59] ,
    \tl_uart_d2h[58] ,
    \tl_uart_d2h[57] ,
    \tl_uart_d2h[56] ,
    \tl_uart_d2h[55] ,
    \tl_uart_d2h[54] ,
    \tl_uart_d2h[53] ,
    \tl_uart_d2h[52] ,
    \tl_uart_d2h[51] ,
    \tl_uart_d2h[50] ,
    \tl_uart_d2h[49] ,
    \tl_uart_d2h[48] ,
    \tl_uart_d2h[47] ,
    \tl_uart_d2h[46] ,
    \tl_uart_d2h[45] ,
    \tl_uart_d2h[44] ,
    \tl_uart_d2h[43] ,
    \tl_uart_d2h[42] ,
    \tl_uart_d2h[41] ,
    \tl_uart_d2h[40] ,
    \tl_uart_d2h[39] ,
    \tl_uart_d2h[38] ,
    \tl_uart_d2h[37] ,
    \tl_uart_d2h[36] ,
    \tl_uart_d2h[35] ,
    \tl_uart_d2h[34] ,
    \tl_uart_d2h[33] ,
    \tl_uart_d2h[32] ,
    \tl_uart_d2h[31] ,
    \tl_uart_d2h[30] ,
    \tl_uart_d2h[29] ,
    \tl_uart_d2h[28] ,
    \tl_uart_d2h[27] ,
    \tl_uart_d2h[26] ,
    \tl_uart_d2h[25] ,
    \tl_uart_d2h[24] ,
    \tl_uart_d2h[23] ,
    \tl_uart_d2h[22] ,
    \tl_uart_d2h[21] ,
    \tl_uart_d2h[20] ,
    \tl_uart_d2h[19] ,
    \tl_uart_d2h[18] ,
    \tl_uart_d2h[17] ,
    \tl_uart_d2h[16] ,
    \tl_uart_d2h[15] ,
    \tl_uart_d2h[14] ,
    \tl_uart_d2h[13] ,
    \tl_uart_d2h[12] ,
    \tl_uart_d2h[11] ,
    \tl_uart_d2h[10] ,
    \tl_uart_d2h[9] ,
    \tl_uart_d2h[8] ,
    \tl_uart_d2h[7] ,
    \tl_uart_d2h[6] ,
    \tl_uart_d2h[5] ,
    \tl_uart_d2h[4] ,
    \tl_uart_d2h[3] ,
    \tl_uart_d2h[2] ,
    \tl_uart_d2h[1] ,
    \tl_uart_d2h[0] }),
    .tl_u_uart_o({\tl_uart_h2d[109] ,
    \tl_uart_h2d[108] ,
    \tl_uart_h2d[107] ,
    \tl_uart_h2d[106] ,
    \tl_uart_h2d[105] ,
    \tl_uart_h2d[104] ,
    \tl_uart_h2d[103] ,
    \tl_uart_h2d[102] ,
    \tl_uart_h2d[101] ,
    \tl_uart_h2d[100] ,
    \tl_uart_h2d[99] ,
    \tl_uart_h2d[98] ,
    \tl_uart_h2d[97] ,
    \tl_uart_h2d[96] ,
    \tl_uart_h2d[95] ,
    \tl_uart_h2d[94] ,
    \tl_uart_h2d[93] ,
    \tl_uart_h2d[92] ,
    \tl_uart_h2d[91] ,
    \tl_uart_h2d[90] ,
    \tl_uart_h2d[89] ,
    \tl_uart_h2d[88] ,
    \tl_uart_h2d[87] ,
    \tl_uart_h2d[86] ,
    \tl_uart_h2d[85] ,
    \tl_uart_h2d[84] ,
    \tl_uart_h2d[83] ,
    \tl_uart_h2d[82] ,
    \tl_uart_h2d[81] ,
    \tl_uart_h2d[80] ,
    \tl_uart_h2d[79] ,
    \tl_uart_h2d[78] ,
    \tl_uart_h2d[77] ,
    \tl_uart_h2d[76] ,
    \tl_uart_h2d[75] ,
    \tl_uart_h2d[74] ,
    \tl_uart_h2d[73] ,
    \tl_uart_h2d[72] ,
    \tl_uart_h2d[71] ,
    \tl_uart_h2d[70] ,
    \tl_uart_h2d[69] ,
    \tl_uart_h2d[68] ,
    \tl_uart_h2d[67] ,
    \tl_uart_h2d[66] ,
    \tl_uart_h2d[65] ,
    \tl_uart_h2d[64] ,
    \tl_uart_h2d[63] ,
    \tl_uart_h2d[62] ,
    \tl_uart_h2d[61] ,
    \tl_uart_h2d[60] ,
    \tl_uart_h2d[59] ,
    \tl_uart_h2d[58] ,
    \tl_uart_h2d[57] ,
    \tl_uart_h2d[56] ,
    \tl_uart_h2d[55] ,
    \tl_uart_h2d[54] ,
    \tl_uart_h2d[53] ,
    \tl_uart_h2d[52] ,
    \tl_uart_h2d[51] ,
    \tl_uart_h2d[50] ,
    \tl_uart_h2d[49] ,
    \tl_uart_h2d[48] ,
    \tl_uart_h2d[47] ,
    \tl_uart_h2d[46] ,
    \tl_uart_h2d[45] ,
    \tl_uart_h2d[44] ,
    \tl_uart_h2d[43] ,
    \tl_uart_h2d[42] ,
    \tl_uart_h2d[41] ,
    \tl_uart_h2d[40] ,
    \tl_uart_h2d[39] ,
    \tl_uart_h2d[38] ,
    \tl_uart_h2d[37] ,
    \tl_uart_h2d[36] ,
    \tl_uart_h2d[35] ,
    \tl_uart_h2d[34] ,
    \tl_uart_h2d[33] ,
    \tl_uart_h2d[32] ,
    \tl_uart_h2d[31] ,
    \tl_uart_h2d[30] ,
    \tl_uart_h2d[29] ,
    \tl_uart_h2d[28] ,
    \tl_uart_h2d[27] ,
    \tl_uart_h2d[26] ,
    \tl_uart_h2d[25] ,
    \tl_uart_h2d[24] ,
    \tl_uart_h2d[23] ,
    \tl_uart_h2d[22] ,
    \tl_uart_h2d[21] ,
    \tl_uart_h2d[20] ,
    \tl_uart_h2d[19] ,
    \tl_uart_h2d[18] ,
    \tl_uart_h2d[17] ,
    \tl_uart_h2d[16] ,
    \tl_uart_h2d[15] ,
    \tl_uart_h2d[14] ,
    \tl_uart_h2d[13] ,
    \tl_uart_h2d[12] ,
    \tl_uart_h2d[11] ,
    \tl_uart_h2d[10] ,
    \tl_uart_h2d[9] ,
    \tl_uart_h2d[8] ,
    \tl_uart_h2d[7] ,
    \tl_uart_h2d[6] ,
    \tl_uart_h2d[5] ,
    \tl_uart_h2d[4] ,
    \tl_uart_h2d[3] ,
    \tl_uart_h2d[2] ,
    \tl_uart_h2d[1] ,
    \tl_uart_h2d[0] }),
    .tl_u_xbar_apb_i({zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_,
    zero_}),
    .tl_u_xbar_apb_o({\tl_xbar_apb_h2d[109] ,
    \tl_xbar_apb_h2d[108] ,
    \tl_xbar_apb_h2d[107] ,
    \tl_xbar_apb_h2d[106] ,
    \tl_xbar_apb_h2d[105] ,
    \tl_xbar_apb_h2d[104] ,
    \tl_xbar_apb_h2d[103] ,
    \tl_xbar_apb_h2d[102] ,
    \tl_xbar_apb_h2d[101] ,
    \tl_xbar_apb_h2d[100] ,
    \tl_xbar_apb_h2d[99] ,
    \tl_xbar_apb_h2d[98] ,
    \tl_xbar_apb_h2d[97] ,
    \tl_xbar_apb_h2d[96] ,
    \tl_xbar_apb_h2d[95] ,
    \tl_xbar_apb_h2d[94] ,
    \tl_xbar_apb_h2d[93] ,
    \tl_xbar_apb_h2d[92] ,
    \tl_xbar_apb_h2d[91] ,
    \tl_xbar_apb_h2d[90] ,
    \tl_xbar_apb_h2d[89] ,
    \tl_xbar_apb_h2d[88] ,
    \tl_xbar_apb_h2d[87] ,
    \tl_xbar_apb_h2d[86] ,
    \tl_xbar_apb_h2d[85] ,
    \tl_xbar_apb_h2d[84] ,
    \tl_xbar_apb_h2d[83] ,
    \tl_xbar_apb_h2d[82] ,
    \tl_xbar_apb_h2d[81] ,
    \tl_xbar_apb_h2d[80] ,
    \tl_xbar_apb_h2d[79] ,
    \tl_xbar_apb_h2d[78] ,
    \tl_xbar_apb_h2d[77] ,
    \tl_xbar_apb_h2d[76] ,
    \tl_xbar_apb_h2d[75] ,
    \tl_xbar_apb_h2d[74] ,
    \tl_xbar_apb_h2d[73] ,
    \tl_xbar_apb_h2d[72] ,
    \tl_xbar_apb_h2d[71] ,
    \tl_xbar_apb_h2d[70] ,
    \tl_xbar_apb_h2d[69] ,
    \tl_xbar_apb_h2d[68] ,
    \tl_xbar_apb_h2d[67] ,
    \tl_xbar_apb_h2d[66] ,
    \tl_xbar_apb_h2d[65] ,
    \tl_xbar_apb_h2d[64] ,
    \tl_xbar_apb_h2d[63] ,
    \tl_xbar_apb_h2d[62] ,
    \tl_xbar_apb_h2d[61] ,
    \tl_xbar_apb_h2d[60] ,
    \tl_xbar_apb_h2d[59] ,
    \tl_xbar_apb_h2d[58] ,
    \tl_xbar_apb_h2d[57] ,
    \tl_xbar_apb_h2d[56] ,
    \tl_xbar_apb_h2d[55] ,
    \tl_xbar_apb_h2d[54] ,
    \tl_xbar_apb_h2d[53] ,
    \tl_xbar_apb_h2d[52] ,
    \tl_xbar_apb_h2d[51] ,
    \tl_xbar_apb_h2d[50] ,
    \tl_xbar_apb_h2d[49] ,
    \tl_xbar_apb_h2d[48] ,
    \tl_xbar_apb_h2d[47] ,
    \tl_xbar_apb_h2d[46] ,
    \tl_xbar_apb_h2d[45] ,
    \tl_xbar_apb_h2d[44] ,
    \tl_xbar_apb_h2d[43] ,
    \tl_xbar_apb_h2d[42] ,
    \tl_xbar_apb_h2d[41] ,
    \tl_xbar_apb_h2d[40] ,
    \tl_xbar_apb_h2d[39] ,
    \tl_xbar_apb_h2d[38] ,
    \tl_xbar_apb_h2d[37] ,
    \tl_xbar_apb_h2d[36] ,
    \tl_xbar_apb_h2d[35] ,
    \tl_xbar_apb_h2d[34] ,
    \tl_xbar_apb_h2d[33] ,
    \tl_xbar_apb_h2d[32] ,
    \tl_xbar_apb_h2d[31] ,
    \tl_xbar_apb_h2d[30] ,
    \tl_xbar_apb_h2d[29] ,
    \tl_xbar_apb_h2d[28] ,
    \tl_xbar_apb_h2d[27] ,
    \tl_xbar_apb_h2d[26] ,
    \tl_xbar_apb_h2d[25] ,
    \tl_xbar_apb_h2d[24] ,
    \tl_xbar_apb_h2d[23] ,
    \tl_xbar_apb_h2d[22] ,
    \tl_xbar_apb_h2d[21] ,
    \tl_xbar_apb_h2d[20] ,
    \tl_xbar_apb_h2d[19] ,
    \tl_xbar_apb_h2d[18] ,
    \tl_xbar_apb_h2d[17] ,
    \tl_xbar_apb_h2d[16] ,
    \tl_xbar_apb_h2d[15] ,
    \tl_xbar_apb_h2d[14] ,
    \tl_xbar_apb_h2d[13] ,
    \tl_xbar_apb_h2d[12] ,
    \tl_xbar_apb_h2d[11] ,
    \tl_xbar_apb_h2d[10] ,
    \tl_xbar_apb_h2d[9] ,
    \tl_xbar_apb_h2d[8] ,
    \tl_xbar_apb_h2d[7] ,
    \tl_xbar_apb_h2d[6] ,
    \tl_xbar_apb_h2d[5] ,
    \tl_xbar_apb_h2d[4] ,
    \tl_xbar_apb_h2d[3] ,
    \tl_xbar_apb_h2d[2] ,
    \tl_xbar_apb_h2d[1] ,
    \tl_xbar_apb_h2d[0] }));
 sky130_fd_sc_hd__conb_1 TIE_ZERO_zero_ (.LO(zero_));
 sky130_fd_sc_hd__conb_1 TIE_ONE_one_ (.HI(one_));
endmodule
