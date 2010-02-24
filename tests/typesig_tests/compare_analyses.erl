%%%-------------------------------------------------------------------
%%% File    : compare_analyses.erl
%%% Author  : Tobias Lindahl <tobiasl@it.uu.se>
%%% Description : 
%%%
%%% Created : 21 Dec 2004 by Tobias Lindahl <tobiasl@it.uu.se>
%%%-------------------------------------------------------------------
-module(compare_analyses).

-export([doit/1]).

doit([Module]) when is_list(Module) ->
  wait_init(),
  {ok, AbstrCode} =dialyzer_utils:get_abstract_code_from_src(Module),
  {ok, Code} = dialyzer_utils:get_core_from_abstract_code(AbstrCode),
  {ok, Records} = dialyzer_utils:get_record_and_type_info(AbstrCode),
  {ok, Contracts} = dialyzer_utils:get_spec_info(AbstrCode, Records),
  TypeAnSigs = get_typean_sigs(Code),
  TypeSigSigs = dialyzer_succ_typings:get_top_level_signatures(Code, Records, Contracts),
  DFSigs = dialyzer_dataflow:get_top_level_signatures(Code, Records),
  compare_sigs(Module, TypeSigSigs, DFSigs, TypeAnSigs, Records).

get_typean_sigs(Code0) ->
  Code = cerl_typean:core_transform(Code0, []),
  Tree = cerl:from_records(Code),
  Defs = cerl:module_defs(Tree),
  GetFunType = 
    fun(X) -> 
	Out0 = proplists:get_value(type, cerl:get_ann(X)),
	Vars = cerl:fun_vars(X),
	VarTypes0 = [proplists:get_value(type, cerl:get_ann(V)) || V <- Vars],
	%% Variables types as any() are not annotated.
	[Out|VarTypes] = lists:map(fun(undefined) -> erl_types:t_any();
				      (T) -> T
				   end, [Out0|VarTypes0]),
	erl_types:t_fun(VarTypes, Out)
    end,
  [{cerl:var_name(Var), GetFunType(Fun)} || {Var, Fun} <- Defs].

compare_sigs(Module, TypeSigSigs, DFSigs, TypeAnSigs, Records) ->
  compare_sigs_1(list_to_atom(Module), 
		 lists:keysort(1, TypeSigSigs),
		 lists:keysort(1, DFSigs),
		 lists:keysort(1, TypeAnSigs),
		 Records).

compare_sigs_1(M, 
	       [{{F, A}, TSType}|TSLeft], 
	       [{{F, A}, DFType}|DFLeft], 
	       [{{F, A}, TAType}|TALeft],
	       Records) ->
  case (F == module_info andalso A =< 1) of
    true -> ok;	%% no need to show the module_info/[0,1] type signatures
    false ->
      "fun" ++ TSTypeString = erl_types:t_to_string(TSType, Records),
      "fun" ++ DFTypeString = erl_types:t_to_string(DFType, Records),
      "fun" ++ TATypeString = erl_types:t_to_string(TAType, Records),
      case erl_types:t_is_subtype(TSType, DFType) 
	andalso erl_types:t_is_subtype(DFType, TAType) of
        true ->
          io:format("~w : OK\n typesig:  ~s\n dataflow: ~s\n   typean: ~s\n", 
		    [{M, F, A}, TSTypeString, DFTypeString, TATypeString]);
        false ->
          io:format("~w : differ!!!\n typesig:  ~s\n"
		    " dataflow: ~s\n   typean: ~s\n", 
		    [{M, F, A}, TSTypeString, DFTypeString, TATypeString])
      end
  end,
  compare_sigs_1(M, TSLeft, DFLeft, TALeft, Records);
compare_sigs_1(_M, [], [], [], _Records) ->
  ok.

wait_init() ->
  case erlang:whereis(code_server) of
    undefined ->
      erlang:yield(),
      wait_init();
    _ ->
      ok
  end.
