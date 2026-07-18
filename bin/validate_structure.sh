#!/usr/bin/env bash
# validate_structure.sh — validate the arm's Causalontology 2.0.0 structure records.
#
# Assembles the library path over the arm packs plus the PrologAI packs and
# conformance-harness directory the arm REUSES UNMODIFIED (causal_core = the
# 2.0.0 engine; schema_check/signing/ed25519 = the additive conformance layers).
# Because the atomic arm co-locates each region's continuant record WITH its
# runtime, the validator imports the region packs, which import library(lattice);
# so — unlike the slice — the Lattice pack must be on the path too (a measured
# consequence, recorded in the Ledger). The schema/ directory is resolved by
# schema_check.pl relative to its own source, so validation reads the exact
# vendored 2.0.0 schemas regardless of the working directory. Exit 0 iff every
# record is valid and the skip finding and signature check pass.
set -u
# Resolve the arm repository root from this script's location.
cd "$(dirname "$0")/.." || exit 2
# Resolve the PrologAI checkout (honour PROLOGAI_HOME, else the local default).
PROLOGAI_HOME="${PROLOGAI_HOME:-/home/ccaitwo/PrologAI}"
# The conformance harness directory holding schema_check.pl, signing.pl, ed25519.pl, schema/.
HARNESS="$PROLOGAI_HOME/tests/causalontology_conformance"
# Confirm the harness exists before building the library path.
if [ ! -f "$HARNESS/schema_check.pl" ]; then
  # Report the missing dependency and stop.
  echo "validate_structure.sh: cannot find the conformance harness at $HARNESS (set PROLOGAI_HOME)" >&2
  exit 2
fi
# Start the library path with every arm pack's prolog directory.
LIB=""
for d in packs/*/prolog; do LIB="$LIB -p library=$d"; done
# Add PrologAI's causal_core engine pack (the 2.0.0 vocabulary).
LIB="$LIB -p library=$PROLOGAI_HOME/packs/causal_core/prolog"
# Add PrologAI's Lattice pack — the region packs (which carry structure records) import it.
LIB="$LIB -p library=$PROLOGAI_HOME/packs/lattice/prolog"
# Add the conformance harness directory so library(schema_check|signing|ed25519) resolve.
LIB="$LIB -p library=$HARNESS"
# Ensure the structure artifact directory exists.
mkdir -p structure
# Run the validator; its initialization goal validates every record and halts with the verdict code.
swipl -q $LIB bin/validate_structure.pl
# Propagate the validator's exit code (0 = all records valid).
exit $?
