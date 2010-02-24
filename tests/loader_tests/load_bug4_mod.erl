-module(load_bug4_mod).
-export([exported/1]).

exported(X) ->
  not_exported(X).

not_exported(X) ->
  X.

