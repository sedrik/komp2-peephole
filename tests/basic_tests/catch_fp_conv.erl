%% ====================================================================
%%  Filename :  catch_fp_conv.erl
%%  Module   :  catch_fp_conv
%%  Purpose  :  To test catching of illegal convertion of bignums
%%		to floating point numbers.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/08/16 12:59:10 $
%%              $Revision: 1.4 $
%% ====================================================================

-module(catch_fp_conv).
-export([test/0,compile/1]).

test() ->
    F = 1.7e308, %% F is a number very close to a maximum float.
    big_arith(F),
    big_const_float(F),
    ok.

big_arith(F) ->
    I = trunc(F),
    {'EXIT',{badarith,_}} = i_big_arith(I).

i_big_arith(I) when is_integer(I) ->
    catch(3.0 + 2*I).

big_const_float(F) ->
    I = trunc(F),
    {'EXIT', _} = (catch 1/(2*I)),
    _Ignore = 2/I,
    {'EXIT', _} = (catch 4/(2*I)),
    ok.

compile(O) ->
  hipe:c(?MODULE,O).
