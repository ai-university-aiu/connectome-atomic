/*  Connectome atomic — dopamine (Layer 2): the neurotransmitter, as one pack.

    THE ATOMIC RULE applied to a neurochemical: everything about DOPAMINE lives
    in one pack — its native DYNAMICS (the reward schedule and the reward-
    prediction-error signal) AND its Causalontology STRUCTURE records (the
    substantia-nigra bearer, the neurotransmitter-release and dopamine-release
    occurrents). This co-location is the atomic stance, and its consequence is a
    measurement: the structure records here reference the synaptic stratum
    (imported from the ladder), so even a leaf neurochemical couples downward to
    the shared substrate.

    DOPAMINE is the reward-prediction-error (RPE): the difference between the
    reward received and the reward the cortex predicted. It is the THIRD FACTOR
    the striatum feeds into the three-factor plasticity rule. The math is reused
    VERBATIM from the slice's neurochemistry pack, so the loop's numbers are
    byte-identical.

    Imports the shared minting vocabulary (Layer 0) and the stratum ladder
    (Layer 1) — both downward, so the layer rule holds. It coordinates nothing
    and imports no region.
*/

% Declare the module: the dopamine dynamics plus its structure accessors.
:- module(dopamine, [
    % dopamine_reward/2: the reward delivered on a given lap.
    dopamine_reward/2,
    % dopamine_signal/3: the reward-prediction-error (RPE) dopamine signal.
    dopamine_signal/3,
    % dopamine_snc_continuant/1: the substantia-nigra-pars-compacta bearer record.
    dopamine_snc_continuant/1,
    % dopamine_nt_release_occurrent/1: the neurotransmitter-release occurrent record.
    dopamine_nt_release_occurrent/1,
    % dopamine_release_occurrent/1: the dopamine-release occurrent record.
    dopamine_release_occurrent/1,
    % dopamine_records/1: the labelled list of dopamine's three structure records.
    dopamine_records/1
]).

% Import the shared minting vocabulary (Layer 0).
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — occurrents here are stamped at the synaptic stratum.
:- use_module(library(neuroendocrine_strata)).

% ---------------------------------------------------------------------------
% The native dynamics (reused verbatim from the slice's neurochemistry).
% ---------------------------------------------------------------------------

% -- dopamine_reward(+Lap, -Reward): the reward on this lap.
% A reliable cue-reward association: reward is 1.0 on every lap, so the classic
% RPE signature appears — dopamine starts high and decays toward zero as the
% cortex's prediction rises to meet the reward.
dopamine_reward(_Lap, 1.0).

% -- dopamine_signal(+Reward, +Prediction, -Dopamine): the RPE signal.
dopamine_signal(Reward, Prediction, Dopamine) :-
    % Dopamine phasic firing encodes reward minus predicted reward (Rescorla-Wagner / TD error).
    Dopamine is Reward - Prediction.

% ---------------------------------------------------------------------------
% The structure records (co-located with the dynamics, the atomic stance).
% ---------------------------------------------------------------------------

% -- dopamine_snc_continuant(-Out): the substantia-nigra-pars-compacta bearer.
dopamine_snc_continuant(Out) :-
    % Mint the dopamine source continuant with the anatomy's fields.
    cm_cnt("substantia_nigra_pars_compacta", "object", Out).

% -- dopamine_nt_release_occurrent(-Out): the neurotransmitter-release event, at the synaptic stratum.
dopamine_nt_release_occurrent(Out) :-
    % Read the synaptic stratum id this event is stamped against.
    neuroendocrine_strata_synaptic(SSyn),
    % Mint the neurotransmitter-release occurrent.
    cm_occ("neurotransmitter_release", "event", SSyn.id, Out).

% -- dopamine_release_occurrent(-Out): the dopamine-release event, at the synaptic stratum.
dopamine_release_occurrent(Out) :-
    % Read the synaptic stratum id this event is stamped against.
    neuroendocrine_strata_synaptic(SSyn),
    % Mint the dopamine-release occurrent.
    cm_occ("dopamine_release", "event", SSyn.id, Out).

% -- dopamine_records(-Records): dopamine's three structure records, labelled by name and kind.
dopamine_records(Records) :-
    % Mint the bearer and the two occurrents.
    dopamine_snc_continuant(CSnc),
    dopamine_nt_release_occurrent(ORelease),
    dopamine_release_occurrent(ODopamine),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(continuant_snc,          continuant, CSnc),
        record(occurrent_nt_release,     occurrent, ORelease),
        record(occurrent_dopamine_release, occurrent, ODopamine)
    ].
