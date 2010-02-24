%% ====================================================================
%%
%% Filename : sccp_bug_1.erl
%% Purpose  : Test program that exhibits a bug in the handling of
%%	      control flow in sparse conditional constant propagation.
%% History  : * 2003-9-30 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2003/09/30 15:51:51 $
%%    $Revision: 1.1 $
%% ====================================================================

-module(sccp_bug_1).
-export([test/0,compile/1]).

-compile([{hipe,[icode_ssa_const_prop]}]).

test() ->
    foo(1, [{1,{ok,[child1,child2]}}]).

compile(Flags) ->
    hipe:c(?MODULE,Flags).

%% This function is the culprit.
foo(Node, DomTree) ->
    {IDom, Children} = case getNode(Node, DomTree) of
                           not_found ->
                               {not_ok,[]};
                           Tuple ->
                               Tuple
                       end,
    box(IDom, Children).

%% Dummy functions just to make the test run.
getNode(N, [{N,Tuple}]) -> Tuple;
getNode(_, _) -> not_found.

box(IDom, Children) ->
   {IDom, Children}.
