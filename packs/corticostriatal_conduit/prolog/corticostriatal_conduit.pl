/*  Connectome atomic — corticostriatal_conduit (Layer 5): the interface, as one pack.

    THE ATOMIC RULE applied to an interface. The order asks the ports to be
    "grouped per the anatomy rather than lumped": this pack groups the two ports
    of the CORTICOSTRIATAL PROJECTION with the projection itself — the cortical
    OUTPUT port, the striatal INPUT port (which bears the plasticity disposition),
    and the COMPUTATIONAL conduit whose transform is the plasticity CRO. A
    computational conduit performs a transformation a perfect wire could not.

    A MEASURED CONSEQUENCE (ATOMIC-3). An interface record references BOTH
    regions it connects and the computation it carries, so this one pack imports
    four others — cortex, striatum and plasticity — purely to mint three records.
    Interfaces are where the atomic decomposition's coupling concentrates: at the
    slice this is one pack reaching to three; projected to 140 constructs, every
    conduit reaches to its two endpoint regions plus its transform, and the
    interface layer becomes the densest part of the import graph (see LEDGER.md).

    Sits at the TOP of the arm's layer stack (Layer 5): it imports regions and
    computation but nothing imports it, so all its edges are downward and the
    layer rule holds.
*/

% Declare the module: the interface's structure accessors.
:- module(corticostriatal_conduit, [
    % corticostriatal_conduit_cortical_output_port/1: the cortical-output port record.
    corticostriatal_conduit_cortical_output_port/1,
    % corticostriatal_conduit_striatal_input_port/1: the corticostriatal-input port record.
    corticostriatal_conduit_striatal_input_port/1,
    % corticostriatal_conduit_conduit/1: the computational corticostriatal-projection conduit record.
    corticostriatal_conduit_conduit/1,
    % corticostriatal_conduit_records/1: the labelled list of this interface's three structure records.
    corticostriatal_conduit_records/1
]).

% Import the shared minting vocabulary (Layer 0) for the structure records.
:- use_module(library(causal_grounding)).
% Import the cortex region (Layer 4) for its continuant id (the output port's bearer).
:- use_module(library(cortex)).
% Import the striatum region (Layer 4) for its continuant id and the plasticity realizable id.
:- use_module(library(striatum)).
% Import plasticity (Layer 3) for the drive occurrent id and the transform CRO id.
:- use_module(library(plasticity)).

% -- corticostriatal_conduit_cortical_output_port(-Out): the cortex's output port (carries drive).
corticostriatal_conduit_cortical_output_port(Out) :-
    % The bearer is the cortex continuant.
    cortex_continuant(CCortex),
    % The port accepts the corticostriatal-drive occurrent.
    plasticity_drive_occurrent(ODrive),
    % Mint the output port (no realizable — a plain projection exit).
    cm_port(CCortex.id, "cortical_output", "out", [ODrive.id], Out).

% -- corticostriatal_conduit_striatal_input_port(-Out): the striatum's input port (bears plasticity).
corticostriatal_conduit_striatal_input_port(Out) :-
    % The bearer is the striatum continuant.
    striatum_continuant(CStriatum),
    % The port accepts the corticostriatal-drive occurrent.
    plasticity_drive_occurrent(ODrive),
    % The port bears the synaptic-plasticity realizable disposition.
    striatum_plasticity_realizable(RPlast),
    % Mint the input port carrying the realizable id.
    cm_port(CStriatum.id, "corticostriatal_input", "in", [ODrive.id], RPlast.id, Out).

% -- corticostriatal_conduit_conduit(-Out): the COMPUTATIONAL conduit (transform = plasticity CRO).
corticostriatal_conduit_conduit(Out) :-
    % The from-port is the cortical output.
    corticostriatal_conduit_cortical_output_port(PCortexOut),
    % The to-port is the striatal input.
    corticostriatal_conduit_striatal_input_port(PStriatumIn),
    % The occurrent carried is the corticostriatal drive.
    plasticity_drive_occurrent(ODrive),
    % The transform is the plasticity CRO — asserting the conduit is COMPUTATIONAL.
    plasticity_transform_cro(CroPlast),
    % Mint the computational conduit (six-argument form carries the transform id).
    cm_conduit(PCortexOut.id, PStriatumIn.id, [ODrive.id], "corticostriatal_projection", CroPlast.id, Out).

% -- corticostriatal_conduit_records(-Records): this interface's three structure records.
corticostriatal_conduit_records(Records) :-
    % Mint the two ports and the computational conduit.
    corticostriatal_conduit_cortical_output_port(PCortexOut),
    corticostriatal_conduit_striatal_input_port(PStriatumIn),
    corticostriatal_conduit_conduit(KCortico),
    % Assemble the labelled record list (same names the slice used).
    Records = [
        record(port_cortical_output,        port,    PCortexOut),
        record(port_corticostriatal_input,  port,    PStriatumIn),
        record(conduit_corticostriatal_computational, conduit, KCortico)
    ].
