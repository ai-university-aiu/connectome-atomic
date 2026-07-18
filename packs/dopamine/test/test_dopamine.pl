% Test suite for the dopamine pack (neurotransmitter dynamics + structure).
% Load the dopamine module under test.
:- use_module(library(dopamine)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the dopamine pack.
:- begin_tests(dopamine).

% The dopamine signal is reward minus prediction (a reward-prediction-error).
test(signal_is_rpe) :-
    % A perfect prediction yields zero dopamine.
    dopamine_signal(1.0, 1.0, D0), D0 =:= 0.0,
    % An unpredicted reward yields a full positive error.
    dopamine_signal(1.0, 0.0, D1), D1 =:= 1.0.

% The reward schedule delivers a reliable unit reward on every lap.
test(reward_is_unit) :-
    % The reward is 1.0 regardless of the lap.
    dopamine_reward(3, R), R =:= 1.0.

% Dopamine's three structure records are all schema-valid.
test(records_valid) :-
    % Fetch the labelled records.
    dopamine_records(Records),
    % There are exactly three of them.
    length(Records, 3),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(dopamine).
