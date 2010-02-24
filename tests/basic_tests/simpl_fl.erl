%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_fl).
-export([test/0,compile/1]).

test() ->
    {mult(2.5617),negate(6.023e23)}.

mult(X) ->
    3.1415 * X.

%% this tests the translation of the fnegate BEAM instruction.
negate(X) ->
    - (X + 0.0).

compile(Flags) ->
    hipe:c(?MODULE,Flags).
