%% ----- Post from the erlang-questions mailing list -----
%%
%% I'm getting an Internal Consistency Check error when attempting to  
%% build Wings3D on Mac OS X 10.4.2 (Erlang OTP R10B-6):
%% 
%% erlc -pa /ebin +warn_unused_vars -I/include -I ../e3d -W +debug_info  
%% '-Dwings_version="0.98.31"' -pa ../ebin -o../ebin wings_color.erl
%% wings_color: function internal_rgb_to_hsv/3+97:
%%    Internal consistency check failed - please report this bug.
%%    Instruction: {test,is_eq_exact,{f,80},[{x,0},{atom,error}]}
%%    Error:       {unsafe_instruction,{float_error_state,cleared}}:
%%
%% The problem is the interaction of the 'try' construct with the
%% handling of FP exceptions.

-module(wings1).
-export([test/0, compile/1]).

test() ->
  internal_rgb_to_hsv(42,43,44).  %% a call with a possible FP exception

internal_rgb_to_hsv(R, G, B) ->
  Max = lists:max([R,G,B]),
  Min = lists:min([R,G,B]),
  V = Max,
  {Hue,Sat} = try
                {if Min == B -> (G-Min)/(R+G-2.0*Min);
                    Min == R -> (1.0+(B-Min)/(B+G-2.0*Min));
                    Min == G -> (2.0+(R-Min)/(B+R-2.0*Min))
                 end * 120, (Max-Min)/Max}
              catch
                error:badarith -> {undefined,0.0}
              end,
  {Hue,Sat,V}.

compile(Opts) ->
  hipe:c(?MODULE, Opts).
