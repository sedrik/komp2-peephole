%%% File    : split.erl
%%% Author  : Per Gustafsson <pergu@dhcp-12-245.it.uu.se>
%%% Description : 
%%% Taken from Björn Gustavsson's e-mail, this module tests 
%%% Using size fields specified within the binary
%%% Created : 22 May 2003 by Per Gustafsson <pergu@dhcp-12-245.it.uu.se>

-module(bs13).

-export([test/0, compile/1]).

test() ->
    {<<45>>,<<>>} = split(<<1:16,45>>),
    {<<45>>,<<46,47>>} = split(<<1:16,45,46,47>>),
    {<<45,46>>,<<47>>} = split(<<2:16,45,46,47>>),

    {<<45,46,47>>,<<48>>} = split_2(<<16:8,3:16,45,46,47,48>>),
    
    {<<45,46>>,<<47>>} = split(2, <<2:16,45,46,47>>),
    {'EXIT',{function_clause,_}} = (catch split(42, <<2:16,45,46,47>>)),

    <<"cdef">> = skip(<<2:8,"abcdef">>),
    
    ok.

compile(O) ->
  hipe:c(?MODULE,O).

split(<<N:16,B:N/binary,T/binary>>) ->
    {B,T}.

split(N, <<N:16,B:N/binary,T/binary>>) ->
    {B,T}.

%split(<<N:16,B:N/binary,T/binary>>, N) ->
%    {B,T}.

split_2(<<N0:8,N:N0,B:N/binary,T/binary>>) ->
    {B,T}.

skip(<<N:8,_:N/binary,T/binary>>) -> T.

