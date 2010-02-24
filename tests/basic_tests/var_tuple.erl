%%
%% Checks that the HiPE compiler does not get confused by constant
%% data structures that resemble the internal compiler data structures.
%%

-module(var_tuple).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  t([foo]).

t([_|_]) ->
  t({var,atom});
t(_) ->
  ok.

