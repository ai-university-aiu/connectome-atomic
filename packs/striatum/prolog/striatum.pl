/*  Connectome atomic — striatum (Layer 4): the region, as one pack.

    THE ATOMIC RULE applied to a region: everything about the STRIATUM lives in
    one pack — its runtime ROLE (the dopamine-gated plasticity site) AND its
    Causalontology STRUCTURE (its continuant bearer and the synaptic-plasticity
    realizable disposition it carries).

    A MEASURED CONSEQUENCE (ATOMIC-2). In the slice the striatum imported ONE
    neurochemistry pack. Under atomic granularity it must import THREE separate
    packs to run one tick — dopamine (for the reward and the RPE), cortisol (via
    plasticity, for the suppression), and plasticity (for the three-factor
    update) — because each neurochemical is now its own pack. Change locality
    improves (retuning dopamine touches one pack) but the striatum's import
    fan-out grows with the number of neurochemicals it reads. The runtime is
    otherwise reused VERBATIM from the slice, so the loop's numbers are identical.

    Like every region it touches only the Lattice at runtime: it awaits a
    numbered phase cue and posts the next one, never addressing the thalamus it
    hands to. Imports are all downward, so the layer rule holds.
*/

% Declare the module: the region's tick plus its structure accessors.
:- module(striatum, [
    % striatum_tick/1: one plasticity step, driven by the phase-1 cue.
    striatum_tick/1,
    % striatum_continuant/1: the striatum continuant (bearer) record.
    striatum_continuant/1,
    % striatum_plasticity_realizable/1: the synaptic-plasticity disposition record.
    striatum_plasticity_realizable/1,
    % striatum_records/1: the labelled list of the striatum's two structure records.
    striatum_records/1
]).

% Import the Lattice substrate (Layer 0) for cue await/post and narration.
:- use_module(library(neural_lattice)).
% Import the shared minting vocabulary (Layer 0) for the structure records.
:- use_module(library(causal_grounding)).
% Import the stratum ladder (Layer 1) — the realizable's bearer is the striatum continuant.
:- use_module(library(neuroendocrine_strata)).
% Import dopamine (Layer 2) for the reward schedule and the reward-prediction-error.
:- use_module(library(dopamine)).
% Import cortisol (Layer 2) — the tone read from the circulating state is passed into plasticity.
:- use_module(library(cortisol)).
% Import plasticity (Layer 3) for the three-factor synaptic update.
:- use_module(library(plasticity)).

% ---------------------------------------------------------------------------
% The runtime role (reused verbatim from the slice, rewired to the atomic packs).
% ---------------------------------------------------------------------------

% -- striatum_tick(+Nexus): block for the phase-1 cue, run dopamine-gated plasticity, hand on.
striatum_tick(Nexus) :-
    % Block with no busy-poll until the cortex has cued phase 1, then take that cue.
    neural_lattice_await_cue(Nexus, 1, State0),
    % Read the current lap number (drives the reward schedule).
    get_dict(lap, State0, Lap),
    % Read the cortex's prediction of reward (its value estimate = the synaptic weight).
    get_dict(prediction, State0, Prediction),
    % Read the current corticostriatal synaptic weight to be updated.
    get_dict(weight, State0, Weight0),
    % Read the prevailing cortisol tone (suppresses plasticity when elevated).
    get_dict(cortisol, State0, Cortisol),
    % Read the learning rate for the three-factor rule.
    get_dict(rate, State0, Rate),
    % Read the running token counter.
    get_dict(token, State0, Token0),
    % Determine the reward delivered on this lap.
    dopamine_reward(Lap, Reward),
    % Form the dopamine reward-prediction-error: reward minus predicted reward.
    dopamine_signal(Reward, Prediction, Dopamine),
    % Apply the three-factor plasticity rule (pre and post activity are both 1.0 here).
    plasticity_update(Weight0, 1.0, 1.0, Dopamine, Cortisol, Rate, Weight),
    % Advance the token by one for the striatal hop.
    Token is Token0 + 1,
    % Record and print the striatal hop; the beat arrived VIA the Lattice.
    neural_lattice_hop(lattice, striatum, Token),
    % Narrate the dopamine computation and the gated weight change, in glass-box style.
    format(string(Line),
        "striatum: reward=~2f prediction=~4f dopamine(RPE)=~4f cortisol=~3f weight ~4f -> ~4f",
        [Reward, Prediction, Dopamine, Cortisol, Weight0, Weight]),
    % Print the narration line at the standard indent.
    neural_lattice_narrate('      ', Line),
    % Update the state snapshot with the new weight, dopamine, reward, and token.
    State1 = State0.put(_{weight: Weight, dopamine: Dopamine, reward: Reward, token: Token}),
    % Post the phase-2 cue: hand the beat to the thalamus slot WITHOUT naming the thalamus.
    neural_lattice_post_cue(Nexus, 2, State1).

% ---------------------------------------------------------------------------
% The structure records (co-located with the runtime, the atomic stance).
% ---------------------------------------------------------------------------

% -- striatum_continuant(-Out): the striatum continuant (bearer) record.
striatum_continuant(Out) :-
    % Mint the striatum bearer with the anatomy's fields.
    cm_cnt("striatum", "object", Out).

% -- striatum_plasticity_realizable(-Out): the synaptic-plasticity disposition borne by the striatum.
striatum_plasticity_realizable(Out) :-
    % Read the striatum bearer id the disposition inheres in.
    striatum_continuant(CStriatum),
    % Mint the realizable disposition.
    cm_rlz(CStriatum.id, "disposition", "synaptic_plasticity", Out).

% -- striatum_records(-Records): the striatum's two structure records, labelled by name and kind.
striatum_records(Records) :-
    % Mint the continuant and the realizable.
    striatum_continuant(CStriatum),
    striatum_plasticity_realizable(RPlast),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(continuant_striatum,  continuant, CStriatum),
        record(realizable_plasticity, realizable, RPlast)
    ].
