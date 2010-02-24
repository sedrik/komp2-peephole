%%%-------------------------------------------------------------------
%%% File    : bs_bit_shell_tests.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : tests for bit stream operations including matching,
%%%               construction and binary_to_list, list_to_binary in
%%%		  the shell
%%%
%%% Created :  6 Sep 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_bit_shell_tests).

-export([test/0,compile/1,receiver/1,receiver_alot/1,send_alot/3,
	 parse_and_eval/1]).

-compile(bitlevel_binaries).
-compile(binary_comprehension).

compile(O) ->
  hipe:c(erl_eval,O),  %This makes this a test of the hipe compiler
  hipe:c(eval_bits,O), %This makes this a test of the hipe compiler
  hipe:c(?MODULE,O).

parse_and_eval(String) ->
  {ok,Toks,_} = erl_scan:string(String),
  {ok,Exprs} = erl_parse:parse_exprs(Toks),
  Bnds = erl_eval:new_bindings(),
  case erl_eval:exprs(Exprs,Bnds) of
    {value,V,_} ->
      V;
    V -> 
      V
  end.

test() ->
  <<1:100>> = parse_and_eval("<<1:100>> = <<1:100>>."),
  {ok,ok} = {match(7),match(9)},
  {ok,ok} = {match1(15),match1(31)},
  ok = horrid_match(),
  ok = test_bitstr(),
  ok = test_bitsize(),
  ok = unsymmetric_tests(),
  ok = big_unsymmetric_tests(),
  ok = binary_to_and_from_list(),
  ok = big_binary_to_and_from_list(),
  ok = send_and_receive(),
  ok = send_and_receive_alot(),
  ok.

match(N) ->
  <<0:N>> = parse_and_eval("N =" ++ integer_to_list(N) ++",<<0:N>> = <<0:N>>."),
  ok.

match1(N) ->
  <<42:N/little>> = parse_and_eval("N =" ++ integer_to_list(N) ++
				   ",<<42:N/little>> = <<42:N/little>>."),
  ok.

test_bitsize() ->
  101 = parse_and_eval("101 = erlang:bit_size(<<1:101>>)."),
  1001 = parse_and_eval("1001 = erlang:bit_size(<<1:1001>>)."),
  80 = parse_and_eval("80 = erlang:bit_size(<<1:80>>)."),
  800 = parse_and_eval("800 = erlang:bit_size(<<1:800>>)."),
  16#10000001 = parse_and_eval("Bin = <<0:16#1000000>>,
  BigBin = erlang:list_to_bitstring([Bin||_ <- lists:seq(1,16#10)]++[<<1:1>>]),
  16#10000001 = erlang:bit_size(BigBin)."),
  %% Only run these on computers with lots of memory
  %% HugeBin = erlang:list_to_bitstring([BigBin||_ <- lists:seq(1,16#10)]++[<<1:1>>]),
  %% 16#100000011 = erlang:bit_size(HugeBin), 
  0 = parse_and_eval("0 = erlang:bit_size(<<>>)."),
  ok.

horrid_match() ->
  <<42:24/little>> =
    parse_and_eval("<<1:4,B:24/bitstring>> = 
<<1:4,42:24/little>>,<<42:24/little>> = B."), 
  ok.

test_bitstr() ->
  <<1:1,6>> = parse_and_eval("<<1:7,B/bitstring>> = <<1:7,<<1:1,6>>/bitstring>>,
  <<1:1,6>> = B,
  B = <<1:1,6>>."),
  ok.
     
unsymmetric_tests() ->
  <<1:12>> = parse_and_eval("<<1:12>> = <<0,1:4>>."),
  <<0,1:4>> = parse_and_eval("<<0,1:4>> = <<1:12>>."),
  <<1,254,0,0:1>> = parse_and_eval("<<1:1,X/bitstring>> = <<128,255,0,0:2>>,
  <<1,254,0,0:1>> = X, 
  X = <<1,254,0,0:1>>."),
  <<1,254,0,0:1>> = parse_and_eval("<<1:1,X1:25/bitstring>> = <<128,255,0,0:2>>,
  <<1,254,0,0:1>> = X1,
  X1 = <<1,254,0,0:1>>."),
  ok.

big_unsymmetric_tests() ->
  <<1:875,1:12>> = parse_and_eval("<<1:875,1:12>> = <<1:875,0,1:4>>."),
  <<1:875,0,1:4>> = parse_and_eval("<<1:875,0,1:4>> = <<1:875,1:12>>."),
  <<1,254,0,0:1,1:875>> = parse_and_eval("<<1:1,X/bitstring>> = <<128,255,0,0:2,1:875>>,
  <<1,254,0,0:1,1:875>> = X,
  X = <<1,254,0,0:1,1:875>>."),
  parse_and_eval("<<1:1,X1:900/bitstring>> = <<128,255,0,0:2,1:875>>,
  <<1,254,0,0:1,1:875>> = X1,
  X1 = <<1,254,0,0:1,1:875>>."),
  ok.

binary_to_and_from_list() ->
  <<1:7>> = parse_and_eval("erlang:list_to_bitstring(erlang:bitstring_to_list(<<1:7>>))."),
  <<1,2,3,4,1:1>> = parse_and_eval("erlang:list_to_bitstring(erlang:bitstring_to_list(<<1,2,3,4,1:1>>))."),
  [1,2,3,4,<<1:1>>] = parse_and_eval("erlang:bitstring_to_list(<<1,2,3,4,1:1>>)."),
  <<1:1,1,2,3,4>> = parse_and_eval("erlang:list_to_bitstring([<<1:1>>,1,2,3,4])."),
  [128,129,1,130,<<0:1>>] = parse_and_eval("erlang:bitstring_to_list(<<1:1,1,2,3,4>>)."),
  ok.
 
big_binary_to_and_from_list() ->
  <<1:800,2,3,4,1:1>> = parse_and_eval("erlang:list_to_bitstring(erlang:bitstring_to_list(<<1:800,2,3,4,1:1>>))."),
  [1,2,3,4|_Rest1] = parse_and_eval("erlang:bitstring_to_list(<<1,2,3,4,1:800,1:1>>)."),
  <<1:801,1,2,3,4>> = parse_and_eval("erlang:list_to_bitstring([<<1:801>>,1,2,3,4])."),
  ok.  

send_and_receive() -> 
  parse_and_eval("Bin = <<1,2:7>>,
  Pid = spawn(fun() -> bs_bit_shell_tests:receiver(Bin) end),
  Pid ! {self(),<<1:7,8:5,Bin/bitstring>>},
  receive
    ok ->
      ok
  end.").

receiver(Bin) ->	 
  receive
    {Pid,<<1:7,8:5,Bin/bitstring>>} ->
      Pid ! ok
  end.
	    
send_and_receive_alot() -> 
  parse_and_eval("Bin = <<1:1000001>>,
  Pid = spawn(fun() -> bs_bit_shell_tests:receiver_alot(Bin) end),
  bs_bit_shell_tests:send_alot(100,Bin,Pid).").

send_alot(N,Bin,Pid) when N > 0 ->
  Pid ! {self(),<<1:7,8:5,Bin/bitstring>>},
  receive
    ok ->
      ok
  end,
  send_alot(N-1,Bin,Pid);
send_alot(0,_Bin,Pid) ->
  Pid ! no_more,
  ok.

receiver_alot(Bin) ->	 
  receive
    {Pid,<<1:7,8:5,Bin/bitstring>>} ->
      Pid ! ok;
    no_more -> ok
  end,
  receiver_alot(Bin).	       
