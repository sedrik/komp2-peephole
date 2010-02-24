%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/03/01 19:51:02 happi>
%% ====================================================================
%%  Filename :  simpl_jt.erl
%%  Module   :  simpl_jt
%%  Purpose  :  
%%  Notes    : 
%%  History  : * 2001-02-26 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/10/10 14:56:01 $
%%              $Revision: 1.4 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(simpl_jt).
-export([test/0,compile/1]).

compile(Op) ->
  hipe:c(?MODULE,[use_jumptable]++Op).

test() ->
  R1 = {tt(),ta(),tex(),p_apply(stacked5_)},
  random:seed(),
  List = random_list(10000),
  statistics(runtime),
  R = loop(100, List),
  {_,Time} = statistics(runtime),
  io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,R]),
  {R,R1}.

random_list(0) -> [];
random_list(N) ->
  Op = random:uniform(93),
  [Op|random_list(N-1)].

loop(0,_) ->
  ok;
loop(N,L) ->
  code_decode(L),
  loop(N-1, L).

code_decode([OP|Ops]) ->
  {Instr, Arity} = opname(OP),
  OP = opcode(Instr, Arity),
  code_decode(Ops);
code_decode([]) -> ok.

p_apply(helix5_) -> helix5_;
p_apply(wc) -> wc;
p_apply(stacked3_) -> stacked3_;
p_apply(p_o3_) -> p_o3_;
p_apply(wc_dumas) -> wc_dumas;
p_apply(helix3_) -> helix3_;
p_apply(stacked5_) -> stacked5_;
p_apply(What) -> exit({badmatch,What}).

tt() ->
  {t(6),t(3),t(foo),t(5)}.

t(A) ->
  case A of
    6 -> ok;
    %% 6 -> a;
    8 ->
      b;
    3 ->
      c;
    1 ->
      f;
    _Digit ->
      e
  end.

ta() ->
  {a(a),a(e),a(o),a(42)}.

a(A) ->
  case A of
    a -> 1;
    b -> 2;
    c -> 3;
    d -> 4;
    e -> 5;
    f -> 6;
    g -> 7;
    h -> 8;
    i -> 9;
    j -> 10;
    k -> 11;
    l -> 12;
    m -> 13;
    n -> 14;
    o -> 15;
    frot16 -> 16;
      _ -> 0
 end.

tex() ->
  {ex(z),
   case catch ex(12) of
     {'EXIT',_} -> 'EXIT';
     R -> {no_exit,R}
   end}.

ex(Key) ->
  case Key of
    h -> 1;
    d -> 2;
    b -> 3;
    f -> 4;
    a -> 5;
    z -> 6;
    i -> 7
  end.


opcode(label, 1) -> 1;
opcode(func_info, 3) -> 2;
opcode(int_code_end, 0) -> 3;
opcode(call, 2) -> 4;
opcode(call_last, 3) -> 5;
opcode(call_only, 2) -> 6;
opcode(call_ext, 2) -> 7;
opcode(call_ext_last, 3) -> 8;
opcode(bif0, 2) -> 9;
opcode(bif1, 4) -> 10;
opcode(bif2, 5) -> 11;
opcode(allocate, 2) -> 12;
opcode(allocate_heap, 3) -> 13;
opcode(allocate_zero, 2) -> 14;
opcode(allocate_heap_zero, 3) -> 15;
opcode(test_heap, 2) -> 16;
opcode(init, 1) -> 17;
opcode(deallocate, 1) -> 18;
opcode(return, 0) -> 19;
opcode(send, 0) -> 20;
opcode(remove_message, 0) -> 21;
opcode(timeout, 0) -> 22;
opcode(loop_rec, 2) -> 23;
opcode(loop_rec_end, 1) -> 24;
opcode(wait, 1) -> 25;
opcode(wait_timeout, 2) -> 26;
opcode(m_plus, 4) -> 27;
opcode(m_minus, 4) -> 28;
opcode(m_times, 4) -> 29;
opcode(m_div, 4) -> 30;
opcode(int_div, 4) -> 31;
opcode(int_rem, 4) -> 32;
opcode(int_band, 4) -> 33;
opcode(int_bor, 4) -> 34;
opcode(int_bxor, 4) -> 35;
opcode(int_bsl, 4) -> 36;
opcode(int_bsr, 4) -> 37;
opcode(int_bnot, 3) -> 38;
opcode(is_lt, 3) -> 39;
opcode(is_ge, 3) -> 40;
opcode(is_eq, 3) -> 41;
opcode(is_ne, 3) -> 42;
opcode(is_eq_exact, 3) -> 43;
opcode(is_ne_exact, 3) -> 44;
opcode(is_integer, 2) -> 45;
opcode(is_float, 2) -> 46;
opcode(is_number, 2) -> 47;
opcode(is_atom, 2) -> 48;
opcode(is_pid, 2) -> 49;
opcode(is_ref, 2) -> 50;
opcode(is_port, 2) -> 51;
opcode(is_nil, 2) -> 52;
opcode(is_binary, 2) -> 53;
opcode(is_constant, 2) -> 54;
opcode(is_list, 2) -> 55;
opcode(is_nonempty_list, 2) -> 56;
opcode(is_tuple, 2) -> 57;
opcode(test_arity, 3) -> 58;
opcode(select_val, 3) -> 59;
opcode(select_tuple_arity, 3) -> 60;
opcode(jump, 1) -> 61;
opcode('catch', 2) -> 62;
opcode(catch_end, 1) -> 63;
opcode(move, 2) -> 64;
opcode(get_list, 3) -> 65;
opcode(get_tuple_element, 3) -> 66;
opcode(set_tuple_element, 3) -> 67;
opcode(put_string, 3) -> 68;
opcode(put_list, 3) -> 69;
opcode(put_tuple, 2) -> 70;
opcode(put, 1) -> 71;
opcode(badmatch, 1) -> 72;
opcode(if_end, 0) -> 73;
opcode(case_end, 1) -> 74;
opcode(call_fun, 1) -> 75;
opcode(make_fun, 3) -> 76;
opcode(is_function, 2) -> 77;
opcode(call_ext_only, 2) -> 78;
opcode(bs_start_match, 2) -> 79;
opcode(bs_get_integer, 5) -> 80;
opcode(bs_get_float, 5) -> 81;
opcode(bs_get_binary, 5) -> 82;
opcode(bs_skip_bits, 4) -> 83;
opcode(bs_test_tail, 2) -> 84;
opcode(bs_save, 1) -> 85;
opcode(bs_restore, 1) -> 86;
opcode(bs_init, 2) -> 87;
opcode(bs_final, 2) -> 88;
opcode(bs_put_integer, 5) -> 89;
opcode(bs_put_binary, 5) -> 90;
opcode(bs_put_float, 5) -> 91;
opcode(bs_put_string, 2) -> 92;
opcode(bs_need_buf, 1) -> 93;
opcode(Name, Arity) -> erlang:error(badarg, [Name,Arity]).

opname(1) -> {label,1};
opname(2) -> {func_info,3};
opname(3) -> {int_code_end,0};
opname(4) -> {call,2};
opname(5) -> {call_last,3};
opname(6) -> {call_only,2};
opname(7) -> {call_ext,2};
opname(8) -> {call_ext_last,3};
opname(9) -> {bif0,2};
opname(10) -> {bif1,4};
opname(11) -> {bif2,5};
opname(12) -> {allocate,2};
opname(13) -> {allocate_heap,3};
opname(14) -> {allocate_zero,2};
opname(15) -> {allocate_heap_zero,3};
opname(16) -> {test_heap,2};
opname(17) -> {init,1};
opname(18) -> {deallocate,1};
opname(19) -> {return,0};
opname(20) -> {send,0};
opname(21) -> {remove_message,0};
opname(22) -> {timeout,0};
opname(23) -> {loop_rec,2};
opname(24) -> {loop_rec_end,1};
opname(25) -> {wait,1};
opname(26) -> {wait_timeout,2};
opname(27) -> {m_plus,4};
opname(28) -> {m_minus,4};
opname(29) -> {m_times,4};
opname(30) -> {m_div,4};
opname(31) -> {int_div,4};
opname(32) -> {int_rem,4};
opname(33) -> {int_band,4};
opname(34) -> {int_bor,4};
opname(35) -> {int_bxor,4};
opname(36) -> {int_bsl,4};
opname(37) -> {int_bsr,4};
opname(38) -> {int_bnot,3};
opname(39) -> {is_lt,3};
opname(40) -> {is_ge,3};
opname(41) -> {is_eq,3};
opname(42) -> {is_ne,3};
opname(43) -> {is_eq_exact,3};
opname(44) -> {is_ne_exact,3};
opname(45) -> {is_integer,2};
opname(46) -> {is_float,2};
opname(47) -> {is_number,2};
opname(48) -> {is_atom,2};
opname(49) -> {is_pid,2};
opname(50) -> {is_ref,2};
opname(51) -> {is_port,2};
opname(52) -> {is_nil,2};
opname(53) -> {is_binary,2};
opname(54) -> {is_constant,2};
opname(55) -> {is_list,2};
opname(56) -> {is_nonempty_list,2};
opname(57) -> {is_tuple,2};
opname(58) -> {test_arity,3};
opname(59) -> {select_val,3};
opname(60) -> {select_tuple_arity,3};
opname(61) -> {jump,1};
opname(62) -> {'catch',2};
opname(63) -> {catch_end,1};
opname(64) -> {move,2};
opname(65) -> {get_list,3};
opname(66) -> {get_tuple_element,3};
opname(67) -> {set_tuple_element,3};
opname(68) -> {put_string,3};
opname(69) -> {put_list,3};
opname(70) -> {put_tuple,2};
opname(71) -> {put,1};
opname(72) -> {badmatch,1};
opname(73) -> {if_end,0};
opname(74) -> {case_end,1};
opname(75) -> {call_fun,1};
opname(76) -> {make_fun,3};
opname(77) -> {is_function,2};
opname(78) -> {call_ext_only,2};
opname(79) -> {bs_start_match,2};
opname(80) -> {bs_get_integer,5};
opname(81) -> {bs_get_float,5};
opname(82) -> {bs_get_binary,5};
opname(83) -> {bs_skip_bits,4};
opname(84) -> {bs_test_tail,2};
opname(85) -> {bs_save,1};
opname(86) -> {bs_restore,1};
opname(87) -> {bs_init,2};
opname(88) -> {bs_final,2};
opname(89) -> {bs_put_integer,5};
opname(90) -> {bs_put_binary,5};
opname(91) -> {bs_put_float,5};
opname(92) -> {bs_put_string,2};
opname(93) -> {bs_need_buf,1};
opname(Number) -> erlang:error(badarg, [Number]).


