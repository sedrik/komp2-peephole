%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename :  simpl_ib.erl
%%  Purpose  :  Tests whether the translation of the is_boolean BEAM
%%		instruction and type guard works.
%%  History  :  * 2004-9-15 Kostis Sagonas (kostis@it.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/09/15 13:54:55 $
%%    $Revision: 1.1 $
%% ====================================================================

-module(simpl_ib).
-export([test/0,compile/1]).

compile(Opts) ->
    hipe:c(?MODULE, Opts).

test() ->
    ok = is_boolean_in_if(),
    ok = is_boolean_in_guard().

is_boolean_in_if() ->
    R1 = t(true),
    R2 = t(false),
    R3 = t(other),
    {ok1,ok2,not_bool} = {R1,R2,R3},
    ok.

is_boolean_in_guard() ->
    G1 = tg(true),
    G2 = tg(false),
    G3 = tg(other),
    {ok,ok,not_bool} = {G1,G2,G3},
    ok.

t(V) ->
    Yes = yes(),	%% just to prevent the optimizer removing this
    if
	%% the following line generates an is_boolean instruction
	V, Yes == yes -> 
	%% while the following one does not (?!)
	% Yes == yes, V ->
	    ok1;
	not(not(not(V))) ->
	    ok2;
	V ->
	    ok3;
	true -> 
	    not_bool
    end.

tg(V) when is_boolean(V) ->
    ok;
tg(_) ->
    not_bool.

yes() -> yes.
