%%============================================================================
%% This is supposed to test two things: 
%%   1. That type inference is able to infer that BodyPart is a proper list.
%%   2. That the Len argument is an integer.
%% Currently, #1 is achieved, but #2 requires correct handling of ==/2.
%%============================================================================

-module(list7).
-export([read_entity_body/2]).

read_entity_body(Len, BodyPart) when Len == length(BodyPart) ->
    {ok, BodyPart}.

