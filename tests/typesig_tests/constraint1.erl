%%-------------------------------------------------------------------
%% File    : constraint1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : Tests propagation and satisfaction of type constraints.
%%
%% Created : 1 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(constraint1).
%% Currently, all functions are exported but this is a fluke
-export([is_foo_bar_record/1, is_foo_bar_tuple/1,
	 middle_element_of_bin_1/1, middle_element_of_bin_2/1,
	 unsatisfiable_1/1, unsatisfiable_2/1,
	 unsatisfiable_3/1, unsatisfiable_4/1]).

-record(foo, {atom, num}).

is_foo_bar_record(B) when is_record(B, foo) ->
    42 = B#foo.num,
    bar == element(2,B).

is_foo_bar_tuple(B) when size(B) == 5 ->
    foo == element(1,B),
    bar == element(2,B).

%%
%% The following two should have similar type specifications.
%%

middle_element_of_bin_1(B) ->
    {_B1,B2} = split_binary(B, size(B) div 2),
    hd(binary_to_list(B2)).

middle_element_of_bin_2(B) when size(B) > 2 ->
    {_B1,B2} = split_binary(B, size(B) div 2),
    <<H,_/binary>> = B2,
    H.

%% The remaining ones have unatisfiable type constraints. (Although
%% perhaps it is too difficult to infer the unsatisfiability of the
%% first two.)

unsatisfiable_1(B) when size(B) < 2 ->
    bar == element(3,B).

unsatisfiable_2(B) when size(B) < 2 ->
    <<_A/integer,42,_R/binary>> = B.

%% Surprisingly, both analyses get the following two wrong in
%% different ways... hmmm.
unsatisfiable_3(B) when size(B) < 2 ->
    L = binary_to_list(B),
    B = list_to_tuple(L).

unsatisfiable_4(B) ->
    L = binary_to_list(B),
    B = list_to_atom(L).
