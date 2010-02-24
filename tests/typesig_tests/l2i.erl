-module(l2i).
-export([main/1]).

main([Arg]) ->
   list_to_integer(Arg).

