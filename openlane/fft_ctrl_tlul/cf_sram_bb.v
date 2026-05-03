// @generated — vyges-soc-generator  DO NOT EDIT
// Synthesis blackbox stub for CF_SRAM_1024x32 (ChipFoundry commercial SRAM).
// All 8 power pins declared as inout. The instantiating RTL is responsible
// for explicitly wiring every power pin to the surrounding module's VPWR/VGND
// (see verilog/rtl/soc_conv.v fft_data_sram instantiation). PDN routing then
// physically connects them via PDN_MACRO_CONNECTIONS in openlane/<macro>/config.json.

module CF_SRAM_1024x32 (
    output [31:0] DO,
    output        ScanOutCC,
    input  [31:0] DI,
    input  [31:0] BEN,
    input  [9:0]  AD,
    input         EN,
    input         R_WB,
    input         CLKin,
    input         WLBI,
    input         WLOFF,
    input         TM,
    input         SM,
    input         ScanInCC,
    input         ScanInDL,
    input         ScanInDR,
    inout         vpwra,
    inout         vpwrp,
    inout         vpwrm,
    inout         vpwrac,
    inout         vpwrpc,
    inout         vgnd,
    inout         vpb,
    inout         vnb
);
endmodule