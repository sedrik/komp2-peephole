%%=====================================================================
%% Module (from erl_parse.erl) showing that the widening function was
%% losing too much information when record-like tuples were involved.
%%
%% Problem description
%% -------------------
%% We are hitting some sort of limit here, because commenting out any
%% clause solves the problem, but I do not really see why this limit
%% is relevant.  Ideally, in this case, the widening should be to:
%%	t_tuple(2) | t_tuple(4) | t_tuple(4)
%% If that's too difficult to:
%%	t_tuple()
%% But widening to t_any() is not acceptable.
%%
%% FIXED: 29 Jan 2007
%%=====================================================================

-module(tuple5).
-export([normalise/1]).

-type(tags() :: nil | atom | bin | char | float | integer |
                string | tuple | cons | op | record_field).

%-spec (normalise/1 :: (({tags(),any()} | {tags(),any(),any()} | 
%			{tags(),any(),any(),any()}) -> any())).
-spec (normalise/1 :: (({tags(),any()}) -> any());
		      (({tags(),any(),any()}) -> any()); 
		      (({tags(),any(),any(),any()}) -> any())).

normalise({char,_,C}) -> C;
normalise({integer,_,I}) -> I;
normalise({float,_,F}) -> F;
normalise({atom,_,A}) -> A;
normalise({string,_,S}) -> S;
normalise({nil,_}) -> [];
normalise({bin,_,Fs}) ->
    {value, B, _} =
        eval_bits:expr_grp(Fs, [],
                           fun(E, _) ->
                                   {value, normalise(E), []}
                           end, [], true),
    B;
normalise({cons,_,Head,Tail}) ->
    [normalise(Head)|normalise(Tail)];
normalise({tuple,_,Args}) ->
    list_to_tuple(normalise_list(Args));
%% Atom dot-notation, as in 'foo.bar.baz'
normalise({record_field,_,_,_}=A) ->
    As = foo:package_segments(A),
    list_to_atom(packages:concat(As));
%% Special case for unary +/-.
normalise({op,_,'+',{char,_,I}}) -> I;
normalise({op,_,'+',{integer,_,I}}) -> I;
normalise({op,_,'+',{float,_,F}}) -> F;
normalise({op,_,'-',{char,_,I}}) -> -I;         %Weird, but compatible!
normalise({op,_,'-',{integer,_,I}}) -> -I;
normalise({op,_,'-',{float,_,F}}) -> -F.

normalise_list([H|T]) ->
    [normalise(H)|normalise_list(T)];
normalise_list([]) ->
    [].
