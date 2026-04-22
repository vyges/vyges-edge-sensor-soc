#!/usr/bin/env bash
# @generated — vyges-soc-generator  DO NOT EDIT
# migrate_to_chipfoundry.sh — Migrate generator output into a ChipFoundry
# caravel_user_project template clone.
#
# Usage:
#   1. Clone the ChipFoundry template:
#        git clone --depth 1 https://github.com/chipfoundry/caravel_user_project.git <dest>
#        cd <dest> && git checkout -b feat/edge_sensor
#
#   2. Run this script FROM the generator output directory:
#        bash scripts/migrate_to_chipfoundry.sh <dest>
#
#   3. On Ubuntu:
#        cd <dest> && cf setup --pdk sky130A && bash scripts/sv2v_asic.sh && bash scripts/run-librelane.sh all

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <chipfoundry-template-dir>"
  echo "  Run from the soc-generator output directory."
  exit 1
fi

SRC="$(pwd)"
DST="$(cd "$1" && pwd)"

echo "=== Migrating edge_sensor to ChipFoundry template ==="
echo "  Source: $SRC"
echo "  Dest:   $DST"
echo ""

# ── 1. Remove template example ───────────────────────────────────────────
rm -rf "$DST/openlane/user_proj_example" "$DST/verilog/rtl/user_proj_example.v"
echo "  [1/11] Removed template example"

# ── 2. Copy RTL ──────────────────────────────────────────────────────────
cp "$SRC/rtl/caravel/user_project_wrapper.v" "$DST/verilog/rtl/"
cp "$SRC/rtl/edge_sensor_glue.v" "$DST/verilog/rtl/" 2>/dev/null || true
cp -r "$SRC/pkg" "$DST/pkg"
echo "  [2/11] Copied RTL + packages"

# ── 3. Merge openlane configs (preserve template signoff.sdc, vsrc/) ─────
rsync -a "$SRC/openlane/" "$DST/openlane/"
echo "  [3/11] Merged openlane configs"

# ── 4. Copy vendored IPs + strip .git ────────────────────────────────────
rsync -a "$SRC/local-ips/" "$DST/local-ips/"
find "$DST/local-ips" -maxdepth 2 -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true
echo "  [4/11] Copied vendored IPs (0 repos)"

# ── 5. Copy scripts, tests, docs, firmware ───────────────────────────────
rsync -a "$SRC/scripts/" "$DST/scripts/"
rsync -a "$SRC/tb/" "$DST/tb/" 2>/dev/null || true
rsync -a "$SRC/docs/" "$DST/docs/" 2>/dev/null || true
rsync -a "$SRC/firmware/" "$DST/fw/" 2>/dev/null || true
echo "  [5/11] Copied scripts, tests, docs, firmware"

# ── 6. Path fixup — openlane configs ─────────────────────────────────────
find "$DST/openlane" -name "config.json" -exec python3 -c "
import sys, pathlib
p = pathlib.Path(sys.argv[1])
txt = p.read_text()
changed = False
for old, new in [
    ('build/synth/soc_conv.v', 'verilog/rtl/soc_conv.v'),
    ('build/synth/soc_fpga_conv.v', 'verilog/rtl/soc_conv.v'),
    ('rtl/caravel/user_project_wrapper.v', 'verilog/rtl/user_project_wrapper.v'),
    ('../../rtl/edge_sensor_glue.v', '../../verilog/rtl/edge_sensor_glue.v'),
]:
    if old in txt:
        txt = txt.replace(old, new)
        changed = True
if changed:
    p.write_text(txt)
" {} \;
echo "  [6/11] Patched openlane config paths"

# ── 7. CF_SRAM vendor drop ──────────────────────────────────────────────
# Each macro whose config.json references dir::cf_sram/… needs its own
# drop — dir:: is resolved relative to the macro's openlane/<name>/ dir.
# The generator emits one destination per SRAM-consumer macro (e.g. the
# bridge wrapper fft_ctrl_tlul rather than the bare FFT IP).
if [ -d "$DST/local-ips/cf-sram/gds" ]; then
  for sram_dest_name in fft_ctrl_tlul ; do
    SRAM_DEST="$DST/openlane/$sram_dest_name/cf_sram"
    mkdir -p "$SRAM_DEST"
    for d in gds lef lib hdl; do
      [ -d "$DST/local-ips/cf-sram/$d" ] && cp -r "$DST/local-ips/cf-sram/$d" "$SRAM_DEST/"
    done
    cp "$DST/local-ips/cf-sram/LICENSE" "$SRAM_DEST/" 2>/dev/null || true
    echo "  [7/11] CF_SRAM vendor drop → openlane/$sram_dest_name/cf_sram/"
  done
else
  echo "  [7/11] SKIP — cf-sram not in local-ips"
fi

# ── 8. .cf/project.json ─────────────────────────────────────────────────
mkdir -p "$DST/.cf"
cat > "$DST/.cf/project.json" << 'CFJSON'
{
  "pdk": "sky130A",
  "project": {
    "name": "edge_sensor",
    "type": "digital",
    "user": "vyges",
    "version": "1.0.0",
    "user_project_wrapper_hash": "",
    "submission_state": "Draft",
    "gpio_config": {
      "5": "13'h1808",
      "6": "13'h0402",
      "7": "13'h0402",
      "8": "13'h0402",
      "9": "13'h0402",
      "10": "13'h0402",
      "11": "13'h0402",
      "12": "13'h0402",
      "13": "13'h0402",
      "14": "13'h0402",
      "15": "13'h0402",
      "16": "13'h0402",
      "17": "13'h0402",
      "18": "13'h0402",
      "19": "13'h0402",
      "20": "13'h0402",
      "21": "13'h0402",
      "22": "13'h0402",
      "23": "13'h0402",
      "24": "13'h0402",
      "25": "13'h0402",
      "26": "13'h0402",
      "27": "13'h0402",
      "28": "13'h0402",
      "29": "13'h0402",
      "30": "13'h0402",
      "31": "13'h0402",
      "32": "13'h0402",
      "33": "13'h0402",
      "34": "13'h0402",
      "35": "13'h0402",
      "36": "13'h0402",
      "37": "13'h0402"
    }
  }
}
CFJSON
echo "  [8/11] Created .cf/project.json"

# ── 9. LVS config ───────────────────────────────────────────────────────
mkdir -p "$DST/lvs/user_project_wrapper"
cat > "$DST/lvs/user_project_wrapper/lvs_config.json" << 'LVSJSON'
{
	"TOP_SOURCE": "user_project_wrapper",
	"TOP_LAYOUT": "$TOP_SOURCE",
	"EXTRACT_FLATGLOB": [""],
	"EXTRACT_ABSTRACT": ["*__fill_*", "*__fakediode_*", "*__tapvpwrvgnd_*", "CF_SRAM_*"],
	"LVS_FLATTEN": [""],
	"LVS_NOFLATTEN": [""],
	"LVS_IGNORE": [""],
	"LVS_SPICE_FILES": [
		"$PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/spice/sky130_ef_sc_hd__decap*.spice",
		"$PDK_ROOT/$PDK/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice"
	],
	"LVS_VERILOG_FILES": [
		"$UPRJ_ROOT/verilog/gl/rv_core_ibex_tlul.v",
		"$UPRJ_ROOT/verilog/gl/uart.v",
		"$UPRJ_ROOT/verilog/gl/spi_host_lite.v",
		"$UPRJ_ROOT/verilog/gl/rv_plic_lite.v",
		"$UPRJ_ROOT/verilog/gl/fft_ctrl_tlul.v",
		"$UPRJ_ROOT/verilog/gl/xbar_main.v",
		"$UPRJ_ROOT/verilog/gl/edge_sensor_glue.v",
		"$UPRJ_ROOT/verilog/gl/user_project_wrapper.v"
	],
	"LAYOUT_FILE": "$UPRJ_ROOT/gds/$TOP_LAYOUT.gds"
}
LVSJSON
echo "  [9/11] Created LVS config (8 macros)"

# ── 10. Copy generator build/rtl + build/pkg for sv2v ────────────────────
mkdir -p "$DST/build/rtl" "$DST/build/pkg"
cp "$SRC/rtl/"*.sv "$DST/build/rtl/" 2>/dev/null || true
cp "$SRC/pkg/"*.sv "$DST/build/pkg/" 2>/dev/null || true
echo "  [10/11] Copied build/rtl + build/pkg"

# ── 11. get_designs.py ───────────────────────────────────────────────────
mkdir -p "$DST/.github/scripts"
cat > "$DST/.github/scripts/get_designs.py" << 'PYDESIGNS'
import argparse, json

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--design", help="Path to the design.")
    args = parser.parse_args()
    config_file = f"{args.design}/lvs/user_project_wrapper/lvs_config.json"
    data = json.load(open(config_file))["LVS_VERILOG_FILES"]
    f = open("harden_sequence.txt", "w")
    for d in data:
        macro_name = d.split("/")[-1].split(".v")[0]
        if macro_name.startswith("$"):
            macro_name = "user_project_wrapper"
        f.write(f"{macro_name} ")
    f.close()

if __name__ == "__main__":
    main()
PYDESIGNS
echo "  [11/11] Created get_designs.py"

echo ""
echo "=== Migration complete ==="
echo ""
echo "To build on Ubuntu (prerequisites: sv2v + podman installed):"
echo ""
echo "  cd $DST"
echo "  cf setup --pdk sky130A                        # installs PDK + LibreLane"
echo "  bash scripts/sv2v_asic.sh                     # produces verilog/rtl/soc_conv.v"
echo "  bash scripts/run-librelane.sh all              # hardens all 8 macros"
echo ""
echo "  (.cf/project.json already generated — no cf login/init needed)"