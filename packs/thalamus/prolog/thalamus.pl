/*  Connectome atomic — thalamus (Layer 4): the region, as one pack.

    THE ATOMIC RULE applied to a region: everything about the THALAMUS lives in
    one pack — its runtime ROLE (the relay that closes the reentrant loop, and
    the carrier of the cortisol event) AND its Causalontology STRUCTURE (its
    continuant bearer).

    In the cortico-basal-ganglia-thalamo-cortical circuit the thalamus is the
    return leg: it relays the beat back UP to the cortex, closing the loop. That
    upward return is exactly the edge the strict layer rule forbids as a STATIC
    import — and it never is one: the thalamus posts a numbered phase cue and
    never names, imports, or addresses the cortex. The loop closes at RUNTIME
    only.

    The thalamus also carries the CORTISOL EVENT: on the designated lap a
    chronic-social-subordination event elevates the glucocorticoid tone to the
    cortisol pack's surge level. The runtime is reused VERBATIM from the slice
    (rewired to the cortisol pack for the surge level and the decay), so the
    loop's numbers are byte-identical.

    Imports library(neural_lattice) and cortisol (plus the grounding/ladder for
    its continuant) — all downward, so the layer rule holds.
*/

% Declare the module: the region's tick plus its structure accessor.
:- module(thalamus, [
    % thalamus_tick/1: one thalamic relay step, driven by the phase-2 cue.
    thalamus_tick/1,
    % thalamus_continuant/1: the thalamus continuant (bearer) record.
    thalamus_continuant/1,
    % thalamus_records/1: the labelled list of the thalamus's one structure record.
    thalamus_records/1
]).

% Import the Lattice substrate (Layer 0) for cue await/post and narration.
:- use_module(library(neural_lattice)).
% Import the shared minting vocabulary (Layer 0) for the structure record.
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — imported for parity with the other region packs' grounding.
:- use_module(library(neuroendocrine_strata)).
% Import cortisol (Layer 2) for the surge level on the event lap and the decay between events.
:- use_module(library(cortisol)).

% ---------------------------------------------------------------------------
% The runtime role (reused verbatim from the slice, rewired to the cortisol pack).
% ---------------------------------------------------------------------------

% -- thalamus_tick(+Nexus): block for the phase-2 cue, relay the beat, close the loop.
thalamus_tick(Nexus) :-
    % Block with no busy-poll until the striatum has cued phase 2, then take that cue.
    neural_lattice_await_cue(Nexus, 2, State0),
    % Read the current lap number from the state snapshot.
    get_dict(lap, State0, Lap),
    % Read the running token counter (the closure proof's monotonic value).
    get_dict(token, State0, Token0),
    % Read the current cortisol tone.
    get_dict(cortisol, State0, Cortisol0),
    % Read the lap on which the social-stress cortisol event fires.
    get_dict(event_lap, State0, EventLap),
    % Advance the token by one for this hop (the relay is a hop like any other).
    Token is Token0 + 1,
    % Record and print the thalamic hop; the beat arrived VIA the Lattice, not from a named sender.
    neural_lattice_hop(lattice, thalamus, Token),
    % Decide the cortisol tone for the next lap: surge on the event lap, else decay.
    thalamus_cortisol(Lap, EventLap, Cortisol0, Cortisol),
    % The loop closes by handing the beat to the next lap: increment the lap number.
    NextLap is Lap + 1,
    % Update the state snapshot with the new token, cortisol tone, and lap.
    State1 = State0.put(_{token: Token, cortisol: Cortisol, lap: NextLap}),
    % Post the phase-0 cue: the beat returns to the cortex slot WITHOUT naming the cortex.
    neural_lattice_post_cue(Nexus, 0, State1).

% -- thalamus_cortisol(+Lap, +EventLap, +Old, -New): the cortisol tone for the next lap.
thalamus_cortisol(Lap, Lap, _Old, Surge) :-
    % On the event lap the chronic social subordination drives a cortisol surge.
    !,
    % Read the surge level from the cortisol pack (held constant at 3.0).
    cortisol_surge_level(Surge),
    % Narrate the layer-skip in glass-box style: one physical step across ten strata, no mechanism.
    neural_lattice_narrate('    ',
        'CORTISOL EVENT: chronic_social_subordination @ community_and_society (ordinal 14) -> gene_expression @ macromolecular (ordinal 4): one physical step, ten strata skipped, no intervening mechanism (skips:true). Glucocorticoid tone now suppresses corticostriatal plasticity.').
thalamus_cortisol(_Lap, _EventLap, Old, New) :-
    % On every other lap the cortisol tone simply decays toward baseline.
    cortisol_decay(Old, New).

% ---------------------------------------------------------------------------
% The structure record (co-located with the runtime, the atomic stance).
% ---------------------------------------------------------------------------

% -- thalamus_continuant(-Out): the thalamus continuant (bearer) record.
thalamus_continuant(Out) :-
    % Mint the thalamus bearer with the anatomy's fields.
    cm_cnt("thalamus", "object", Out).

% -- thalamus_records(-Records): the thalamus's one structure record, labelled by name and kind.
thalamus_records(Records) :-
    % Mint the continuant.
    thalamus_continuant(CThalamus),
    % Assemble the labelled record list (same name the slice used).
    Records = [
        record(continuant_thalamus, continuant, CThalamus)
    ].
