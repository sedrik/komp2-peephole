%%----------------------------------------------------------------------------
%% Tests the ranges that we infer for taking the remainder with the integer 2.
%%----------------------------------------------------------------------------

-module(rem2).
-export([pos/1, neg/1, unknown/1]).

pos(I) when I > 0 -> I rem 2.

neg(I) when I < 0 -> I rem 2.

unknown(I) -> I rem 2.

