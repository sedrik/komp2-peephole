%%-------------------------------------------------------------------
%% File    : bool1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests correct solving of constraints involving funs.
%%
%% Created : 8 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(bool1).
-export([and1/2, and2/2, and3/2]).

and1(true,true) -> true;
and1(false,_) -> false;
and1(_,false) -> false.

and2(true,true) -> true;
and2(false,X) when is_boolean(X) -> false;
and2(X,false) when is_boolean(X) -> false.

and3(X,X) when X -> X;
and3(X,Y) when is_boolean(X) and is_boolean(Y) -> false.

