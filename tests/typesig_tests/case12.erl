%%%-------------------------------------------------------------------
%%% File    : case12.erl
%%% Author  : Tobias Lindahl <tobiasl@csd.uu.se>
%%% Description : Excercises the mechanism to find the possible clauses.
%%%
%%% Created : 23 Jan 2007 by Tobias Lindahl <tobiasl@csd.uu.se>
%%%-------------------------------------------------------------------
-module(case12).

-export([t1/1, t2/1]).

t1(X) ->
  t2(X),
  t4(t3(X)).
  
t2(X) ->
  case element(1, X) of
    a -> {a, _} = X, i_dont_want_to_be_alone;
    b -> {b, _} = X, i_dont_want_to_be_alone;
    c -> {c, _} = X, i_dont_want_to_be_alone;
    d -> {d, _, _} = X, i_dont_want_to_be_alone;
    e -> {e, _, _} = X, i_dont_want_to_be_alone;
    f -> {f, _, _} = X, i_dont_want_to_be_alone;
    g -> {g, _, _, _} = X, i_dont_want_to_be_alone;
    h -> {h, _, _, _} = X, i_dont_want_to_be_alone;
    i -> {i, _, _, _} = X, i_will_be_your_friend;
    j -> {j, _, _, _} = X, i_will_be_your_friend
  end.

t3(X) ->
  case element(1, X) of
    a -> {a, _}=X;
    b -> {b, _} = X;
    c -> {c, _} = X;
    d -> {d, _, _} = X;
    e -> {e, _, _} = X;
    f -> {f, _, _} = X;
    g -> {g, _, _, _} = X;
    h -> {h, _, _, _} = X;
    i -> {i, _, _, _} = X;
    j -> {j, _, _, _} = X
  end.
      
t4(X) ->
  case element(1, X) of
    a -> {a, _} = X, i_dont_want_to_be_alone;
    b -> {b, _} = X, i_dont_want_to_be_alone;
    c -> {c, _} = X, i_dont_want_to_be_alone;
    d -> {d, _, _} = X, i_dont_want_to_be_alone;
    e -> {e, _, _} = X, i_dont_want_to_be_alone;
    f -> {f, _, _} = X, i_dont_want_to_be_alone;
    g -> {g, _, _, _} = X, i_dont_want_to_be_alone;
    h -> {h, _, _, _} = X, i_dont_want_to_be_alone;
    i -> {i, _, _, _} = X, i_will_be_your_friend;
    j -> {j, _, _, _} = X, i_will_be_your_friend
  end.
