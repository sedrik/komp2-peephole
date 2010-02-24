%%%-------------------------------------------------------------------
%%% File    : bs_send_hybrid.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : 
%%%
%%% Created : 30 Oct 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_send_hybrid).

-export([test/0,compile/1,sleeper/0]).

-define(heap_binary_size, 64).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Self = self(),
  Pid = spawn_link(fun() -> copy_server(Self) end),
  F = fun(Term) ->
	  Pid ! Term,
	  receive
	    Term -> ok;
	    Other ->
	      io:format("Sent: ~P\nGot back:~P", [Term,12,Other,12])
	  end
      end,
  test_terms(F),
  ok.

copy_server(Parent) ->
    receive
	Term ->
	    Parent ! Term,
	    copy_server(Parent)
    end.

test_terms(Test_Func) ->
  Test_Func(atom),
  Test_Func(''),
  Test_Func('a'),
  Test_Func('ab'),
  Test_Func('abc'),
  Test_Func('abcd'),
  Test_Func('abcde'),
  Test_Func('abcdef'),
  Test_Func('abcdefg'),
  Test_Func('abcdefgh'),

  Test_Func({trace_ts,{even_bigger,{some_data,fun() -> ok end}},{1,2,3}}),
  Test_Func({trace_ts,{even_bigger,{some_data,<<1,2,3,4,5,6,7,8,9,10>>}},
	     {1,2,3}}),

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

  Test_Func(make_ref()),
  Test_Func([make_ref(), make_ref()]),

  Test_Func(make_port()),

  Test_Func(make_pid()),

  Test_Func(Bin0 = list_to_binary(lists:seq(0, 14))),
  Test_Func(Bin1 = list_to_binary(lists:seq(0, ?heap_binary_size))),
  Test_Func(Bin2 = list_to_binary(lists:seq(0, ?heap_binary_size+1))),
  Test_Func(Bin3 = list_to_binary(lists:seq(0, 255))),

  Test_Func(make_unaligned_sub_binary(Bin0)),
  Test_Func(make_unaligned_sub_binary(Bin1)),
  Test_Func(make_unaligned_sub_binary(Bin2)),
  Test_Func(make_unaligned_sub_binary(Bin3)),

  Test_Func(make_sub_binary(lists:seq(42, 43))),
  Test_Func(make_sub_binary([42,43,44])),
  Test_Func(make_sub_binary([42,43,44,45])),
  Test_Func(make_sub_binary([42,43,44,45,46])),
  Test_Func(make_sub_binary([42,43,44,45,46,47])),
  Test_Func(make_sub_binary([42,43,44,45,46,47,48])),
  Test_Func(make_sub_binary(lists:seq(42, 49))),
  Test_Func(make_sub_binary(lists:seq(0, 14))),
  Test_Func(make_sub_binary(lists:seq(0, ?heap_binary_size))),
  Test_Func(make_sub_binary(lists:seq(0, ?heap_binary_size+1))),
  Test_Func(make_sub_binary(lists:seq(0, 255))),

  Test_Func(make_unaligned_sub_binary(lists:seq(42, 43))),
  Test_Func(make_unaligned_sub_binary([42,43,44])),
  Test_Func(make_unaligned_sub_binary([42,43,44,45])),
  Test_Func(make_unaligned_sub_binary([42,43,44,45,46])),
  Test_Func(make_unaligned_sub_binary([42,43,44,45,46,47])),
  Test_Func(make_unaligned_sub_binary([42,43,44,45,46,47,48])),
  Test_Func(make_unaligned_sub_binary(lists:seq(42, 49))),
  Test_Func(make_unaligned_sub_binary(lists:seq(0, 14))),
  Test_Func(make_unaligned_sub_binary(lists:seq(0, ?heap_binary_size))),
  Test_Func(make_unaligned_sub_binary(lists:seq(0, ?heap_binary_size+1))),
  Test_Func(make_unaligned_sub_binary(lists:seq(0, 255))),

  Test_Func(F = fun(A) -> 42*A end),
  Test_Func(lists:duplicate(32, F)),

  ok.

make_sub_binary(Bin) when is_binary(Bin) ->
    {_,B} = split_binary(list_to_binary([0,1,3,Bin]), 3),
    B;
make_sub_binary(List) ->
    make_sub_binary(list_to_binary(List)).

make_unaligned_sub_binary(Bin0) when is_binary(Bin0) ->
    Bin1 = <<0:3,Bin0/binary,31:5>>,
    Sz = size(Bin0),
    <<0:3,Bin:Sz/binary,31:5>> = id(Bin1),
    Bin;
make_unaligned_sub_binary(List) ->
    make_unaligned_sub_binary(list_to_binary(List)).

very_big_num() ->
  very_big_num(33, 1).

very_big_num(Left, Result) when Left > 0 ->
  very_big_num(Left-1, Result*256);
very_big_num(0, Result) ->
  Result.

make_port() ->
    open_port({spawn, efile}, [eof]).

make_pid() ->
    spawn_link(?MODULE, sleeper, []).

sleeper() ->
    receive after infinity -> ok end.

id(I) -> I.
