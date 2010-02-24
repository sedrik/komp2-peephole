%% ====================================================================
%% Test module for the HiPE test suite.  Taken from exception_SUITE.erl
%%
%%  Filename :  exception01.erl
%%  Purpose  :  Checks correct handling of exceptions.
%%  History  :  * 2001-09-17 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2007/01/21 11:01:18 $
%%    $Revision: 1.9 $
%% ====================================================================

-module(exception01).
-export([test/0,compile/1,pending/2]).

-export([bad_guy/2]).

test() ->
    error_logger:tty(false),	% disable printouts of error reports
    pending_errors().
    
compile(Flags) ->
    hipe:c(?MODULE,Flags).

%% Test various exceptions, in the presence of a previous error
%% suppressed in a guard.
pending_errors() ->
    pending(e_badmatch, {badmatch,b}),
    pending(x, function_clause),
    pending(e_case, {case_clause,xxx}),
    pending(e_if, if_clause),
    %% pending(e_badarith, badarith),
    %% pending(e_undef, undef),
    %% pending(e_timeoutval, timeout_value),
    %% pending(e_badarg, badarg),
    %% pending(e_badarg_spawn, badarg),
    ok.

%% ================== AUXILIARY FUNCTIONS =============================

bad_guy(pe_badarith, Other) when Other+1 =:= 0 -> % badarith (suppressed)
    ok;
bad_guy(pe_badarg, Other) when length(Other) > 0 -> % badarg (suppressed)
    ok;
bad_guy(_, e_case) ->
    case xxx() of
        ok -> ok
    end;                                        % case_clause
bad_guy(_, e_if) ->
    B = b(),
    if
        a == B -> ok
    end;                                        % if_clause
%% bad_guy(_, e_badarith) ->
%%     1+b;                                        % badarith
bad_guy(_, e_undef) ->
    non_existing_module:foo();                  % undef
bad_guy(_, e_timeoutval) ->
    receive
        after arne ->                           % timeout_value
                ok
        end;
bad_guy(_, e_badarg) ->
    node(xxx);                                  % badarg
bad_guy(_, e_badarg_spawn) ->
    spawn({}, {}, {});                          % badarg
bad_guy(_, e_badmatch) ->
    a = b().                                    % badmatch

xxx() ->
    xxx.

b() ->
    b.

pending(Arg, Expected) ->
    pending(pe_badarith, Arg, Expected),
    pending(pe_badarg, Arg, Expected).

pending(First, Second, Expected) ->
    pending_catched(First, Second, Expected),
    pending_exit_message([First, Second], Expected).

pending_catched(First, Second, Expected) ->
    %% ok = io:format("Catching bad_guy(~p, ~p)\n", [First, Second]),
    case catch bad_guy(First, Second) of
        {'EXIT', Reason} ->
            pending(Reason, bad_guy, [First, Second], Expected);
        Other ->
            exit({not_exit, Other})
    end.

pending_exit_message(Args, Expected) ->
    %% ok = io:format("Trapping exits from spawn_link(~p, ~p, ~p)\n",
    %%                [?MODULE, bad_guy, Args]),
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, bad_guy, Args),
    receive
        {'EXIT', Pid, Reason} ->
            pending(Reason, bad_guy, Args, Expected);
        Other ->
            exit({unexpected_message, Other})
    after 10000 ->
            exit(timeout)
    end,
    process_flag(trap_exit, false).

%% pending({badarg, [{erlang,Bif,BifArgs},{?MODULE,Func,Arity}|_]},
%% 	Func, Args, _Code)
%%   when atom(Bif), list(BifArgs), length(Args) == Arity ->
%%     ok;
pending({badarg,Trace}, _, _, _) when is_list(Trace) ->
    ok;
%% pending({undef,[{non_existing_module,foo,[]}|_]}, _, _, _) ->
%%     ok;
pending({undef,Trace}, _, _, _)  when is_list(Trace) ->
    ok;
%% pending({function_clause,[{?MODULE,Func,Args}|_]}, Func, Args, _Code) ->
%%     ok;
pending({function_clause,Trace}, _, _, _) when is_list(Trace) ->
    ok;
%% pending({Code,[{?MODULE,Func,Arity}|_]}, Func, Args, Code)
%%   when length(Args) == Arity ->
%%     ok;
pending({Code,Trace}, _, _, Code) when is_list(Trace) ->
    ok;
pending(Reason, _Function, _Args, _Code) ->
    exit({bad_exit_reason,Reason}).
