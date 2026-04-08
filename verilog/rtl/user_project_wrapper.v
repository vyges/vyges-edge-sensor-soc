// SPDX-License-Identifier: Apache-2.0
// Caravel user_project_wrapper — Pure structural integration shell
//
// ZERO assigns, ZERO logic, ZERO tie-offs at this level.
// All logic (reset inversion, GPIO mapping, tie-offs) lives inside
// the edge_sensor_glue hardened macro.
//
// Pattern: mole99/caravel_wfg_sky130 (6 macros + SRAM, SYNTH_ELABORATE_ONLY)
// Reference: dineshannayya/riscduino (20 macros, reset inside wb_host)

`default_nettype none

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,
`endif
    input  wb_clk_i,
    input  wb_rst_i,
    input  wbs_stb_i,
    input  wbs_cyc_i,
    input  wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,
    inout  [`MPRJ_IO_PADS-10:0] analog_io,
    input  user_clock2,
    output [2:0] user_irq
);

    // ── Internal wires (no assigns — just declarations) ─────────────────────
    wire clk;
    wire rst_n;

    // TL-UL buses (110-bit H2D, 66-bit D2H)
    wire [109:0] tl_cpu_h2d;
    wire [65:0]  tl_cpu_d2h;
    wire [109:0] tl_uart_h2d;
    wire [65:0]  tl_uart_d2h;
    wire [109:0] tl_spi_h2d;
    wire [65:0]  tl_spi_d2h;
    wire [109:0] tl_plic_h2d;
    wire [65:0]  tl_plic_d2h;
    wire [109:0] tl_fft_h2d;
    wire [65:0]  tl_fft_d2h;
    wire [109:0] tl_rom_h2d;
    wire [65:0]  tl_rom_d2h;
    wire [109:0] tl_ram_h2d;
    wire [65:0]  tl_ram_d2h;

    // Peripheral signals
    wire uart_rx, uart_tx;
    wire spi_sclk, spi_cs_n, spi_mosi, spi_miso;
    wire fft_done, fft_error;
    wire plic_irq;
    wire [31:0] intr_vec;

    // UART interrupts
    wire intr_uart_tx_watermark, intr_uart_tx_empty, intr_uart_rx_watermark;
    wire intr_uart_tx_done, intr_uart_rx_overflow, intr_uart_rx_frame_err;
    wire intr_uart_rx_break_err, intr_uart_rx_timeout, intr_uart_rx_parity_err;

    // SPI interrupts
    wire intr_spi_tx_empty, intr_spi_rx_full, intr_spi_idle;

    // ROM/RAM stub responses (active-low valid = always not-ready)
    wire [65:0] tl_rom_d2h_stub;
    wire [65:0] tl_ram_d2h_stub;

    // ── Glue macro (reset, tie-offs, GPIO, interrupt vector) ────────────────
    edge_sensor_glue u_glue (
        .wb_clk_i       (wb_clk_i),
        .wb_rst_i       (wb_rst_i),
        .wbs_stb_i      (wbs_stb_i),
        .wbs_cyc_i      (wbs_cyc_i),
        .wbs_we_i       (wbs_we_i),
        .wbs_sel_i      (wbs_sel_i),
        .wbs_dat_i      (wbs_dat_i),
        .wbs_adr_i      (wbs_adr_i),
        .wbs_ack_o      (wbs_ack_o),
        .wbs_dat_o      (wbs_dat_o),
        .la_data_in     (la_data_in),
        .la_data_out    (la_data_out),
        .la_oenb        (la_oenb),
        .io_in          (io_in),
        .io_out         (io_out),
        .io_oeb         (io_oeb),
        .user_irq       (user_irq),
        .clk_o          (clk),
        .rst_no         (rst_n),
        .uart_rx_o      (uart_rx),
        .uart_tx_i      (uart_tx),
        .spi_sclk_i     (spi_sclk),
        .spi_cs_ni      (spi_cs_n),
        .spi_mosi_i     (spi_mosi),
        .spi_miso_o     (spi_miso),
        .fft_done_i     (fft_done),
        .fft_error_i    (fft_error),
        .plic_irq_i     (plic_irq),
        .intr_uart_tx_watermark_i   (intr_uart_tx_watermark),
        .intr_uart_tx_empty_i       (intr_uart_tx_empty),
        .intr_uart_rx_watermark_i   (intr_uart_rx_watermark),
        .intr_uart_tx_done_i        (intr_uart_tx_done),
        .intr_uart_rx_overflow_i    (intr_uart_rx_overflow),
        .intr_uart_rx_frame_err_i   (intr_uart_rx_frame_err),
        .intr_uart_rx_break_err_i   (intr_uart_rx_break_err),
        .intr_uart_rx_timeout_i     (intr_uart_rx_timeout),
        .intr_uart_rx_parity_err_i  (intr_uart_rx_parity_err),
        .intr_spi_tx_empty_i        (intr_spi_tx_empty),
        .intr_spi_rx_full_i         (intr_spi_rx_full),
        .intr_spi_idle_i            (intr_spi_idle),
        .intr_vec_o     (intr_vec)
    );

    // ── Crossbar ────────────────────────────────────────────────────────────
    xbar_main u_xbar (
        .clk_i          (clk),
        .rst_ni         (rst_n),
        .tl_u_ibex_i    (tl_cpu_h2d),
        .tl_u_ibex_o    (tl_cpu_d2h),
        .tl_u_uart_o    (tl_uart_h2d),
        .tl_u_uart_i    (tl_uart_d2h),
        .tl_u_spi_host_o(tl_spi_h2d),
        .tl_u_spi_host_i(tl_spi_d2h),
        .tl_u_plic_o    (tl_plic_h2d),
        .tl_u_plic_i    (tl_plic_d2h),
        .tl_u_fft_o     (tl_fft_h2d),
        .tl_u_fft_i     (tl_fft_d2h),
        .tl_u_rom_o     (tl_rom_h2d),
        .tl_u_rom_i     (tl_rom_d2h),
        .tl_u_ram_o     (tl_ram_h2d),
        .tl_u_ram_i     (tl_ram_d2h)
    );

    // ── CPU (TL-UL wrapped Ibex) ────────────────────────────────────────────
    rv_core_ibex_tlul u_ibex (
        .clk_i          (clk),
        .rst_ni         (rst_n),
        .boot_addr_i    (32'h00008000),
        .hart_id_i      (32'h0),
        .tl_o           (tl_cpu_h2d),
        .tl_i           (tl_cpu_d2h),
        .irq_software_i (1'b0),
        .irq_timer_i    (1'b0),
        .irq_external_i (plic_irq),
        .core_sleep_o   ()
    );

    // ── UART ────────────────────────────────────────────────────────────────
    uart u_uart (
        .clk_i                  (clk),
        .rst_ni                 (rst_n),
        .tl_i                   (tl_uart_h2d),
        .tl_o                   (tl_uart_d2h),
        .cio_rx_i               (uart_rx),
        .cio_tx_o               (uart_tx),
        .cio_tx_en_o            (),
        .intr_tx_watermark_o    (intr_uart_tx_watermark),
        .intr_rx_watermark_o    (intr_uart_rx_watermark),
        .intr_tx_done_o         (intr_uart_tx_done),
        .intr_rx_overflow_o     (intr_uart_rx_overflow),
        .intr_rx_frame_err_o    (intr_uart_rx_frame_err),
        .intr_rx_break_err_o    (intr_uart_rx_break_err),
        .intr_rx_timeout_o      (intr_uart_rx_timeout),
        .intr_rx_parity_err_o   (intr_uart_rx_parity_err),
        .intr_tx_empty_o        (intr_uart_tx_empty),
        .lsio_trigger_o         (),
        .alert_rx_i             (4'b0),
        .alert_tx_o             (),
        .racl_policies_i        (8'b0),
        .racl_error_o           ()
    );

    // ── SPI Host ────────────────────────────────────────────────────────────
    spi_host_lite u_spi_host (
        .clk_i          (clk),
        .rst_ni         (rst_n),
        .tl_i           (tl_spi_h2d),
        .tl_o           (tl_spi_d2h),
        .spi_sclk_o     (spi_sclk),
        .spi_cs_no      (spi_cs_n),
        .spi_mosi_o     (spi_mosi),
        .spi_miso_i     (spi_miso),
        .intr_tx_empty_o(intr_spi_tx_empty),
        .intr_rx_full_o (intr_spi_rx_full),
        .intr_idle_o    (intr_spi_idle)
    );

    // ── PLIC ────────────────────────────────────────────────────────────────
    rv_plic_lite u_plic (
        .clk_i          (clk),
        .rst_ni         (rst_n),
        .tl_i           (tl_plic_h2d),
        .tl_o           (tl_plic_d2h),
        .intr_src_i     (intr_vec),
        .irq_o          (plic_irq)
    );

    // ── FFT Accelerator ─────────────────────────────────────────────────────
    fft_ctrl_tlul u_fft (
        .clk_i          (clk),
        .rst_ni         (rst_n),
        .tl_i           (tl_fft_h2d),
        .tl_o           (tl_fft_d2h),
        .fft_done_o     (fft_done),
        .fft_error_o    (fft_error)
    );

    // ── ROM / RAM stubs ─────────────────────────────────────────────────────
    // Hardcoded TL-UL D2H default response (all zeros = no valid response).
    // These will be replaced with SRAM macros or behavioral models in
    // a future iteration. For now they allow the xbar to complete address
    // decode without hanging.
    //
    // NOTE: These are the ONLY assigns in the wrapper. They are constant
    // tie-offs (no logic) and should survive SYNTH_ELABORATE_ONLY as
    // constant wire drivers. If they cause issues, replace with a tiny
    // hardened stub macro.
    assign tl_rom_d2h = 66'h0;
    assign tl_ram_d2h = 66'h0;

endmodule

`default_nettype wire
