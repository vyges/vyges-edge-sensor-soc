// tb_edge_sensor_smoke.sv — minimal Verilator smoke testbench for the
// edge_sensor SoC. Boots the Ibex CPU from a real boot.hex image (built by
// the firmware Makefile under fw/) and exposes uart_tx_o + the Ibex
// instruction-fetch address for the C++ harness to monitor.
//
// Purpose: prove that
//   (1) the firmware image loads into the Ibex local boot ROM,
//   (2) the CPU comes out of reset and starts fetching from 0x00008000,
//   (3) the CPU progresses through the firmware (PC advances past _start),
//   (4) the firmware writes to the OpenTitan UART and characters appear
//       on uart_tx_o at 115200 baud.
//
// This is the contest's GLS-precursor test — same wrapper, swap soc_conv.v
// for verilog/gl/*.v to run gate-level.
//
// Run with:  make -C verilog/tb run

`timescale 1ns / 1ps

module tb_edge_sensor_smoke (
    input  wire        clk_i,
    input  wire        rst_ni,
    output wire        uart_tx_o,
    output wire [31:0] dbg_pc_o
);

    // ── Tied-off external pins ──────────────────────────────────────────
    //   uart_rx_i: idle high (no incoming traffic)
    //   spi_miso_i: low (no ADXL355 in sim — boot firmware will time-out
    //               on the device-ID check and proceed to the FFT loop)
    wire spi_sclk, spi_cs_n, spi_mosi;
    wire irq_ext;

    edge_sensor_soc_top dut (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .uart_tx_o  (uart_tx_o),
        .uart_rx_i  (1'b1),
        .spi_sclk_o (spi_sclk),
        .spi_cs_no  (spi_cs_n),
        .spi_mosi_o (spi_mosi),
        .spi_miso_i (1'b0),
        .irq_ext_o  (irq_ext)
    );

    // ── Debug: expose the Ibex instruction-fetch PC for the C++ harness ─
    // The C++ harness samples this every cycle to confirm the CPU is
    // making forward progress through the firmware.
    assign dbg_pc_o = dut.u_ibex.instr_addr;

    // ── Boot ROM load ───────────────────────────────────────────────────
    // The rv_core_ibex_tlul module declares BootRomFile = "" by default and
    // its time-0 initial fills the local boot_rom with NOPs. Initial-block
    // ordering between top-level and submodules is fragile in this sim
    // (top-down by default, so a top-level $readmemh is clobbered by the
    // inner NOP-fill that runs after). Solution: load the ROM from an
    // always-block on the first positive clock edge, well after all time-0
    // inits have completed. The C++ harness holds rst_ni asserted for the
    // first 40 cycles, so the CPU is idle while we load, and by the time
    // reset deasserts the ROM holds the real firmware.
    //
    // Cross-module hierarchical $readmemh writes are supported when the
    // target array is reachable through normal signal references.
    reg boot_rom_loaded = 1'b0;
    always @(posedge clk_i) begin
        if (!boot_rom_loaded) begin
            $readmemh("../../boot_rom.hex", dut.u_ibex.boot_rom);
            $display("[tb] loaded boot_rom.hex; boot_rom[0]=%08h  [1]=%08h  [2]=%08h",
                     dut.u_ibex.boot_rom[0],
                     dut.u_ibex.boot_rom[1],
                     dut.u_ibex.boot_rom[2]);
            boot_rom_loaded <= 1'b1;
        end
    end

endmodule
