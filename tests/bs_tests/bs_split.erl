-module(bs_split).
-export([test/0, compile/1]).

test() ->
  [<<61,62,63>>] = z_split(<<61,62,63>>),
  [<<61,62,63>>, <<>>] = z_split(<<61,62,63,0>>),
  [<<61,62,63>>, <<64>>] = z_split(<<61,62,63,0,64>>),
  [<<61,62,63>>, <<64,65,66>>] = z_split(<<61,62,63,0,64,65,66>>),
  [<<61,62>>, <<64>>, <<>>, <<65,66>>] = z_split(<<61,62,0,64,0,0,65,66>>),
  ok.

%% Splits a series of null terminated segments of a binary without
%% creating any new sub-binaries until the zero is found.

z_split(B) when is_binary(B) -> z_split(B, 0).

z_split(B, N) ->
  case B of
    <<_B1:N/binary,0,_B2/binary>> ->	% use skip_bits for B1, B2
      <<B1:N/binary,_,B2/binary>> = B,	% and postpone the matching
      [B1 | z_split(B2)];
    <<_:N/binary>> ->
      [B];
    _ ->
      z_split(B, N+1)
  end.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
