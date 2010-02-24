%% Shows how the analysis till Jan 2007 totally gives up when a catch
%% is encountered.  No matter what happens here, the return type is a
%% string().  Also, clearly B is a binary for the function to return.
%% These should be fixed.
%% On the other hand, we cannot infer much information for Max's type.

-module(catch2).
-export([bin_to_list_max/2]).

bin_to_list_max(B, Max) ->
    case catch binary_to_list(B, 1, Max) of
	{'EXIT',_} -> binary_to_list(B);
	Other -> Other
    end.

