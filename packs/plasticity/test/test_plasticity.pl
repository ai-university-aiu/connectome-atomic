% Test suite for the plasticity pack (three-factor rule + transform structure).
% Load the plasticity module under test.
:- use_module(library(plasticity)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the plasticity pack.
:- begin_tests(plasticity).

% The three-factor rule raises the weight on a positive error and stays bounded.
test(bounded_and_gated) :-
    % A positive error with no cortisol raises the weight toward the reward.
    plasticity_update(0.0, 1.0, 1.0, 1.0, 0.0, 0.4, W1), W1 > 0.0, W1 =< 1.0,
    % Zero dopamine produces no weight change (the third factor gates learning).
    plasticity_update(0.5, 1.0, 1.0, 0.0, 0.0, 0.4, W2), W2 =:= 0.5,
    % Elevated cortisol shrinks the same update.
    plasticity_update(0.0, 1.0, 1.0, 1.0, 3.0, 0.4, W3), W3 < W1.

% The clamp keeps a value inside the unit interval.
test(clamp_bounds) :-
    % An over-range value clamps to the high bound.
    plasticity_clamp(1.5, 0.0, 1.0, H), H =:= 1.0,
    % An under-range value clamps to the low bound.
    plasticity_clamp(-0.2, 0.0, 1.0, L), L =:= 0.0.

% Plasticity's three structure records are all schema-valid, one being the transform CRO.
test(records_valid) :-
    % Fetch the labelled records.
    plasticity_records(Records),
    % There are exactly three of them.
    length(Records, 3),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])),
    % One of them is the corticostriatal transform causal_relation_object.
    memberchk(record(cro_corticostriatal_transform, causal_relation_object, _), Records).

% Close the test block.
:- end_tests(plasticity).
