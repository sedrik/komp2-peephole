% file: "tak.erl"

-module(tak).
-export([test/0]).

tak(X,Y,Z) ->
  if
    Y<X -> tak( tak(X-1,Y,Z),
                tak(Y-1,Z,X),
                tak(Z-1,X,Y) );
    true -> Z
  end.

loop(0,R) -> R;
loop(N,_) -> loop(N-1,tak(18,12,6)).

test() ->
    statistics(runtime),
    R = loop(2,0),
    {_,Time} = statistics(runtime),
    io:format("\nruntime = ~p msecs\nresult = ~p\n",[Time,R]),
    R.
