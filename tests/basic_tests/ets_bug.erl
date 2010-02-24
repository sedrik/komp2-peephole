%% This module, if hipe-compiled, used to always crash like this (on SPARC)
%% 
%% (gdb) where
%% #0  fullsweep_heap (p=0x2c60dc, new_sz=610, objv=0xffbee8b4, nobj=3)
%%     at beam/ggc.c:1060
%% #1  0x7ff24 in erts_garbage_collect (p=0x2c60dc, need=2, objv=0x1128fc, nobj=3)
%%     at beam/ggc.c:1648
%% #2  0xab6fc in hipe_mode_switch (p=0x2c60dc, cmd=704512, reg=0x1128fc)
%%     at hipe/hipe_mode_switch.c:180
%% #3  0x8e27c in process_main () at beam/beam_emu.c:3314
%% #4  0x31338 in erl_start (argc=9, argv=0xffbeed5c) at beam/erl_init.c:936
%% #5  0x2d9f4 in main (argc=9, argv=0xffbeed5c) at sys/unix/erl_main.c:28
%%
%% A guess at what could be the problem: From R8, many ets BIFs trap to other
%% ets BIFs with a *different* arity (i.e. they have more or less arguments).
%% I have probably forgotten to mention that subtle change.
%%
%% /Bjorn

-module(ets_bug).
-export([test/0, compile/1]).

test() ->
    Seed = {1032,15890,22716},
    put(random_seed,Seed),
    do_random_test().

do_random_test() ->
    OrdSet = ets:new(xxx,[ordered_set]),
    Set = ets:new(xxx,[]),
    do_n_times(fun() ->
		       Key = create_random_string(25),
		       Value = create_random_tuple(25),
		       ets:insert(OrdSet,{Key,Value}),
		       ets:insert(Set,{Key,Value})
	       end, 5000),
    io:format("~nData inserted~n"),
    do_n_times(fun() ->
		       I = random:uniform(25),
		       Key = create_random_string(I) ++ '_',
		       L1 = ets_match_object(OrdSet,{Key,'_'}),
		       L2 = lists:sort(ets_match_object(Set,{Key,'_'})),
		       case L1 == L2 of
			   false ->
			       io:format("~p != ~p~n",
					 [L1,L2]),
			       exit({not_eq, L1, L2});
			   true ->
			       ok
		       end
	       end,
	       2000),
    io:format("~nData matched~n"),
    ets:match_delete(OrdSet,'_'),
    ets:match_delete(Set,'_'),
    ok.
    
create_random_string(0) ->
    [];
create_random_string(OfLength) ->
    C = case random:uniform(2) of
	1 ->
	    (random:uniform($Z - $A + 1) - 1) + $A;
	_ ->
	    (random:uniform($z - $a + 1) - 1) + $a
	end,
    [C | create_random_string(OfLength - 1)].

create_random_tuple(OfLength) ->
    list_to_tuple(lists:map(fun(X) ->
				    list_to_atom([X])
			    end,create_random_string(OfLength))).

ets_match_object(Tab,Expr) ->
    case random:uniform(2) of
	1 ->
	    ets:match_object(Tab,Expr);
	_ ->
	    match_object_chunked(Tab,Expr)
    end.

match_object_chunked(Tab,Expr) ->
    match_object_chunked_collect(ets:match_object(Tab,Expr,
						  random:uniform(1999) + 1)).
match_object_chunked_collect('$end_of_table') ->
    [];
match_object_chunked_collect({Results, Continuation}) ->
    Results ++ match_object_chunked_collect(ets:match_object(Continuation)).


do_n_times(_,0) ->
    ok;
do_n_times(Fun,N) ->
    Fun(),
    case N rem 1000 of
	0 ->
	    io:format(".");
	_ ->
	    ok
    end,
    do_n_times(Fun,N-1).


compile(O) ->
  hipe:c(?MODULE,O).
