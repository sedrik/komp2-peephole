%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/08 20:19:48 happi>
%% ====================================================================
%%  Filename : 	bs.erl
%%  Module   :	bs
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-04-10 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: happi $
%%              $Date: 2001/06/14 12:08:41 $
%%              $Revision: 1.1 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs2).
-export([test/0,compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
 m(<<12>>).

%t1()->
%  match(<<12,42,17,0,0,0>>).

%match(<<12, Bin/binary>>) ->
%  Bin.
%   match(Bin);
%match(<<42, Word:4/little-signed-integer-unit:8>>) ->
%  Word.

m(<<12>>) ->
  ok.
