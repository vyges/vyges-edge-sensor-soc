#!/usr/bin/env bash
# @generated — vyges-soc-generator  DO NOT EDIT
# sv2v_fpga.sh — Convert edge_sensor SoC SystemVerilog to Verilog for FPGA (Vivado)
#
# Produces: build/synth/soc_fpga_conv.v
# Run on build machine with sv2v on PATH.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# Sources live flat at repo root (generator writes rtl/, pkg/, local-ips/
# here). Tool-generated artifacts go under build/ so they stay out of the
# source tree.
PKG="$REPO_ROOT/pkg"
RTL="$REPO_ROOT/rtl"
LOCAL_IPS="$REPO_ROOT/local-ips"

# Aliases matching compile_stages paths (stages reference $build_dir/rtl,
# $build_dir/pkg — kept as $REPO_ROOT so those resolve to the flat layout).
local_ips="$LOCAL_IPS"
build_dir="$REPO_ROOT"

# IP directories
cf_sram="$LOCAL_IPS/cf-sram/rtl"
fast_fourier_transform_ip="$LOCAL_IPS/fast-fourier-transform-ip/rtl"
ibex="$LOCAL_IPS/ibex/rtl"
opentitan_prim="$LOCAL_IPS/opentitan-prim/rtl"
opentitan_prim_generic="$LOCAL_IPS/opentitan-prim-generic/rtl"
opentitan_rv_core_ibex="$LOCAL_IPS/opentitan-rv-core-ibex/rtl"
opentitan_tlul="$LOCAL_IPS/opentitan-tlul/rtl"
opentitan_uart="$LOCAL_IPS/opentitan-uart/rtl"
tlul_apb_adapter="$LOCAL_IPS/tlul-apb-adapter/rtl"
vyges_rv_plic_lite="$LOCAL_IPS/vyges-rv-plic-lite/rtl"
vyges_spi_host_lite="$LOCAL_IPS/vyges-spi-host-lite/rtl"

SYNTH_DIR="$REPO_ROOT/build/synth"
mkdir -p "$SYNTH_DIR"
OUT="$SYNTH_DIR/soc_fpga_conv.v"

if ! command -v sv2v &>/dev/null; then
  echo "ERROR: sv2v not found on PATH" >&2; exit 1
fi

FILES=()

# Per-basename dedup. Prevents double definitions when a module file exists
# in both local-ips/ and build/rtl/ (e.g. rv_core_ibex_tlul.sv), and protects
# against DM-dep allowlist overlapping with later globs.
declare -A _SV2V_SEEN
_add_once() {
  local f="$1" b
  b="$(basename "$f")"
  [[ -n "${_SV2V_SEEN[$b]:-}" ]] && return 0
  _SV2V_SEEN[$b]=1
  FILES+=("$f")
}

# ── Source files in dependency order (mirrors Vivado compile stages) ──

# Prim packages
for f in \
  "$local_ips/opentitan-prim-generic/rtl/prim_pkg.sv" \
  "$opentitan_prim/prim_mubi_pkg.sv" \
  "$opentitan_prim/prim_util_pkg.sv" \
  "$opentitan_prim/prim_count_pkg.sv" \
  "$opentitan_prim/prim_secded_pkg.sv" \
  "$opentitan_prim/prim_cipher_pkg.sv" \
  "$local_ips/opentitan-prim-generic/rtl/prim_ram_1p_pkg.sv" \
  "$local_ips/opentitan-prim-generic/rtl/prim_ram_2p_pkg.sv" \
  "$local_ips/opentitan-prim-generic/rtl/prim_rom_pkg.sv" \
  "$opentitan_prim/prim_alert_pkg.sv" \
  "$opentitan_prim/prim_subreg_pkg.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Top-level packages
for f in \
  "$build_dir/pkg/top_pkg.sv" \
  "$build_dir/pkg/top_racl_pkg.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# TL-UL package
for f in \
  "$opentitan_tlul/tlul_pkg.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Peripheral packages
for f in \
  "$opentitan_uart/uart_reg_pkg.sv" \
  "$local_ips/ibex/rtl/ibex_pkg.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Address map package
for f in \
  "$build_dir/pkg/edge_sensor_pkg.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Prim generic implementations
opentitan_prim_generic_SKIP="prim_pkg.sv prim_ram_1p_pkg.sv prim_ram_2p_pkg.sv prim_rom_pkg.sv prim_flash.sv prim_generic_flash_bank.sv prim_pad_wrapper.sv prim_pad_attr.sv prim_usb_diff_rx.sv"
for f in "$opentitan_prim_generic"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${opentitan_prim_generic_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# Prim modules
opentitan_prim_SKIP="prim_pkg.sv prim_mubi_pkg.sv prim_util_pkg.sv prim_count_pkg.sv prim_secded_pkg.sv prim_cipher_pkg.sv prim_alert_pkg.sv prim_subreg_pkg.sv prim_assert.sv prim_flop_macros.sv prim_lc_and_hardened.sv prim_lc_combine.sv prim_lc_dec.sv prim_lc_or_hardened.sv prim_lc_sender.sv prim_lc_sync.sv prim_alert_receiver.sv prim_sdc_example.sv prim_cdc_rand_delay.sv prim_edn_req.sv prim_pad_wrapper_pkg.sv prim_usb_diff_rx.sv prim_sha2_pad.sv"
for f in "$opentitan_prim"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${opentitan_prim_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# TL-UL RTL
opentitan_tlul_SKIP="tlul_pkg.sv tlul_adapter_shim.sv tlul_jtag_dtm.sv tlul_adapter_dmi.sv tlul_adapter_racl.sv tlul_adapter_sram_racl.sv tlul_adapter_reg_racl.sv tlul_lc_gate.sv"
for f in "$opentitan_tlul"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${opentitan_tlul_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# IP: cf-sram
cf_sram_SKIP=""
for f in "$cf_sram"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  _add_once "$f"
done

# FFT RTL: fast-fourier-transform-ip
fast_fourier_transform_ip_SKIP=""
for f in "$fast_fourier_transform_ip"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  _add_once "$f"
done

# UART RTL: opentitan-uart
for f in \
  "$opentitan_uart/uart_rx.sv" \
  "$opentitan_uart/uart_tx.sv" \
  "$opentitan_uart/uart_core.sv" \
  "$opentitan_uart/uart_reg_top.sv" \
  "$opentitan_uart/uart.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Bridge: tlul-apb-adapter
tlul_apb_adapter_SKIP="tlul_pkg.sv"
for f in "$tlul_apb_adapter"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${tlul_apb_adapter_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# IP: vyges-rv-plic-lite
vyges_rv_plic_lite_SKIP=""
for f in "$vyges_rv_plic_lite"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  _add_once "$f"
done

# IP: vyges-spi-host-lite
vyges_spi_host_lite_SKIP=""
for f in "$vyges_spi_host_lite"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  _add_once "$f"
done

# Ibex core RTL
ibex_SKIP="ibex_pkg.sv ibex_tracer.sv ibex_tracer_pkg.sv ibex_top_tracing.sv ibex_register_file_fpga.sv ibex_register_file_latch.sv"
for f in "$ibex"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${ibex_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# CPU wrapper pkg only: opentitan-rv-core-ibex
opentitan_rv_core_ibex_SKIP="rv_core_ibex_tlul.sv"
for f in "$opentitan_rv_core_ibex"/*.sv; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  echo "${opentitan_rv_core_ibex_SKIP}" | grep -qw "$base" && continue
  _add_once "$f"
done

# Generated crossbar(s)
for f in \
  "$build_dir/rtl/xbar_main.sv" \
  "$build_dir/rtl/apb_sub_bus_apb.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# Generated RTL stubs (rom, ram, host_stub — skip xbar and tops) + CPU wrapper
for f in \
  "$build_dir/rtl/tlul_host_stub.sv" \
  "$build_dir/rtl/tlul_ram.sv" \
  "$build_dir/rtl/tlul_rom.sv" \
  "$build_dir/rtl/tlul_stub.sv" \
  "$build_dir/rtl/rv_core_ibex_tlul.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# FPGA top + board wrapper
for f in \
  "$build_dir/rtl/top_edge_sensor_fpga.sv" \
  "$build_dir/rtl/top_edge_sensor_aws_f2.sv" \
; do
  [[ -f "$f" ]] && _add_once "$f"
done

# ── FPGA top + board wrapper (stubs and xbar are in compile stages above) ──
[[ -f "$RTL/top_edge_sensor_fpga.sv" ]] && FILES+=("$RTL/top_edge_sensor_fpga.sv")
[[ -f "$RTL/top_edge_sensor_aws_f2.sv" ]] && FILES+=("$RTL/top_edge_sensor_aws_f2.sv")

echo "=== sv2v (FPGA): converting ${#FILES[@]} files ==="
sv2v \
  --define=SYNTHESIS \
  -I "$opentitan_prim" \
  -I "$fast_fourier_transform_ip" \
  "${FILES[@]}" \
  -w "$OUT"

# Post-process: fix RACL struct member accesses that sv2v can't fully flatten
N="top_racl_pkg_NrRaclRoles"
sed -i "s/+:${N} + ${N}]\\.read_perm/+ ${N} +:${N}]/g" "$OUT" 2>/dev/null || true
sed -i "s/+:${N} + ${N}]\\.write_perm/+:${N}]/g" "$OUT" 2>/dev/null || true

echo "=== sv2v complete: $(wc -l < "$OUT") lines → $OUT ==="