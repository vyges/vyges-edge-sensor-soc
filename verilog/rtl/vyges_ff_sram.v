// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2026 Vyges
//
// vyges_ff_sram — 8 KB FFT data memory, 2 banks of 1024 × 32-bit each.
// Pre-hardened sky130A standard-cell macro that replaces the prior
// CF_SRAM_1024x32 × 2 sibling-macro layout at user_project_wrapper.
//
// Why this macro exists: see commit on `fft-ff-array` branch.
// Architecturally identical port shape to the previous "sibling banks"
// arrangement (en[1:0] selects bank, shared address / wdata / ben /
// rwb), so the wrapper RTL change is just one less instantiation.

`default_nettype none

module vyges_ff_sram (
    input  wire        clk_i,
    input  wire [1:0]  en_i,        // [0] = bank 0, [1] = bank 1
    input  wire        rwb_i,        // 1 = read, 0 = write (shared)
    input  wire [9:0]  addr_i,       // shared (intra-bank addr)
    input  wire [31:0] wdata_i,      // shared
    input  wire [31:0] ben_i,        // shared per-bit byte enable
    output wire [31:0] rdata0_o,
    output wire [31:0] rdata1_o
);

    vyges_ff_sram_1024x32 u_bank0 (
        .CLKin (clk_i),
        .EN    (en_i[0]),
        .R_WB  (rwb_i),
        .AD    (addr_i),
        .DI    (wdata_i),
        .BEN   (ben_i),
        .DO    (rdata0_o)
    );

    vyges_ff_sram_1024x32 u_bank1 (
        .CLKin (clk_i),
        .EN    (en_i[1]),
        .R_WB  (rwb_i),
        .AD    (addr_i),
        .DI    (wdata_i),
        .BEN   (ben_i),
        .DO    (rdata1_o)
    );

endmodule

`default_nettype wire
