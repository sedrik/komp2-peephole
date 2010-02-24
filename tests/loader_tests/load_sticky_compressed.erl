%%-----------------------------------------------------------------------
%% File    : load_sticky_compressed.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Purpose : We discovered that the native code of .beam files which had
%%	     been compiled with the 'compressed' compiler option on and
%%	     resided in sticky dirs could not be loaded prior to R12B-4.
%% Created : 29 Aug 2008
%%-----------------------------------------------------------------------

-module(load_sticky_compressed).

-export([test/0, compile/1]).

-define(MODNAME, load_sticky_compressed_data).

compile(_Flags) ->
  {ok, ?MODULE}.

test() ->
  case code:is_sticky(?MODNAME) of
    false ->
      {ok, ?MODNAME} = c:c(?MODNAME, [compressed]),
      ok = code:stick_dir("."),
      {ok, ?MODNAME} = hipe:c(?MODNAME),
      ok;
    true ->
      ok
  end.

