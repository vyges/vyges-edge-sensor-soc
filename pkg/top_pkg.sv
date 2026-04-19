// Minimal top_pkg for simulation when using vendored opentitan-tlul.
// opentitan-tlul/rtl/tlul_pkg.sv depends on top_pkg and prim_*; this provides TL_* params.

package top_pkg;
  localparam int TL_AW  = 32;
  localparam int TL_DW  = 32;
  localparam int TL_AIW = 8;
  localparam int TL_DIW = 1;
  localparam int TL_AUW = 24;
  localparam int TL_DBW = (TL_DW >> 3);
  localparam int TL_SZW = $clog2($clog2(TL_DBW) + 1);
endpackage
