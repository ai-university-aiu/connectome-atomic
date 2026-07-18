% Test suite for the thalamus region pack.
% The region's tick predicate blocks on a Lattice cue, so its full behaviour is
% exercised end-to-end by bin/run_slice.sh; this in-pack test confirms the module
% loads, exports its tick interface, and mints its valid structure record.
% Load the thalamus module under test.
:- use_module(library(thalamus)).
% Load PrologAI's schema validator for the structure record.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the thalamus pack.
:- begin_tests(thalamus).

% The region exports its single tick predicate.
test(exports_tick) :-
    % The thalamus_tick/1 predicate is defined and callable.
    current_predicate(thalamus_tick/1).

% The thalamus's one structure record is a schema-valid continuant.
test(records_valid) :-
    % Fetch the labelled records.
    thalamus_records(Records),
    % There is exactly one of them.
    length(Records, 1),
    % It validates against the continuant schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(thalamus).
