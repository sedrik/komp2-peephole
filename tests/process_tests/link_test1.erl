%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  History  :	* 2001-03-27 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: richardc $
%%              $Date: 2004/08/20 14:35:15 $
%%              $Revision: 1.3 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(link_test1).
-export([test/0,compile/1]).

test() ->
  case catch go() of 
    {'EXIT',_} -> exited_ok;
    Other -> {error, Other}
  end.

go() ->
  process_flag(trap_exit, true),
  flush(),
  {ok, Node} = start_node(ref_port_roundtrip),
  _Pid = spawn_link(Node, ?MODULE, roundtrip, [xxx]),
  receive after 1000 -> ok end,
  process_flag(trap_exit, false),
  ok.

compile(Opts) ->
    hipe:c(?MODULE,Opts).

start_node(Name) ->
    Pa = filename:dirname(code:which(?MODULE)),
    Cookie = atom_to_list(erlang:get_cookie()),
    slave:start(hostname(), Name, "-setcookie " ++ Cookie ++" -pa " ++ Pa).

hostname() ->
    from($@, atom_to_list(node())).

from(H, [H | T]) -> T;
from(H, [_ | T]) -> from(H, T);
from(_, []) -> [].

flush() ->
    receive _ -> flush() after 0 -> ok end.
