// CF_SRAM_1024x32.v — behavioural simulation model
//
// Stand-in for the ChipFoundry commercial SRAM hard macro installed via
// `ipm install CF_SRAM_1024x32`. The OpenLane flow swaps in the real
// .lef/.gds/.lib via openlane/fft_ctrl_tlul/config.json, so this model
// never reaches the hardened netlist.
//
// Geometry: 1024 words × 32 bits, per-bit write enable (BEN), active-high
// chip enable (EN), active-high read / active-low write (R_WB). Single
// port, single-cycle read/write — matches the real macro at cycle
// granularity. Power / scan / test pins are omitted (simulation only).

`timescale 1ns / 1ps

module CF_SRAM_1024x32 (
    output reg  [31:0] DO,
    output             ScanOutCC,
    input       [31:0] DI,
    input       [31:0] BEN,
    input       [9:0]  AD,
    input              EN,
    input              R_WB,   // 1 = read, 0 = write
    input              CLKin,
    input              WLBI,
    input              WLOFF,
    input              TM,
    input              SM,
    input              ScanInCC,
    input              ScanInDL,
    input              ScanInDR
);

    reg [31:0] mem [0:1023];

    assign ScanOutCC = 1'b0;

    always @(posedge CLKin) begin
        if (EN) begin
            if (!R_WB) begin
                // Write cycle — per-bit mask from BEN
                mem[AD] <= (DI & BEN) | (mem[AD] & ~BEN);
            end
            DO <= mem[AD];
        end
    end

endmodule
