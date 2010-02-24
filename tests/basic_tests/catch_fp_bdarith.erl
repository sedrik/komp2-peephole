%% ====================================================================
%%  Filename :  catch_fp_bdarith.erl
%%  Module   :  catch_fp_bdarith
%%  Purpose  :  To test catching of floating point bad arithmetic.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/08/16 12:59:10 $
%%              $Revision: 1.2 $
%% ====================================================================

-module(catch_fp_bdarith).
-export([test/0,compile/1]).

test() ->
   5.7 = f(2.56),
   {'EXIT',{badarith,_}} = bad_arith(9.9),
   ok.

f(F) when is_float(F) -> F + 3.14.

bad_arith(F) when is_float(F) ->
    catch F * 1.70000e+308.

compile(O) ->
  hipe:c(?MODULE,O).

