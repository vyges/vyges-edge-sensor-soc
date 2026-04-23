// @generated — vyges-soc-generator  DO NOT EDIT
// Target    : sim
// SoC       : edge_sensor
// Timescale : 1ns/1ps
//
// Purpose: Simulation-only top. Instantiates tlul_host_stub instead of a real
// CPU. All peripherals are stubbed with tlul_stub. Verilator / iverilog ready.
// For real IP integration use target=fpga, asic, or chiplet.
`timescale 1ns/1ps

module top_edge_sensor_sim (
  input  logic clk_i,
  input  logic rst_ni
);

  // ── Clock / reset ──────────────────────────────────────────────────────────
  logic clk_sys;
  logic rst_sys_n;
  assign clk_sys   = clk_i;
  assign rst_sys_n = rst_ni;

  // ── Interconnect wires ─────────────────────────────────────────────────────
  // TL-UL host channel — generic `tl_host_i/o` so xbar sees one port whether
  // fed directly by the CPU or by a tlul_socket_m1 arbiter (CPU + DM SBA).
  tlul_pkg::tl_h2d_t tl_host_i;
  tlul_pkg::tl_d2h_t tl_host_o;
  // No DM → CPU drives tl_host_i/o directly via aliases below
  tlul_pkg::tl_h2d_t tl_u_ibex_h2d;
  tlul_pkg::tl_d2h_t tl_u_ibex_d2h;
  assign tl_host_i = tl_u_ibex_h2d;
  assign tl_u_ibex_d2h = tl_host_o;
  // TL-UL slave channels
  tlul_pkg::tl_h2d_t tl_u_uart_o;
  tlul_pkg::tl_d2h_t tl_u_uart_i;
  tlul_pkg::tl_h2d_t tl_u_spi_host_o;
  tlul_pkg::tl_d2h_t tl_u_spi_host_i;
  tlul_pkg::tl_h2d_t tl_u_plic_o;
  tlul_pkg::tl_d2h_t tl_u_plic_i;
  tlul_pkg::tl_h2d_t tl_u_rom_o;
  tlul_pkg::tl_d2h_t tl_u_rom_i;
  tlul_pkg::tl_h2d_t tl_u_ram_o;
  tlul_pkg::tl_d2h_t tl_u_ram_i;
  tlul_pkg::tl_h2d_t tl_u_xbar_apb_o;
  tlul_pkg::tl_d2h_t tl_u_xbar_apb_i;

  // ── CPU: host stub (simulation only; replace with rv_core_ibex for silicon) ─
  tlul_host_stub #(
    .ROM_BASE (32'h00008000),
    .RAM_BASE (32'h10000000)
  ) u_host (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_o   (tl_u_ibex_i),
    .tl_i   (tl_u_ibex_o)
  );

  // ── Crossbar ───────────────────────────────────────────────────────────────
  xbar_main u_xbar (
    .clk_i              (clk_sys),
    .rst_ni             (rst_sys_n),
    // Master port is generic `tl_host_i/o` — upstream multiplexes CPU + DM
    // SBA via tlul_socket_m1 when debug_module is present; otherwise this is
    // wired straight from the CPU's TL-UL host output.
    .tl_host_i          (tl_host_i),
    .tl_host_o          (tl_host_o),
    .tl_u_uart_o      (tl_u_uart_o),
    .tl_u_uart_i      (tl_u_uart_i),
    .tl_u_spi_host_o      (tl_u_spi_host_o),
    .tl_u_spi_host_i      (tl_u_spi_host_i),
    .tl_u_plic_o      (tl_u_plic_o),
    .tl_u_plic_i      (tl_u_plic_i),
    .tl_u_rom_o      (tl_u_rom_o),
    .tl_u_rom_i      (tl_u_rom_i),
    .tl_u_ram_o      (tl_u_ram_o),
    .tl_u_ram_i      (tl_u_ram_i),
    .tl_u_xbar_apb_o      (tl_u_xbar_apb_o),
    .tl_u_xbar_apb_i      (tl_u_xbar_apb_i)
  );
  // ── Slaves (all stubbed for simulation) ───────────────────────────────────
  tlul_stub u_uart (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_i   (tl_u_uart_o),
    .tl_o   (tl_u_uart_i)
  );

  tlul_stub u_spi_host (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_i   (tl_u_spi_host_o),
    .tl_o   (tl_u_spi_host_i)
  );

  tlul_stub u_plic (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_i   (tl_u_plic_o),
    .tl_o   (tl_u_plic_i)
  );

  tlul_rom #(
    .BaseAddr (32'h00008000),
    .Depth    (8192),
    // Mirror the CPU's internal boot ROM so data-side reads of .rodata
    // (string literals, const tables) succeed. Without this the external
    // u_rom is zero-filled, uart_puts("literal") sees *s=0 and emits nothing
    // even though CPU instruction fetch works from the internal BRAM.
    .RomFile  ("boot_rom.hex")
  ) u_rom (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_i   (tl_u_rom_o),
    .tl_o   (tl_u_rom_i)
  );

  tlul_ram #(
    .BaseAddr (32'h10000000),
    .Depth    (32768)
  ) u_ram (
    .clk_i  (clk_sys),
    .rst_ni (rst_sys_n),
    .tl_i   (tl_u_ram_o),
    .tl_o   (tl_u_ram_i)
  );


endmodule