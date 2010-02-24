% -*- erlang-indent-level: 2 -*-
%% ====================================================================
%% Test module for testing the HiPE compiler.
%%
%%  Filename :  wings.erl
%%  Purpose  :  Tests whether the HiPE compiler works by compiling
%%		some files from the "Wings3D" application.
%%		These files used to cause craches or infinite loops
%%		in the HiPE version of mid Feb 2004.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2004/12/01 08:26:53 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(wings).
-export([test/0,compile/1]).

test() ->
  file:set_cwd(wings_src),
  Opts = get_comp_opts(),
  R = [ hc_mod(Mod,Opts) || Mod <- files() ],
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
   wings_ask,		%% was crashing in two places:
			%%  1. in Icode SSA pass (with default compiler options)
			%%  2. in handling binaries in RTL (hipe_rtl_inline_bs_ops)
   wings_auv_matrix,	%% was crashing in un-convert pass of RTL SSA
   wings_e3d__tga,	%% was going into an infinite loop in to_8bitpp/9
   wings_e3d__tif,	%% RTL prop pass took long time in save_image/3
   wings_e3d_image,	%% was going into an infinite loop in bumpmapRow/6
   wings_e3d_q,		%% was craching due to malformed Icode CFG
   wings_e3d_vec,	%% was going into an infinite loop in add/4
   wings_extrude_edge,	%% was going into an infinite loop in bevel_min_limit/3
   wings_pick		%% was craching due to malformed Icode CFG
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
