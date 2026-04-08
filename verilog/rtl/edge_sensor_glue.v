// SPDX-License-Identifier: Apache-2.0
// edge_sensor_glue — Caravel integration glue for Edge Sensor SoC
//
// Handles everything the user_project_wrapper cannot:
//   - Reset polarity inversion (Caravel active-high → SoC active-low)
//   - Caravel port tie-offs (Wishbone, Logic Analyzer)
//   - GPIO mapping (io_in/out/oeb → peripheral signals)
//   - Interrupt vector assembly (14 sources → PLIC → Caravel IRQ)
//
// This module is hardened as a small macro and placed in the wrapper
// alongside the other SoC macros. The wrapper itself has ZERO logic,
// ZERO assigns — just port-to-port wiring between hardened macros.
//
// Pattern follows riscduino (wb_host) and mole99/caravel_wfg_sky130.

`default_nettype none

module edge_sensor_glue (
    // ── Caravel-side ports (active-high reset, active-high logic) ────────
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,        // active-high from Caravel

    // Wishbone slave — unused, tie off here
    input  wire        wbs_stb_i,
    input  wire        wbs_cyc_i,
    input  wire        wbs_we_i,
    input  wire [3:0]  wbs_sel_i,
    input  wire [31:0] wbs_dat_i,
    input  wire [31:0] wbs_adr_i,
    output wire        wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    // Logic Analyzer — unused, tie off here
    input  wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input  wire [127:0] la_oenb,

    // GPIO from Caravel pads
    input  wire [37:0] io_in,
    output wire [37:0] io_out,
    output wire [37:0] io_oeb,

    // IRQ to Caravel management SoC
    output wire [2:0]  user_irq,

    // ── SoC-side ports (active-low reset, active-low logic) ─────────────
    output wire        clk_o,           // buffered clock
    output wire        rst_no,          // active-low reset

    // UART signals
    output wire        uart_rx_o,       // io_in[0] → uart
    input  wire        uart_tx_i,       // uart → io_out[1]

    // SPI signals
    input  wire        spi_sclk_i,      // spi → io_out[2]
    input  wire        spi_cs_ni,       // spi → io_out[3]
    input  wire        spi_mosi_i,      // spi → io_out[4]
    output wire        spi_miso_o,      // io_in[5] → spi

    // FFT status
    input  wire        fft_done_i,
    input  wire        fft_error_i,

    // PLIC IRQ
    input  wire        plic_irq_i,

    // Interrupt sources (directly from peripherals → PLIC)
    // UART: 9 interrupts
    input  wire        intr_uart_tx_watermark_i,
    input  wire        intr_uart_tx_empty_i,
    input  wire        intr_uart_rx_watermark_i,
    input  wire        intr_uart_tx_done_i,
    input  wire        intr_uart_rx_overflow_i,
    input  wire        intr_uart_rx_frame_err_i,
    input  wire        intr_uart_rx_break_err_i,
    input  wire        intr_uart_rx_timeout_i,
    input  wire        intr_uart_rx_parity_err_i,
    // SPI: 3 interrupts
    input  wire        intr_spi_tx_empty_i,
    input  wire        intr_spi_rx_full_i,
    input  wire        intr_spi_idle_i,

    // Assembled interrupt vector → PLIC
    output wire [31:0] intr_vec_o
);

    // ── Clock buffer ────────────────────────────────────────────────────────
    assign clk_o = wb_clk_i;

    // ── Reset inversion (active-high → active-low) ─────────────────────────
    assign rst_no = ~wb_rst_i;

    // ── Wishbone tie-offs ───────────────────────────────────────────────────
    assign wbs_ack_o = 1'b0;
    assign wbs_dat_o = 32'h0;

    // ── Logic Analyzer tie-off ──────────────────────────────────────────────
    assign la_data_out = 128'h0;

    // ── GPIO mapping ────────────────────────────────────────────────────────
    // io_in[0]  → uart_rx
    // io_out[1] ← uart_tx
    // io_out[2] ← spi_sclk
    // io_out[3] ← spi_cs_n
    // io_out[4] ← spi_mosi
    // io_in[5]  → spi_miso
    // io_out[6] ← fft_done (debug)

    assign uart_rx_o  = io_in[0];
    assign spi_miso_o = io_in[5];

    assign io_out[0]     = 1'b0;           // uart_rx pad (input, drive low)
    assign io_out[1]     = uart_tx_i;
    assign io_out[2]     = spi_sclk_i;
    assign io_out[3]     = spi_cs_ni;
    assign io_out[4]     = spi_mosi_i;
    assign io_out[5]     = 1'b0;           // spi_miso pad (input, drive low)
    assign io_out[6]     = fft_done_i;     // debug GPIO
    assign io_out[37:7]  = 31'h0;          // unused

    // oeb: 0 = output, 1 = input
    assign io_oeb[0]     = 1'b1;           // input (uart_rx)
    assign io_oeb[1]     = 1'b0;           // output (uart_tx)
    assign io_oeb[2]     = 1'b0;           // output (spi_sclk)
    assign io_oeb[3]     = 1'b0;           // output (spi_cs_n)
    assign io_oeb[4]     = 1'b0;           // output (spi_mosi)
    assign io_oeb[5]     = 1'b1;           // input (spi_miso)
    assign io_oeb[6]     = 1'b0;           // output (fft_done)
    assign io_oeb[37:7]  = 31'h7FFFFFFF;   // inputs (unused)

    // ── IRQ to Caravel ──────────────────────────────────────────────────────
    assign user_irq = {2'b0, plic_irq_i};

    // ── Interrupt vector assembly → PLIC ────────────────────────────────────
    assign intr_vec_o = {
        18'b0,
        fft_error_i,                // 13
        fft_done_i,                 // 12
        intr_spi_idle_i,            // 11
        intr_spi_rx_full_i,         // 10
        intr_spi_tx_empty_i,        // 9
        intr_uart_rx_parity_err_i,  // 8
        intr_uart_rx_timeout_i,     // 7
        intr_uart_rx_break_err_i,   // 6
        intr_uart_rx_frame_err_i,   // 5
        intr_uart_rx_overflow_i,    // 4
        intr_uart_tx_done_i,        // 3
        intr_uart_rx_watermark_i,   // 2
        intr_uart_tx_empty_i,       // 1
        intr_uart_tx_watermark_i    // 0
    };

endmodule

`default_nettype wire
