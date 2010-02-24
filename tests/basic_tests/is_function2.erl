%%-------------------------------------------------------------------
%% File    : is_function2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests the new is_function/2 guard and BIF.
%%
%% Created : 6 Jul 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(is_function2).
-export([test/0, compile/1]).

%% -export([two_tuple_as_fun/2, three_tuple_as_fun/3]).

test() ->
  ok = test_guard(),
  ok = test_guard2(),
  ok = test_call(),
  ok.

%%---------------------------------------------------------------

test_guard() ->
  zero_fun = test_f(fun() -> ok end),
  unary_fun = test_f(fun(X) -> X end),
  binary_fun = test_f(fun(X,Y) -> {X,Y} end),
  no_fun = test_f(gazonk),
  %% R = test_f({?MODULE, two_tuple_as_fun}),
  %% R = test_f({?MODULE, three_tuple_as_fun}),
  ok.

test_f(Fun) when is_function(Fun,0) ->
  zero_fun;
test_f(Fun) when is_function(Fun,1) ->
  unary_fun;
test_f(Fun) when is_function(Fun,2) ->
  binary_fun;
test_f(_) ->
  no_fun.

%% two_tuple_as_fun(X,Y) ->
%%   {X,Y}.
%% 
%% three_tuple_as_fun(X,Y,Z) ->
%%   {X,Y,Z}.

%%---------------------------------------------------------------

test_guard2() ->
  zero_fun = test_f_n(fun() -> ok end, 0),
  unary_fun = test_f_n(fun(X) -> X end, 1),
  binary_fun = test_f_n(fun(X,Y) -> {X,Y} end, 2),
  no_fun = test_f_n(gazonk, 0),
  ok.

test_f_n(F, N) when is_function(F,N) ->
  case N of
    0 -> zero_fun;
    1 -> unary_fun;
    2 -> binary_fun
  end;
test_f_n(_, _) -> no_fun.

%%---------------------------------------------------------------

test_call() ->
  true  = test_fn(fun(X,Y) -> {X,Y} end, 2),
  false = test_fn(fun(X,Y) -> {X,Y} end, 3),
  false = test_fn(gazonk, 2),
  {'EXIT',{badarg,_TRACE1}} = (catch test_fn(gazonk, gazonk)),
  {'EXIT',{badarg,_TRACE2}} = (catch test_fn(fun(X,Y) -> {X,Y} end, gazonk)),
  ok.

test_fn(F, N) ->
  is_function(F, N).

compile(Options) ->
  hipe:c(?MODULE, Options).
