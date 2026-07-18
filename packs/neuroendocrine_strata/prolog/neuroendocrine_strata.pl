/*  Connectome atomic — neuroendocrine_strata (Layer 1): the stratum ladder.

    THE DELIBERATE SHARED-INFRASTRUCTURE DECISION (recorded in COMPARISON.md).
    The five strata the slice touches (macromolecular, synaptic, cellular,
    region, community_and_society) are the level coordinate every occurrent is
    stamped against. The atomic rule could split them one-pack-per-stratum — but
    that is precisely arm 3c's (connectome-strata) defining move. To keep the
    three arms distinct and comparable, the ATOMIC arm keeps the ladder as ONE
    shared substrate pack, and records that choice as a measurement: atomic
    treats the DATA layer's level ladder as infrastructure, not as a construct
    to atomise. Splitting it is a different experiment.

    Each stratum body is reused VERBATIM from the slice (same label, scheme,
    ordinal, unit, governs), so each stratum's content-addressed id is identical
    to the slice's — which is why an occurrent minted in the dopamine or cortisol
    pack, referencing a stratum id from here, comes out with the slice's id too.

    Imports only the shared minting vocabulary (Layer 0). Its declared layer(1)
    sits one above that vocabulary and below every construct that stamps against
    a stratum.
*/

% Declare the module and its stratum accessors plus the record projection.
:- module(neuroendocrine_strata, [
    % neuroendocrine_strata_macromolecular/1: the macromolecular stratum (ordinal 4).
    neuroendocrine_strata_macromolecular/1,
    % neuroendocrine_strata_synaptic/1: the synaptic stratum (ordinal 7).
    neuroendocrine_strata_synaptic/1,
    % neuroendocrine_strata_cellular/1: the cellular stratum (ordinal 6).
    neuroendocrine_strata_cellular/1,
    % neuroendocrine_strata_region/1: the brain-region stratum (ordinal 9).
    neuroendocrine_strata_region/1,
    % neuroendocrine_strata_community/1: the community-and-society stratum (ordinal 14).
    neuroendocrine_strata_community/1,
    % neuroendocrine_strata_records/1: the labelled list of the five stratum records.
    neuroendocrine_strata_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).

% -- neuroendocrine_strata_macromolecular(-Out): the macromolecular stratum record.
neuroendocrine_strata_macromolecular(Out) :-
    % Mint the macromolecular stratum with the anatomy's fields.
    cm_stratum("macromolecular", "neuroendocrine", 4, "macromolecule", ["molecular_biology"], Out).

% -- neuroendocrine_strata_synaptic(-Out): the synaptic stratum record.
neuroendocrine_strata_synaptic(Out) :-
    % Mint the synaptic stratum with the anatomy's fields.
    cm_stratum("synaptic", "neuroendocrine", 7, "synapse", ["synaptic_physiology"], Out).

% -- neuroendocrine_strata_cellular(-Out): the cellular stratum record.
neuroendocrine_strata_cellular(Out) :-
    % Mint the cellular stratum with the anatomy's fields.
    cm_stratum("cellular", "neuroendocrine", 6, "cell", ["cell_biology"], Out).

% -- neuroendocrine_strata_region(-Out): the brain-region stratum record.
neuroendocrine_strata_region(Out) :-
    % Mint the region stratum with the anatomy's fields.
    cm_stratum("region", "neuroendocrine", 9, "brain_region", ["systems_neuroscience"], Out).

% -- neuroendocrine_strata_community(-Out): the community-and-society stratum record.
neuroendocrine_strata_community(Out) :-
    % Mint the community-and-society stratum with the anatomy's fields.
    cm_stratum("community_and_society", "neuroendocrine", 14, "community", ["sociology"], Out).

% -- neuroendocrine_strata_records(-Records): the five stratum records, labelled by name and kind.
neuroendocrine_strata_records(Records) :-
    % Mint each stratum in turn.
    neuroendocrine_strata_macromolecular(SMacro),
    neuroendocrine_strata_synaptic(SSyn),
    neuroendocrine_strata_cellular(SCell),
    neuroendocrine_strata_region(SRegion),
    neuroendocrine_strata_community(SCommunity),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(stratum_macromolecular, stratum, SMacro),
        record(stratum_synaptic,       stratum, SSyn),
        record(stratum_cellular,       stratum, SCell),
        record(stratum_region,         stratum, SRegion),
        record(stratum_community,      stratum, SCommunity)
    ].
