%%%-------------------------------------------------------------------
%%% File    : heap_allocate_trim.erl
%%% Author  : Per Gustafsson <pergu@it.uu.se>
%%% Description : This is a test adapted from the file sent to the 
%%%               Erlang mailing list by Eranga Udesh on dec 28 2007
%%%               The file did not compile because of problems with 
%%%               the heap_allocate instruction and stack-trimming
%%% Created : 28 Dec 2007 by Per Gustafsson <pergu@it.uu.se>
%%%-------------------------------------------------------------------

-module(heap_allocate_trim).

-export([compile/1, test/0]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  {abandon, 1} = get_next_retry(a,1),
  ok.

get_next_retry(Error, Count) ->
  case catch tup(retry_scheme, {Error,Count}) of
    _ ->
      case tup(Error, Count) of
        _ ->
          {abandon, Count}
      end
  end.

tup(A,B) -> {A,B}.
  
