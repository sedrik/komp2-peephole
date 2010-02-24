%% ====================================================================
%% Test module for the HiPE test suite.
%%
%%  Filename :  const_size_test.erl
%%  Purpose  :  Tests loading of constants into the runtime system and
%%		its interaction with constant propagation. The test is
%%		written so that it returns 42; a better explanation of
%%		the magic number that is printed appears below.
%%  History  :  * 2003-10-31 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: richardc $
%%    $Date: 2004/11/03 20:05:53 $
%%    $Revision: 1.8 $
%% ====================================================================

-module(const_size_test).
-export([test/0,compile/1,return_const_tuple/0]).

%% This is supposed to count the constants which are added in the
%% constant pool when compiling and loading native code.
%% These are:
%%
%%	Constant					Size (words)
%% --------------------------------------------------------------------
%% 1. {[501,502,503,504,505,506,507,508,509,510],
%%     {[501,502,503,504,505,506,507,508,509,510],
%%      {[501,502,503,504,505,506,507,508,509,510],
%%       3.14000,
%%       [501,502,503,504,505,506,507,508,509,510]},
%%      [501,502,503,504,505,506,507,508,509,510]},
%%     [501,502,503,504,505,506,507,508,509,510]}	 138 (137 on 64-bit)
%% 2. [o2]						   5 (2 + 3)
%% --------------------------------------------------------------------
%%                                                       143
%% Explanation
%% 1. size = 9 is 4 for the tuple, 2 for the list, and
%%		  3 header words (for the constant entry).
%% 2. size = 138 is 120 for the lists (6*20), 3 for the float,
%%		    12 (3*4) for the tuples, and 3 header words.
%%		    On a 64-bit machine the flonum is 2 words.

test() ->
  compile([o2]),
  hipe_bifs:constants_size() bor 1.

compile(Opts) ->
  hipe:c(?MODULE, Opts).

return_const_tuple() ->
  Const = [501,502,503,504,505,506,507,508,509,510], %% size = 20
  {Const,{Const,{Const,3.14,Const},Const},Const}.
