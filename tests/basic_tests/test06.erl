%% Copyright (c) 1999 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <99/12/17 14:35:15 happi>
%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test06.erl
%%  Module   :	test06
%%  Purpose  :  
%%  Notes    :  Adopted from binary_SUITE by 'bjorn@erix.ericsson.se'
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2010/01/23 11:49:02 $
%%    $Revision: 1.5 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test06).
-export([test/0,compile/1]).

test() ->
    {
      conversions(), 
      deep_lists(), 
      t_split_binary(), 
      t_concat_binary(),
      bad_list_to_binary(), 
      terms(), 
      terms_float(),
%%      bad_terms(), %% Does not seem to work in 4.5.3
      ok
     }.


compile(Flags) ->
    hipe:c(?MODULE,Flags).


%% Tests list_to_binary/1, binary_to_list/1 and size/1,
%% using flat lists.


conversions() ->
    test_bin([]),
    test_bin([1]),
    test_bin([1, 2]),
    test_bin([1, 2, 3]),
    test_bin(lists:seq(0, 255)),
    test_bin(lists:duplicate(50000, $@)),

    %% Binary in list.
    List = [1, 2, 3, 4, 5],
    B1 = list_to_binary(List),
    5 = size(B1),
    B2 = list_to_binary([42, B1, 19]),
    7 = size(B2),
    [42, 1, 2, 3, 4, 5, 19] = binary_to_list(B2),
    
    ok.

test_bin(List) ->
    Size = length(List),
    Bin = list_to_binary(List),
    Size = size(Bin),
    List = binary_to_list(Bin).

%% Tests list_to_binary/1, binary_to_list/1,3 and size/1,
%% using deep lists.

deep_lists() ->
    test_deep_list(["abc"]),
    test_deep_list([[12, 13, [123, 15]]]),
    test_deep_list([[12, 13, [lists:seq(0, 255), []]]]),
    ok.

test_deep_list(List) ->
    Flat_List = lists:flatten(List),
    Size = length(Flat_List),
    Bin = list_to_binary(List),
    Size = size(Bin),
    Flat_List = binary_to_list(Bin),
    t_binary_to_list_3(Flat_List, Bin, 1, Size).

t_binary_to_list_3(List, Bin, From, To) ->
    going_up(List, Bin, From, To),
    going_down(List, Bin, From, To),
    going_center(List, Bin, From, To).

going_up(List, Bin, From, To) when From =< To ->
    List = binary_to_list(Bin, From, To),
    going_up(tl(List), Bin, From+1, To);
going_up(_List, _Bin, From, To) when From > To ->
    ok.
    
going_down(List, Bin, From, To) when To > 0->
    compare(List, binary_to_list(Bin, From, To), To-From+1),
    going_down(List, Bin, From, To-1);
going_down(_List, _Bin, _From, _To) ->
    ok.

going_center(List, Bin, From, To) when From >= To ->
    compare(List, binary_to_list(Bin, From, To), To-From+1),
    going_center(tl(List), Bin, From+1, To-1);
going_center(_List, _Bin, _From, _To) ->
    ok.

compare([X|Rest1], [X|Rest2], Left) when Left > 0 ->
    compare(Rest1, Rest2, Left-1);
compare([_X|_], [_Y|_], _Left) ->
    exit(fail);
compare(_List, [], 0) ->
    ok.

bad_list_to_binary() ->
    test_bad_bin(atom),
    test_bad_bin(42),
    test_bad_bin([1|2]),
    test_bad_bin([256]),
    test_bad_bin([255, [256]]),
    test_bad_bin([-1]),
    test_bad_bin([atom_in_list]),
    ok.

test_bad_bin(List) ->
  {'EXIT', _} = (catch list_to_binary(List)).

%% Tries to split a binary at all possible positions.

t_split_binary() ->
    L = lists:seq(0, 57),
    B = list_to_binary(L),
    split(L, B, size(B)).

split(L, B, Pos) when Pos > 0 ->
    {B1, B2} = split_binary(B, Pos),
    B1 = list_to_binary(lists:sublist(L, 1, Pos)),
    B2 = list_to_binary(lists:nthtail(Pos, L)),
    split(L, B, Pos-1);
split(_L, _B, 0) ->
    ok.

%% Tests concat_binary/2 and size/1.

t_concat_binary() ->
    test_concat([]),
    
    test_concat([[]]),
    test_concat([[], []]),
    test_concat([[], [], []]),
    
    test_concat([[1], []]),
    test_concat([[], [2]]),
    test_concat([[], [3], []]),

    test_concat([[1, 2, 3], [4, 5, 6, 7]]),
    test_concat([[1, 2, 3], [4, 5, 6, 7], [9, 10]]),

    test_concat([lists:seq(0, 255), lists:duplicate(1024, $@),
		 lists:duplicate(2048, $a),
		 lists:duplicate(4000, $b)]),
    ok.

test_concat(Lists) ->
    test_concat(Lists, 0, [], []).

test_concat([List|Rest], Size, Combined, Binaries) ->
    Bin = list_to_binary(List),
    test_concat(Rest, Size+length(List), Combined++List, [Bin|Binaries]);
test_concat([], Size, Combined, Binaries0) ->
    Binaries = lists:reverse(Binaries0),
    Bin = list_to_binary(Binaries),
    Size = size(Bin),
    Combined = binary_to_list(Bin).

%% Tests binary_to_term/1 and term_to_binary/1.

terms() ->
    test_terms(fun(Term) ->
		       Bin = term_to_binary(Term),
		       Term = binary_to_term(Bin)
	       end).

terms_float() ->
    test_floats(fun(Term) ->
			Bin = term_to_binary(Term),
			Term = binary_to_term(Bin)
		end).

%% Tests bad input to binary_to_term/1.
%%
%% XXX Don't expect this to work on 4.4.1 or earlier.

%% bad_terms() ->
%%     test_terms(fun corrupter/1).
			     
%% corrupter(Term) ->
%%     Bin = term_to_binary(Term),
%%     corrupter(Bin, size(Bin)-1).

%% corrupter(Bin, Pos) when Pos >= 0 ->
%%     {Shorter_Bin, _} = split_binary(Bin, Pos),
%%     catch binary_to_term(Shorter_Bin), %% emulator shouldn't crash
%%     Moved_Bin = list_to_binary([Shorter_Bin]),
%%     catch binary_to_term(Moved_Bin), %% emulator shouldn't crash
%%     corrupter(Moved_Bin, Pos-1);
%% corrupter(_Bin, _) ->
%%     ok.

test_terms(Test_Func) ->
    Test_Func(atom),
    Test_Func(''),
    
    Test_Func(1),
    Test_Func(42),
    Test_Func(-23),
    Test_Func(256),
    Test_Func(25555),
    Test_Func(-3333),

    Test_Func(1.0),
    
    Test_Func(183749783987483978498378478393874),
    Test_Func(-37894183749783987483978498378478393874),
    Very_Big = very_big_num(),
    Test_Func(Very_Big),
    Test_Func(-Very_Big+1),

    Test_Func([]),
    Test_Func("abcdef"),
    Test_Func([a, b, 1, 2]),
    Test_Func([a|b]),
    
    Test_Func({}),
    Test_Func({1}),
    Test_Func({a, b}),
    Test_Func({a, b, c}),
    Test_Func(list_to_tuple(lists:seq(0, 255))),
    Test_Func(list_to_tuple(lists:seq(0, 256))),
    Test_Func(list_to_tuple(lists:seq(0, 1024))),
    Test_Func(list_to_tuple(lists:seq(0, 65536))),

    Test_Func(make_ref()),
    Test_Func([make_ref(), make_ref()]),
    
    Test_Func(list_to_binary(lists:seq(0, 255))),

    ok.

test_floats(Test_Func) ->
    Test_Func(5.5),
    Test_Func(-15.32),
    Test_Func(1.2435e25),
    Test_Func(1.2333e-20),
    Test_Func(199.0e+15),
    ok.

very_big_num() ->
    very_big_num(33, 1).

very_big_num(Left, Result) when Left > 0 ->
    very_big_num(Left-1, Result*256);
very_big_num(0, Result) ->
    Result.
