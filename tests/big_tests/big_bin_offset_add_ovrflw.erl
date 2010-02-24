%%======================================================================
%% From: Per Gustafsson
%% Date: Jun 23, 2009
%%
%% Bug in HiPE big binary matching, offset additions are not handled
%% correctly.
%% 
%%======================================================================

%% testsuite.sh scans for the string 'overflow' :-(
-module(big_bin_offset_add_ovrflw).

-export([test/0, compile/1]).

test() ->
  case catch bug(1, <<0:1200>>) of
    {'EXIT',{{badmatch,_Bin},[{?MODULE,bug,2}|_]}} -> ok
  end.

compile(Opts) -> hipe:c(?MODULE, Opts).

bug(X, Bin) ->
  <<_:X/bytes, _:16#fffffffff, _/bits>> = Bin.
