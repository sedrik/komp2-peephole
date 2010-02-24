%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(inline_match).
-export([test/0,compile/1]).

-compile({inline, [{to_objects,3}]}).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  {test1(a,{binary, foo, set},c),
   test2(a,{binary, foo, set},c),
   test3(a,{binary, foo, set},c)}.

%% Inlined.
to_objects(Bin, {binary, _, set}, _Ts) ->
  <<_ObjSz0:32, _T/binary>> = Bin,
  %% {A,B} = Bin,
  ok;
to_objects(<<_ObjSz0:32, _T/binary>> ,_,_) ->
  ok;
to_objects(_Bin, _, _Ts) ->
  ok.

%% Not Inlined.
fto_objects(Bin, {binary, _, set}, _Ts) ->
  <<_ObjSz0:32, _T/binary>> = Bin,
  %% {A,B} = Bin,
  ok;
fto_objects(<<_ObjSz0:32, _T/binary>> ,_,_) ->
  ok;
fto_objects(_Bin, _, _Ts) ->
  ok.


%% Inlined
test1(KeysObjs, C, Ts) ->
  case catch to_objects(KeysObjs, C, Ts) of
     {'EXIT', _} ->
      bad_object;
    ok ->
      ok
  end.

%% "Inlined" by hand
test2(KeysObjs, C, _Ts) ->
  case catch (case C of
  {binary, _, set} ->
    <<_ObjSz0:32, _T/binary>> = KeysObjs;
  _ -> ok
       end) of
     {'EXIT', _} ->
      bad_object;
    ok ->
      ok
  end.

%% Not inlined
test3(KeysObjs, C, Ts) ->
  case catch fto_objects(KeysObjs, C, Ts) of
     {'EXIT', _} ->
      bad_object;
    ok ->
      ok
  end.
