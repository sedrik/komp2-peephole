%% File   : dial_warns.erl
%% Author : Kostis Sagonas
%%
%% Purpose: To run Dialyzer on the HiPE application and test that
%%          there are no discrepancies that it identifies.
%%
%% $Id: dial_warns.erl,v 1.12 2007/02/05 12:34:12 pergu Exp $
%%

-module(dial_warns).

-export([test/0,compile/1]).

compile(_Options) ->
    ok. %% No native code compilation.

test() ->
    %% remember the current working directory
    {ok,CWD} = file:get_cwd(),

    %% set stuff needed by Dialyzer to work
    OTP_Dir = code:root_dir(),
    Dialyzer_Dir = filename:join([OTP_Dir, "lib", "dialyzer"]),
    InitPlt = filename:join([Dialyzer_Dir, "plt", "dialyzer_init_plt"]),
    true = code:add_path(filename:join(Dialyzer_Dir, "ebin")),
    true = os:putenv("DIALYZER_DIR", Dialyzer_Dir),    

    %% this is the application which is going to be analyzed
    HiPE_Dir = filename:join([OTP_Dir, "lib", "hipe", "ebin"]),
    %% the call to dialyzer changes the current working directory to
    %% the ebin dir of the application which is analyzed
    true = os:putenv("DIALYZER_USE_CALLGRAPH", "true"),
    {ok,[]} = dialyzer:run([{from,byte_code},{files,[HiPE_Dir]},{init_plt,InitPlt}]),
    %% so change the current working dir back to what we started from
    file:set_cwd(CWD),
    ok.

