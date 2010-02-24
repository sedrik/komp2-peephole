%% Author  : Kostis
%% File    : simpl_se.erl
%% Purpose : To test the compilation of the set_tuple_element
%%	     BEAM instruction

-module(simpl_se).
-export([test/0,compile/1]).

test() ->
    State0 = init_rec(),
    State1 = simple_set(State0, 42),
    odd_set(State1, 21).

-record(rec,{f1,f2,f3,f4,f5}).

init_rec() ->
    #rec{f1=bar,f2=[a,b,c],f3=10,f4={a,b},f5=3.14}.

simple_set(State, Val) ->	  %% f3=Val is the one used in set_element;
    State#rec{f3=Val,f5=Val*2}.   %% this checks the case of variable

odd_set(State, Val) ->		  %% f3=foo is the one used in set_element;
    State#rec{f1=foo,f5=Val*2.0}. %% this checks the case of constant

compile(Flags) ->
    hipe:c(?MODULE,Flags).

