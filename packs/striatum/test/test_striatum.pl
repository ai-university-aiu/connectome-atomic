% Test suite for the striatum region pack.
% The region's tick predicate blocks on a Lattice cue, so its full behaviour is
% exercised end-to-end by bin/run_slice.sh; this in-pack test confirms the module
% loads, exports its tick interface, and mints valid structure records.
% Load the striatum module under test.
:- use_module(library(striatum)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the striatum pack.
:- begin_tests(striatum).

% The region exports its single tick predicate.
test(exports_tick) :-
    % The striatum_tick/1 predicate is defined and callable.
    current_predicate(striatum_tick/1).

% The striatum's two structure records are schema-valid, one being the plasticity realizable.
test(records_valid) :-
    % Fetch the labelled records.
    striatum_records(Records),
    % There are exactly two of them.
    length(Records, 2),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])),
    % One of them is the synaptic-plasticity realizable disposition.
    memberchk(record(realizable_plasticity, realizable, _), Records).

% Close the test block.
:- end_tests(striatum).
