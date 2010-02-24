%%----------------------------------------------------------------------
%% From: Paulo Sérgio Almeida
%% Date: May 20, 2009
%%
%% The following code when compiled under R13B gives a compiler error.
%%   Function loop/1 refers to undefined label 6
%%   ./almeida_R13compiler_bug.erl:none: internal error in beam_peep;
%%   crash reason: {{case_clause,{'EXIT',{undefined_label,6}}},
%%                  [{compile,'-select_passes/2-anonymous-2-',2},
%%                   {compile,'-internal_comp/4-anonymous-1-',2},
%%----------------------------------------------------------------------

-module(almeida_R13compiler_bug). 
-export([test/0, compile/1]). 

test() ->
  self() ! {backup, 42, false},
  loop([]).

loop(Tids) ->
  receive 
    {backup, Tid, Dumping} -> 
      case Dumping of 
        false -> ok; 
        _ -> receive {logged, Tab, Tid} -> put({log, Tab}, Tid) end 
      end, 
      collect(Tid, Tids, []) 
  end. 

collect(_, _, _) -> ok.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

