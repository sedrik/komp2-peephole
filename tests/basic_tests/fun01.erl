%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <2004-08-20 16:52:20 richardc>
%% ====================================================================
%%  Filename : fun01.erl
%%  Module   : fun01
%%  Purpose  :  
%%  Notes    : 
%%  History  : * 2001-01-10 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: richardc $
%%              $Date: 2004/08/20 14:58:46 $
%%              $Revision: 1.10 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(fun01).
-export([test/0, compile/1]).
%% The following exports are so that inlining does not eliminate
%% these functions (which are used as hipe:c arguments).
-export([n_mk_fun/3, n_call_fun/1, n_call_fun2/1,
	 b_arity/0, c_barity/0, b_fun/0, l/0, l2/2]).

test() ->
  EF = e_mk_fun(1,2,3),
  NF = n_mk_fun(1,2,3),
  EF2 = e_mk_fun2(1,2,3),
  EBA = c_barity(),
  NBA = c_barity(),
  EBF = b_fun(),  
  NBF = b_fun(),  
  {e_call_fun(EF),   %% Call emu from emu
   n_call_fun(NF),   %% Call native from native
   e_call_fun(NF),   %% Call native from emu
   n_call_fun(EF),   %% Call emu from native
   n_call_fun2(EF2),
   EBA,
   NBA,
   EBF,
   NBF,
  l()}.
   
compile(Opts) ->
  case proplists:get_bool(core, Opts) of
    false ->
      hipe:c({?MODULE,test,0}, Opts),
      hipe:c({?MODULE,n_mk_fun,3}, Opts),
      hipe:c({?MODULE,n_call_fun,1}, Opts),
      hipe:c({?MODULE,n_call_fun2,1}, Opts),  
      hipe:c({?MODULE,b_arity,0}, Opts),
      hipe:c({?MODULE,c_barity,0}, Opts),
      hipe:c({?MODULE,b_fun,0}, Opts),
      hipe:c({?MODULE,l,0}, Opts),
      hipe:c({?MODULE,l2,2}, Opts),
      {ok, ?MODULE};
    true ->
      %% This defeats the real purpose of the test since it does not
      %% test calling BEAM funs from native code and vice versa, but
      %% that will never be possible since only whole modules can be
      %% compiled from core.
      test:note(?MODULE, "native-compiling whole module"),
      hipe:c(?MODULE, Opts)
  end.


l() ->
  {_T,_} = erlang:statistics(runtime),

  F =
    fun (_, 0) ->
	    ok;
	(F2, N) -> (F2)(F2,N-1)
    end,
  %% fun(X,Y) -> [T] end,
  {T1,_} = erlang:statistics(runtime),
  l2(F,1000),
  {T2,_} = erlang:statistics(runtime),
  io:format("Runtime: ~w ms\n",[T2-T1]).


l2(_,0) ->
  done;
l2(F,N) ->
  (F)(F,500),
  l2(F,N-1).


e_mk_fun(A,B,C) ->
  D = A+C,
  fun (E, F, G) ->
      {A, B, C, D, E, F, G}
  end.

n_mk_fun(A,B,C) ->
  D = A+C,
  fun (E, F, G) ->
      {A, B, C, D, E, F, G}
  end.

e_call_fun(F) ->
  F(5,6,7).

n_call_fun(F) ->
  F(5,6,7).

e_mk_fun2(A,B,C) ->
  D = A+C,
  fun (E, F, G, H, I, J) ->
      {A, B, C, D, E, F, G, H, I, J}
  end.

n_call_fun2(F) ->
  F(5,6,7,8,9,10).

b_arity() ->
  fun (A) ->
      A
  end.

c_barity() ->
  F = b_arity(),
  {case catch F() of
       {'EXIT',_BadSomething} -> {'EXIT',bad_something};
       Other -> Other
   end,
   case catch F(1) of
       {'EXIT',_BadSomething} -> {'EXIT',bad_something};
       Other -> Other
   end,
   case catch F(1,2) of
      {'EXIT',_BadSomething} -> {'EXIT',bad_something};
       Other -> Other
   end}.

b_fun() ->
  A = 1,
  case catch A(2) of
      {'EXIT',_BadSomething} -> {'EXIT',bad_something};
      Other -> Other
  end.
