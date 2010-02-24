-module(fisher_R13B01compiler_bug).
-export([test/0, compile/1]).

test() ->
  perform_select({foo, "42"}).

perform_select({Type, Keyval}) -> 
  try 
    if is_atom(Type) andalso length(Keyval) > 0 -> ok; 
       true -> ok 
    end 
  catch 
    _:_ -> fail 
  end. 

compile(Opts) ->
  hipe:c(?MODULE, Opts).
