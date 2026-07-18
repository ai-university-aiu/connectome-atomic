% Test suite for the cortex region pack.
% The region's tick predicate blocks on a Lattice cue, so its full behaviour is
% exercised end-to-end by bin/run_slice.sh (the closure verdict is its real test);
% this in-pack test confirms the module loads, exports its tick interface, and
% mints valid structure records, so the pack can never rot silently.
% Load the cortex module under test.
:- use_module(library(cortex)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the cortex pack.
:- begin_tests(cortex).

% The region exports its single tick predicate.
test(exports_tick) :-
    % The cortex_tick/1 predicate is defined and callable.
    current_predicate(cortex_tick/1).

% The cortex's three structure records are all schema-valid, one being the bridge.
test(records_valid) :-
    % Fetch the labelled records.
    cortex_records(Records),
    % There are exactly three of them.
    length(Records, 3),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])),
    % One of them is the action-selection bridge.
    memberchk(record(bridge_action_selection, bridge, _), Records).

% Close the test block.
:- end_tests(cortex).
