%%-------------------------------------------------------------------
%% File    : bin3.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Purpose : Test that inference of success typings faithfully
%%	     follows the operational semantics of binary construction.
%%
%% Created : 16 Sept 2006 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------
-module(bin3).
-export([construct_float_bin/0,
	 construct_pos_integer_bin/0,
	 construct_neg_integer_bin/0]).

construct_float_bin() ->
  <<3.14:64/float>>.

construct_pos_integer_bin() ->
  {<<1:8>>, <<1:8/integer-unsigned>>, <<1:8/integer-signed>>}.

construct_neg_integer_bin() ->
  {<<-1:8>>, <<-1:8/integer-unsigned>>, <<-1:8/integer-signed>>}.

