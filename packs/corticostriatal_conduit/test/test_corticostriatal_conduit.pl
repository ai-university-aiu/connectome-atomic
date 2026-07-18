% Test suite for the corticostriatal_conduit interface pack.
% Load the corticostriatal_conduit module under test.
:- use_module(library(corticostriatal_conduit)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the corticostriatal_conduit pack.
:- begin_tests(corticostriatal_conduit).

% The interface's three structure records are all schema-valid.
test(records_valid) :-
    % Fetch the labelled records.
    corticostriatal_conduit_records(Records),
    % There are exactly three of them.
    length(Records, 3),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% The conduit is COMPUTATIONAL: it carries a transform (the plasticity CRO).
test(conduit_is_computational) :-
    % Mint the conduit record.
    corticostriatal_conduit_conduit(K),
    % It has a transform field (the mark of a computational conduit).
    get_dict(transform, K, _).

% Close the test block.
:- end_tests(corticostriatal_conduit).
