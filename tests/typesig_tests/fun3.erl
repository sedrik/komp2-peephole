-module(fun3).
-export([l/1, l_fun/1]).

l(List) -> l(List, 0).

l(List, L) -> 
  case List of
    [] when is_integer(L) -> L;
    [_|T] -> l(T, L+1)
  end.

l_fun(List) -> l_fun(fun() -> List end, 0).

l_fun(FunList, L) ->
  case FunList() of
    [] when is_integer(L) -> L;
    [_|T] -> l_fun(fun() -> T end, L+1)
  end.
