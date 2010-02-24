-module(unary_plus_test).
-export([test/0,compile/1]).

test() ->
    list_to_atom([111,107]).	%% temporarily
%    if
%       + false ->
%	weird;
%       + (+ true) ->
%	+ list_to_atom([111,107])
%    end.

compile(Opts) ->
    hipe:c(?MODULE,Opts).
