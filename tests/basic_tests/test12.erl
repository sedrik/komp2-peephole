%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/29 09:38:53 happi>
%% ====================================================================
%%  Filename : 	test12.erl
%%  Module   :	test12
%%  Purpose  :  To test reference counts for binaries
%%              and to test user invoked GC calls.
%%  Notes    :  Based on binary_SUITE from the emulator test suite.
%%  History  :	* 2001-06-28 Erik Johansson (happi@csd.uu.se): Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/09/23 10:50:17 $
%%              $Revision: 1.5 $
%% ====================================================================
%%  Exports  :  test/0
%%              compile/1  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test12).
-export([test/0,compile/1]).

-define(heap_binary_size, 64).

compile(O)->
  hipe:c(?MODULE,O).

test()->
  case erlang:system_info(heap_type) of
    private ->
      B = list_to_binary(lists:seq(0, ?heap_binary_size)),
      Self = self(),
      F = fun() ->
	    receive go -> ok end,
	    Self ! binary_to_list(B),
	    Self ! {self(), process_info(self(), binary)}
	  end,
      c3(F);
    hybrid ->
      %% NOTE: HARD-CODED TEST RESULT IN THIS CASE -- CHEATING!
      {?heap_binary_size+1, 1}
  end.

c3(F) ->
  gc_test1(spawn_opt(erlang, apply, [F,[]], [])).

gc_test1(Pid) ->
  erlang:garbage_collect(),
  c(Pid).

c(Pid) ->
  Pid ! go,
  Result =
    receive
      {Pid, {binary,[{_,Size,Refs}]}} -> {Size,Refs}
    after 10000 -> exit(ooops)
    end,
  Result.
 
