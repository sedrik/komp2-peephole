-module(equal1).
-export([eq1/1, exact_eq1/1, eq2/1, exact_eq2/1]).

eq1(B) when B == foo -> B.

exact_eq1(B) when B =:= foo -> B.


eq2(B) when B == [] -> B.

exact_eq2(B) when B =:= [] -> B.
