%% This test should be run in a system started with the argument:
%% -pa /more/than/64/characters/here/will/cause/an/error/so/I/need/a/few/more
%%
%% The return value should be a list containing the path above if
%% everything is working.

-module(long_pa).
-export([test/0, compile/1]).

compile(Opts) ->
    hipe:c(?MODULE, Opts).

test() ->
    Args = init:get_arguments(),
    "/more/than/64/characters/here/will/cause/an/error/so/I/need/a/few/more" = 
      get_pa(Args),
    ok.

get_pa([]) ->
    'No pa arg specified';
get_pa([{pa,[PA]}|_]) ->
    PA;
get_pa([_|T]) ->
    get_pa(T).
