%% -*- erlang-indent-level: 2 -*-
%%====================================================================
%% Date: Thu, 27 Jan 2005 10:52:26 +0000
%% From: Peter-Henry Mander <erlang@manderp.freeserve.co.uk>
%% Subject: Compiler crash report
%% 
%% I managed to isolate a non-critical BEAM compilation error.
%% When compiling the following code: 
%%====================================================================

-module(mander_R10compiler_bug).
-export([test/0, compile/1, just_compile_me/0]).

test() -> ok.

just_compile_me() ->
  URI_Before =
  {absoluteURI,
    {scheme,fun() -> nil end},
    {'hier-part',
      {'net-path',
        {srvr,
          {userinfo,nil},
          fun() -> nil end},
        nil},
    {'query',nil}}},

  {absoluteURI,
    {scheme,_},
    {'hier-part',
      {'net-path',
        {srvr,
          {userinfo,nil},
          _HostportBefore},
        nil},
    {'query',nil}}} = URI_Before,

  %% ... some funky code ommitted, not relevant ...

  {absoluteURI,
    {scheme,_},
    {'hier-part',
      {'net-path',
        {srvr,
          {userinfo,nil},
          HostportAfter},
        nil},
    {'query',nil}}} = URI_Before,
  %% NOTE: I intended to write URI_After instead of URI_Before
  %% but the accident revealed that when you add the line below,
  %% it causes internal error in v3_codegen on compilation
  {hostport,{hostname,"HostName"},{port,nil}} = HostportAfter,
  ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

%%====================================================================
%% 12> c(mander_R10compiler_bug).
%% ./mander_R10compiler_bug.erl:none: internal error in v3_codegen;
%% crash reason: {{case_clause,{'EXIT',{function_clause,
%%                                        [{v3_codegen,
%%                                             fetch_reg,
%%                                             ['HostportAfter',[]]},
%%                                         {v3_codegen,move_unsaved,4},
%%                                         {v3_codegen,cg_call_args,4},
%%                                         {v3_codegen,cg_setup_call,4},
%%                                         {v3_codegen,bif_cg,7},
%%                                         {v3_codegen,
%%                                             '-cg_list/5-anonymous-0-',
%%                                             3},
%%                                         {v3_codegen,flatmapfoldl,3},
%%                                         {v3_codegen,flatmapfoldl,3},
%%                                         {v3_codegen,cg_list,5},
%%                                         {v3_codegen,cg_block,5}]}}},
%%               [{compile,'-select_passes/2-anonymous-2-',2},
%%                {compile,'-internal_comp/4-anonymous-1-',2},
%%                {compile,fold_comp,3},
%%                {compile,internal_comp,4},
%%                {compile,internal,3}]}
%% error
%%====================================================================
