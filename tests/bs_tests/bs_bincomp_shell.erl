%%%-------------------------------------------------------------------
%%% File    : bs_bincomp_shell.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : 
%%%
%%% Created : 13 Sep 2006 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_bincomp_shell).

-export([test/0,compile/1]).

-compile(bitlevel_binaries).
-compile(binary_comprehension).

compile(O) ->
  hipe:c(erl_eval,O),  %This makes this a test of the hipe compiler
  hipe:c(eval_bits,O), %This makes this a test of the hipe compiler
  hipe:c(?MODULE,O).

test() ->
  ok = byte_aligned(),
  ok = bit_aligned(),
  ok = extended_byte_aligned(),
  ok = extended_bit_aligned(),
  ok = mixed(),
  ok.

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


byte_aligned() ->
  <<"abcdefg">> =
    parse_and_eval("<<\"abcdefg\">> = << <<(X+32)>> || <<X>> <= <<\"ABCDEFG\">> >>."),
  <<1:32/little,2:32/little,3:32/little,4:32/little>> =
    parse_and_eval("<<1:32/little,2:32/little,3:32/little,4:32/little>> =
    << <<X:32/little>> || <<X:32>> <= <<1:32,2:32,3:32,4:32>> >>."),
  <<1:32/little,2:32/little,3:32/little,4:32/little>> =
    parse_and_eval("<<1:32/little,2:32/little,3:32/little,4:32/little>> =
    << <<X:32/little>> || <<X:16>> <= <<1:16,2:16,3:16,4:16>> >>."),
  ok.

bit_aligned() ->
  <<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>> = 
    parse_and_eval("<<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>> = 
    << <<(X+32):7>> || <<X>> <= <<\"ABCDEFG\">> >>."),
  <<"ABCDEFG">> =
    parse_and_eval("<<\"ABCDEFG\">> = 
    << <<(X-32)>> || <<X:7>> <= <<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>> >>."),
 <<1:31/little,2:31/little,3:31/little,4:31/little>> =
    parse_and_eval("<<1:31/little,2:31/little,3:31/little,4:31/little>> =
    << <<X:31/little>> || <<X:31>> <= <<1:31,2:31,3:31,4:31>> >>."),
  <<1:31/little,2:31/little,3:31/little,4:31/little>> =
    parse_and_eval("<<1:31/little,2:31/little,3:31/little,4:31/little>> =
    << <<X:31/little>> || <<X:15>> <= <<1:15,2:15,3:15,4:15>> >>."),
  ok.

extended_byte_aligned() ->
  <<"abcdefg">> =
    parse_and_eval("<<\"abcdefg\">> = << <<(X+32)>> || X <- \"ABCDEFG\" >>."),
  "abcdefg" =
    parse_and_eval("\"abcdefg\" = [(X+32) || <<X>> <= <<\"ABCDEFG\">>]."),
  <<1:32/little,2:32/little,3:32/little,4:32/little>> =
    parse_and_eval("<<1:32/little,2:32/little,3:32/little,4:32/little>> =
    << <<X:32/little>> || X <- [1,2,3,4] >>."),
  [256,512,768,1024] =
    parse_and_eval("[256,512,768,1024] =
    [X || <<X:16/little>> <= <<1:16,2:16,3:16,4:16>>]."),
  ok.

extended_bit_aligned() ->
  <<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>> = 
    parse_and_eval("<<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>> = 
    << <<(X+32):7>> || X <- \"ABCDEFG\" >>."),
  "ABCDEFG" = 
    parse_and_eval("\"ABCDEFG\" = [(X-32) || <<X:7>> <= 
<<$a:7,$b:7,$c:7,$d:7,$e:7,$f:7,$g:7>>]."),
  <<1:31/little,2:31/little,3:31/little,4:31/little>> =
    parse_and_eval("<<1:31/little,2:31/little,3:31/little,4:31/little>> =
    << <<X:31/little>> || X <- [1,2,3,4] >>."),
  [256,512,768,1024] =
    parse_and_eval("[256,512,768,1024] =
    [X || <<X:15/little>> <= <<1:15,2:15,3:15,4:15>>]."),
  ok.

mixed() ->
  <<2,3,3,4,4,5,5,6>> =
    parse_and_eval("<<2,3,3,4,4,5,5,6>> =  
    << <<(X+Y)>> || <<X>> <= <<1,2,3,4>>, <<Y>> <= <<1,2>> >>."),
  <<2,3,3,4,4,5,5,6>> =
  parse_and_eval("<<2,3,3,4,4,5,5,6>> =  
    << <<(X+Y)>> || <<X>> <= <<1,2,3,4>>, Y <- [1,2] >>."),
  <<2,3,3,4,4,5,5,6>> = 
  parse_and_eval("<<2,3,3,4,4,5,5,6>> =  
    << <<(X+Y)>> || X <- [1,2,3,4], Y <- [1,2] >>."),
  [2,3,3,4,4,5,5,6] =  
  parse_and_eval("[2,3,3,4,4,5,5,6] =  
    [(X+Y) || <<X>> <= <<1,2,3,4>>, <<Y>> <= <<1,2>>]."),
  [2,3,3,4,4,5,5,6] =
  parse_and_eval("[2,3,3,4,4,5,5,6] =  
    [(X+Y) || <<X>> <= <<1,2,3,4>>, Y <- [1,2]]."),
  <<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> =
  parse_and_eval("<<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> =  
    << <<(X+Y):3>> || <<X:3>> <= <<1:3,2:3,3:3,4:3>>, <<Y:3>> <= <<1:3,2:3>> >>."),
  <<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> =
  parse_and_eval("<<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> =  
    << <<(X+Y):3>> || <<X:3>> <= <<1:3,2:3,3:3,4:3>>, Y <- [1,2] >>."),
  <<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> = 
  parse_and_eval("<<2:3,3:3,3:3,4:3,4:3,5:3,5:3,6:3>> =  
    << <<(X+Y):3>> || X <- [1,2,3,4], Y <- [1,2] >>."),
  [2,3,3,4,4,5,5,6] =
  parse_and_eval("[2,3,3,4,4,5,5,6] =  
    [(X+Y) || <<X:3>> <= <<1:3,2:3,3:3,4:3>>, <<Y:3>> <= <<1:3,2:3>>]."),
  [2,3,3,4,4,5,5,6] =
  parse_and_eval("[2,3,3,4,4,5,5,6] =  
    [(X+Y) || <<X:3>> <= <<1:3,2:3,3:3,4:3>>, Y <- [1,2]]."),
  ok.
