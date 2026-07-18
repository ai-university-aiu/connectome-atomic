# LEDGER — what one-pack-per-construct found PrologAI still lacks

**This Ledger is the deliverable.** connectome-atomic is the CONTROL arm of the
Wave 3 granularity experiment (see `WAVE_3_DESIGN_v1.txt`). It re-decomposes the
Wave 2 slice under one rule — **one pack per named construct** — holding the
behaviour, the twenty-eight Causalontology 2.0.0 records, the dynamics, and the
closure mechanism constant. Every entry below is a wall the arm hit while
carving the identical anatomy at maximal granularity.

## Identifier scheme

Entries use a fresh **ATOMIC-series (ATOMIC-1, ATOMIC-2, …)**, so a finding here
can never be confused with:

- the frozen spike's **L1–L9** (`/home/ccaitwo/prologai-loops/LEDGER.md`),
- PrologAI's living **L-series and N1–N5** (`/home/ccaitwo/PrologAI/LEDGER.md`),
- the Wave 2 slice's **P1–P10** (`/home/ccaitwo/connectome-proto-agi/LEDGER.md`),
- and, later, the loops arm's **LOOPS-*** and the strata arm's **STRATA-***.

Where a finding is a second sighting of an existing gap, it says so and cites
the parent by its own id rather than minting a rival number. Severity `S` uses
the spike's H/M/L scale.

## Where the findings cluster

As the design predicted for the maximal-granularity arm, the findings cluster on
**packaging and dependency management**: with the most packs of the three arms
(eleven, against the slice's six), every cross-construct reference that lived
*inside* the slice's `causal_map` or `neurochemistry` pack becomes an *inter-pack
import*. Four new gaps (ATOMIC-1 … ATOMIC-4) are all facets of one theme —
**PrologAI has one kind of dependency (a `use_module` import) and no way to say
what KIND of dependency it is** (structure-only, aggregate, a bare id, or one
face of a co-located construct). The remaining three (ATOMIC-5 … ATOMIC-7) are
second sightings of the layer construct's limits (P5, P6, P7), re-hit harder
because this arm has the most packs and the tallest layer stack.

---

### ATOMIC-1 — a STRUCTURE-only cross-pack reference cannot be distinguished from a runtime dependency · S=M

- **Construct that forced it.** The action-selection BRIDGE (a cross-stratal
  Causalontology record owned by the cortex).
- **What PrologAI could not express.** The bridge says "action-selection realises
  the finer neurotransmitter events," so it must reference dopamine's release
  occurrents. Under one-pack-per-construct that forces the cortex pack to
  `use_module(library(dopamine))` — but the cortex's RUNTIME (`cortex_tick`)
  never calls dopamine; the import exists only to mint one structure record.
  PrologAI has a single dependency primitive (the import) and no way to declare a
  dependency as STRUCTURE-ONLY (needed to build a record, not to run behaviour).
  The layer graph and the import fan-out are therefore inflated by references the
  behaviour does not need, and a reader cannot tell a load-bearing runtime edge
  from a mint-time-only one.
- **Evidence.** `packs/cortex/prolog/cortex.pl` imports `library(dopamine)` and
  uses it only in `cortex_bridge/1`; `cortex_tick/1` never mentions dopamine.
- **Proposed remedy (minimum).** A dependency ANNOTATION distinguishing a
  structure-only (mint-time) import from a runtime import — so tooling, the layer
  report, and a reader can separate the behavioural graph from the grounding
  graph.
- **Parents.** New. A packaging gap the slice never hit (its structure lived in
  one `causal_map` pack that no region imported).

### ATOMIC-2 — no dependency-AGGREGATION construct: a consumer must enumerate every fine-grained pack · S=M

- **Construct that forced it.** The STRIATUM's tick, now reading three separately
  packaged neurochemicals.
- **What PrologAI could not express.** In the slice the striatum imported ONE
  `neurochemistry` pack. Atomised, the same tick imports THREE — `dopamine` (the
  RPE), `cortisol` (its tone), and `plasticity` (the three-factor update) —
  because each neurochemical is its own pack. There is no PrologAI construct for
  a dependency BUNDLE or a re-export facade ("the neurochemistry a striatum
  needs") that would let a consumer depend on a coherent group while the group's
  members stay individually packaged. Every consumer must therefore name every
  fine-grained dependency, and the import list grows one line per atomised
  construct it touches.
- **Evidence.** `packs/striatum/prolog/striatum.pl` imports `library(dopamine)`,
  `library(cortisol)`, and `library(plasticity)` where the slice's striatum
  imported only `library(neurochemistry)`.
- **Proposed remedy (minimum).** A pack GROUP / facade construct — one importable
  name that re-exports a declared set of packs — so atomic granularity does not
  force every consumer to track the decomposition of its dependencies.
- **Parents.** New. The direct cost of maximal granularity on the consumer side.

### ATOMIC-3 — no cross-pack RECORD/ID registry: content-addressed ids are threaded by hand-exported accessors · S=M

- **Construct that forced it.** The two CONDUITS, whose records reference ports,
  continuants, occurrents and a transform owned by other packs.
- **What PrologAI could not express.** A conduit record names the endpoint ports
  (built from region continuants) and, if computational, a transform CRO. With
  minting distributed one-per-construct, the only way for the conduit pack to
  obtain those content-addressed ids is to import each owning pack and call a
  hand-written accessor predicate it exported (`cortex_continuant/1`,
  `plasticity_transform_cro/1`, …). PrologAI/Causalontology offers no cross-pack
  RECORD REGISTRY keyed by record name, so every grounded pack must publish
  bespoke id accessors and every downstream pack must import them. The coupling
  concentrates at the interfaces: `corticostriatal_conduit` imports three other
  packs solely to read ids.
- **Evidence.** `packs/corticostriatal_conduit/prolog/corticostriatal_conduit.pl`
  imports `library(cortex)`, `library(striatum)`, `library(plasticity)` and calls
  their exported accessors to assemble its port and conduit records.
- **Proposed remedy (minimum).** A record REGISTRY (resolve a record by a stable
  logical name to its content-addressed id) so a construct can reference another's
  record without importing its module and depending on a bespoke accessor.
- **Parents.** New. Sibling of ATOMIC-2 on the grounding side.

### ATOMIC-4 — co-locating a construct's structure with its runtime fuses the two dependency faces · S=L

- **Construct that forced it.** The REGION packs, each owning both a runtime tick
  and a continuant record.
- **What PrologAI could not express.** The atomic stance co-locates everything
  about a construct in one pack — so a region pack has a RUNTIME face (imports
  `neural_lattice` → `library(lattice)`) and a STRUCTURE face (imports the
  grounding engine). PrologAI can load a pack, but not ONE FACE of it. The two
  consequences are mirror images: validating STRUCTURE now drags in the whole
  runtime substrate (the validator must put `library(lattice)` on its path,
  because it imports the region packs), and running the pure BEHAVIOUR now drags
  in the grounding engine (the runner must put `causal_core` and the signing
  harness on its path, because the regions it loads import the minting vocabulary).
  Neither was true in the slice, where structure (`causal_map`) and runtime
  (`neurochemistry`, regions) were separate packs with disjoint dependencies.
- **Evidence.** `bin/validate_structure.sh` must add `library(lattice)` (the
  slice's did not); `bin/run_slice.sh` must add `causal_core` and the conformance
  harness (the slice's did not) — see the ATOMIC-5 comment block in each script.
- **Proposed remedy (minimum).** A notion of a pack FACE (a loadable slice of a
  pack's exports and their transitive deps) so a co-located construct can be
  loaded for structure OR for runtime without pulling the other face's engine.
- **Parents.** New. The load-time face of the atomic co-location theme; siblings
  ATOMIC-1..3 are its declaration-time faces.

### ATOMIC-5 — the layer construct's entry point still cannot be pointed at an external packs dir (P5, second sighting) · S=L

- **Construct that forced it.** The LAYER construct, now under its heaviest user
  (eleven packs).
- **What PrologAI could not express.** Exactly the slice's **P5**: PrologAI's own
  `bin/check_layers.sh` is hard-wired to its own packs, so this arm had to write
  its own wrapper calling the reusable `layer_report_dir/1` + `layer_check_dir/2`.
  With eleven packs the arm exercises the construct harder, and re-confirms the
  wrapper duplication P5 named. This is a **second sighting, not a new gap.**
- **Evidence.** `bin/check_layers.sh` (this repo) reimplements the wrapper the
  slice already had to write.
- **Parents.** Confirms **P5** (Wave 2 slice; still open in PrologAI).

### ATOMIC-6 — the layer graph cannot see the PrologAI packs the arm sits on (P6, second sighting) · S=M

- **Construct that forced it.** The LAYER construct spanning two repos, with the
  most cross-repo imports of any arm so far.
- **What PrologAI could not express.** Exactly the slice's **P6**: every atomic
  pack imports PrologAI packs (`library(lattice)`, `library(causal_core)`,
  `library(actors)`), but the layer scan builds its owner map only from the arm's
  own `packs/` dir, so those cross-repo edges are invisible — the layer report
  lists eleven packs and none of the PrologAI packs beneath them. With more packs
  importing more external libraries, this arm has MORE invisible edges than the
  slice, re-confirming P6. **Second sighting.**
- **Evidence.** `bin/check_layers.sh` reports exactly the eleven arm packs; the
  PrologAI packs every one of them depends on never appear.
- **Parents.** Confirms **P6** (Wave 2 slice; a facet of L4 / N3).

### ATOMIC-7 — layer NUMBERS are a per-repo namespace with no global coordinate (P7, second sighting) · S=L

- **Construct that forced it.** The LAYER construct's integers, across arms.
- **What PrologAI could not express.** Exactly the slice's **P7**, sharpened: the
  atomic arm's stack is SIX levels (0–5), the slice's was five (0–4), and PrologAI
  declares layers into the hundreds. "Atomic layer 5" (an interface conduit),
  "slice layer 4" (the cortex), and any PrologAI layer are unrelated integers in
  different namespaces. The granularity experiment makes this concrete: each arm
  invents its own layer scale, and nothing reconciles them — so the three arms'
  layer numbers cannot even be compared to one another, let alone to PrologAI's.
  **Second sighting.**
- **Evidence.** `bin/check_layers.sh` reports arm layers 0–5; the slice reported
  0–4; the two scales share no coordinate.
- **Parents.** Confirms **P7** (Wave 2 slice; related to P6, a facet of L4 / N3).

---

## What did NOT become a finding (honesty)

- The behaviour held EXACTLY. The narrated trace is byte-identical to the slice's
  (same hops, tokens, weights, dopamine decay, cortisol event) — proven by a
  direct `diff`. Carving the code a new way changed nothing the loop does.
- The twenty-eight records are byte-identical to the slice's, proven by
  regenerating `structure/` from the distributed packs and `diff`-ing against the
  slice's records: every content-addressed id matched. Distributing the minting
  across nine packs cost the DATA nothing — a strong result for the
  content-addressed identity model, and evidence that the grounding engine
  (WP-425) is decomposition-agnostic.
- The layer rule fell out cleanly: zero violations, zero awkward placements, a
  six-level stack the anatomy dictated. The strict layer rule scaled to the
  most packs of any arm without friction.

This Ledger is not thin: seven entries, four of them new packaging/dependency
gaps that ONLY a high pack count surfaces, and three second sightings of the
layer construct's known limits — exactly the profile the design predicted for
the maximal-granularity control arm. The full side-by-side measurement is in
[`COMPARISON.md`](COMPARISON.md).
