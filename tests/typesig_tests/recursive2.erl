%% Program showing a bug in inferrence of refined success typings.
%% Type propagation resulted in none() for the two collect functions.

-module(recursive2).
-export([collect/2]).

collect([$~|Fmt0], Args0) ->
    {C,Fmt1,Args1} = collect_cseq(Fmt0, Args0),
    [C|collect(Fmt1, Args1)];
collect([C|Fmt], Args) ->
    [C|collect(Fmt, Args)];
collect([], []) -> [].

collect_cseq(Fmt0, Args0) ->
    {F,Ad,Fmt1,Args1} = field_width(Fmt0, Args0),
    {{F,Ad},Fmt1,Args1}.

field_val([$*|Fmt], [A|Args]) when is_integer(A) ->
    {A,Fmt,Args};
field_val([C|Fmt], Args) when C >= $0, C =< $9 ->
    value([C|Fmt], Args, 0);
field_val(Fmt, Args) ->
    {tag,Fmt,Args}.

field_width([$-|Fmt0], Args0) ->
    {F,Fmt,Args} = field_val(Fmt0, Args0),
    width(-F, Fmt, Args);
field_width(Fmt0, Args0) ->
    {F,Fmt,Args} = field_val(Fmt0, Args0),
    width(F, Fmt, Args).

value([C|Fmt], Args, F) when is_integer(C), C >= $0, C =< $9 ->
    value(Fmt, Args, 10*F + (C - $0));
value(Fmt, Args, F) ->
    {F,Fmt,Args}.

width(F, Fmt, Args) when F < 0 ->
    {-F,left,Fmt,Args};
width(F, Fmt, Args) when F >= 0 ->
    {F,right,Fmt,Args}.

