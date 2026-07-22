# connectome-atomic — one pack per named construct (Wave 3a control)

**THE DELIVERABLE IS THE FINDING, NOT THE CODE.**

This repository is the **control arm** of the Wave 3 granularity experiment (see
`WAVE_3_DESIGN_v1.txt`). Its one-sentence purpose: **to measure the decomposition
rule "one pack per named construct," and to surface what building the identical
anatomy at maximal granularity reveals PrologAI still lacks.** The walls it hit
live in [`LEDGER.md`](LEDGER.md); the side-by-side measurement lives in
[`COMPARISON.md`](COMPARISON.md). Those two files, not this code, are the product.

## What this is (and is not)

It is **not a new slice.** It is the SAME Wave 2 vertical slice
(`connectome-proto-agi`), carved a different way. The ONE variable Wave 3 tests
is **how big a code-pack should be**; this arm's answer is the maximal one — if a
construct is named in the slice, it gets its own pack.

Everything else is held constant and PROVEN so:

- **The behaviour** — the cortico-basal-ganglia-thalamo-cortical loop closing for
  N laps, same verdict (3N+1 hops, a strictly monotonic token, the region
  sequence cortex then N×[striatum, thalamus, cortex], the cortex re-entering N
  times). The narrated trace is **byte-identical** to the slice (verified by
  `diff`).
- **The data layer** — the SAME twenty-eight Causalontology 3.0.0 records, same
  ids, same content, here MINTED by the distributed construct packs and proven
  **byte-identical** to the slice's `structure/` by regenerating and `diff`-ing.
- **The dynamics** — the same dopamine RPE, cortisol suppression, and three-factor
  plasticity math, reused verbatim.
- **The closure mechanism** — stigmergy for state (zero actor-to-actor
  references) plus notification for reactivity (`lattice_await`/`lattice_notify`,
  no busy-poll), narrated in glass-box style.
- **The platform** — PrologAI reused UNMODIFIED, read-only. Every gap is a Ledger
  entry, never a commit. Mentova and the frozen spike are untouched.

Only the **pack boundaries** move.

## The decomposition — one pack per named construct

Eleven packs carve the identical anatomy:

```
packs/neural_lattice/          layer 0  closure substrate (stigmergy + await/notify)   [shared infra]
packs/causal_grounding/        layer 0  the shared Causalontology minting vocabulary    [shared infra]
packs/neuroendocrine_strata/   layer 1  the five-stratum ladder                         [shared infra]
packs/dopamine/                layer 2  the RPE neurotransmitter + its structure records
packs/cortisol/                layer 2  the layer-skipping hormone + its skip/token/assertion
packs/plasticity/              layer 3  the three-factor rule + the corticostriatal transform
packs/cortex/                  layer 4  region: origin/re-entry + continuant/occurrent/bridge
packs/striatum/                layer 4  region: dopamine-gated plasticity + continuant/realizable
packs/thalamus/                layer 4  region: the relay that closes the loop + continuant
packs/corticostriatal_conduit/ layer 5  interface: the computational projection, its ports + transform
packs/nigrostriatal_conduit/   layer 5  interface: the transmissive dopamine projection + its ports
```

Three of the eleven are deliberate **shared-infrastructure** decisions (recorded
in `COMPARISON.md`): the closure substrate and the minting VOCABULARY are kept
whole (splitting them is duplication, not granularity), and the stratum LADDER is
kept as one pack because splitting it per stratum is arm 3c's defining move. The
other eight are genuine anatomical constructs, one pack each.

## How to run it

Everything reuses a local PrologAI checkout **unmodified** (default
`/home/ccaitwo/PrologAI`; override with `PROLOGAI_HOME`). SWI-Prolog 9.x required.

```bash
# 1. Tick the reentrant loop and print the narrated, glass-box trace (exit 0 on a proven close).
bin/run_slice.sh 8 5 0.4        #  <laps> <cortisol_event_lap> <learning_rate>

# 2. Run PrologAI's UNMODIFIED layer construct against the arm's 11 packs (exit 0 = no upward edge).
bin/check_layers.sh

# 3. Prove the regions share only the Lattice — zero actor-to-actor references (exit 0 = clean).
#    (Scope by design: the three REGION packs — cortex, striatum, thalamus; the substrate,
#     neurochemical, plasticity and interface packs are not regions and are out of scope.)
bin/check_no_coupling.sh

# 4. Validate every minted Causalontology 3.0.0 structure record + the skip finding + the signature.
#    (bin/validate_structure.sh is the wrapper; it runs the validator implemented in
#     bin/validate_structure.pl — one validator, two filenames.)
bin/validate_structure.sh

# 5. Run every pack's in-pack PLUnit suite.
bin/run_tests.sh
```

## How to read the narration

Each line of the trace is one hop of the beat through the Lattice — identical in
form to the slice:

```
    hop 14  via lattice  striatum  token=14
      striatum: reward=1.00 prediction=0.6400 dopamine(RPE)=0.3600 cortisol=0.000 weight 0.6400 -> 0.7840
    hop 15  via lattice  thalamus  token=15
```

- `via lattice` on **every** hop is the point: the beat always arrives through
  the shared Lattice, never from a named sender. The reentrant thalamus→cortex
  return is just another `via lattice` hop — the upward edge exists only at
  runtime.
- `token=N` increases by exactly 1 every hop. At the end the runner checks the
  token ran 1..3N+1, the region sequence was `cortex` then N×`[striatum, thalamus,
  cortex]`, and the cortex re-entered N times.
- Watch **dopamine(RPE)** fall from 1.0 toward 0 as the cortex's prediction rises
  to meet the reward. At the cortisol event lap a one-line banner marks the
  ten-stratum skip; afterward the weight barely moves despite ongoing reward.

## Status

The loop closes for N laps with a byte-identical trace to the slice; zero
actor-to-actor references and no busy-poll; every pack declares a layer and the
layer checker passes with zero upward edges (six levels, 0–5); all 28 minted
records validate against the Causalontology 3.0.0 schemas and are byte-identical
to the slice's; the mini regression is green (ARC-AGI-1 40/40, ARC-AGI-2 12/12 —
a 10 percent spot-check; full regression deferred); PrologAI, Mentova, and the
frozen spike are unmodified. See [`LEDGER.md`](LEDGER.md) for the seven findings
and [`COMPARISON.md`](COMPARISON.md) for the rubric — the reason this repository
exists.

## Boundaries (what this arm must not become)

Not a new slice, not the full 140-construct connectome (it replicates the SLICE
and PROJECTS to scale), not a modification of PrologAI (a gap is a Ledger entry,
not a commit), the frozen spike, or Mentova. It is the slice, carved at maximal
granularity — one arm of a three-arm comparison whose verdict comes after
connectome-loops (3b) and connectome-strata (3c) are built.
