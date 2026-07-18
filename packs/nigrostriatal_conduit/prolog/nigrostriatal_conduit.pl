/*  Connectome atomic — nigrostriatal_conduit (Layer 5): the interface, as one pack.

    THE ATOMIC RULE applied to the transmissive interface. This pack groups the
    two ports of the NIGROSTRIATAL PROJECTION with the projection itself — the
    substantia-nigra dopaminergic OUTPUT port, the striatal dopaminergic INPUT
    port, and the TRANSMISSIVE conduit between them. Per the Perfect Wire Test a
    conduit is transmissive when a perfect wire would suffice: the dopamine
    projection just delivers the signal, applying no transform, so this conduit
    carries NO transform id.

    It reaches DOWN to the dopamine pack (for the source continuant and the
    dopamine-release occurrent) and to the striatum region (for the target
    continuant) — a lighter fan-out than the computational conduit, because a
    transmissive interface names no computation. That the two conduit flavours
    differ in import fan-out is itself a grounding-fit observation (see
    COMPARISON.md).

    Sits at the TOP of the arm's layer stack (Layer 5): all its edges are
    downward, so the layer rule holds.
*/

% Declare the module: the interface's structure accessors.
:- module(nigrostriatal_conduit, [
    % nigrostriatal_conduit_dopaminergic_output_port/1: the substantia-nigra output port record.
    nigrostriatal_conduit_dopaminergic_output_port/1,
    % nigrostriatal_conduit_dopaminergic_input_port/1: the striatal dopaminergic input port record.
    nigrostriatal_conduit_dopaminergic_input_port/1,
    % nigrostriatal_conduit_conduit/1: the transmissive nigrostriatal-projection conduit record.
    nigrostriatal_conduit_conduit/1,
    % nigrostriatal_conduit_records/1: the labelled list of this interface's three structure records.
    nigrostriatal_conduit_records/1
]).

% Import the shared minting vocabulary (Layer 0) for the structure records.
:- use_module(library(causal_grounding)).
% Import the dopamine pack (Layer 2) for the source continuant id and the dopamine-release occurrent id.
:- use_module(library(dopamine)).
% Import the striatum region (Layer 4) for the target continuant id.
:- use_module(library(striatum)).

% -- nigrostriatal_conduit_dopaminergic_output_port(-Out): the nigral output port (carries dopamine).
nigrostriatal_conduit_dopaminergic_output_port(Out) :-
    % The bearer is the substantia-nigra continuant.
    dopamine_snc_continuant(CSnc),
    % The port accepts the dopamine-release occurrent.
    dopamine_release_occurrent(ODopamine),
    % Mint the output port (no realizable — a plain projection exit).
    cm_port(CSnc.id, "dopaminergic_output", "out", [ODopamine.id], Out).

% -- nigrostriatal_conduit_dopaminergic_input_port(-Out): the striatal dopaminergic input port.
nigrostriatal_conduit_dopaminergic_input_port(Out) :-
    % The bearer is the striatum continuant.
    striatum_continuant(CStriatum),
    % The port accepts the dopamine-release occurrent.
    dopamine_release_occurrent(ODopamine),
    % Mint the input port (no realizable — a plain projection entry).
    cm_port(CStriatum.id, "dopaminergic_input", "in", [ODopamine.id], Out).

% -- nigrostriatal_conduit_conduit(-Out): the TRANSMISSIVE conduit (no transform).
nigrostriatal_conduit_conduit(Out) :-
    % The from-port is the nigral dopaminergic output.
    nigrostriatal_conduit_dopaminergic_output_port(PSncOut),
    % The to-port is the striatal dopaminergic input.
    nigrostriatal_conduit_dopaminergic_input_port(PStriatumDop),
    % The occurrent carried is the dopamine release.
    dopamine_release_occurrent(ODopamine),
    % Mint the transmissive conduit (five-argument form: no transform, a perfect wire suffices).
    cm_conduit(PSncOut.id, PStriatumDop.id, [ODopamine.id], "nigrostriatal_projection", Out).

% -- nigrostriatal_conduit_records(-Records): this interface's three structure records.
nigrostriatal_conduit_records(Records) :-
    % Mint the two ports and the transmissive conduit.
    nigrostriatal_conduit_dopaminergic_output_port(PSncOut),
    nigrostriatal_conduit_dopaminergic_input_port(PStriatumDop),
    nigrostriatal_conduit_conduit(KDopamine),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(port_dopaminergic_output,  port,    PSncOut),
        record(port_dopaminergic_input,   port,    PStriatumDop),
        record(conduit_nigrostriatal_transmissive, conduit, KDopamine)
    ].
