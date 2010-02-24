%% Why does dataflow print better information for the following?
%%
%% {str2,all_tails,1} :
%%  typesig:  (([[char(),...],...]) -> [string()])
%%  dataflow: (([string(),...]) -> [string()])

-module(str2).
-export([match/3]).

match(Prefix, As, Extra) ->
    Len = length(Prefix),
    Matches = [{S, A} || {H, A} <- As, lists:prefix(Prefix,S=atom_to_list(H))],
    case longest_common_head([N || {N,_} <- Matches]) of
 	{partial, []} ->
 	    {no, [], Matches};
 	{partial, Str} ->
 	    case lists:nthtail(Len, Str) of
 		[] ->
		    {yes, [], Matches};
 		Remain ->
 		    {yes, Remain, []}
 	    end;
 	{complete, Str} ->
 	    {yes, lists:nthtail(Len, Str) ++ Extra, []};
 	no ->
 	    {no, [], []}
    end.

longest_common_head([]) ->
    no;
longest_common_head(LL) ->
    longest_common_head(LL, []).

longest_common_head([[]|_], L) ->
    {partial, lists:reverse(L)};
longest_common_head(LL, L) ->
    case same_head(LL) of
 	true ->
 	    [[H|_]|_] = LL,
 	    LL1 = all_tails(LL),
 	    case all_nil(LL1) of
 		false ->
 		    longest_common_head(LL1, [H|L]);
 		true ->
 		    {complete, lists:reverse([H|L])}
 	    end;
 	false ->
 	    {partial, lists:reverse(L)}
    end.

same_head([[H|_]|T1]) -> same_head(H, T1).

same_head(H, [[H|_]|T]) -> same_head(H, T);
same_head(_, [])        -> true;
same_head(_, _)         -> false.

all_tails(LL) -> all_tails(LL, []).

all_tails([[_|T]|T1], L) -> all_tails(T1, [T|L]);
all_tails([], L)         -> L.

all_nil([]) -> true;
all_nil([[] | Rest]) -> all_nil(Rest);
all_nil(_) -> false.
