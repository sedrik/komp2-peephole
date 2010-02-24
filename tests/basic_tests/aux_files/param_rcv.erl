%%----------------------------------------------------------------------------
%% A parameterized module that is used by param_srv.erl
%%----------------------------------------------------------------------------

-module(param_rcv, [Time]). 

-export([get_time/0]). 

get_time() -> Time. 

