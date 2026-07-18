% Test suite for the cortisol pack (hormone dynamics + skipping structure).
% Load the cortisol module under test.
:- use_module(library(cortisol)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the cortisol pack.
:- begin_tests(cortisol).

% Cortisol suppression is 1.0 at baseline and strictly below 1.0 when elevated.
test(suppresses_when_elevated) :-
    % Baseline tone leaves the plasticity gain untouched.
    cortisol_suppression(0.0, S0), S0 =:= 1.0,
    % Elevated tone shrinks the gain below one.
    cortisol_suppression(3.0, S1), S1 < 1.0.

% Cortisol decays toward baseline between events.
test(decays) :-
    % One decay step reduces the tone.
    cortisol_decay(3.0, C), C < 3.0.

% The cortisol CRO is a genuine layer-skip: classified skipping, with no skip-gap.
test(clean_skip) :-
    % Read the semantic classification and skip-gaps.
    cortisol_skip_check(Class, Gaps),
    % It skips ten strata with no gap — the absence of a mechanism is a positive finding.
    Class == skipping, Gaps == [].

% The signed provenance assertion over the skip CRO carries a signature.
test(assertion_signed) :-
    % A signed assertion exists and has a signature field.
    cortisol_signed_assertion(Signed),
    get_dict(signature, Signed, _).

% Cortisol's five structure records are all schema-valid.
test(records_valid) :-
    % Fetch the labelled records.
    cortisol_records(Records),
    % There are exactly five of them.
    length(Records, 5),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% Close the test block.
:- end_tests(cortisol).
