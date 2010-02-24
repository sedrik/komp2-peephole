%%--------------------------------------------------------------------------
%% Tests is_record/[2,3] expressions in guards and in bodies.
%% The compilation of the is_record/3 expression with variables,
%% starting from Core used to cause problems which were fixed in March 2006.
%%--------------------------------------------------------------------------

-module(rec1).
-export([test/0, compile/1]).

-record(foo, {f1,f2}).
-record(bar, {b1,b2}).

test() ->
     F = #foo{},
     B = #bar{},
     T = {foo,42},
     {true, true} = {in_guard_2(F), in_guard_3(F)},
     {false, false, false} = {in_guard_2(B), in_guard_2(T), in_guard_3(T)},
     {true, true} = {in_body_2(F, foo), in_body_3(F, foo, size(F))},
     {false, false, false} = {in_body_2(B, foo), in_body_3(F, bar, size(F)),
						 in_body_3(F, foo, size(F)+1)},
     ok.

in_guard_2(R) when is_record(R, foo) -> true;
in_guard_2(_) -> false.

in_guard_3(R) when is_record(R, foo, 3) -> true;
in_guard_3(_) -> false.

in_body_2(R, N) -> is_record(R, N).

in_body_3(R, N, S) -> is_record(R, N, S).

compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
