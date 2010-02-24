%%-----------------------------------------------------------------------
%% From    : Mateusz Berezecki <mateuszb@gmail.com>
%% Date    : 19 Jan 2008
%% Subject : Compiler error -- internal error in v3_codegen
%%-----------------------------------------------------------------------

-module(bs_R12bug).
-export([test/0, compile/1]).

test() ->
    B0 = gen_bit(120, <<>>),
    B1 = set_bit(B0, 5),
    B2 = clr_bit(B1, 5),
    set_bit(B2, 5),
    ok.

gen_bit(0, Acc) -> Acc;
gen_bit(N, Acc) when is_integer(N), N > 0 ->
    gen_bit(N-1, <<Acc/binary, (random:uniform(2)-1):1>>).

%% sets bit K in the Bitmap
set_bit(<<_Start:32/unsigned-little-integer,Bitmap/bits>>, K)
  when is_integer(K), bit_size(Bitmap) >= K, 0 < K ->
    Before = K-1,
    After = bit_size(Bitmap) - K,
    <<BeforeBits:Before/bits, _:1, AfterBits:After/bits>> = Bitmap,
    <<BeforeBits/bits, 1:1, AfterBits/bits>>.

%% clears bit K in the Bitmap
clr_bit(<<_Start:32/unsigned-little-integer, Bitmap/bits>>, K)
  when is_integer(K), bit_size(Bitmap) >= K, 0 < K ->
    Before = K-1,
    After = bit_size(Bitmap) - K,
    <<BeforeBits:Before/bits, _:1, AfterBits:After/bits>> = Bitmap,
    <<BeforeBits/bits, 0:1, AfterBits/bits>>.

compile(Opts) ->
    hipe:c(?MODULE, Opts).
