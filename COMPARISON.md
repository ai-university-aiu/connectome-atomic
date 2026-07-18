# COMPARISON — connectome-atomic (Wave 3a, the control arm)

The Wave 3 granularity experiment tests ONE variable: **how big should a
code-pack be?** This arm's answer is **one pack per named construct** — the
maximal-granularity control. Every number below is argued from the built code,
so the three arms can be laid side by side by a later Wave 3 verdict. The
invariant (behaviour, the twenty-eight records, the dynamics, the closure
mechanism, the platform) was held constant and is proven so: the narrated trace
and all twenty-eight structure records are byte-identical to the Wave 2 slice.

## Rubric at a glance

| # | Rubric question | connectome-atomic (this arm) |
|---|---|---|
| 1 | Pack count (slice / projected to 140) | **11** / **~143** (140 constructs + 3 fixed substrate) |
| 2 | Change locality (retune dopamine) | **1 pack**, fully isolated — best possible |
| 3 | Coupling (intra-repo import edges) | **29 edges / 11 packs** (2.6/pack) vs slice 5/6 (0.83/pack) — grew 5.8× while packs grew 1.8× |
| 4 | Layer-rule pressure | 6 levels (0–5) fell out cleanly; **0 violations, 0 awkward placements**; but 11 layer declarations |
| 5 | Testability (one construct in isolation) | Dynamics isolate perfectly; grounded/runtime constructs drag in substrate only |
| 6 | Grounding fit (boundary vs Causalontology kinds) | **Low by design** — construct packs cut across kinds (orthogonal cuts) |
| 7 | Ergonomics / new gaps | 4 new packaging gaps (ATOMIC-1…4) + 3 layer second sightings (P5/P6/P7) |
| 8 | Scale verdict | Best change-locality; per-pack ceremony and interface coupling hurt first at 140 |

## 1. Pack count

**Actual at the slice: 11 packs.** Three shared substrate — `neural_lattice`
(closure), `causal_grounding` (the minting vocabulary), `neuroendocrine_strata`
(the stratum ladder); two neurochemicals — `dopamine`, `cortisol`; one
computation — `plasticity`; three regions — `cortex`, `striatum`, `thalamus`;
two interfaces — `corticostriatal_conduit`, `nigrostriatal_conduit`. The slice
did the same anatomy in 6 packs, so atomic granularity nearly doubled the count.

**Two deliberate shared-infrastructure decisions** (the order asked for these to
be decided and recorded): the closure substrate and the MINTING VOCABULARY are
kept whole (splitting `cm_id`/`cm_stratum`/… per construct would be duplication,
not granularity), and the five-stratum LADDER is kept as one pack because
splitting it per stratum is precisely arm 3c's (connectome-strata) defining move.
Everything that is genuinely a distinct anatomical construct — every region,
neurochemical, computation, and interface — got its own pack.

**Projected to 140 constructs: ~143 packs.** Reasoning: the connectome names
~140 constructs (regions, neurochemicals, hormones, conduits, port groups …) and
atomic assigns one pack each → ~140. The three fixed substrate packs
(closure, minting vocabulary, stratum ladder) do NOT scale with construct count,
so they add a constant ~3. The projection is linear in constructs: this is the
control arm precisely because its pack count IS the construct count.

## 2. Change locality — retune dopamine

**One pack, fully isolated.** Dopamine's reward schedule and RPE law live only in
`packs/dopamine/prolog/dopamine.pl`. Editing it touches nothing else: cortisol,
plasticity, and the regions are separate files. This is the best change locality
of any decomposition — the blast radius of a construct edit is exactly that
construct's pack. In the slice, the same retune edits `neurochemistry`, a file
that also holds cortisol and the plasticity rule, so the edit shares a file with
unrelated dynamics. **Atomic's headline win is here.**

## 3. Coupling and how it grows

Measured intra-repo import edges (a `use_module(library(X))` where X is another
arm pack):

```
causal_grounding        0        cortex                  4
neural_lattice          0        thalamus                4
neuroendocrine_strata   1        corticostriatal_conduit 4
dopamine                2        striatum                6
cortisol                2        nigrostriatal_conduit   3
plasticity              3
                                 TOTAL                   29 edges / 11 packs
```

The slice had **5** intra-repo edges across 6 packs. Atomic has **29** across 11.
Edges grew **5.8×** while packs grew **1.8×** — coupling grows FASTER than pack
count. The density concentrates in two places: the **regions** (striatum imports
6 — every neurochemical it reads is now a separate pack; ATOMIC-2) and the
**interfaces** (each conduit imports its endpoint regions plus, if computational,
the transform; ATOMIC-3). At 140 constructs the interface layer becomes the
densest part of the import graph, because every wire in the connectome is a
conduit that names both endpoints. Two universal edges also appear per grounded
pack (each imports `causal_grounding` and usually `neuroendocrine_strata`), so
total edges scale with (grounded constructs + wires), not with constructs alone.

## 4. Layer-rule pressure

The strict layer rule (PrologAI L4) passed with **zero violations and zero
awkward placements**. Six levels fell out from the anatomy: 0 substrate
(`neural_lattice`, `causal_grounding`), 1 ladder, 2 neurochemicals, 3 plasticity,
4 regions, 5 interfaces. The only mild effects of granularity: the stack is one
level TALLER than the slice's (6 vs 5, because `plasticity` split out from the
neurochemistry leaf and must sit above `cortisol`), and there are **11 layer
declarations to maintain** rather than 6. The rule did not resist maximal
granularity — a good result for L4 under its heaviest user so far — but the arm
re-hit the layer construct's cross-repo and per-repo-namespace limits (ATOMIC-5,
-6, -7 → P5, P6, P7).

## 5. Testability

**Pure dynamics isolate perfectly.** `dopamine`, `cortisol`, and `plasticity`
each carry an in-pack PLUnit suite that exercises the construct with minimal
dependencies — you can test the dopamine RPE without loading cortisol or the
regions. This is a genuine atomic win over the slice, where the three chemistries
shared one `neurochemistry` pack and one test file.

**Grounded and runtime constructs drag in substrate, not siblings.** A region's
structure test still loads the grounding engine, and (per ATOMIC-4) the Lattice,
because a region co-locates its continuant record with its tick. But it does NOT
load the OTHER regions or neurochemicals. So a construct isolates from its
SIBLINGS (the thing granularity should buy) even though it cannot isolate from
the SUBSTRATE it is grounded and coordinated on (inherent, not a granularity
cost).

## 6. Grounding fit

**Low, and that is the finding.** Atomic groups by ANATOMICAL CONSTRUCT, so a
single pack owns records of MIXED Causalontology kinds: the cortex owns a
continuant, an occurrent, and a bridge; cortisol owns two occurrents, a CRO, a
token, and a signed assertion; each conduit owns two ports and a conduit. The
pack boundary cuts ACROSS the seventeen kinds rather than along them.

This establishes the experiment's baseline: **construct-granularity and
kind-granularity are ORTHOGONAL cuts of the same anatomy.** The strata arm (3c)
is expected to align its pack boundary with the stratum kind and should score
high here; whether that alignment BUYS anything is 3c's question. Atomic's
contribution is to show that one-pack-per-construct gains nothing from the kind
taxonomy — and needs a cross-pack record registry to compensate (ATOMIC-3).

## 7. Ergonomics and new gaps

Building at maximal granularity surfaced four NEW gaps, all facets of one theme —
PrologAI has ONE dependency primitive (the import) and no way to say what KIND of
dependency it is:

- **ATOMIC-1** — a structure-only cross-pack reference (a bridge to a
  neurochemical's occurrents) cannot be distinguished from a runtime dependency.
- **ATOMIC-2** — no dependency-aggregation / facade construct, so a consumer must
  enumerate every fine-grained pack it touches (striatum imports three).
- **ATOMIC-3** — no cross-pack record/id registry, so content-addressed ids are
  threaded by hand-exported accessor predicates, densest at the interfaces.
- **ATOMIC-4** — co-locating structure with runtime fuses the two dependency
  faces (the validator loads the runtime substrate; the runner loads the
  grounding engine).

plus three SECOND SIGHTINGS of the layer construct's known limits — **ATOMIC-5 →
P5** (own `check_layers.sh` wrapper), **ATOMIC-6 → P6** (cross-repo imports
invisible to the layer graph), **ATOMIC-7 → P7** (per-repo layer-number
namespace). Full detail in [`LEDGER.md`](LEDGER.md).

## 8. Scale verdict

At 140 constructs, one-pack-per-construct would fare like this. **What it buys:**
perfect change locality (retune any single construct → touch exactly one pack)
and clean per-construct testability of the dynamics. If the connectome evolves
one construct at a time, atomic is close to ideal.

**What hurts first:** the per-pack CEREMONY. ~143 packs means ~143 `pack.pl`
manifests, ~143 `layer(N)` declarations, ~143 in-pack test files, and ~143
ERC-commented modules — the fixed overhead per construct dominates the file
count. Close behind is the **interface coupling**: with hundreds of conduits each
importing two endpoint regions plus a transform, the import graph's densest layer
is the interfaces, and — absent the constructs ATOMIC-1..4 ask for (a
structure-only dependency marker, an aggregation facade, a record registry, and a
pack face) — the import lists and the layer graph carry every fine-grained
reference, so **navigability degrades before correctness does.** Atomic is the
right cut for a system changed one construct at a time and the wrong cut for one
changed one CIRCUIT at a time — which is exactly the hypothesis the loops arm
(3b) will test next.
