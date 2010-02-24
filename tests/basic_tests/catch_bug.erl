%% This was a bug posted on the Erlang mailing list with the following
%% description:
%%
%%    Given the module below and the function call
%% 	"catch_bug:start_link(foo)."
%%    from the Erlang shell, why does Erlang crash with "Catch not found"?
%%
%% The BEAM compiler was generating wrong code for this case; this has
%% been fixed in R9C-0.  Native code generation was OK.
 
-module(catch_bug).
-behaviour(gen_server).
-export([test/0,compile/1,start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

test() ->
    start_link(foo).

start_link(Param) ->
    gen_server:start_link(?MODULE, Param, []).

init(Param) ->
    process_flag(trap_exit, true),
    (catch begin
             foo(Param),
             (catch exit(bar))
           end
    ),
    ignore.

foo(_) -> ok.

handle_call(_Call, _From, State) -> {noreply, State}.
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Msg, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

compile(Flags) ->
    hipe:c(?MODULE,Flags).

