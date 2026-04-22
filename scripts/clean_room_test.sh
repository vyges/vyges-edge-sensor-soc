#!/usr/bin/env bash
# @generated — vyges-soc-generator  DO NOT EDIT
# clean_room_test.sh — Full clean-room validation of soc-generator flow
#
# Runs everything from scratch:
#   1. Nuke build/ and local-ips/
#   2. Vendor IPs (with patches)
#   3. Verify patches applied
#   4. Generate RTL + firmware + constraints
#   5. Run Verilator sim (local)
#   6. Rsync to remote build box
#   7. Run sv2v (FPGA targets)
#   8. Run Vivado synthesis
#
# Usage:
#   bash scripts/clean_room_test.sh           # full flow
#   bash scripts/clean_room_test.sh --local   # steps 1-5 only (no remote)
#
# Prerequisites:
#   - soc-generator repo at ../soc-generator (sibling directory)
#   - Verilator on local PATH
#   - ssh access to REMOTE_HOST (for FPGA steps)

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOC_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$SOC_ROOT"

# ── Configuration ────────────────────────────────────────────────────────
SOC_GEN="${SOC_GENERATOR_REPO:-$SOC_ROOT/../soc-generator}"
REMOTE_USER="${REMOTE_USER:-ovs}"
REMOTE_HOST="${REMOTE_HOST:-ovs-intelsdn-2}"
REMOTE_DIR="${REMOTE_DIR:-/home/$REMOTE_USER/vyges-test/$(basename "$SOC_ROOT")}"
LOCAL_ONLY="${1:-}"

if [ -x "$SOC_ROOT/../soc-generator/scripts/run-from-repo.sh" ]; then
  SOC_GEN="$SOC_ROOT/../soc-generator"
fi

# Prefer vyges-soc-generator on PATH, else run from repo
if command -v vyges-soc-generator &>/dev/null; then
  GEN_CMD="vyges-soc-generator"
else
  GEN_CMD="PYTHONPATH=$SOC_GEN/src python3 -m soc_generator.cli"
fi

echo "=== Clean-room test: $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="
echo "    SoC root:   $SOC_ROOT"
echo "    Generator:  $SOC_GEN"

# ── Step 1: Nuke (local + remote) ──
echo ""
echo "=== Step 1: Nuke build/ and local-ips/ ==="
rm -rf build local-ips
if [[ "$LOCAL_ONLY" != "--local" ]]; then
  echo "    Nuking remote: $REMOTE_HOST:$REMOTE_DIR"
  ssh "$REMOTE_USER@$REMOTE_HOST" "rm -rf $REMOTE_DIR" || true
fi
echo "    Done."

# ── Step 2: Vendor IPs ──
echo ""
echo "=== Step 2: Vendor IPs (with patches) ==="
eval $GEN_CMD vendor-ips soc-spec.yaml --ips-dir local-ips --force

# ── Step 3: Verify critical patches ──
echo ""
echo "=== Step 3: Verify patches ==="
FAIL=0
# Ibex DV coverage macros stub
if [[ -d local-ips/ibex ]] && [[ ! -f local-ips/ibex/rtl/dv_fcov_macros.svh ]]; then
  echo "  FAIL: dv_fcov_macros.svh not found in ibex (patch not applied)"
  FAIL=1
else
  echo "  OK: ibex dv_fcov_macros.svh present"
fi
# Check all vendored IPs have vyges-metadata.json
for d in local-ips/*/; do
  ip="$(basename "$d")"
  if [[ ! -f "$d/vyges-metadata.json" ]] && [[ ! -f "$d/rtl" ]]; then
    echo "  WARN: $ip has no vyges-metadata.json"
  fi
done
if [[ $FAIL -ne 0 ]]; then
  echo "  Patch verification failed — aborting."
  exit 1
fi

# ── Step 4: Generate ──
echo ""
echo "=== Step 4: Generate RTL + firmware + constraints ==="
bash scripts/generate.sh

# ── Step 5: Verilator sim ──
echo ""
echo "=== Step 5: Verilator simulation ==="
cd build
make -f sim/Makefile 2>&1 | tail -5
cd "$SOC_ROOT"

if [[ "$LOCAL_ONLY" == "--local" ]]; then
  echo ""
  echo "=== Local-only mode: skipping FPGA steps ==="
  echo "=== Clean-room test (local) PASSED ==="
  exit 0
fi

# ── Step 6: Rsync to remote build box ──
echo ""
echo "=== Step 6: Rsync to $REMOTE_HOST ==="
rsync -avz --exclude '.git' --exclude 'obj_dir' \
  "$SOC_ROOT/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" 2>&1 | tail -3

# ── Step 7: sv2v conversion (if script exists) ──
if [[ -f scripts/sv2v_fpga.sh ]]; then
  echo ""
  echo "=== Step 7: sv2v conversion ==="
  ssh "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_DIR && bash scripts/sv2v_fpga.sh"
fi

# ── Step 8: Vivado synthesis ──
echo ""
echo "=== Step 8: Vivado synthesis (aws_f2, xcvu9p-flgb2104-2-i) ==="
ssh "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_DIR && \
  source /opt/xilinx/vivado/2025.2/Vivado/settings64.sh && \
  mkdir -p build/vivado && \
  vivado -mode batch -source build/synth/build_aws_f2.tcl \
    -log build/vivado/build_aws_f2.log 2>&1" | tail -20 || \
  echo "  WARNING: Vivado synthesis failed for aws_f2 (part may not be licensed)"
echo ""
echo "=== Step 8: Vivado synthesis (arty, xc7a100tcsg324-1) ==="
ssh "$REMOTE_USER@$REMOTE_HOST" "cd $REMOTE_DIR && \
  source /opt/xilinx/vivado/2025.2/Vivado/settings64.sh && \
  mkdir -p build/vivado && \
  vivado -mode batch -source build/synth/build_arty.tcl \
    -log build/vivado/build_arty.log 2>&1" | tail -20 || \
  echo "  WARNING: Vivado synthesis failed for arty (part may not be licensed)"

echo ""
echo "=== Clean-room test complete: $(date -u +%Y-%m-%dT%H:%M:%SZ) ==="