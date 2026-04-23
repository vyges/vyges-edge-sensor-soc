#!/usr/bin/env bash
# @generated — vyges-soc-generator  DO NOT EDIT
# splice_boot_rom.sh — Replace the boot ROM in an already-built edge_sensor
# bitstream WITHOUT re-running Vivado synthesis + implementation.
#
# Use case: firmware-only iteration. Typical Vivado full rebuild is 6-10 min;
# splice is seconds.
#
# Usage:
#   bash scripts/splice_boot_rom.sh [new_boot_rom.hex] [output.bit]
#
# Defaults:
#   new_boot_rom.hex = ./boot_rom.hex  (same file $readmemh reads at synth)
#   output.bit       = build/vivado/top_edge_sensor_arty_spliced.bit
#
# Prerequisites:
#   1. Run a full Vivado build once: produces .bit + .mmi under build/vivado/
#      (build_vivado.tcl.j2 emits the .mmi via write_mem_info).
#   2. Vivado on PATH (source settings64.sh). updatemem ships with Vivado.
#   3. A valid boot_rom.hex built from firmware/ (runs firmware/Makefile).
#
# Notes:
#   - The RTL attribute (* keep = "true" *) on boot_rom in rv_core_ibex_tlul.sv
#     is what allows updatemem to find the BRAM at splice time.
#   - If updatemem complains "no BRAM matches", run a fresh full build so the
#     .mmi is re-generated against the current netlist.

set -euo pipefail

SCRIPT_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -P "$SCRIPT_DIR/.." && pwd)"

NEW_HEX="${1:-$REPO_ROOT/boot_rom.hex}"
OUT_BIT="${2:-$REPO_ROOT/build/vivado/top_edge_sensor_arty_spliced.bit}"

IN_BIT="$REPO_ROOT/build/vivado/top_edge_sensor_arty.bit"
MMI_FILE="$REPO_ROOT/build/vivado/top_edge_sensor_arty.mmi"

for f in "$IN_BIT" "$MMI_FILE" "$NEW_HEX"; do
    if [ ! -f "$f" ]; then
        echo "ERROR: required file missing: $f" >&2
        exit 2
    fi
done

if ! command -v updatemem >/dev/null 2>&1; then
    echo "ERROR: updatemem not on PATH. Source Vivado settings64.sh first." >&2
    exit 2
fi

echo "=== Splicing new boot_rom into bitstream ==="
echo "  Input .bit:  $IN_BIT"
echo "  MMI:         $MMI_FILE"
echo "  New hex:     $NEW_HEX"
echo "  Output .bit: $OUT_BIT"

# updatemem replaces the BRAM contents described by the .mmi with the new hex.
# When -proc is omitted, updatemem uses the only BRAM group in the .mmi.
# For our SoC the boot_rom is the only `$readmemh`-initialized array, so
# this just works — but if multiple BRAMs exist, you'd need -proc <name>.
updatemem \
    -meminfo "$MMI_FILE" \
    -data    "$NEW_HEX" \
    -bit     "$IN_BIT" \
    -out     "$OUT_BIT" \
    -force

if [ ! -f "$OUT_BIT" ]; then
    echo "ERROR: updatemem produced no output" >&2
    exit 1
fi

echo ""
echo "=== Spliced bitstream ready ==="
echo "  $OUT_BIT"
echo ""
echo "Flash:"
echo "  openFPGALoader -b arty_a7_100t $OUT_BIT"