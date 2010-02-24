%%
%% Yet another version of Fibonacci -- this time a tail-recursive one
%%
-module(fib4).
-export([fib/1]).

fib(0) -> 1;
fib(N) ->
    fibaux(0,1,0,N).

fibaux(_, N1,N,N) -> N1;
fibaux(N2,N1,C,N) -> fibaux(N1,N1+N2,C+1,N).

