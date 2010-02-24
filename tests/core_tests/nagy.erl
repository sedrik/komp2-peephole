%%--------------------------------------------------------------------------
%% The BEAM compiler, in its Core Erlang passes, gets confused by the
%% presence of new lines, in the middle of pattern matching operations.
%%
%% The following program used to spit out a warning when compiled
%% by the R10B-8 BEAM compiler that a matching will fail.  Turns out
%% there was some assumption that the representations of 'simple' things
%% like constants will match, if they should match as patterns
%%
%% Reported by Peter Nagy (Ericsson, Hungary) and fixed by Richard Carlsson.
%% Test program by Kostis Sagonas.
%%--------------------------------------------------------------------------

-module(nagy).
-export([test/0, compile/1]).

-record(rec, {f1,f2}).

test() ->
     [#rec{f1 = A}]	%% do not remove this line break
	 = [TRec] = [#rec{f1 = a}],
     TRec1 = TRec#rec{f2 = b},
     {{rec,a,b},{rec,a,undefined},a} = {TRec1,TRec,A},
     ok.

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
