% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%% Test module for testing the HiPE compiler.
%%
%%  Filename :  esmb.erl
%%  Purpose  :  Tests whether the HiPE compiler works by compiling
%%		some files from the "esmb" Jungerl application with
%%		the 'core' option on.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/12/01 08:25:42 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(esmb).
-export([test/0,compile/1]).

test() ->
  file:set_cwd(esmb_src),
  Opts = get_comp_opts(),
  R = [ hc_mod(Mod,[core|Opts]) || Mod <- files() ],
  file:set_cwd('..'),
  R.

hc_mod(Mod,Opts) ->
  CS1 = hipe_bifs:constants_size(),
  io:format("Compiling ~w ...",[Mod]),
  T0 = time_now(),
  Res = hipe:c(Mod,Opts),
  T = time_since(T0) / 1000,
  CS2 = hipe_bifs:constants_size(),
  NatCodeSize = hipe_bifs:code_size(Mod),
  CS = CS2 - CS1,
  io:format(" done in ~.2f secs (~w bytes ++ ~w words)\n",[T,NatCodeSize,CS]),
  {ok,Mod} = Res.

get_comp_opts() ->
  {ok,Tokens,_} = erl_scan:string(os:getenv("HiPE_COMP_OPTS") ++ "."),
  {ok,CompFlags} = erl_parse:parse_term(Tokens),
  CompFlags.

files() ->
  [
    esmb,
    esmb_app,
    esmb_client,
    esmb_rpc,
    esmb_sup,
    iconv,
    md4
  ].

time_now() ->
  T1 = hipe_bifs:get_hrvtime(),
  {time_now,T1}.

time_since({time_now,T1}) ->
  T2 = hipe_bifs:get_hrvtime(),
  T = T2-T1,
  trunc(T).

compile(Options) ->
  hipe:c(?MODULE,Options).
