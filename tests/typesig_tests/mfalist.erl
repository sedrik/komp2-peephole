-module(mfalist).

-export([mfa/2]).

mfa(BeamFuns, {M,F,A} = MFA) when is_atom(M), is_atom(F), is_integer(A) ->
  ModCode = [beam_disasm:function__code(F) || F <- BeamFuns],
  mfa_loop([MFA], [], sets:new(), ModCode).

%% The problem is in the types inferred for function mfa_loop/4:
%% typesig somehow loses the information that the first list and part
%% of the second list consists of mfas and not just triples -- why?
mfa_loop([{M,F,A} = MFA | MFAs], Acc, Seen, ModCode)
  when is_atom(M), is_atom(F), is_integer(A) ->
  case sets:is_element(MFA, Seen) of
    true ->
      mfa_loop(MFAs, Acc, Seen, ModCode);
    false ->
      {Icode, FunMFAs} = mfa_get(M, F, A, ModCode),
      mfa_loop(FunMFAs ++ MFAs, [{MFA, Icode} | Acc],
	       sets:add_element(MFA, Seen), ModCode)
  end;
mfa_loop([], Acc, _, _) ->
  lists:reverse(Acc).

mfa_get(M, F, A, ModCode) ->
  BeamCode = foo:get_fun(ModCode, M,F,A),
  Icode = foo:trans_mfa_code(M,F,A, BeamCode),
  FunMFAs = get_fun_mfas(BeamCode),
  {Icode, FunMFAs}.

get_fun_mfas([{patched_make_fun,{M,F,A} = MFA,_,_,_}|BeamCode])
  when is_atom(M), is_atom(F), is_integer(A) ->
  [MFA|get_fun_mfas(BeamCode)];
get_fun_mfas([_|BeamCode]) ->
  get_fun_mfas(BeamCode);
get_fun_mfas([]) ->
  [].

