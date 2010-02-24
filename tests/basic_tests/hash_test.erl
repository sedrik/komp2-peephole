%% ====================================================================
%% Test module for the HiPE test suite.  Taken from hash_SUITE.erl
%%
%%  Filename :  hash_test.erl
%%  Purpose  :  Checks correct handling of exceptions.
%%  History  :  * 2001-09-19 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/08/20 12:40:50 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(hash_test).
-export([test/0,compile/1,spread_test/1]).

test() ->
    spread_test(5).
    
compile(Flags) ->
    hipe:c(?MODULE,Flags).

spread_test(N) ->
    test_fun(N,{erlang,phash},16#50000000000,fun(X) ->
                                                     X
                                             end),
    test_fun(N,{erlang,phash},0,fun(X) ->
					X
                                end),
    test_fun(N,{erlang,phash},16#123456789ABCDEF123456789ABCDEF,fun(X) ->
                                                                        X
                                                                end),
    test_fun(N,{erlang,phash},16#50000000000,fun(X) ->
                                                     integer_to_list(X)
                                             end),
    test_fun(N,{erlang,phash},16#50000000000,fun(X) ->
                                                     integer_to_bytelist(X,[])
                                             end),
    test_fun(N,{erlang,phash},16#50000000000,fun(X) ->
                                                     integer_to_binary(X)
                                             end).

test_fun(N,{HM,HF}, Template, Fun) ->
    init_table(),
    test_fun_1(0,1,N+1,{HM,HF},Template,Fun).

test_fun_1(_,To,To,_,_,_) ->
    ok;
test_fun_1(A,X,To,Y,Z,W) when A > To ->
    %% io:format("~p:~p(~p,~p,~p,~p,~p,~p)~n",[?MODULE,test_fun_1,To,X,To,Y,Z,W]),
    test_fun_1(0,X+1,To,Y,Z,W);
test_fun_1(Pos,Siz,To,{HM,HF},Template,Fun) when 1 bsl (Siz*8) =< 65536 ->
    %% io:format("Byte: ~p, Size: ~p~n",[Pos,Siz]),
    N = 1 bsl (Siz*8),
    gen_keys(N,Template,Pos,fun (X) ->
                                    P = HM:HF(Fun(X),N),
                                    ets:insert(?MODULE,{P})
                            end
            ),
    Hits = collect_hits(),
    io:format("Hashing of ~p values spread over ~p buckets~n",[N,Hits]),
    case (N div Hits) > 2 of
        true ->
            exit({not_spread_enough, Hits, on, N});
        _ ->
            test_fun_1(Pos + Siz, Siz, To,{HM,HF},Template,Fun)
    end;
test_fun_1(_,_,_,_,_,_) ->
    ok.

init_table() ->
    (catch ets:delete(?MODULE)),
    ets:new(?MODULE,[ordered_set,named_table]).

collect_hits() ->
    N = ets:info(?MODULE,size),
    init_table(),
    N.


integer_to_binary(N) ->
    list_to_binary(lists:reverse(integer_to_bytelist(N,[]))).

integer_to_bytelist(0,Acc) ->
    Acc;
integer_to_bytelist(N,Acc) ->
    integer_to_bytelist(N bsr 8, [N band 16#FF | Acc]).


gen_keys(N, Template, BP, Fun) ->
    Ratio = (1 bsl (BP * 8)),
    Low = Template + Ratio,
    High = Template + (N*Ratio),
    %% io:format("N = ~p, BP = ~p, Template = ~p, Low = ~s, High = ~s~n",
    %%           [hex(N),hex(BP),hex(Template),hex(Low),hex(High-1)]),
    Fun(Template),
    gen_keys2(Low, High,Ratio,Fun).

gen_keys2(High,High2,_,_) when High >= High2 ->
    [];
gen_keys2(Low,High,R,Fun) ->
    Fun(Low),
    gen_keys2(Low + R,High,R,Fun).

%%hex(N) ->
%%    hex(0,N,[]).

%%hex(X,0,Acc) when X >= 8 ->
%%    [$0, $x | Acc];
%%hex(X,N,Acc) ->
%%    hex(X+1,N bsr 4, [trans(N band 16#F) | Acc]).

%%trans(N) when N < 10 ->
%%    N + $0;
%%trans(10) ->
%%    $A;
%%trans(11) ->
%%    $B;
%%trans(12) ->
%%    $C;
%%trans(13) ->
%%    $D;
%%trans(14) ->
%%    $E;
%%trans(15) ->
%%    $F.
