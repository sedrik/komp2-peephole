%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Filename : 	mode_errors.erl
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2004/12/12 12:02:43 $
%%              $Revision: 1.10 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(mode_errors).
-export([test/0,compile/1]).
%% The following are used as remote calls.
-export([fe/1,fn/1]).

test() ->
  lists:map(fun (T) -> 
		FV = element(2,T),
%% 		Trace = element(2,FV),
		FReason = element(1,FV),
%% 		{FReason, [hd(Trace)]}
		FReason
	    end,
	    [t1n(),  
	     t2n(),
	     t3e(),
	     t4e(),
	     t5n(),
	     t6n(),
	     t7e(),
	     t8e(),
	     annn(),
	     anne(),
	     anen(),
	     anee(),
	     aenn(),
	     aene(),
	     aeen(),
	     aeee()]).

compile(Opts0) ->
  case proplists:get_bool(core, Opts0) of
    true ->
        %% compiling from Core does not make sense for this test
        test:note(?MODULE, "disabling compilation from core - no point"),
        Opts = [{core,false}|Opts0];
    false ->
        Opts = Opts0
  end,
  hipe:c({?MODULE,t1n,0},Opts),
  hipe:c({?MODULE,t2n,0},Opts),
  hipe:c({?MODULE,t5n,0},Opts),
  hipe:c({?MODULE,t6n,0},Opts),
  hipe:c({?MODULE,annn,0},Opts),
  hipe:c({?MODULE,anne,0},Opts),
  hipe:c({?MODULE,anen,0},Opts),
  hipe:c({?MODULE,anee,0},Opts),
  hipe:c({?MODULE,bnn,0},Opts),
  hipe:c({?MODULE,bne,0},Opts),
  hipe:c({?MODULE,fn,1},Opts),
  hipe:c({?MODULE,cn,1},Opts),
  {ok, ?MODULE}.

t1n() -> catch ?MODULE:fe([mud]).
t2n() -> catch ?MODULE:fn([mud]).
t3e() -> catch ?MODULE:fe([mud]).
t4e() -> catch ?MODULE:fn([mud]).

t5n() ->  catch apply(?MODULE, fe, [mud]).
t6n() ->  catch apply(?MODULE, fn, [mud]).
t7e() ->  catch apply(?MODULE, fe, [mud]).
t8e() ->  catch apply(?MODULE, fn, [mud]).

annn() -> catch bnn().
anne() -> catch bne().
anen() -> catch ben().
anee() -> catch bee().
aenn() -> catch bnn().
aene() -> catch bne().
aeen() -> catch ben().
aeee() -> catch bee().

bnn() -> {cn([])}.
bne() -> {ce([])}.
ben() -> {cn([])}.
bee() -> {ce([])}.
 
fe(dum) -> ok.
fn(dum) -> ok.

ce(X) ->
  case X of
    dum ->
      ok
  end.

cn(X) ->
  case X of
    dum ->
      ok
  end.
