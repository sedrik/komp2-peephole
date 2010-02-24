%% 
%%     $Id: undef_func.erl,v 1.42 2008/03/25 10:10:54 kostis Exp $
%%

-module(undef_func).

-export([test/0,compile/1]).

compile(_Options) ->
    ok. %% No native code compilation.

test() ->
    Root = code:root_dir(),
    HiPE = Root ++ "/lib/hipe",
    Dialyzer = Root ++ "/lib/dialyzer",
    Path = [Root ++ D || D <- ["/lib/kernel/ebin",
			       "/lib/stdlib/ebin",
			       "/lib/compiler/ebin",
			       %% syntax_tools is needed by cerl_typean
			       "/lib/syntax_tools/ebin",
			       %% gs and edoc are needed for the hipe_tool
			       "/lib/gs/ebin", "/lib/edoc/ebin"]],
    Server = hipe_testsuite,
    xref:start(Server),
    xref:set_default(Server, [{verbose,false},{warnings,false}]),
    xref:set_library_path(Server, Path),
    {ok,_} = xref:add_application(Server, HiPE),
    {ok,_} = xref:add_application(Server, Dialyzer),
    {ok,Undef} = xref:analyze(Server, undefined_function_calls),
    {ok,UnusedLocals} = xref:analyze(Server, locals_not_used),
    {ok,UnusedExports} = xref:analyze(Server, exports_not_used),
    ReallyUnusedExports = lists:subtract(UnusedExports, used_exports()),
    catch xref:stop(Server),
    U1 = case Undef of
	     [] -> no_undefined_functions;
	     _ ->
		 lists:foreach(fun ({MFA1,MFA2}) ->
				  io:format("~s calls undefined ~s\n",
					    [format_mfa(MFA1),
					     format_mfa(MFA2)])
			       end, Undef),
		 {undefined_functions,Undef}
	 end,
    U2 = case UnusedLocals of
	     [] -> no_unused_local_functions;
	     _ ->
		 lists:foreach(fun (MFA) ->
				  io:format("unused: ~s\n", [format_mfa(MFA)])
			       end, UnusedLocals),
		 {unused_locals,UnusedLocals}
	 end,
    U3 = case ReallyUnusedExports of
	     [] -> no_unused_exported_functions;
	     _ ->
		 lists:foreach(fun (MFA) ->
				  io:format("exported but unused: ~s\n",
					    [format_mfa(MFA)])
			       end, ReallyUnusedExports),
		 {unused_exports,ReallyUnusedExports}
	 end,
    {U1,U2,U3}.

%%% "(XC - UC) || (XU - X - B)"

format_mfa({M,F,A}) ->
    io_lib:format("~s:~s/~p", [M,F,A]).

%%=====================================================================
%% Below appears some hard-coded information about exported functions
%% which are used either outside the hipe application, or are used
%% in the form of apply calls and xref does not discover this fact.
%%=====================================================================

used_exports() ->
    hipe_application_interface() ++
    dialyzer_application_interface() ++
    hipe_exports_used_as_remote_apply_calls().

%%
%% This is the list of all functions which are supposed to be
%% accessible by the user or by other applications.
%%
hipe_application_interface() ->
    [
     {hipe,help,0},
     {hipe,help_hiper,0},
     {hipe,help_option,1},
     {hipe,help_options,0},
     {hipe,compile,1},
     {hipe,compile,2},
     {hipe,compile,4},	%% used by compiler/src/compile.erl
     {hipe,compile_core,4},  %% for the dialyzer
     {hipe,f,1},
     {hipe,f,2},
     {hipe,file,1},
     {hipe,file,2},
     {hipe,load,1},
     {hipe,has_hipe_code,1},
     {hipe,help_debug_options,0},
     {hipe,version,0},
     {hipe_ceach,c,1},
     {hipe_ceach,c,2},
     {hipe_ceach,c,3},
     {hipe_jit,start,0},
     {hipe_tool,start,0},

     {erl_types,t_nonempty_string,0},	     %% used by Typer
     {erl_types,t_improper_list,1},	     %% used by Typer
     {erl_types,t_nonempty_improper_list,1}, %% used by Typer
     {erl_types,t_nonempty_improper_list,0}, %% used by Typer
     {erl_types,t_to_string,2},		     %% used by Typer

     {hipe_dot,translate_digraph,3}, %% eventually these will be used 
     {hipe_dot,translate_digraph,5}, %% inside HiPE, but now they are 
     {hipe_dot,translate_list,3},    %% mostly used from the outside
     {hipe_dot,translate_list,5},    %% by Tobias
     {hipe_dot,translate_list,4},

     {erl_bif_types,type,3},	     %% exported for testing purposes
     {cerl_closurean,annotate,1},    %% exported for testing purposes
     {cerl_cconv,core_transform,2},  %% called from corec as metacall + used by Dialyzer
     {cerl_typean,analyze,1},        %% exported for testing purposes
     {cerl_typean,core_transform,2}, %% called from corec as metacall
     {cerl_typesig,get_export_signatures,1}, %% Used in typesig_test
     {cerl_typesig,doit,1},          %% exported for testing purposes
     {cerl_typesig,core_transform,2},%% called from corec as metacall
     {cerl_prettypr,format,1},       %% exported for testing purposes
     {cerl_prettypr,format,2},       %% exported for testing purposes
     {cerl_prettypr,annotate,3},     %% exported for testing purposes
     {cerl_typean,pp_hook,0},        %% exported for testing purposes
     {cerl_hybrid_transform,core_transform,2}%% used by compiler/src/v3_core_opt.erl
    ].

%%
%% I would love if there were a way for the following to be discovered
%% automatically, but currently there does not appear to be any...
%%
hipe_exports_used_as_remote_apply_calls() ->
    [
     {hipe_graph_coloring_regalloc,regalloc,5},
     {hipe_coalescing_regalloc,regalloc,5},
     {hipe_optimistic_regalloc,regalloc,5},

     {hipe_sparc_specific,analyze,1},
     {hipe_sparc_specific,bb,2},
     {hipe_sparc_specific,args,1},
     {hipe_sparc_specific,labels,1},
     {hipe_sparc_specific,livein,2},
     {hipe_sparc_specific,liveout,2},
     {hipe_sparc_specific,uses,1},
     {hipe_sparc_specific,defines,1},
     {hipe_sparc_specific,def_use,1},
     {hipe_sparc_specific,is_arg,1},   %% used by hipe_ls_regalloc
     {hipe_sparc_specific,is_move,1},
     {hipe_sparc_specific,is_fixed,1}, %% used by hipe_graph_coloring_regalloc
     {hipe_sparc_specific,is_global,1},
     {hipe_sparc_specific,is_precoloured,1},
     {hipe_sparc_specific,reg_nr,1},
     {hipe_sparc_specific,non_alloc,1},
     {hipe_sparc_specific,allocatable,0},
     {hipe_sparc_specific,physical_name,1},
     {hipe_sparc_specific,all_precoloured,0},
     {hipe_sparc_specific,new_spill_index,1},
     {hipe_sparc_specific,var_range,1},
     {hipe_sparc_specific,breadthorder,1},
     {hipe_sparc_specific,postorder,1},
     {hipe_sparc_specific,reverse_postorder,1},
     {hipe_sparc_specific,preorder,1},
     {hipe_sparc_specific,inorder,1},
     {hipe_sparc_specific,reverse_inorder,1},
     {hipe_sparc_specific,predictionorder,1},

     {hipe_sparc_specific_fp,analyze,1},
     {hipe_sparc_specific_fp,bb,2},
     {hipe_sparc_specific_fp,args,1},
     {hipe_sparc_specific_fp,labels,1},
     {hipe_sparc_specific_fp,livein,2},
     {hipe_sparc_specific_fp,liveout,2},
     {hipe_sparc_specific_fp,uses,1},
     {hipe_sparc_specific_fp,defines,1},
     {hipe_sparc_specific_fp,is_arg,1},
     {hipe_sparc_specific_fp,is_global,1},
     {hipe_sparc_specific_fp,reg_nr,1},
     {hipe_sparc_specific_fp,physical_name,1},
     {hipe_sparc_specific_fp,new_spill_index,1},
     {hipe_sparc_specific_fp,breadthorder,1},
     {hipe_sparc_specific_fp,postorder,1},
     {hipe_sparc_specific_fp,reverse_postorder,1},

     {hipe_ppc_specific,all_precoloured,0},
     {hipe_ppc_specific,allocatable,0},
     {hipe_ppc_specific,analyze,1},
     {hipe_ppc_specific,args,1},
     {hipe_ppc_specific,bb,2},
     {hipe_ppc_specific,breadthorder,1},
     {hipe_ppc_specific,check_and_rewrite,2},
     {hipe_ppc_specific,def_use,1},
     {hipe_ppc_specific,defines,1},
     {hipe_ppc_specific,defun_to_cfg,1},
     {hipe_ppc_specific,is_arg,1},
     {hipe_ppc_specific,is_fixed,1},
     {hipe_ppc_specific,is_global,1},
     {hipe_ppc_specific,is_move,1},
     {hipe_ppc_specific,is_precoloured,1},
     {hipe_ppc_specific,labels,1},
     {hipe_ppc_specific,livein,2},
     {hipe_ppc_specific,liveout,2},
     {hipe_ppc_specific,new_spill_index,1},
     {hipe_ppc_specific,non_alloc,1},
     {hipe_ppc_specific,number_of_temporaries,1},
     {hipe_ppc_specific,postorder,1},
     {hipe_ppc_specific,physical_name,1},
     {hipe_ppc_specific,reg_nr,1},
     {hipe_ppc_specific,reverse_postorder,1},
     {hipe_ppc_specific,uses,1},
     {hipe_ppc_specific,var_range,1},

     {hipe_ppc_specific_fp,all_precoloured,0},
     {hipe_ppc_specific_fp,allocatable,0},
     {hipe_ppc_specific_fp,analyze,1},
     {hipe_ppc_specific_fp,bb,2},
     {hipe_ppc_specific_fp,check_and_rewrite,2},
     {hipe_ppc_specific_fp,def_use,1},
     {hipe_ppc_specific_fp,defines,1},
     {hipe_ppc_specific_fp,defun_to_cfg,1},
     {hipe_ppc_specific_fp,is_fixed,1},
     {hipe_ppc_specific_fp,is_move,1},
     {hipe_ppc_specific_fp,is_precoloured,1},
     {hipe_ppc_specific_fp,labels,1},
     {hipe_ppc_specific_fp,livein,2},
     {hipe_ppc_specific_fp,liveout,2},
     {hipe_ppc_specific_fp,non_alloc,1},
     {hipe_ppc_specific_fp,number_of_temporaries,1},
     {hipe_ppc_specific_fp,physical_name,1},
     {hipe_ppc_specific_fp,reg_nr,1},
     {hipe_ppc_specific_fp,reverse_postorder,1},
     {hipe_ppc_specific_fp,uses,1},
     {hipe_ppc_specific_fp,var_range,1},

     {hipe_ppc_liveness_all,livein,2},	% liveness.inc breakage
     {hipe_ppc_liveness_all,analyze,1},	% liveness.inc breakage
     {hipe_ppc_liveness_fpr,analyze,1},	% liveness.inc breakage
     {hipe_ppc_liveness_gpr,analyze,1},	% liveness.inc breakage

     {hipe_arm_specific,all_precoloured,0},
     {hipe_arm_specific,allocatable,0},
     {hipe_arm_specific,analyze,1},
     {hipe_arm_specific,args,1},
     {hipe_arm_specific,bb,2},
     {hipe_arm_specific,breadthorder,1},
     {hipe_arm_specific,check_and_rewrite,2},
     {hipe_arm_specific,def_use,1},
     {hipe_arm_specific,defines,1},
     {hipe_arm_specific,defun_to_cfg,1},
     {hipe_arm_specific,is_arg,1},
     {hipe_arm_specific,is_fixed,1},
     {hipe_arm_specific,is_global,1},
     {hipe_arm_specific,is_move,1},
     {hipe_arm_specific,is_precoloured,1},
     {hipe_arm_specific,labels,1},
     {hipe_arm_specific,livein,2},
     {hipe_arm_specific,liveout,2},
     {hipe_arm_specific,new_spill_index,1},
     {hipe_arm_specific,non_alloc,1},
     {hipe_arm_specific,number_of_temporaries,1},
     {hipe_arm_specific,postorder,1},
     {hipe_arm_specific,physical_name,1},
     {hipe_arm_specific,reg_nr,1},
     {hipe_arm_specific,reverse_postorder,1},
     {hipe_arm_specific,uses,1},
     {hipe_arm_specific,var_range,1},

     {hipe_arm_liveness_gpr,analyze,1},	% liveness.inc breakage

     {hipe_x86_specific,analyze,1},
     {hipe_x86_specific,bb,2},
     {hipe_x86_specific,args,1},
     {hipe_x86_specific,labels,1},
     {hipe_x86_specific,livein,2},
     {hipe_x86_specific,liveout,2},
     {hipe_x86_specific,uses,1},
     {hipe_x86_specific,defines,1},
     {hipe_x86_specific,def_use,1},
     {hipe_x86_specific,is_arg,1},    %% used by hipe_ls_regalloc
     {hipe_x86_specific,is_move,1},
     {hipe_x86_specific,is_fixed,1},  %% used by hipe_graph_coloring_regalloc
     {hipe_x86_specific,is_global,1},
     {hipe_x86_specific,is_precoloured,1},
     {hipe_x86_specific,reg_nr,1},
     {hipe_x86_specific,non_alloc,1},
     {hipe_x86_specific,allocatable,0},
     {hipe_x86_specific,physical_name,1},
     {hipe_x86_specific,all_precoloured,0},
     {hipe_x86_specific,new_spill_index,1},
     {hipe_x86_specific,var_range,1},
     {hipe_x86_specific,breadthorder,1},
     {hipe_x86_specific,postorder,1},
     {hipe_x86_specific,reverse_postorder,1},
     {hipe_x86_specific,check_and_rewrite,2},
     {hipe_x86_specific,defun_to_cfg,1},

     {hipe_x86_specific_fp,analyze,1},
     {hipe_x86_specific_fp,args,1},
     {hipe_x86_specific_fp,bb,2},
     {hipe_x86_specific_fp,breadthorder,1},
     {hipe_x86_specific_fp,defines,1},
     {hipe_x86_specific_fp,is_arg,1},
     {hipe_x86_specific_fp,is_global,1},
     {hipe_x86_specific_fp,labels,1},
     {hipe_x86_specific_fp,livein,2},
     {hipe_x86_specific_fp,liveout,2},
     {hipe_x86_specific_fp,new_spill_index,1},
     {hipe_x86_specific_fp,physical_name,1},
     {hipe_x86_specific_fp,postorder,1},
     {hipe_x86_specific_fp,reg_nr,1},
     {hipe_x86_specific_fp,reverse_postorder,1},
     {hipe_x86_specific_fp,uses,1},

     {hipe_amd64_specific,analyze,1},
     {hipe_amd64_specific,bb,2},
     {hipe_amd64_specific,args,1},
     {hipe_amd64_specific,labels,1},
     {hipe_amd64_specific,livein,2},
     {hipe_amd64_specific,liveout,2},
     {hipe_amd64_specific,uses,1},
     {hipe_amd64_specific,defines,1},
     {hipe_amd64_specific,def_use,1},
     {hipe_amd64_specific,is_arg,1},    %% used by hipe_ls_regalloc
     {hipe_amd64_specific,is_move,1},
     {hipe_amd64_specific,is_fixed,1},  %% used by hipe_graph_coloring_regalloc
     {hipe_amd64_specific,is_global,1},
     {hipe_amd64_specific,is_precoloured,1},
     {hipe_amd64_specific,reg_nr,1},
     {hipe_amd64_specific,non_alloc,1},
     {hipe_amd64_specific,allocatable,0},
     {hipe_amd64_specific,physical_name,1},
     {hipe_amd64_specific,all_precoloured,0},
     {hipe_amd64_specific,new_spill_index,1},
     {hipe_amd64_specific,var_range,1},
     {hipe_amd64_specific,breadthorder,1},
     {hipe_amd64_specific,postorder,1},
     {hipe_amd64_specific,reverse_postorder,1},
     {hipe_amd64_specific,check_and_rewrite,2},
     {hipe_amd64_specific,defun_to_cfg,1},

     {hipe_amd64_specific_sse2,analyze,1},
     {hipe_amd64_specific_sse2,bb,2},
     {hipe_amd64_specific_sse2,args,1},
     {hipe_amd64_specific_sse2,labels,1},
     {hipe_amd64_specific_sse2,livein,2},
     {hipe_amd64_specific_sse2,liveout,2},
     {hipe_amd64_specific_sse2,uses,1},
     {hipe_amd64_specific_sse2,defines,1},
     {hipe_amd64_specific_sse2,def_use,1},
     {hipe_amd64_specific_sse2,is_arg,1},
     {hipe_amd64_specific_sse2,is_move,1},
     {hipe_amd64_specific_sse2,is_fixed,1},
     {hipe_amd64_specific_sse2,is_global,1},
     {hipe_amd64_specific_sse2,is_precoloured,1},
     {hipe_amd64_specific_sse2,reg_nr,1},
     {hipe_amd64_specific_sse2,non_alloc,1},
     {hipe_amd64_specific_sse2,allocatable,0},
     {hipe_amd64_specific_sse2,physical_name,1},
     {hipe_amd64_specific_sse2,all_precoloured,0},
     {hipe_amd64_specific_sse2,new_spill_index,1},
     {hipe_amd64_specific_sse2,var_range,1},
     {hipe_amd64_specific_sse2,breadthorder,1},
     {hipe_amd64_specific_sse2,postorder,1},
     {hipe_amd64_specific_sse2,reverse_postorder,1},
     {hipe_amd64_specific_sse2,number_of_temporaries,1},
     {hipe_amd64_specific_sse2,check_and_rewrite,2},
     {hipe_amd64_specific_sse2,defun_to_cfg,1},

     {hipe_amd64_registers,is_precoloured_x87,1},

     {hipe_amd64_specific_x87,analyze,1},
     {hipe_amd64_specific_x87,args,1},
     {hipe_amd64_specific_x87,bb,2},
     {hipe_amd64_specific_x87,defines,1},
     {hipe_amd64_specific_x87,is_arg,1},
     {hipe_amd64_specific_x87,labels,1},
     {hipe_amd64_specific_x87,livein,2},
     {hipe_amd64_specific_x87,liveout,2},
     {hipe_amd64_specific_x87,new_spill_index,1},
     {hipe_amd64_specific_x87,uses,1},
     % {hipe_amd64_specific_x87,def_use,1},
     % {hipe_amd64_specific_x87,is_arg,1},
     % {hipe_amd64_specific_x87,is_move,1},
     % {hipe_amd64_specific_x87,is_fixed,1},
     {hipe_amd64_specific_x87,is_global,1},
     {hipe_amd64_specific_x87,is_precoloured,1},
     {hipe_amd64_specific_x87,reg_nr,1},
     % {hipe_amd64_specific_x87,non_alloc,1},
     {hipe_amd64_specific_x87,allocatable,0},
     {hipe_amd64_specific_x87,physical_name,1},
     % {hipe_amd64_specific_x87,all_precoloured,0},
     % {hipe_amd64_specific_x87,new_spill_index,1},
     % {hipe_amd64_specific_x87,var_range,1},
     {hipe_amd64_specific_x87,breadthorder,1},
     {hipe_amd64_specific_x87,postorder,1},
     {hipe_amd64_specific_x87,reverse_postorder,1}
    ].

%%=====================================================================
%% Below appears some hard-coded information about exported functions
%% which are used either outside the Dialyzer application.
%%=====================================================================

%%
%% This is the list of all functions which are supposed to be
%% accessible by the user or by other applications.
%%
dialyzer_application_interface() ->
    [
     {dialyzer,cl,1},
     {dialyzer,plain_cl,0},
     {dialyzer_dep,test,1},
     {dialyzer,gui,1},
     {dialyzer,run,1},
     {dialyzer,cl_check_init_plt,1},
     {dialyzer_dataflow,annotate_module,1},
     {dialyzer_dataflow,doit,1},	%% debugging
     {dialyzer_dataflow,get_top_level_signatures,1}, %% typesig_tests
     {dialyzer_dataflow,pp,1},		%% debugging
     {dialyzer_typesig,doit,1},		%% debugging
     {dialyzer_typesig,pp,1},		%% debugging
     {dialyzer_typesig,get_top_level_signatures,1}   %% typesig_tests + typer
    ].

