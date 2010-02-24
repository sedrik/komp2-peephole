%% ====================================================================
%% Test module for the HiPE test suite.  Taken from guard_SUITE.erl
%%
%%  Filename :  exception01.erl
%%  Purpose  :  Checks correct handling of exceptions.
%%  History  :  * 2001-09-17 Kostis Sagonas (kostis@csd.uu.se): Created.
%% CVS:
%%    $Author: kostis $
%%    $Date: 2007/08/16 12:59:11 $
%%    $Revision: 1.3 $
%% ====================================================================

-module(guard01).
-export([test/0,compile/1]).

test() ->
    guard_bifs([foo]).
    
compile(Flags) ->
    hipe:c(?MODULE,Flags).

guard_bifs(doc) -> "Test all guard bifs with nasty (but legal arguments).";
guard_bifs(suite) -> [];
guard_bifs(Config) when is_list(Config) ->
    Big = -237849247829874297658726487367328971246284736473821617265433,
    Float = 387924.874,

    %% Succeding use of guard bifs.

    try_gbif('abs/1', Big, -Big),
    try_gbif('float/1', Big, float(Big)),
    try_gbif('trunc/1', Float, 387924.0),
    try_gbif('round/1', Float, 387925.0),
    try_gbif('length/1', [], 0),

    try_gbif('length/1', [a], 1),
    try_gbif('length/1', [a, b], 2),
    try_gbif('length/1', lists:seq(0, 31), 32),

    try_gbif('hd/1', [a], a),
    try_gbif('hd/1', [a, b], a),

    try_gbif('tl/1', [a], []),
    try_gbif('tl/1', [a, b], [b]),
    try_gbif('tl/1', [a, b, c], [b, c]),

    try_gbif('size/1', {}, 0),
    try_gbif('size/1', {a}, 1),
    try_gbif('size/1', {a, b}, 2),
    try_gbif('size/1', {a, b, c}, 3),
    try_gbif('size/1', list_to_binary([]), 0),
    try_gbif('size/1', list_to_binary([1]), 1),
    try_gbif('size/1', list_to_binary([1, 2]), 2),
    try_gbif('size/1', list_to_binary([1, 2, 3]), 3),

    try_gbif('element/2', {x}, {1, x}),
    try_gbif('element/2', {x, y}, {1, x}),
    try_gbif('element/2', {x, y}, {2, y}),

    try_gbif('self/0', 0, self()),
    try_gbif('node/0', 0, node()),
    try_gbif('node/1', self(), node()),

    %% Failing use of guard bifs.

    try_fail_gbif('abs/1', Big, 1),
    try_fail_gbif('abs/1', [], 1),

    try_fail_gbif('float/1', Big, 42),
    try_fail_gbif('float/1', [], 42),

    try_fail_gbif('trunc/1', Float, 0.0),
    try_fail_gbif('trunc/1', [], 0.0),

    try_fail_gbif('round/1', Float, 1.0),
    try_fail_gbif('round/1', [], a),

    try_fail_gbif('length/1', [], 1),
    try_fail_gbif('length/1', [a], 0),
    try_fail_gbif('length/1', a, 0),
    try_fail_gbif('length/1', {a}, 0),

    try_fail_gbif('hd/1', [], 0),
    try_fail_gbif('hd/1', [a], x),
    try_fail_gbif('hd/1', x, x),

    try_fail_gbif('tl/1', [], 0),
    try_fail_gbif('tl/1', [a], x),
    try_fail_gbif('tl/1', x, x),

    try_fail_gbif('size/1', {}, 1),
    try_fail_gbif('size/1', [], 0),
    try_fail_gbif('size/1', [a], 1),
    try_fail_gbif('size/1', fun() -> 1 end, 0),
    try_fail_gbif('size/1', fun() -> 1 end, 1),

    try_fail_gbif('element/2', {}, {1, x}),
    try_fail_gbif('element/2', {x}, {1, y}),
    try_fail_gbif('element/2', [], {1, z}),

    try_fail_gbif('self/0', 0, list_to_pid("<0.0.0>")),
    try_fail_gbif('node/0', 0, xxxx),
    try_fail_gbif('node/1', self(), xxx),
    try_fail_gbif('node/1', yyy, xxx),
    ok.

try_gbif(Id, X, Y) ->
    case guard_bif(Id, X, Y) of
        {Id, X, Y} ->
            %% io:format("guard_bif(~p, ~p, ~p) -- ok\n", [Id, X, Y]);
	    ok;
        Other ->
            ok = io:format("guard_bif(~p, ~p, ~p) -- bad result: ~p\n",
			   [Id, X, Y, Other]),
            exit({bad_result,try_gbif})
    end.

try_fail_gbif(Id, X, Y) ->
    case catch guard_bif(Id, X, Y) of
	%% {'EXIT', {function_clause,[{?MODULE,guard_bif,[Id,X,Y]}|_]}} ->
        {'EXIT', {function_clause,_}} ->  % in HiPE, a trace is not generated
	    %% io:format("guard_bif(~p, ~p, ~p) -- ok\n", [Id,X,Y]);
	    ok;
        Other ->
            ok = io:format("guard_bif(~p, ~p, ~p) -- bad result: ~p\n",
			   [Id, X, Y, Other]),
            exit({bad_result,try_fail_gbif})
    end.

guard_bif('abs/1', X, Y) when abs(X) == Y ->
    {'abs/1', X, Y};
guard_bif('float/1', X, Y) when float(X) == Y ->
    {'float/1', X, Y};
guard_bif('trunc/1', X, Y) when trunc(X) == Y ->
    {'trunc/1', X, Y};
guard_bif('round/1', X, Y) when round(X) == Y ->
    {'round/1', X, Y};
guard_bif('length/1', X, Y) when length(X) == Y ->
    {'length/1', X, Y};
guard_bif('hd/1', X, Y) when hd(X) == Y ->
    {'hd/1', X, Y};
guard_bif('tl/1', X, Y) when tl(X) == Y ->
    {'tl/1', X, Y};
guard_bif('size/1', X, Y) when size(X) == Y ->
    {'size/1', X, Y};
guard_bif('element/2', X, {Pos, Expected}) when element(Pos, X) == Expected ->
    {'element/2', X, {Pos, Expected}};
guard_bif('self/0', X, Y) when self() == Y ->
    {'self/0', X, Y};
guard_bif('node/0', X, Y) when node() == Y ->
    {'node/0', X, Y};
guard_bif('node/1', X, Y) when node(X) == Y ->
    {'node/1', X, Y}.
