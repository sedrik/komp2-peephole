%%
%% From: "Niclas Pehrsson \(LN/EAB\)" <niclas.pehrsson@ericsson.com>
%% Date: Thu, 20 Apr 2006 11:18:51
%% 
%% We found something weird with the bit shifting in HiPE. It seems
%% that bsr in some cases shifts the bits in the wrong way...
%%
%% -- Fixed about 10 mins afterwards; was a bug in constant propagation
%%

-module(shift_test).
-export([test/0,compile/1]).

test() ->
  A = plain_shift(),                 %  1
  B = length_list_plus(),            %  6
  C = shift_length_list(),           %  0
  D = shift_length_list_plus(),      %  1
  E = shift_length_list_plus2(),     %  1
  F = shift_length_list_plus_bsl(),  % 24
  G = shift_fun(),                   %  1
  {1,6,0,1,1,24,1} = {A,B,C,D,E,F,G},
  ok.

plain_shift() ->
  6 bsr 2.

length_list() ->
  length([0,0]).

length_list_plus() ->
  length([0,0])+4.

shift_length_list() ->
  length([0,0]) bsr 2.

shift_length_list_plus() ->
  (length([0,0])+4) bsr 2.

shift_length_list_plus_bsl() ->
  (length([0,0])+4) bsl 2.

shift_length_list_plus2() ->
  N = length([0,0])+4,
  N bsr 2.

shift_fun() ->
  (length_list()+4) bsr 2.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
