%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2001-03-22 18:37:37 richardc>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test09.erl
%%  Module   :	test09
%%  Purpose  :  Tests nested constructions.
%%  Notes    :  Original author: bjorn@erix.ericsson.se
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/05/04 22:22:13 $
%%    $Revision: 1.5 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test09).
-export([test/0,compile/1]).

test() ->
    {case_in_case(),case_in_after()}.

compile(Opts) ->
    hipe:c(?MODULE,Opts).

case_in_case() ->
    done = search_any([a], [{a,1}]),
    done = search_any([x], [{a,1}]),
    ok.

search_any([Key|Rest], List) ->
    case case keysearch(Key, 1, List) of
	     {value, _} -> 
		 true;
	     _ ->
		 false
	 end of
	true ->
	    ok;
	false ->
	    error;
	Other ->
	    exit({other_result, Other})
    end,
    search_any(Rest, List);
search_any([], _) ->
    done.

case_in_after() ->
    receive
    after case {x, y, z} of
	      {x, y, z} -> 0
	  end ->
	    ok
    end,
    ok.

keysearch(Key, N, [H|_]) when element(N,H) == Key ->
    {value, H};
keysearch(Key, N, [_|T]) ->
    keysearch(Key, N, T);
keysearch(_Key, _N, []) -> false.
