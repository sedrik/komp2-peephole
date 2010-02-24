%%------------------------------------------------------------------------
%% File    : trecord3.erl
%% Author  : Kostis Sagonas <kostis@cs.ntua.gr>
%% Purpose : Make sure that type information in records is not lost by
%%	     depth limits in typesig analysis.
%%	     Ideally, the type information maintained and shown to the user
%%	     should look as the specifications below.
%%		- Currently (2007/1/18), it is polluted by 'undefined's
%%		- More importantly, in the return type of mk_moves/2,
%%		  the fact that these are proper #move{} records whose
%%		  fields have known types appears to be lost.
%%		  We want the analysis to propagate this information to
%%		  the users of mk_moves/2.
%%
%% Created : 18 Jan 2007 by Kostis Sagonas <kostis@cs.ntua.gr>
%%------------------------------------------------------------------------
-module(trecord3).
-export([mk_move/2, mk_moves/2]).

-record(const, {value}).
-record(reg, {name :: integer()}).
-record(var, {name :: integer()}).

-record(move, {dst :: #var{} | #reg{}, src :: #var{} | #reg{} | #const{}}).

%% @spec (#reg{} | #var{},#const{} | #reg{} | #var{}) -> #move{}
mk_move(Dst, Src) -> 
  case Src of #var{} -> ok; #reg{} -> ok; #const{} -> ok end,
  #move{dst=Dst, src=Src}.

%% @spec ([#reg{} | #var{}],[#const{} | #reg{} | #var{}]) -> [#move{}])
mk_moves([], []) ->
  [];
mk_moves([X|Xs], [Y|Ys]) ->
  [mk_move(X, Y) | mk_moves(Xs, Ys)].

