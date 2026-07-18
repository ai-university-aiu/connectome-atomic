/*  Connectome atomic — plasticity (Layer 3): the three-factor rule, as one pack.

    THE ATOMIC RULE applied to the synaptic COMPUTATION. The corticostriatal
    synapse's learning is a named construct in its own right: the three-factor
    plasticity rule (the dynamics) and the corticostriatal transform CRO plus
    the drive and weight-change occurrents (the structure). In the slice these
    were split across neurochemistry (the rule) and causal_map (the CRO); the
    atomic decomposition co-locates the rule with the very structure records it
    realises. That co-location is a direct comment on the slice's P3 finding
    (the transform CRO and the plasticity rule "never meet"): here they at least
    live in one pack, though PrologAI still offers no construct BINDING the CRO
    to the native law — the seam is closer but still unmanaged (see LEDGER.md).

    The rule: change = rate * presynaptic * postsynaptic * dopamine, scaled by
    the cortisol suppression factor. The math is reused VERBATIM from the slice.

    Imports the shared minting vocabulary (Layer 0), the stratum ladder
    (Layer 1), and cortisol (Layer 2, for the suppression factor) — all
    downward, so the layer rule holds.
*/

% Declare the module: the plasticity dynamics plus its structure accessors.
:- module(plasticity, [
    % plasticity_update/7: the three-factor synaptic update.
    plasticity_update/7,
    % plasticity_clamp/4: clamp a value into a closed interval.
    plasticity_clamp/4,
    % plasticity_drive_occurrent/1: the corticostriatal-drive occurrent record.
    plasticity_drive_occurrent/1,
    % plasticity_weight_change_occurrent/1: the synaptic-weight-change occurrent record.
    plasticity_weight_change_occurrent/1,
    % plasticity_transform_cro/1: the corticostriatal transform causal_relation_object.
    plasticity_transform_cro/1,
    % plasticity_records/1: the labelled list of plasticity's three structure records.
    plasticity_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — the two occurrents stamp against the synaptic stratum.
:- use_module(library(neuroendocrine_strata)).
% Import cortisol (Layer 2) — the three-factor rule reads its suppression factor.
:- use_module(library(cortisol)).

% ---------------------------------------------------------------------------
% The native dynamics (reused verbatim from the slice's neurochemistry).
% ---------------------------------------------------------------------------

% -- plasticity_update(+Weight, +Pre, +Post, +Dopamine, +Cortisol, +Rate, -NewWeight):
% the THREE-FACTOR rule: change = rate * presynaptic * postsynaptic * dopamine, scaled by cortisol tone.
plasticity_update(Weight, Pre, Post, Dopamine, Cortisol, Rate, NewWeight) :-
    % Compute the cortisol-dependent suppression of the plasticity gain.
    cortisol_suppression(Cortisol, Suppression),
    % The weight change is the product of the three factors, the learning rate, and the suppression.
    Delta is Rate * Pre * Post * Dopamine * Suppression,
    % Apply the change to the current weight.
    Raw is Weight + Delta,
    % Keep the synaptic weight inside the unit interval (a bounded efficacy).
    plasticity_clamp(Raw, 0.0, 1.0, NewWeight).

% -- plasticity_clamp(+X, +Low, +High, -Y): clamp X into [Low, High].
plasticity_clamp(X, Low, _High, Low) :-
    % When X is at or below the lower bound, clamp to the lower bound.
    X =< Low, !.
plasticity_clamp(X, _Low, High, High) :-
    % When X is at or above the upper bound, clamp to the upper bound.
    X >= High, !.
plasticity_clamp(X, _Low, _High, X).
    % Otherwise X is already inside the interval; pass it through unchanged.

% ---------------------------------------------------------------------------
% The structure records (co-located with the dynamics, the atomic stance).
% ---------------------------------------------------------------------------

% -- plasticity_drive_occurrent(-Out): the corticostriatal-drive process, at the synaptic stratum.
plasticity_drive_occurrent(Out) :-
    % Read the synaptic stratum id this process is stamped against.
    neuroendocrine_strata_synaptic(SSyn),
    % Mint the corticostriatal-drive occurrent.
    cm_occ("corticostriatal_drive", "process", SSyn.id, Out).

% -- plasticity_weight_change_occurrent(-Out): the synaptic-weight-change, at the synaptic stratum.
plasticity_weight_change_occurrent(Out) :-
    % Read the synaptic stratum id this state-change is stamped against.
    neuroendocrine_strata_synaptic(SSyn),
    % Mint the synaptic-weight-change occurrent.
    cm_occ("synaptic_weight_change", "state_change", SSyn.id, Out).

% -- plasticity_transform_cro(-Out): the corticostriatal transform (drive -> weight change).
plasticity_transform_cro(Out) :-
    % The cause is the corticostriatal-drive occurrent.
    plasticity_drive_occurrent(ODrive),
    % The effect is the synaptic-weight-change occurrent.
    plasticity_weight_change_occurrent(OUpdate),
    % Mint the transform CRO with its modality and temporal window (the conduit's computation).
    cm_cro([ODrive.id], [OUpdate.id],
           [modality-"sufficient", temporal-_{minimum_delay:0, maximum_delay:1, unit:"seconds"}],
           Out).

% -- plasticity_records(-Records): plasticity's three structure records, labelled by name and kind.
plasticity_records(Records) :-
    % Mint the two occurrents and the transform CRO.
    plasticity_drive_occurrent(ODrive),
    plasticity_weight_change_occurrent(OUpdate),
    plasticity_transform_cro(CroPlast),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(occurrent_corticostriatal_drive, occurrent,              ODrive),
        record(occurrent_weight_change,          occurrent,              OUpdate),
        record(cro_corticostriatal_transform,    causal_relation_object, CroPlast)
    ].
