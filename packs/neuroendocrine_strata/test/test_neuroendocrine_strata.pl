% Test suite for the neuroendocrine_strata pack (the shared stratum ladder).
% Load the neuroendocrine_strata module under test.
:- use_module(library(neuroendocrine_strata)).
% Load PrologAI's schema validator to confirm each stratum is well formed.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the neuroendocrine_strata pack.
:- begin_tests(neuroendocrine_strata).

% The ladder mints exactly five stratum records, each schema-valid.
test(five_strata_valid) :-
    % Fetch the labelled stratum records.
    neuroendocrine_strata_records(Records),
    % There are exactly five of them.
    length(Records, 5),
    % Every record is a schema-valid stratum.
    forall(member(record(_, stratum, Dict), Records),
           co_validate_schema(Dict, stratum, true, [])).

% The synaptic stratum carries ordinal 7 (the anatomy's synaptic level).
test(synaptic_ordinal_is_7) :-
    % Mint the synaptic stratum.
    neuroendocrine_strata_synaptic(S),
    % Its ordinal is 7.
    get_dict(ordinal, S, 7).

% Close the test block.
:- end_tests(neuroendocrine_strata).
