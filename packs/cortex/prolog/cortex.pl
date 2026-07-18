/*  Connectome atomic — cortex (Layer 4): the region, as one pack.

    THE ATOMIC RULE applied to a region: everything about the CORTEX lives in one
    pack — its runtime ROLE (origin and re-entry point of the loop; the counter
    and terminator) AND its Causalontology STRUCTURE (its continuant bearer, the
    action-selection occurrent it performs, and the cross-stratal bridge that
    says action-selection realises the finer neurotransmitter events).

    A MEASURED CONSEQUENCE (ATOMIC-1). The bridge references dopamine's release
    occurrents, so this region pack imports the dopamine pack SOLELY to mint a
    structure record — the runtime cortex_tick never calls dopamine. Atomic
    co-location manufactures a structure-only downward dependency the behaviour
    does not need. In the slice, that reference lived inside the single
    causal_map pack and cost no region an import.

    The runtime (cortex_tick/cortex_step) is reused VERBATIM from the slice, so
    the loop's behaviour is byte-identical. On its turn the cortex reads the
    corticostriatal weight as its reward PREDICTION and hands the beat on; when
    the beat returns it has re-entered (the reentrant loop closing at RUNTIME,
    never a static import from a lower layer).

    Imports library(neural_lattice) for coordination and the grounding/ladder/
    dopamine packs for its records — all downward, so the layer rule holds. It
    never imports the striatum it hands to; the hand-off is a numbered cue.
*/

% Declare the module: the region's tick plus its structure accessors.
:- module(cortex, [
    % cortex_tick/1: one cortical step, driven by the phase-0 cue.
    cortex_tick/1,
    % cortex_continuant/1: the cortex continuant (bearer) record.
    cortex_continuant/1,
    % cortex_action_selection_occurrent/1: the action-selection occurrent record.
    cortex_action_selection_occurrent/1,
    % cortex_records/1: the labelled list of the cortex's three structure records.
    cortex_records/1
]).

% Import the Lattice substrate (Layer 0) for cue await/post and narration.
:- use_module(library(neural_lattice)).
% Import the shared minting vocabulary (Layer 0) for the structure records.
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — the action-selection occurrent stamps at the region stratum.
:- use_module(library(neuroendocrine_strata)).
% Import dopamine (Layer 2) SOLELY for the bridge's fine occurrent ids (a structure-only edge; ATOMIC-1).
:- use_module(library(dopamine)).

% ---------------------------------------------------------------------------
% The runtime role (reused verbatim from the slice's cortex region).
% ---------------------------------------------------------------------------

% -- cortex_tick(+Nexus): block for the phase-0 cue, predict, and either hand on or finish.
cortex_tick(Nexus) :-
    % Block with no busy-poll until the beat has returned to phase 0, then take that cue.
    neural_lattice_await_cue(Nexus, 0, State0),
    % Read the current lap number.
    get_dict(lap, State0, Lap),
    % Read the number of laps the loop should run.
    get_dict(n_laps, State0, NLaps),
    % Read the current corticostriatal weight, which the cortex reads as its reward prediction.
    get_dict(weight, State0, Weight),
    % Read the running token counter.
    get_dict(token, State0, Token0),
    % Advance the token by one for the cortical hop.
    Token is Token0 + 1,
    % Record and print the cortical hop; the beat arrived VIA the Lattice, re-entering the loop.
    neural_lattice_hop(lattice, cortex, Token),
    % Decide whether this re-entry is the terminal one or a continuing lap.
    cortex_step(Nexus, Lap, NLaps, Weight, Token, State0).

% -- cortex_step(+Nexus, +Lap, +NLaps, +Weight, +Token, +State0): terminate or continue.
cortex_step(Nexus, Lap, NLaps, _Weight, Token, _State0) :-
    % The loop is at rest once the cortex re-enters beyond the last lap.
    Lap > NLaps,
    !,
    % Narrate that the loop has closed for the full number of laps.
    format(string(Line), "cortex: lap ~w exceeds ~w -- loop at rest; final token=~w", [Lap, NLaps, Token]),
    % Print the closing narration line.
    neural_lattice_narrate('    ', Line),
    % Signal the driver that the loop has come to rest, carrying the final token.
    neural_lattice_signal_done(Nexus, Token).
cortex_step(Nexus, Lap, NLaps, Weight, Token, State0) :-
    % Otherwise this is a continuing lap: the cortex predicts reward from its learned value.
    Prediction = Weight,
    % Narrate the lap header and the cortical prediction, in glass-box style.
    format(string(Line), "cortex: lap ~w/~w  predict(value)=~4f", [Lap, NLaps, Prediction]),
    % Print the narration line.
    neural_lattice_narrate('    ', Line),
    % Update the state snapshot with the token and the prediction for the striatum to use.
    State1 = State0.put(_{token: Token, prediction: Prediction}),
    % Post the phase-1 cue: hand the beat to the striatum slot WITHOUT naming the striatum.
    neural_lattice_post_cue(Nexus, 1, State1).

% ---------------------------------------------------------------------------
% The structure records (co-located with the runtime, the atomic stance).
% ---------------------------------------------------------------------------

% -- cortex_continuant(-Out): the cortex continuant (bearer) record.
cortex_continuant(Out) :-
    % Mint the cortex bearer with the anatomy's fields.
    cm_cnt("cortex", "object", Out).

% -- cortex_action_selection_occurrent(-Out): the action-selection process, at the region stratum.
cortex_action_selection_occurrent(Out) :-
    % Read the brain-region stratum id this process is stamped against.
    neuroendocrine_strata_region(SRegion),
    % Mint the action-selection occurrent.
    cm_occ("action_selection", "process", SRegion.id, Out).

% -- cortex_bridge(-Out): the cross-stratal bridge — action-selection realises the finer NT events.
cortex_bridge(Out) :-
    % The coarse occurrent is the cortex's action-selection process.
    cortex_action_selection_occurrent(OSelect),
    % The finer occurrents are dopamine's neurotransmitter-release and dopamine-release events.
    dopamine_nt_release_occurrent(ORelease),
    dopamine_release_occurrent(ODopamine),
    % Mint the bridge relating the coarse process to the finer events by "realizes".
    cm_bridge(OSelect.id, [ORelease.id, ODopamine.id], "realizes", Out).

% -- cortex_records(-Records): the cortex's three structure records, labelled by name and kind.
cortex_records(Records) :-
    % Mint the continuant, the action-selection occurrent, and the bridge.
    cortex_continuant(CCortex),
    cortex_action_selection_occurrent(OSelect),
    cortex_bridge(BSelect),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(continuant_cortex,           continuant, CCortex),
        record(occurrent_action_selection,  occurrent,  OSelect),
        record(bridge_action_selection,     bridge,     BSelect)
    ].
