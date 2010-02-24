%% ====================================================================
%%  Filename : ctest.erl
%%  Module   : ctest
%%  Purpose  : To run a HiPE test module and write the result to a file
%% CVS:
%%    $Author: kostis $
%%    $Date: 2003/03/05 16:45:50 $
%%    $Revision: 1.2 $
%% ====================================================================
%% Exported functions (short description):
%%
%% start(Module,CompilerOptions,File) 
%% 
%%  Executes a test module in htis way:
%%   1. Compiles the module Module.erl to Module.beam. 
%%   2. Then the function test/0 in Module is called.
%%   3. Then Module is compiled to native code with the flags CompilerOptions
%%   4. Then the function test/0 in Module is called.
%%   5. Finally the a tuple with the results from both Module:test() executions
%%      are written to the file File.
%%
%% start(Module,File) 
%%
%%  Does the same as start/3 but with default compiler options.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(ctest).
-export([start/3,start/2]).

start(Module,File) ->
    start(Module,[o2],File).

%% CompilerOptions are ignored
start(Module,_CompilerOptions,File) ->
    C = (catch compile:file(Module)),
    Res = (catch Module:test()),
    Result = {{result,Res},C},
    write(File,Result).

write(File,Result) ->
    case file:open(File,write) of
	{ok,Dev} ->
	    io:format(Dev,"~p~n",[Result]),
	    file:close(Dev);
	_ ->
	    true
    end.
