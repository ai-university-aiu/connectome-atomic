% Test suite for the nigrostriatal_conduit interface pack.
% Load the nigrostriatal_conduit module under test.
:- use_module(library(nigrostriatal_conduit)).
% Load PrologAI's schema validator for the structure records.
:- use_module(library(schema_check)).
% Load the PLUnit testing framework.
:- use_module(library(plunit)).
% Load list utilities.
:- use_module(library(lists)).

% Open the test block for the nigrostriatal_conduit pack.
:- begin_tests(nigrostriatal_conduit).

% The interface's three structure records are all schema-valid.
test(records_valid) :-
    % Fetch the labelled records.
    nigrostriatal_conduit_records(Records),
    % There are exactly three of them.
    length(Records, 3),
    % Each validates against its kind's schema.
    forall(member(record(_, Kind, Dict), Records),
           co_validate_schema(Dict, Kind, true, [])).

% The conduit is TRANSMISSIVE: it carries NO transform (a perfect wire suffices).
test(conduit_is_transmissive) :-
    % Mint the conduit record.
    nigrostriatal_conduit_conduit(K),
    % It has no transform field (the mark of a transmissive conduit).
    \+ get_dict(transform, K, _).

% Close the test block.
:- end_tests(nigrostriatal_conduit).
