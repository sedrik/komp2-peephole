%% One of the lex_digits functions of thie modulw gave incorrect
%% results due to incorrect pattern matching compilation of
%% binaries by the BEAM compiler.
%% Fixed by Bjorn Gustavsson on 5/3/2003.

-module(bs_match_bug).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Bin = <<"123.123">>,
  {lex_digits1(Bin,1,[]),
   lex_digits2(Bin,1,[])}.

lex_digits1(<<$., Rest/binary>>,_Val,_Acc) ->
  Rest;
lex_digits1(<<N, Rest/binary>>,Val, Acc) when N >= $0 , N =< $9 ->
  lex_digits1(Rest,Val*10+dec(N),Acc);
lex_digits1(_Other,_Val,_Acc) ->
  not_ok.

lex_digits2(<<N, Rest/binary>>,Val, Acc) when N >= $0 , N =< $9 ->
  lex_digits2(Rest,Val*10+dec(N),Acc);
lex_digits2(<<$., Rest/binary>>,_Val,_Acc) ->
  Rest;
lex_digits2(_Other,_Val,_Acc) ->
  not_ok.

dec(A) ->
  A-$0.  
