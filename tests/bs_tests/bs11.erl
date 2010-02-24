%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright (c) 2001 by Erik Johansson.  All Rights Reserved 
%% Time-stamp: <01/06/13 23:51:42 happi>
%% ====================================================================
%%  Filename : 	bs11.erl
%%  Module   :	bs11
%%  Purpose  :  
%%  Notes    : 
%%  History  :	* 2001-06-13 Erik Johansson (happi@csd.uu.se): 
%%               Created.
%%  CVS      :
%%              $Author: pergu $
%%              $Date: 2004/02/26 10:27:50 $
%%              $Revision: 1.3 $
%% ====================================================================
%%  Exports  :
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs11).
-export([test/0,compile/1]).


compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  bound_var().
% %   bound_tail(),
% %   t_float(),
  % little_float().
%  sean().

 bound_var() ->
   ok = bound_var(42, 13, <<42,13>>),
   nope = bound_var(42, 13, <<42,255>>),
   nope = bound_var(42, 13, <<154,255>>),
   ok.

 bound_var(A, B, <<A:8,B:8>>) -> ok;
 bound_var(_, _, _) -> nope.


% bound_tail()->
%   ok = bound_tail(<<>>, <<13,14>>),
%   ok = bound_tail(<<2,3>>, <<1,1,2,3>>),
%   nope = bound_tail(<<2,3>>, <<1,1,2,7>>),
%   nope = bound_tail(<<2,3>>, <<1,1,2,3,4>>),
%   nope = bound_tail(<<2,3>>, <<>>),
%   ok.

% bound_tail(T, <<_:16,T/binary>>) -> ok;
% bound_tail(_, _) -> nope.

% t_float()->
%   F = f1(),
%   G = f_one(),

%   G = match_float(<<63,128,0,0>>, 32, 0),
%   G = match_float(<<63,240,0,0,0,0,0,0>>, 64, 0),

  %  fcmp(F, match_float(<<F:32/float>>, 32, 0)),
%    fcmp(F, match_float(<<F:64/float>>, 64, 0)),
%    fcmp(F, match_float(<<1:1,F:32/float,127:7>>, 32, 1)),
%    fcmp(F, match_float(<<1:1,F:64/float,127:7>>, 64, 1)),
%    fcmp(F, match_float(<<1:13,F:32/float,127:3>>, 32, 13)),
%    fcmp(F, match_float(<<1:13,F:64/float,127:3>>, 64, 13)),
%    ok.

%  fcmp(F1, F2) when (F1 - F2) / F2 < 0.0000001 -> ok.
    
% match_float(Bin0, Fsz, I) ->
%     Bin = make_sub_bin(Bin0),
%     Bsz = size(Bin) * 8,
%     Tsz = Bsz - Fsz - I,
%     <<_:I,F:Fsz/float,_:Tsz>> = Bin,
%     F.


% little_float()->
%   F = f2(),
%   G = f_one(),

%   G = match_float_little(<<0,0,0,0,0,0,240,63>>, 64, 0),
%   G = match_float_little(<<0,0,128,63>>, 32, 0),

%   fcmp(F, match_float_little(<<F:32/float-little>>, 32, 0)),
%   fcmp(F, match_float_little(<<F:64/float-little>>, 64, 0)),
%   fcmp(F, match_float_little(<<1:1,F:32/float-little,127:7>>, 32, 1)),
%   fcmp(F, match_float_little(<<1:1,F:64/float-little,127:7>>, 64, 1)),
%   fcmp(F, match_float_little(<<1:13,F:32/float-little,127:3>>, 32, 13)),
%   fcmp(F, match_float_little(<<1:13,F:64/float-little,127:3>>, 64, 13)),

%   ok.

% match_float_little(Bin0, Fsz, I) ->
%   Bin = make_sub_bin(Bin0),
%   Bsz = size(Bin) * 8,
%   Tsz = Bsz - Fsz - I,
%   <<_:I,F:Fsz/float-little,_:Tsz>> = Bin,
%   F.


% make_sub_bin(Bin0) ->
%   Sz = size(Bin0),
%   Bin1 = <<37,Bin0/binary,38,39>>,
%     <<_:8,Bin:Sz/binary,_:8,_:8>> = Bin1,
%   Bin.

% f1() ->
%   3.1415.

% f2() ->
%   2.7133.

% f_one() ->
%   1.0.

% sean()->
%   small = sean1(<<>>),
%   small = sean1(<<1>>),
%   small = sean1(<<1,2>>),
%   small = sean1(<<1,2,3>>),
%   large = sean1(<<1,2,3,4>>),

%   small = sean1(<<4>>),
%   small = sean1(<<4,5>>),
%   small = sean1(<<4,5,6>>),
%   {'EXIT',{function_clause,_}} = (catch sean1(<<4,5,6,7>>)),
%   ok.

% sean1(<<B/binary>>) when size(B) < 4 ->	small;
% sean1(<<1, _/binary>>) -> large.

