%%======================================================================
%% From: Martin Bjorklund <mbj@nortelnetworks.com>
%% To: tobias.lindahl@it.uu.se, kostis@it.uu.se
%% Subject: Another compilation error: not a boolean value: 0.
%%======================================================================
-module(guard1).
-export([test/0, compile/1]).

test() ->
    Ip = {130,238,12,34},
    Mask = {255,255,255,0},
    Proto = 17,
    [{dst,Ip,Mask},{proto,Proto}] = redir_open_match(Ip, Mask, 80, Proto),
    ok.

%% Ip = tuple() | int32()
%% Mask = tuple() | int32()
%% Port = int16() | { int16(), int16() }
%% Proto = icmp | udp | tcp | ... | integer()
redir_open_match(Ip, Mask, Port, Proto) ->
    case Proto of
	%% The following guard is actually wrong. It should really be like:
	%% "((Port > 0) or is_tuple(Port)) and ..."  instead of the following
	%% which most probably is a typo and does not capture the programmer's
	%% intention. Intended or not, the code should really compile starting
	%% from Core and not raise an exception.
	Proto when (Port > 0 or is_tuple(Port)) and
                   ((Proto == tcp) or (Proto == udp) or
                    (Proto == 6)   or (Proto == 17)) ->
	    [{dst, Ip, Mask}, {Proto, [{dport, Port}]}];
        Proto ->
            [{dst, Ip, Mask}, {proto, Proto}]
    end.
 
compile(Opts) ->
    hipe:c(?MODULE, [core|Opts]).
