#!/usr/bin/env bash
# Verify SLEIGH consistency invariants that were broken before the June 2026 fix:
#   1. BC/BNC must read CBR (not the $(C) bitfield) so the decompiler can track conditions
#   2. Every macro that sets $(C) must also set CBR on the next logical line
set -e

SINC="data/languages/m32r.sinc"

if [ ! -f "$SINC" ]; then
    echo "ERROR: $SINC not found (run from repo root)"
    exit 1
fi

fail=0

# Check 1: BC/BNC must not use $(C) in branch condition
if grep -nE '^\s*if \(\$\(C\)' "$SINC"; then
    echo "FAIL: BC/BNC still test \$(C) instead of CBR"
    fail=1
fi

# Check 2: every assignment to $(C) must be followed by CBR = ... within 3 lines
python3 - "$SINC" <<'EOF'
import sys, re

path = sys.argv[1]
lines = open(path).readlines()
set_c = re.compile(r'\$\(C\)\s*=')
set_cbr = re.compile(r'\bCBR\s*=')

for i, line in enumerate(lines):
    if set_c.search(line):
        window = lines[i:i+4]
        if not any(set_cbr.search(w) for w in window):
            print(f"{path}:{i+1}: sets $(C) but CBR not set within 3 lines")
            sys.exit(1)

print("check-sleigh: all invariants OK")
EOF

exit $fail
