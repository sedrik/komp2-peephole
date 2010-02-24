%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/13 11:13:11 happi>
%% ====================================================================
%%  Filename : 	bs1.erl
%%  Module   :	bs1
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-04-10 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/04/13 14:58:58 $
%%              $Revision: 1.3 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs1).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test()->
 m(<<12>>).

m(<<X>>) ->
  X;
m({Y, Z}) ->
  Y + Z.
