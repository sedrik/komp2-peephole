%%-------------------------------------------------------------------
%% File    : trecord2.erl
%% Author  : Kostis Sagonas <kostis@cs.ntua.gr>
%% Purpose : Expose a bug in success typings when type declarations
%%	     in records are involved -- when there is a type for a
%%	     field that is not given a value in the constructor,
%%           its value defaults to 'undefined' and the success typings
%%	     get confused.
%%
%% Created : 19 Dec 2006 by Kostis Sagonas <kostis@cs.ntua.gr>
%%-------------------------------------------------------------------
-module(trecord2).
-export([mk_icode/1]).

-record(icode, {is_closure    :: bool()
	        %% Uncomment below and see what happens
	       ,closure_arity :: integer() % | 'undefined'
	       ,info=[]}).

mk_icode(Closure) when Closure =/= 'undefined' ->
  #icode{is_closure=Closure}.

