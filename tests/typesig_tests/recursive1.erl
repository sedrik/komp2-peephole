%% Program fragment taken from "hipe.erl" and used as example in the
%% PPDP success typing paper.  Currently it shows that the automatic
%% inference of recursive data structures leaves much to be desired.

-module(recursive1).
-export([beam_file/1]).

beam_file({M,_F,_A}) ->
  beam_file(M);
beam_file(Module) when is_atom(Module) ->
  case code:which(Module) of
    non_existing ->
      exit({cant_find_beam_file,Module});
    File ->
      File
  end.

