%% Trivial test to test correct handling of all sorts of alphanumeric
%% types in Erlang, and conversions between them.

-module(hello_world).
-export([test/0,compile/1]).

test() ->
  String = gimme(string),
  String = atom_to_list(gimme(atom)),
  String = binary_to_list(gimme(binary)),
  ok.

gimme(string) ->
  "hello world";
gimme(atom) ->
  'hello world';
gimme(binary) ->
  <<"hello world">>.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
