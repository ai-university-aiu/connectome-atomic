/*  Connectome atomic — cortisol (Layer 2): the layer-skipping hormone, as one pack.

    THE ATOMIC RULE applied to the hormone: everything about CORTISOL lives in
    one pack — its native DYNAMICS (the glucocorticoid suppression factor, the
    slow decay, the surge level) AND its Causalontology STRUCTURE (the two
    occurrents it spans, the SKIPPING causal_relation_object that crosses ten
    strata with no intervening mechanism, the local-by-default token episode,
    and the Ed25519-signed provenance assertion over the skip). Cortisol is the
    single richest construct in the slice's Ledger (P1, P2), and in the atomic
    decomposition all of that richness co-locates here.

    CORTISOL is the slow glucocorticoid tone: a chronic-stress elevation
    suppresses corticostriatal plasticity. It enters the three-factor rule as a
    multiplicative suppression factor. The math is reused VERBATIM from the
    slice's neurochemistry pack.

    Imports the shared minting vocabulary (Layer 0), the stratum ladder
    (Layer 1), and PrologAI's causal_core (EXTERNAL) for the skip classification.
    All downward; the layer rule holds.
*/

% Declare the module: cortisol's dynamics plus its structure and skip/signature checks.
:- module(cortisol, [
    % cortisol_suppression/2: the plasticity suppression factor for a cortisol level.
    cortisol_suppression/2,
    % cortisol_decay/2: one step of cortisol return toward baseline.
    cortisol_decay/2,
    % cortisol_surge_level/1: the glucocorticoid level a social-stress event drives to.
    cortisol_surge_level/1,
    % cortisol_social_occurrent/1: the chronic-social-subordination occurrent record.
    cortisol_social_occurrent/1,
    % cortisol_gene_expression_occurrent/1: the glucocorticoid-gene-expression occurrent record.
    cortisol_gene_expression_occurrent/1,
    % cortisol_skip_cro/1: the skipping causal_relation_object (community -> macromolecular).
    cortisol_skip_cro/1,
    % cortisol_skip_check/2: the semantic classification and skip-gaps of the cortisol CRO.
    cortisol_skip_check/2,
    % cortisol_signed_assertion/1: the Ed25519-signed provenance over the skip CRO.
    cortisol_signed_assertion/1,
    % cortisol_records/1: the labelled list of cortisol's five structure records.
    cortisol_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — the two occurrents stamp against community and macromolecular.
:- use_module(library(neuroendocrine_strata)).
% Import PrologAI's Causalontology engine (EXTERNAL) for the skip classification and gaps.
:- use_module(library(causal_core)).

% ---------------------------------------------------------------------------
% The native dynamics (reused verbatim from the slice's neurochemistry).
% ---------------------------------------------------------------------------

% -- cortisol_suppression(+Cortisol, -Factor): plasticity gain under stress.
cortisol_suppression(Cortisol, Factor) :-
    % Higher glucocorticoid tone shrinks the plasticity gain; baseline (0) leaves it at 1.0.
    Factor is 1.0 / (1.0 + Cortisol).

% -- cortisol_decay(+Cortisol, -NewCortisol): slow return toward baseline.
cortisol_decay(Cortisol, NewCortisol) :-
    % Cortisol clears with a slow exponential decay (retains 90 percent each lap).
    NewCortisol is Cortisol * 0.9.

% -- cortisol_surge_level(-Level): the tone a chronic-social-subordination event drives to.
cortisol_surge_level(3.0).
    % The event lap elevates the glucocorticoid tone to 3.0 (the slice's surge constant).

% ---------------------------------------------------------------------------
% The structure records (co-located with the dynamics, the atomic stance).
% ---------------------------------------------------------------------------

% -- cortisol_social_occurrent(-Out): the chronic-social-subordination process, at the community stratum.
cortisol_social_occurrent(Out) :-
    % Read the community-and-society stratum id this process is stamped against.
    neuroendocrine_strata_community(SCommunity),
    % Mint the chronic-social-subordination occurrent.
    cm_occ("chronic_social_subordination", "process", SCommunity.id, Out).

% -- cortisol_gene_expression_occurrent(-Out): the glucocorticoid gene expression, at the macromolecular stratum.
cortisol_gene_expression_occurrent(Out) :-
    % Read the macromolecular stratum id this state-change is stamped against.
    neuroendocrine_strata_macromolecular(SMacro),
    % Mint the glucocorticoid-gene-expression occurrent.
    cm_occ("glucocorticoid_gene_expression", "state_change", SMacro.id, Out).

% -- cortisol_skip_cro(-Out): the SKIPPING CRO — community (14) -> macromolecular (4), skips:true.
cortisol_skip_cro(Out) :-
    % The cause is the social-subordination occurrent.
    cortisol_social_occurrent(OSocial),
    % The effect is the gene-expression occurrent ten strata below, with NO intervening mechanism.
    cortisol_gene_expression_occurrent(OGene),
    % Mint the causal_relation_object flagged skips:true (the absence of a mechanism is a positive finding).
    cm_cro([OSocial.id], [OGene.id], [skips-true], Out).

% -- cortisol_token_episode(-Out): one particular cortisol episode, local-by-default, signed observer.
cortisol_token_episode(Out) :-
    % The episode instantiates the gene-expression occurrent.
    cortisol_gene_expression_occurrent(OGene),
    % Derive the arm's deterministic observer key (name held constant: connectome_slice).
    cm_key("connectome_slice", _Sec, Observer),
    % Mint the token occurrence over a one-hour interval.
    cm_token(OGene.id, _{start:"2026-07-17T00:00:00Z", end:"2026-07-17T01:00:00Z"}, Observer, Out).

% -- cortisol_signed_assertion(-Signed): an Ed25519-signed provenance assertion over the skip CRO.
cortisol_signed_assertion(Signed) :-
    % Read the skip CRO's content-addressed id.
    cortisol_skip_cro(SkipCro),
    % Mint and sign the provenance assertion over that id.
    cm_signed_assertion_over(SkipCro.id, Signed).

% -- cortisol_skip_check(-Class, -Gaps): classify the cortisol CRO and read its skip-gaps.
cortisol_skip_check(Class, Gaps) :-
    % Mint the skip CRO and the two occurrents it relates.
    cortisol_skip_cro(SkipCro),
    cortisol_social_occurrent(OSocial),
    cortisol_gene_expression_occurrent(OGene),
    % Mint the two strata the CRO spans.
    neuroendocrine_strata_community(SCommunity),
    neuroendocrine_strata_macromolecular(SMacro),
    % Build the occurrent and stratum maps the classifier needs.
    cm_map_of([OSocial, OGene], OccMap),
    cm_map_of([SCommunity, SMacro], StratumMap),
    % Classify the cross-stratal relation (expected: skipping).
    causal_core_classify(SkipCro, OccMap, StratumMap, Class),
    % Read the skip-gaps (expected: none — the absence of a mechanism is a positive finding).
    causal_core_skip_gaps(SkipCro, Class, Gaps).

% -- cortisol_records(-Records): cortisol's five structure records, labelled by name and kind.
cortisol_records(Records) :-
    % Mint the two occurrents, the skip CRO, the token episode, and the signed assertion.
    cortisol_social_occurrent(OSocial),
    cortisol_gene_expression_occurrent(OGene),
    cortisol_skip_cro(SkipCro),
    cortisol_token_episode(TEpisode),
    cortisol_signed_assertion(Signed),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(occurrent_social_subordination, occurrent,              OSocial),
        record(occurrent_gene_expression,       occurrent,              OGene),
        record(cro_cortisol_skip,               causal_relation_object, SkipCro),
        record(token_cortisol_episode,          token_occurrence,       TEpisode),
        record(assertion_skip_provenance,       assertion,              Signed)
    ].
