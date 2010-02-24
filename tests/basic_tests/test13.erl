-module(test13).

-export([test/0, compile/1]).

test() ->
  Frame = list_to_binary([list_to_binary([1]), list_to_binary([2]),
			  list_to_binary([3]),
			  list_to_binary([4]), list_to_binary([5]),
			  list_to_binary([6]), list_to_binary([7]),
			  list_to_binary([8]),
			  list_to_binary([9]), list_to_binary([10]),
			  list_to_binary([11]),list_to_binary([12]),
			  list_to_binary([13]),list_to_binary([14]),
			  list_to_binary([15]),list_to_binary([16]),
			  list_to_binary([17]),list_to_binary([18]),
			  list_to_binary([19]),list_to_binary([20]),
			  list_to_binary([21]),
			  list_to_binary([0])
			 ]),	
  Frame.

compile(O) ->
  hipe:c(?MODULE, O).
