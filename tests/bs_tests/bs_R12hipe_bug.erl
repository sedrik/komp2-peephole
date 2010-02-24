%% -*- erlang-indent-level: 2 -*-
%%--------------------------------------------------------------------
%% From: Steve Vinoski <vinoski@ieee.org>
%% Date: 1st March 2008
%%
%% Below find the results of compiling and running the example code at
%% the bottom of this message. Using "c" to compile gives the right
%% answer; using "hipe:c" gives the wrong answer. This is with R12B-1.
%%
%% Within the code, on the second instance of function check/2 you'll
%% find a commented-out guard. If you uncomment the guard, then the
%% code works correctly with both "c" and "hipe:c".
%%---------------------------------------------------------------------

-module(bs_R12hipe_bug).
-export([test/0, compile/1]).

test() ->
  String = "2006/10/02/Linux-Journal",
  Binary = list_to_binary(String),
  StringToMatch = "200x/" ++ String ++ " ",
  BinaryToMatch = list_to_binary(StringToMatch),
  {ok, Binary} = match(BinaryToMatch),
  ok.

match(<<>>) ->
  nomatch;
match(Bin) ->
  <<Front:16/binary, Tail/binary>> = Bin,
  case Front of
    <<_:3/binary,"x/",Y:4/binary,$/,M:2/binary,$/,D:2/binary,$/>> ->
      case check(Tail) of
	{ok, Match} ->
          {ok, <<Y/binary,$/,M/binary,$/,D/binary,$/,Match/binary>>};
	{nomatch, Skip} ->
          {skip, Skip+size(Front)};
	_ ->
	  wrong_answer
      end;
    _ ->
      nomatch
  end.

check(Bin) ->
  check(Bin, 0).
check(<<$ , _/binary>>, 0) ->
  {nomatch, 0};
check(Bin, Len) ->  %when Len < size(Bin) ->
  case Bin of
    <<Front:Len/binary, $ , _/binary>> ->
      {ok, Front};
    <<_:Len/binary, $., _/binary>> ->
      {nomatch, Len};
    _ ->
      check(Bin, Len+1)
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
