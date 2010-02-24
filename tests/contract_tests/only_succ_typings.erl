%%%-------------------------------------------------------------------
%%% File    : only_succ_typings
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 21 Dec 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(only_succ_typings).
 
-export([doit/1]).

doit([Module]) when is_list(Module) ->
  wait_init(),
  AbstrCode = dialyzer_utils:get_abstract_code_from_src(Module, [no_copt]),
  Code = dialyzer_utils:get_core_from_abstract_code(AbstrCode, [no_copt]),
  {ok, Records} = dialyzer_utils:get_record_info(AbstrCode),
  %{ok, Contracts} = dialyzer_utils:get_spec_info(AbstrCode),
  Sigs0 = dialyzer_succ_typings:get_top_level_signatures(Code, Records),
  M = 
    if is_atom(Module) ->  
       	list_to_atom(filename:basename(atom_to_list(Module)));
       is_list(Module) -> 
	list_to_atom(filename:basename(Module))
    end,
  Sigs1 = [{{M, F, A}, Type} || {{F, A}, Type} <- Sigs0],
  Sigs = ordsets:from_list(Sigs1),
  io:nl(),
  pp_signatures(Sigs, Records),
  ok.


pp_signatures([{{_, module_info, 0}, _}|Left], Records) -> 
  pp_signatures(Left, Records);
pp_signatures([{{_, module_info, 1}, _}|Left], Records) -> 
  pp_signatures(Left, Records);
pp_signatures([{{M, F, A}, Type}|Left], Records) ->
  TypeString =
    case cerl:is_literal(Type) of
      true -> io_lib:format("~w", [cerl:concrete(Type)]);
      false -> "fun" ++ String = erl_types:t_to_string(Type, Records),
	       String
    end,
  io:format("~w:~w/~w :: ~s\n", [M, F, A, TypeString]),
  pp_signatures(Left, Records);
pp_signatures([], _Records) ->
  ok.

wait_init() ->
  case erlang:whereis(code_server) of
    undefined ->
      erlang:yield(),
      wait_init();
    _ ->
      ok
  end.
