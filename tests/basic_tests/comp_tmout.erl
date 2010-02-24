%% Tests that when the native-code compilation times out or gets killed
%% for some other reason, the parent process does not also get killed.
%%
%% Problem discovered by Bjorn G. on 1/12/2003 and fixed by Kostis S.

-module(comp_tmout).
-export([test/0,compile/1]).

test() ->
    error_logger:tty(false), % disable printouts of error reports
    Self = self(),	     % get the parent process
    c:c(?MODULE,[native,{hipe,[{timeout,1}]}]),	% This will kill the process
    Self = self(),	     % make sure the parent process stays the same
    ok.

compile(_Flags) ->
    {ok, ?MODULE}.	     % no reason for native code compilation, really
