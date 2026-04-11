#!/usr/bin/env bash
#
# Run one SoC-level cocotb + Verilator integration test and return a
# verdict from the resulting results.xml, not from `make`'s exit code.
#
# Rationale
# ---------
# cocotb 1.9.2 + Verilator 5.020 can return non-zero from `make` even
# when every testsuite in results.xml reports failures=0 errors=0
# (VCD trace-close path around the VPI-injected $finish on some
# Ubuntu GHA runners). results.xml is the authoritative verdict:
#
#   - results.xml missing entirely  → the sim never produced a verdict;
#                                     treat as failure (preserves make's
#                                     exit code in the error message).
#   - failures>0 or errors>0        → real test failure; fail the step
#                                     and dump the XML for diagnosis.
#   - failures=0 errors=0           → pass, regardless of make rc.
#
# Usage: run_cocotb_test.sh <test-dir> <test-name>

set -u

if [ "$#" -ne 2 ]; then
    echo "usage: $0 <test-dir> <test-name>" >&2
    exit 2
fi

test_dir="$1"
test_name="$2"

cd "${test_dir}"

# Capture make's exit code without letting it fail the script under -e.
set +e
make
make_rc=$?
set -e

if [ ! -f results.xml ]; then
    echo "::error::${test_name}: results.xml not generated (make rc=${make_rc}); simulation did not produce a verdict"
    exit 1
fi

failures=$(xmllint --xpath 'string(//testsuite/@failures)' results.xml 2>/dev/null)
errors=$(xmllint   --xpath 'string(//testsuite/@errors)'   results.xml 2>/dev/null)

# Treat missing attributes as 0 (older cocotb xml schemas omit when none).
: "${failures:=0}"
: "${errors:=0}"

if [ "${failures}" != "0" ] || [ "${errors}" != "0" ]; then
    echo "::error::${test_name}: test failed — failures=${failures} errors=${errors} (make rc=${make_rc})"
    echo "--- results.xml ---"
    cat results.xml
    exit 1
fi

echo "${test_name}: passed (failures=0 errors=0; make rc=${make_rc})"
