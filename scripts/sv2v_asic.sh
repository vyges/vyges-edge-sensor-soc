#!/usr/bin/env bash
# @generated — vyges-soc-generator  DO NOT EDIT
# sv2v_asic.sh — Convert edge_sensor SoC SystemVerilog to Verilog for ASIC (OpenLane/LibreLane)
#
# Produces: verilog/rtl/soc_conv.v (or build/synth/soc_conv.v depending on layout)
# Run on build machine with sv2v on PATH.
#
# Key differences from sv2v_fpga.sh:
#   - Defines: -DFFT_USE_SRAM_MACRO -DSYNTHESIS (real SRAM macros, suppress sim blocks)
#   - Curated file list (not glob) — some IP modules contain SVA assertions
#     that sv2v cannot parse; only packages from those IPs are included
#   - Post-process: strips modules with Yosys-incompatible constructs

set -euo pipefail
shopt -s nullglob


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

BUILD="$REPO_ROOT/build"
PKG="$BUILD/pkg"
RTL="$BUILD/rtl"
LOCAL_IPS="$REPO_ROOT/local-ips"

# Output — contest layout uses verilog/rtl/, generator layout uses build/synth/
if [[ -d "$REPO_ROOT/verilog/rtl" ]]; then
  OUT="$REPO_ROOT/verilog/rtl/soc_conv.v"
else
  mkdir -p "$BUILD/synth"
  OUT="$BUILD/synth/soc_conv.v"
fi


if ! command -v sv2v &>/dev/null; then
  echo "ERROR: sv2v not found on PATH" >&2; exit 1
fi

echo "=== sv2v (ASIC): edge_sensor ==="
echo "  Output: $OUT"

FILES=()

# Per-basename dedup. Prevents double definitions when a module file exists
# in both local-ips/ and build/rtl/ (e.g. generator copies rv_core_ibex_tlul.sv
# into build/rtl). sv2v would concatenate both, producing invalid Verilog.
declare -A _SV2V_SEEN
_add_once() {
  local f="$1" b
  b="$(basename "$f")"
  [[ -n "${_SV2V_SEEN[$b]:-}" ]] && return 0
  _SV2V_SEEN[$b]=1
  FILES+=("$f")
}

# ── 1. Prim packages (order matters) ────────────────────────────────────────
# Only *_pkg.sv from opentitan-prim — implementation modules have SVA
# assertions ([*], ##) that sv2v cannot parse. They are NOT instantiated
# by the design; OpenLane synthesizes prim cells from the standard cell library.

PRIM="$LOCAL_IPS/opentitan-prim/rtl"
PRIM_GEN="$LOCAL_IPS/opentitan-prim-generic/rtl"
for pkg in \
  "$PRIM_GEN/prim_pkg.sv" \
  "$PRIM/prim_mubi_pkg.sv" \
  "$PRIM/prim_util_pkg.sv" \
  "$PRIM/prim_count_pkg.sv" \
  "$PRIM/prim_secded_pkg.sv" \
  "$PRIM/prim_cipher_pkg.sv" \
  "$PRIM_GEN/prim_ram_1p_pkg.sv" \
  "$PRIM_GEN/prim_ram_2p_pkg.sv" \
  "$PRIM_GEN/prim_rom_pkg.sv" \
  "$PRIM/prim_alert_pkg.sv" \
  "$PRIM/prim_subreg_pkg.sv"; do
  [[ -f "$pkg" ]] && _add_once "$pkg"
done

# ── 2. Top-level + TL-UL packages ───────────────────────────────────────────

[[ -f "$PKG/top_pkg.sv" ]]      && _add_once "$PKG/top_pkg.sv"
[[ -f "$PKG/top_racl_pkg.sv" ]] && _add_once "$PKG/top_racl_pkg.sv"

TLUL="$LOCAL_IPS/opentitan-tlul/rtl"
[[ -f "$TLUL/tlul_pkg.sv" ]] && _add_once "$TLUL/tlul_pkg.sv"

# ── 3. Per-IP packages ──────────────────────────────────────────────────────
# OPENTITAN_UART register package
[[ -f "$LOCAL_IPS/opentitan-uart/rtl/uart_reg_pkg.sv" ]] && _add_once "$LOCAL_IPS/opentitan-uart/rtl/uart_reg_pkg.sv"
# IBEX register package
[[ -f "$LOCAL_IPS/ibex/rtl/ibex_pkg.sv" ]] && _add_once "$LOCAL_IPS/ibex/rtl/ibex_pkg.sv"

# ── 4. Address map package ──────────────────────────────────────────────────
[[ -f "$PKG/edge_sensor_pkg.sv" ]] && _add_once "$PKG/edge_sensor_pkg.sv"

# ── 5. Prim-generic implementations (leaf cells — explicit list) ────────────

for f in \
  prim_buf.sv prim_flop.sv prim_flop_en.sv prim_flop_no_rst.sv \
  prim_flop_2sync.sv prim_rst_sync.sv \
  prim_clock_gating.sv prim_clock_buf.sv prim_clock_mux2.sv \
  prim_and2.sv prim_xor2.sv prim_xnor2.sv \
  prim_ram_1p.sv prim_rom.sv; do
  [[ -f "$PRIM_GEN/$f" ]] && _add_once "$PRIM_GEN/$f"
done

# ── 6. Prim modules (skip SVA / lc_ctrl / sim-only) ─────────────────────────

PRIM_SKIP="prim_lc_and_hardened.sv prim_lc_combine.sv prim_lc_dec.sv \
  prim_lc_or_hardened.sv prim_lc_sender.sv prim_lc_sync.sv \
  prim_alert_receiver.sv prim_sdc_example.sv \
  prim_assert.sv prim_flop_macros.sv \
  prim_cdc_rand_delay.sv prim_edn_req.sv"
for f in "$PRIM"/*.sv; do
  base="$(basename "$f")"
  echo "$PRIM_SKIP" | grep -qw "$base" && continue
  _add_once "$f"
done

# ── 7. TL-UL RTL (skip packages, shim, RACL, JTAG adapters) ─────────────────

TLUL_SKIP="tlul_pkg.sv tlul_adapter_shim.sv tlul_jtag_dtm.sv tlul_adapter_dmi.sv \
  tlul_adapter_racl.sv tlul_adapter_sram_racl.sv tlul_adapter_reg_racl.sv tlul_lc_gate.sv"
for f in "$TLUL"/*.sv; do
  base="$(basename "$f")"
  echo "$TLUL_SKIP" | grep -qw "$base" && continue
  _add_once "$f"
done

# ── 8. Per-IP RTL ───────────────────────────────────────────────────────────
# Three modes per IP (evaluated in order): allowlist → glob+skip_list → bare glob.
# Allowlist is used for library IPs (common_cells, tech_cells_generic) where most
# files are irrelevant to the synthesis path; only the named files are added.
# OPENTITAN_RV_CORE_IBEX
for f in "$LOCAL_IPS/opentitan-rv-core-ibex/rtl"/*.sv; do
  _add_once "$f"
done
# OPENTITAN_UART
OPENTITAN_UART_SKIP="uart_reg_pkg.sv"
for f in "$LOCAL_IPS/opentitan-uart/rtl"/*.sv; do
  base="$(basename "$f")"
  echo "${OPENTITAN_UART_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done
# VYGES_SPI_HOST_LITE
for f in "$LOCAL_IPS/vyges-spi-host-lite/rtl"/*.sv; do
  _add_once "$f"
done
# VYGES_RV_PLIC_LITE
for f in "$LOCAL_IPS/vyges-rv-plic-lite/rtl"/*.sv; do
  _add_once "$f"
done
# FAST_FOURIER_TRANSFORM_IP
for f in "$LOCAL_IPS/fast-fourier-transform-ip/rtl"/*.sv; do
  _add_once "$f"
done
# TLUL_APB_ADAPTER
for f in "$LOCAL_IPS/tlul-apb-adapter/rtl"/*.sv; do
  _add_once "$f"
done
# IBEX
IBEX_SKIP="ibex_pkg.sv ibex_tracer.sv ibex_tracer_pkg.sv ibex_top_tracing.sv ibex_register_file_fpga.sv ibex_register_file_latch.sv"
for f in "$LOCAL_IPS/ibex/rtl"/*.sv; do
  base="$(basename "$f")"
  echo "${IBEX_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# ── 9. Generated RTL (xbar, stubs, SRAM wrappers) ───────────────────────────
# Dedup (_add_once) protects against basename collisions between generated
# build/rtl/*.sv and local-ips copies (e.g. rv_core_ibex_tlul.sv exists in both).

if [[ -d "$RTL" ]]; then
  for f in "$RTL"/*.sv; do
    base="$(basename "$f")"
    [[ "$base" == top_* ]] && continue        # top-level wrappers not for module synth
    [[ "$base" == sram_*_wrapper.sv ]] && continue  # OpenRAM wrappers (not used with CF_SRAM)
    _add_once "$f"
  done
fi


echo "  ${#FILES[@]} source files"

# ── Run sv2v ─────────────────────────────────────────────────────────────────
sv2v \
  --define=SYNTHESIS \
  --define=FFT_USE_SRAM_MACRO \
  -I "$PRIM" \
  -I "$RTL" \
  -I "$LOCAL_IPS/fast-fourier-transform-ip/rtl" \
  -I "$LOCAL_IPS/common_cells/include" \
  -I "$LOCAL_IPS/common_cells/rtl" \
  -I "$LOCAL_IPS/tech_cells_generic/rtl" \
  -I "$LOCAL_IPS/pulp-riscv-dbg/rtl/debug_rom" \
  "${FILES[@]}" \
  -w "$OUT"

echo "=== sv2v complete: $OUT ==="
wc -l "$OUT"

# ── Post-process: fix residual struct member accesses from uart_reg_top ─────
# racl_policies_i[base +: N+N].read_perm is left behind by sv2v when
# flattening RACL-conditional code in opentitan-uart's reg_top. The enclosing
# blocks are dead at synthesis (EnableRacl=1'b0) but Yosys rejects the
# dangling struct access syntactically. racl_policy_t layout is
# {read_perm[N-1:0], write_perm[N-1:0]} — upper half reads, lower half writes.
N="top_racl_pkg_NrRaclRoles"
sed -i.bak "s/+:${N} + ${N}]\\.read_perm/+ ${N} +:${N}]/g" "$OUT" && rm -f "$OUT.bak"
sed -i.bak "s/+:${N} + ${N}]\\.write_perm/+:${N}]/g" "$OUT" && rm -f "$OUT.bak"
if grep -q ']\.' "$OUT"; then
  echo "WARNING: residual struct member accesses remain in $OUT" >&2
  grep -n ']\.' "$OUT" | head -5 >&2
fi

# ── Post-process: strip Yosys-incompatible modules ──────────────────────────
python3 - "$OUT" << 'PYSTRIP'
import sys
path = sys.argv[1]
lines = open(path).readlines()
out, skip = [], False
STRIP = {'tc_clk_delay', 'tc_clk_and2', 'tc_clk_buffer',
         'tc_clk_gating', 'tc_clk_xor2', 'tc_clk_or2'}
for l in lines:
    if any(l.strip().startswith(f'module {m}') for m in STRIP):
        skip = True
    if not skip:
        out.append(l)
    if skip and l.strip() == 'endmodule':
        skip = False
with open(path, 'w') as f:
    f.writelines(out)
if len(out) < len(lines):
    print(f'  Stripped {len(lines)-len(out)} lines from unused modules')
PYSTRIP
