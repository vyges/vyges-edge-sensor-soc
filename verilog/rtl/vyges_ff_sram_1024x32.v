
// @generated — vyges-soc-generator  DO NOT EDIT
// Vyges flip-flop-array SRAM — drop-in replacement for CF_SRAM_1024x32
// at instantiation sites that don't connect test / scan / power-pin
// ports. Behavioural register-array; synth tool infers flip-flops.
//
// Functional equivalence to CF_SRAM_1024x32 on the data path:
//   * 1-cycle registered read latency
//   * Byte-enable write via BEN[31:0] (per-bit; CF_SRAM uses 32-bit
//     mask, AND-reduced into 4 byte enables internally)
//   * EN gates both reads and writes
//   * R_WB: 1 = read, 0 = write
//
// Differences vs CF_SRAM_1024x32:
//   * No physical macro; absorbed into parent macro's standard-cell
//     area at synthesis time. ~64 K flip-flops at sky130A density
//     ≈ 0.13 mm² (Ibex's 1 M-flop array fits in ~2 mm²).
//   * No test / scan / power-pin ports. Wrapper VPWR/VGND attached
//     by the synth tool.

module vyges_ff_sram_1024x32 (
    output logic [31:0] DO,
    input  logic [31:0] DI,
    input  logic [31:0] BEN,
    input  logic [9:0]  AD,
    input  logic        EN,
    input  logic        R_WB,
    input  logic        CLKin
);

    // Storage: 1024 × 32-bit words. Synth tool infers flip-flops.
    logic [31:0] mem [0:1023];

    // Registered-output read (matches CF_SRAM_1024x32's 1-cycle
    // latency contract).
    logic [31:0] dout_q;

    always_ff @(posedge CLKin) begin
        if (EN) begin
            if (!R_WB) begin
                // Write with byte enables. BEN[31:0] is per-bit; we
                // honour the per-bit mask directly (synth simplifies
                // when bytes are uniform, which is the OT TL-UL
                // contract).
                for (int b = 0; b < 32; b++) begin
                    if (BEN[b]) mem[AD][b] <= DI[b];
                end
            end
            // Read latch fires unconditionally on EN — non-blocking
            // semantics give "old value" on read-during-write,
            // matching CF_SRAM behaviour.
            dout_q <= mem[AD];
        end
    end

    assign DO = dout_q;

endmodule

