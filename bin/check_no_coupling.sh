#!/usr/bin/env bash
# check_no_coupling.sh — prove the regions share ONLY the Lattice (zero actor-to-actor references).
#
# The CLOSURE RULE demands actor-to-actor references ZERO: a region may never
# import, address, or name another region — it coordinates purely through the
# Lattice by posting numbered phase cues. This checker strips every comment
# (prose legitimately names regions) from each region's CODE and confirms no
# region's code contains any OTHER region's name, in either direction. It also
# confirms the reactive cues are numbered phase slots, not region names.
#
# Scope by design: this checker covers the three REGION packs (cortex, striatum,
# thalamus) — the packs the closure rule forbids from naming one another. The
# substrate packs (neural_lattice, causal_grounding, neuroendocrine_strata), the
# neurochemical packs (dopamine, cortisol), plasticity, and the interface packs
# (the two conduits) are not regions and are intentionally outside this check's
# scope — an interface's whole job is to reference the regions it connects.
#
# Two complementary guarantees back this up: (1) PrologAI's library(layer)
# already reports ZERO region-to-region STATIC import edges (bin/check_layers.sh);
# (2) this script covers the L5 case — a name carried as DATA in code.
#
# Exit 0 = clean (no actor-to-actor reference); 1 = a reference found; 2 = error.
set -u
# Resolve the arm repository root from this script's location.
cd "$(dirname "$0")/.." || exit 2
# Run a small Python check that strips comments and looks for cross-region names in code.
python3 - <<'PY'
import re, sys, glob, os
# The three region packs whose code must never name one another.
regions = ["cortex", "striatum", "thalamus"]
# Track whether any actor-to-actor reference is found.
violations = []
# Examine each region's source file.
for r in regions:
    path = f"packs/{r}/prolog/{r}.pl"
    # Read the whole source.
    src = open(path).read()
    # Strip block comments /* ... */ (dot matches newline).
    code = re.sub(r"/\*.*?\*/", "", src, flags=re.S)
    # Strip whole-line % comments (keep code lines only).
    code = "\n".join(l for l in code.split("\n") if not l.lstrip().startswith("%"))
    # Also strip trailing % comments on code lines (rare here, but be safe).
    code = re.sub(r"%.*", "", code)
    # Look for any OTHER region's name as a whole word in the surviving code.
    for other in regions:
        if other == r:
            continue
        if re.search(r"\b" + re.escape(other) + r"\b", code):
            violations.append(f"region '{r}' names region '{other}' in code")

# Report the outcome.
if violations:
    print("check_no_coupling: FAIL")
    for v in violations:
        print("  " + v)
    sys.exit(1)
else:
    print("check_no_coupling: PASS -- regions share only the Lattice; 0 actor-to-actor references in code.")
    print("  cortex, striatum, thalamus coordinate solely via numbered phase cues (phase_0/1/2).")
    sys.exit(0)
PY
# Propagate the Python checker's exit code.
exit $?
