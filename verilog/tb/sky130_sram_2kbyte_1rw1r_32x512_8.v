// sky130_sram_2kbyte_1rw1r_32x512_8.v — behavioural simulation model
//
// Stand-in for the OpenRAM-generated sky130 SRAM hard macro that the FFT
// accelerator instantiates. The hardened design uses the actual GDS macro
// from the sky130 PDK; for RTL simulation we just need a functional 1-port
// (RW) + 1-port (R-only) SRAM with the same pin names and timing.
//
// Geometry: 512 words × 32 bits, byte write enables (4 lanes), active-low
// chip select and write enable.
//
// Synthesisable as well — Yosys will infer block RAM — but only used in
// simulation here. The OpenLane flow swaps in the real .lef/.gds via the
// MACROS section of openlane/fft_ctrl_tlul/config.json.

`timescale 1ns / 1ps

module sky130_sram_2kbyte_1rw1r_32x512_8 (
    // Port 0 — RW
    input  wire        clk0,
    input  wire        csb0,    // active-low chip select
    input  wire        web0,    // active-low write enable
    input  wire [3:0]  wmask0,  // per-byte write enable
    input  wire [8:0]  addr0,
    input  wire [31:0] din0,
    output reg  [31:0] dout0,

    // Port 1 — R only
    input  wire        clk1,
    input  wire        csb1,
    input  wire [8:0]  addr1,
    output reg  [31:0] dout1
);

    reg [31:0] mem [0:511];

    // Port 0: byte-masked write + read on the same cycle
    always @(posedge clk0) begin
        if (!csb0) begin
            if (!web0) begin
                if (wmask0[0]) mem[addr0][ 7: 0] <= din0[ 7: 0];
                if (wmask0[1]) mem[addr0][15: 8] <= din0[15: 8];
                if (wmask0[2]) mem[addr0][23:16] <= din0[23:16];
                if (wmask0[3]) mem[addr0][31:24] <= din0[31:24];
            end
            dout0 <= mem[addr0];
        end
    end

    // Port 1: read only
    always @(posedge clk1) begin
        if (!csb1) begin
            dout1 <= mem[addr1];
        end
    end

endmodule
