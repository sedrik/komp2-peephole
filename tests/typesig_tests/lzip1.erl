-module(lzip1).
-export([zip2/0, zip3/0,
	 zipwith3/0, zipwith3_nil/0,
	 zipwith4/0, zipwith4_nil/0,
	 unzip1_known_types/0, unzip1_unknown_types/1,
	 unzip1_nil/0, unzip1_error/0,
	 unzip3_known_types/0]).

zip2() ->
  lists:zip([1,2], [a,b]).

zip3() ->
  lists:zip3([1,2], [a,b], [1.0,2.0]).

zipwith3() ->
  F = fun (X,Y) -> {X,Y} end,
  lists:zipwith(F, [1,2], [a,b]).

zipwith3_nil() ->
  F = fun (X,Y) -> {X,Y} end,
  lists:zipwith(F, [], []).

zipwith4() ->
  F = fun (X,_,Z) -> {X,gazonk,Z} end,
  lists:zipwith3(F, [1,2], [foo,bar], [a,b]).

zipwith4_nil() ->
  F = fun (X,Y,_) -> {X,gazonk,Y} end,
  lists:zipwith3(F, [], [], []).

unzip1_known_types() ->
  lists:unzip(zip2()).

unzip1_unknown_types(List) ->
  lists:unzip(List).

unzip1_nil() ->
  lists:unzip([]).

unzip1_error() ->
  lists:unzip(zip3()).

unzip3_known_types() ->
  lists:unzip3([{a,b,c}]).
