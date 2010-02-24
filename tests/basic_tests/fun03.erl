%%% -*- erlang-indent-level: 2 -*-
%%% $Id: fun03.erl,v 1.1 2006/10/22 12:57:20 mikpe Exp $
%%%
%%% Verify that HiPE handles calling EXPORT and 2-tuple funs.
%%% Also verify that is_function/1 handles EXPORT funs.

-module(fun03).
-export([test/0, compile/1]).
-export([add1/1]).

test() ->
  78 = do_call(add1_as_export(), 77),
  89 = do_call(add1_as_2tuple(), 88),
  true = do_guard(add1_as_export()),
  false = do_guard(add1_as_2tuple()), % 2-tuples do not satisfy is_function/1
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

do_call(F, X) -> F(X).

do_guard(F) when is_function(F) -> true;
do_guard(_) -> false.

add1_as_export() -> fun ?MODULE:add1/1.
add1_as_2tuple() -> {?MODULE,add1}.
add1(X) -> X+1.
