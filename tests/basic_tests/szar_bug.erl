%% -*- erlang-indent-level: 2 -*-

%% Program which was submitted as a bug report on Feb 19th 2004 by
%% "Jozsef Berces (PR/ECZ)" <jozsef.berces@ericsson.com>.
%%
%% As it turned out, there was a bug in the Icode type propagator (the
%% program exhibiting that bad behaviour was added as a test named
%% tuple_as_fun_bug) but the following program was also added in the
%% testsuite, since it is a good test for testing calling native code
%% funs from BEAM code (lists:map, lists:filter, ...).

-module(szar_bug).
-export([test/0, compile/1]).

test() ->
  ["A","B","C"] = smartconcat([],"H'A, H'B, H'C"),
  ok.

smartconcat(B, L) ->
  LL = tokenize(L, $,),
  NewlineDel = fun (X) -> killcontrol(X) end,
  StripFun = fun (X) -> string:strip(X) end,
  LL2 = lists:map(NewlineDel, lists:map(StripFun, LL)),
  EmptyDel = fun(X) ->
		 case string:len(X) of 
		   0 -> false; 
		   _ -> true 
		 end
	     end,
  LL3 = lists:filter(EmptyDel, LL2),
  HexFormat = fun(X, Acc) ->
		  case string:str(X, "H'") of
		    1 ->
		      case checkhex(string:substr(X, 3)) of
			{ok, Y} ->
			  {Y, Acc};
			_ ->
			  {X, Acc + 1}
		      end;
                    _ -> 
		      {X, Acc + 1}
		  end
	      end,
  {LL4,_Ret} = lists:mapfoldl(HexFormat, 0, LL3),
  lists:append(B, lists:sublist(LL4, lists:max([0, 25 - length(B)]))).

checkhex(L) ->
  checkhex(L, "").

checkhex([H | T], N) when H >= $0, H =< $9 ->
  checkhex(T, [H | N]);
checkhex([H | T], N) when H >= $A, H =< $F ->
  checkhex(T, [H | N]);
checkhex([H | T], N) when H =< 32 ->
  checkhex(T, N);
checkhex([_ | _], _) ->
  {error, ""};
checkhex([], N) ->
  {ok, lists:reverse(N)}.

killcontrol([C | S]) when C < 32 ->
  killcontrol(S);
killcontrol([C | S]) ->
  [C | killcontrol(S)];
killcontrol([]) ->
  [].

tokenize(L, C) ->
  tokenize(L, C, [], []).

tokenize([C | T], C, A, B) ->
  case A of
   [] ->
      tokenize(T, C, [], B);
    _ ->
      tokenize(T, C, [], [lists:reverse(A) | B])
  end;
tokenize([H | T], C, A, B) ->
  tokenize(T, C, [H | A], B);
tokenize(_, _, [], B) ->
  lists:reverse(B);
tokenize(_, _, A, B) ->
  lists:reverse([lists:reverse(A) | B]).


compile(Opts) ->
  hipe:c(?MODULE,Opts).

