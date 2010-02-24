%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/17 19:28:05 happi>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test11.erl
%%  Module   :	test11
%%  Purpose  :  Tests tuples and the BIFs:
%%
%%               size(Tuple)
%%               element/2
%%               setelement/3
%%               tuple_to_list/1
%%               list_to_tuple/1
%%
%%  Notes    :  Original author: 'bjorn@erix.ericsson.se'
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2009/06/22 06:46:03 $
%%    $Revision: 1.8 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler options Opts.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test11).
-export([test/0,compile/1]).

test() ->
    {t_tuple_to_list(),
     build_and_match(), t_size(),
     t_list_to_tuple(), t_list_to_tuple(),
     t_element(), t_setelement(3),
     tuple_with_case(), tuple_in_guard({a, b}, {a, b, c}),
     true}.

compile(Opts) ->
    hipe:c(?MODULE, Opts).

build_and_match() ->
    {} = {},
    {1} = {1},
    {1, 2} = {1, 2},
    {1, 2, 3} = {1, 2, 3},
    {1, 2, 3, 4} = {1, 2, 3, 4},
    {1, 2, 3, 4, 5} = {1, 2, 3, 4, 5},
    {1, 2, 3, 4, 5, 6} = {1, 2, 3, 4, 5, 6},
    {1, 2, 3, 4, 5, 6} = {1, 2, 3, 4, 5, 6},
    {1, 2, 3, 4, 5, 6, 7} = {1, 2, 3, 4, 5, 6, 7},
    {1, 2, 3, 4, 5, 6, 7, 8} = {1, 2, 3, 4, 5, 6, 7, 8},
    ok.

%% Tests size(Tuple).
t_size() ->
    0 = size({}),
    1 = size({a}),
    1 = size({{a}}),
    2 = size({{a}, {b}}),
    3 = size({1, 2, 3}),
    ok.

%% Tests element/2.
t_element() ->
    a = element(1, {a}),
    a = element(1, {a, b}),

    List = lists:seq(1, 4096),
    Tuple = list_to_tuple(lists:seq(1, 4096)),
    get_elements(List, Tuple, 1),
 
    {'EXIT', _} = (catch my_element(0, {a, b})),
    {'EXIT', _} = (catch my_element(3, {a, b})),
    {'EXIT', _} = (catch my_element(1, {})),
    {'EXIT', _} = (catch my_element(1, [a, b])),
    {'EXIT', _} = (catch my_element(1, 42)),
    {'EXIT', _} = (catch my_element(1.5, {a, b})),
    ok.

my_element(Pos, Term) ->
    element(Pos, Term).

get_elements([Element|Rest], Tuple, Pos) ->
    Element = element(Pos, Tuple),
    get_elements(Rest, Tuple, Pos+1);
get_elements([], _Tuple, _Pos) ->
    ok.
    
%% Tests set_element/3.
t_setelement(Three) ->
    {x} = setelement(1, {1}, x),
    {x, 2} = setelement(1, {1, 2}, x),
    {1, x} = setelement(2, {1, 2}, x),
    
    Tuple = list_to_tuple(lists:duplicate(2048, x)),
    NewTuple = set_all_elements(Tuple, 1),
    NewTuple = list_to_tuple(lists:seq(1+7, 2048+7)),
 
    %% the following cases were rewritten to use the Three
    %% variable in this weird way so as to silence the compiler
    {'EXIT', _} = (catch setelement(Three - Three, {a, b}, x)),
    {'EXIT', _} = (catch setelement(Three, {a, b}, x)),
    {'EXIT', _} = (catch setelement(Three div Three, {}, x)),
    {'EXIT', _} = (catch setelement(Three div Three, [a, b], x)),
    {'EXIT', _} = (catch setelement(Three / 2, {a, b}, x)),
    ok.

set_all_elements(Tuple, Pos) when Pos =< size(Tuple) ->
    set_all_elements(setelement(Pos, Tuple, Pos+7), Pos+1);
set_all_elements(Tuple, Pos) when Pos > size(Tuple) ->
    Tuple.

%% Tests list_to_tuple/1.
t_list_to_tuple() ->
    {} = list_to_tuple([]),
    {a} = list_to_tuple([a]),
    {a, b} = list_to_tuple([a, b]),
    {a, b, c} = list_to_tuple([a, b, c]),
    {a, b, c, d} = list_to_tuple([a, b, c, d]),
    {a, b, c, d, e} = list_to_tuple([a, b, c, d, e]),
    
    Size = 4096,
    Tuple = list_to_tuple(lists:seq(1, Size)),
    Size = size(Tuple),

    {'EXIT', _} = (catch my_list_to_tuple({a, b})),
    {'EXIT', _} = (catch my_list_to_tuple([a|b])),
    {'EXIT', _} = (catch my_list_to_tuple([a|b])),

    ok.

my_list_to_tuple(X) ->
    list_to_tuple(X).

%% Tests tuple_to_list/1.
t_tuple_to_list() ->
    [] = tuple_to_list({}),
    [a] = tuple_to_list({a}),
    [a, b] = tuple_to_list({a, b}),
    [a, b, c] = tuple_to_list({a, b, c}),
    [a, b, c, d] = tuple_to_list({a, b, c, d}),
    [a, b, c, d] = tuple_to_list({a, b, c, d}),
    
    Size = 4096,
    List = lists:seq(1, Size),
    Tuple = list_to_tuple(List),
    Size = size(Tuple),
    List = tuple_to_list(Tuple),

    {'EXIT', _} = (catch my_tuple_to_list(a)),
    {'EXIT', _} = (catch my_tuple_to_list(42)),
    ok.

my_tuple_to_list(X) ->
    tuple_to_list(X).

%% Tests that a case nested inside a tuple is ok.
%% (This is known to crash earlier versions of BEAM.)
tuple_with_case() ->
    {reply, true} = tuple_with_case2(),
    ok.

tuple_with_case2() ->
    %% The following comments apply to the BEAM compiler.
    foo(),                            % Reset var count.
    {reply,                           % Compiler will choose {x,1} for tuple.
     case foo() of                    % Call will reset var count.
         {'EXIT', Reason} ->	      % Case will return in {x,1} (first free).
             {error, Reason};         % but the tuple will be build in {x,1},
         _ ->                         % so case value is lost and a circular
             true                     % data element is built.
     end}.

foo() -> ignored.

%% Test to build a tuple in a guard.
tuple_in_guard(Tuple1, Tuple2) ->
    %% Tuple1 = {a, b},
    %% Tuple2 = {a, b, c},
    if
	Tuple1 == {element(1, Tuple2), element(2, Tuple2)} ->
	    ok;
	true ->
	    test_server:fail()
    end,
    if
	Tuple2 == {element(1, Tuple2), element(2, Tuple2),
		   element(3, Tuple2)} ->
	    ok;
	true ->
	    test_server:fail()
    end,
    ok.
