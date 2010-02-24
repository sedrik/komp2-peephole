%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename : 	test10.erl
%%  Module   :	test10
%%  Purpose  :  Tests the BIFs:  
%%          	 abs/1
%%               float/1
%%	         float_to_list/1
%%	         integer_to_list/1
%%	         list_to_float/1
%%	         list_to_integer/1
%%      	 round/1
%%      	 trunc/1
%%  Notes    :  Original author bjorn@erix.ericsson.se
%%  History  :	* 1999-12-05 Erik Johansson (happi@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2007/09/23 10:50:17 $
%%    $Revision: 1.5 $
%% ====================================================================
%% Exported functions (short description):
%%  test()         - execute the test.
%%  compile(Flags) - Compile to native code with compiler flags Flags.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(test10).
-export([test/0,compile/1]).

test() ->
    [
     t_abs(),
     t_float(), 
     t_float_to_list(),
     t_integer_to_list(),
     t_list_to_integer(),
     t_list_to_float_safe(), 
     t_list_to_float_risky(),
     t_round(), 
     t_trunc()
    ].

compile(Flags) ->
    hipe:c(?MODULE,Flags).

%------------------------------------------------------------------------

t_abs() ->
    %% Floats.
    5.5 = abs(5.5),
    0.0 = abs(0.0),
    100.0 = abs(-100.0),
    
    %% Integers.
    5 = abs(5),
    0 = abs(0),
    100 = abs(-100),
    
    %% Bignums.
    BigNum = 13984792374983749,
    BigNum = abs(BigNum),
    BigNum = abs(-BigNum),
    ok.
    
t_float() ->
    0.0 = float(0),
    2.5 = float(2.5),
    0.0 = float(0.0),
    -100.55 = float(-100.55),
     42.0 = float(42),
    -100.0 = float(-100),
    
    %% Bignums.
    4294967305.0 = float(4294967305),
    -4294967305.0 = float(-4294967305),
    
    %% Extremly big bignums.
    Big = list_to_integer(duplicate(2000, $1)),
    {'EXIT', _} = (catch float(Big)),
    
    %% Invalid types and lists.
    {'EXIT', _} = (catch my_list_to_integer(atom)),
    {'EXIT', _} = (catch my_list_to_integer(123)),
    {'EXIT', _} = (catch my_list_to_integer([$1, [$2]])),
    {'EXIT', _} = (catch my_list_to_integer("1.2")),
    {'EXIT', _} = (catch my_list_to_integer("a")),
    {'EXIT', _} = (catch my_list_to_integer("")),
    ok.

my_list_to_integer(X) ->
    list_to_integer(X).

%% Tests float_to_list/1.

t_float_to_list() ->
    test_ftl("0.0e+0", 0.0),
    test_ftl("2.5e+1", 25.0),
    test_ftl("2.5e+0", 2.5),
    test_ftl("2.5e-1", 0.25),
    test_ftl("-3.5e+17", -350.0e15),
    ok.

test_ftl(Expect, Float) ->
    %% No  on the next line -- we want the line number from t_float_to_list.
    Expect = remove_zeros(reverse(float_to_list(Float)), []).

%% Removes any non-significant zeros in a floating point number.
%% Example: 2.500000e+01 -> 2.5e+1

remove_zeros([$+, $e|Rest], [$0, X|Result]) ->
    remove_zeros([$+, $e|Rest], [X|Result]);
remove_zeros([$-, $e|Rest], [$0, X|Result]) ->
    remove_zeros([$-, $e|Rest], [X|Result]);
remove_zeros([$0, $.|Rest], [$e|Result]) ->
    remove_zeros(Rest, [$., $0, $e|Result]);
remove_zeros([$0|Rest], [$e|Result]) ->
    remove_zeros(Rest, [$e|Result]);
remove_zeros([Char|Rest], Result) ->
    remove_zeros(Rest, [Char|Result]);
remove_zeros([], Result) ->
    Result.

%% Tests integer_to_list/1.

t_integer_to_list() ->
    "0" = integer_to_list(0),
    "42" = integer_to_list(42),
    "-42" = integer_to_list(-42),
    "-42" = integer_to_list(-42),
    "32768" = integer_to_list(32768),
    "268435455" = integer_to_list(268435455),
    "-268435455" = integer_to_list(-268435455),
    "123456932798748738738" = integer_to_list(123456932798748738738),
    Big_List = duplicate(2000, $1),
    Big = list_to_integer(Big_List),
    Big_List = integer_to_list(Big),
    ok.

%% Tests list_to_float/1.

t_list_to_float_safe() ->
    0.0 = list_to_float("0.0"),
    0.0 = list_to_float("-0.0"),
    0.5 = list_to_float("0.5"),
    -0.5 = list_to_float("-0.5"),
    100.0 = list_to_float("1.0e2"),
    127.5 = list_to_float("127.5"),
    -199.5 = list_to_float("-199.5"),
    
    {'EXIT', _} = (catch my_list_to_float("0")),
    {'EXIT', _} = (catch my_list_to_float("0..0")),
    {'EXIT', _} = (catch my_list_to_float("0e12")),
    {'EXIT', _} = (catch my_list_to_float("--0.0")),
%%    {'EXIT', {arg, _}} = (catch list_to_float("0.0e+99999999")),
    ok.

my_list_to_float(X) ->
    list_to_float(X).

%% This might crash the emulator...
%% (Known to crash the Unix version of Erlang 4.4.1)

t_list_to_float_risky() ->
    Many_Ones = duplicate(25000, $1),
    ok = case list_to_float("2."++Many_Ones) of
           F when is_float(F), 0.0 < F, F =< 3.14 -> ok
	 end,
    {'EXIT', _} = (catch list_to_float("2"++Many_Ones)),
    ok.

%% Tests list_to_integer/1.

t_list_to_integer() ->
    0 = list_to_integer("0"),
    0 = list_to_integer("00"),
    0 = list_to_integer("-0"),
    1 = list_to_integer("1"),
    -1 = list_to_integer("-1"),
    42 = list_to_integer("42"),
    -12 = list_to_integer("-12"),
    32768 = list_to_integer("32768"),
    268435455 = list_to_integer("268435455"),
    -268435455 = list_to_integer("-268435455"),
    
    %% Bignums.
    123456932798748738738 = list_to_integer("123456932798748738738"),
    case list_to_integer(duplicate(2000, $1)) of
      I when is_integer(I), I > 123456932798748738738 -> ok
    end.

%% Tests round/1.

t_round() ->
    0 = round(0.0),
    0 = round(0.4),
    1 = round(0.5),
    0 = round(-0.4),
    -1 = round(-0.5),
    255 = round(255.3),
    256 = round(255.6),
    -1033 = round(-1033.3),
    -1034 = round(-1033.6),
    
    %% Bignums.
    4294967296 = round(4294967296.1),
    4294967297 = round(4294967296.9),
    -4294967296 = -round(4294967296.1),
    -4294967297 = -round(4294967296.9),
    ok.

t_trunc() ->
    0 = trunc(0.0),
    
    5 = trunc(5.3333),
    -10 = trunc(-10.978987),
    
    %% Bignums.
    4294967305 = trunc(4294967305.7),
    -4294967305 = trunc(-4294967305.7),
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local lists functions....

duplicate(N, X) when is_integer(N), N >= 0 ->
    duplicate(N, X, []).

duplicate(0, _, L) -> L;
duplicate(N, X, L) -> duplicate(N-1, X, [X|L]).

reverse(X) ->
    reverse(X, []).

reverse([H|T], Y) ->
    reverse(T, [H|Y]);
reverse([], X) -> X.
