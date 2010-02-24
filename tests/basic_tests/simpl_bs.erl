%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved
%% ====================================================================
%%  Filename :  simpl_bs.erl
%%  Module   :  simpl_bs
%%  Purpose  :  Test binary search of jump-tables.
%%  Notes    :
%%  History  : * 2001-03-08 Erik Johansson (happi@csd.uu.se):
%%               Created.
%%  CVS      :
%%              $Author: richardc $
%%              $Date: 2004/08/20 14:59:34 $
%%              $Revision: 1.5 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_bs).
-export([test/0, compile/1, all/1]).

test() ->
  _Rep = [lists:sort(lists:map(fun(X) ->
				       {hipe_bifs:term_to_word(X),X}
			       end, l(17)))],
  %% io:format("Rep: ~w\n", _Rep),

  {_T,R} = timer:tc(?MODULE,all,[17]),
  %% io:format("Time: ~w\n",[_T]),
  R.

compile(Opts0) ->
  case proplists:get_bool(core, Opts0) of
    true ->
	test:note(?MODULE, "disabling compilation from core - BUG"),
	Opts = [{core,false}|Opts0];
    false ->
	Opts = Opts0
  end,
  hipe:c(?MODULE, Opts).


all(0) ->
  [t(0)];
all(N) ->
  [t(N)|all(N-1)].

t(N) ->
  loop(f(N),l(N)).

loop(F,L) ->
  lists:map(F,L).

s0(X) ->
  case X of
    _ -> 0
  end.

s1(X) ->
  case X of
    a -> 1;
    _ -> 0
  end.

s2(X) ->
  case X of
    a -> 1;
    b -> 2;
    _ -> 0
  end.

s3(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    _ -> 0
  end.

s4(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    _ -> 0
  end.

s5(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    _ -> 0
  end.

s6(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    _ -> 0
  end.

s7(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    _ -> 0
  end.

s8(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    _ -> 0
  end.

s9(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    _ -> 0
  end.

s10(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    _ -> 0
  end.

s11(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    _ -> 0
  end.

s12(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    _ -> 0
  end.


s13(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    _ -> 0
  end.

s14(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    n -> 14;
    _ -> 0
  end.

s15(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    n -> 14;
    o -> 15;
    _ -> 0
  end.

s16(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    n -> 14;
    o -> 15;
    p -> 16;
    _ -> 0
  end.

s17(X) ->
  case X of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    n -> 14;
    o -> 15;
    p -> 16;
    q -> 17;
    _ -> 0
  end.

f(N) ->
  case N of
    0 -> fun(X) -> {X,s0(X)} end;
    1 -> fun(X) -> {X,s1(X)} end;
    2 -> fun(X) -> {X,s2(X)} end;
    3 -> fun(X) -> {X,s3(X)} end;
    4 -> fun(X) -> {X,s4(X)} end;
    5 -> fun(X) -> {X,s5(X)} end;
    6 -> fun(X) -> {X,s6(X)} end;
    7 -> fun(X) -> {X,s7(X)} end;
    8 -> fun(X) -> {X,s8(X)} end;
    9 -> fun(X) -> {X,s9(X)} end;
    10 -> fun(X) -> {X,s10(X)} end;
    11 -> fun(X) -> {X,s11(X)} end;
    12 -> fun(X) -> {X,s12(X)} end;
    13 -> fun(X) -> {X,s13(X)} end;
    14 -> fun(X) -> {X,s14(X)} end;
    15 -> fun(X) -> {X,s15(X)} end;
    16 -> fun(X) -> {X,s16(X)} end;
    17 -> fun(X) -> {X,s17(X)} end
  end.


l(0) ->
  [default];
l(N) ->
  [atom(N)|l(N-1)].

atom(N) ->
  list_to_atom([$`+N]).


