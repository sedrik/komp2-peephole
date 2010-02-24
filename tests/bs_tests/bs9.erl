%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/13 17:20:30 happi>
%% ====================================================================
%%  Filename : 	bs.erl
%%  Module   :	bs
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-04-10 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2002/05/08 07:33:41 $
%%              $Revision: 1.2 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs9).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
 {m1(<<12,42,17,0,0,0>>, 1),
  m2(<<12,42,17,0,0,0>>, 1,4)}.

m1(B,S) ->  %% 4 is hard-coded
<<12, Bin:S/binary, Bin2:4/binary>> = B,
  {Bin, Bin2}.

m2(B,S,S2) ->
<<12, Bin:S/binary, Bin2:S2/binary>> = B,
  {Bin, Bin2}.
