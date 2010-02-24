%%% -*- erlang-indent-level: 2 -*-
%%% $Id: load_bug2.erl,v 1.3 2005/04/06 10:54:29 tobiasl Exp $
%%%
%%% Tests whether module loading invalidates all paths to obsolete code.

-module(load_bug2).
-export([test/0, compile/1]).

compile(Flags) ->
  code:purge(tmp),
  code:delete(tmp),
  hipe:c(?MODULE,Flags).

test() ->
  FN_erl = "/tmp/tmp.erl",
  FN_beam = "/tmp/tmp.beam",
  true = write_compile_run(FN_erl, prog1()),
  case write_compile_run(FN_erl, prog2()) of
    {'EXIT',{undef,[{tmp,tmp,[]}|_]}} ->
      file:delete(FN_erl),
      file:delete(FN_beam),
      ok;
    true -> error % we get true from the stale code
  end.

write_compile_run(FN, Prog) ->
  file:write_file(FN, Prog),
  {ok, _} = c:c(FN, [native,{outdir, "/tmp/"}]),
  catch(tmp:tmp()).

prog1() ->
  <<"-module(tmp).\n",
    "-export([tmp/0, tmp2/0]).\n",
    "tmp() -> true.\n", % hipe_bifs:in_native() is currently broken
    "tmp2() -> 27.\n">>.

prog2() ->
  <<"-module(tmp).\n",
    "-export([tmp2/0]).\n",
    "tmp2() -> 27.\n">>.
