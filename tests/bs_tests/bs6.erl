%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Filename : 	bs6.erl
%%  Purpose  :  Tests construction of "bad" binaries
%%  Notes    : 
%%  History  :	* 2001-04-10 Erik Johansson (happi@csd.uu.se): Created.
%%  CVS      :
%%              $Author: kostis $
%%              $Date: 2007/05/30 12:47:35 $
%%              $Revision: 1.5 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-module(bs6).
-export([test/0,compile/1]).

-define(FAIL(Expr), {'EXIT',{badarg,_}} = (catch Expr)).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  PI = math:pi(),
  ?FAIL(<<PI>>),
  Bin12 = <<1,2>>,
  ?FAIL(<<Bin12>>),

  E = 2.71,
  ?FAIL(<<E/binary>>),
  Int = 24334,
  BigInt = 24334344294788947129487129487219847,
  ?FAIL(<<Int/binary>>),
  ?FAIL(<<BigInt/binary>>),

  Bin123 = <<1,2,3>>,
  ?FAIL(<<Bin123/float>>),

  ok.

