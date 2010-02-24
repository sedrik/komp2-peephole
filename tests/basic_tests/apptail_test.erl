%%% $Id: apptail_test.erl,v 1.3 2004/04/02 10:22:45 mikpe Exp $
%%% Check that apply is tail-recursive.
%%
%%% NOTE: Increased the SIZE_INCREASE from 20 to 30 so that it
%%%	  can also be tested with the naive register allocator.

-module(apptail_test).
-export([test/0, compile/1]).
-export([app0/2]).

-define(SIZE_INCREASE, 30).

compile(Flags) ->
    hipe:c(?MODULE, Flags).

test() ->
    Inc = start(400),
    %% io:format("Inc ~w\n", [Inc]),
    if Inc > ?SIZE_INCREASE ->
	 exit(?MODULE);
       true -> []
    end,
    ok.

start(N) ->
    app0(N, hipe_bifs:nstack_used_size()).

app0(0, Size0) ->
    hipe_bifs:nstack_used_size() - Size0;
app0(N, Size) ->
    apply(?MODULE, app0, [N-1, Size]).
