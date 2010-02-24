-module(babis2).
-export([parse/1, parse_and_scan/1, format_error/1]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The parser generator will insert appropriate declarations before this line.%

parse(Tokens) ->
    case catch yeccpars1(Tokens, false, 0, [], []) of
	error ->
	    Errorline =
		if Tokens == [] -> 0; true -> element(2, hd(Tokens)) end,
	    {error,
	     {Errorline, "syntax error at or after this line."}};
	Other ->
	    Other
    end.

parse_and_scan({Mod, Fun, Args}) ->
    case apply(Mod, Fun, Args) of
	{eof, _} ->
	    {ok, eof};
	{error, Descriptor, _} ->
	    {error, Descriptor};
	{ok, Tokens, _} ->
	    yeccpars1(Tokens, {Mod, Fun, Args}, 0, [], [])
    end.

format_error(Message) ->
    case io_lib:deep_char_list(Message) of
	true ->
	    Message;
	_ ->
	    io_lib:write(Message)
    end.

% Don't change yeccpars1/6 too much, it is called recursively by yeccpars2/8!
yeccpars1([Token | Tokens], Tokenizer, State, States, Vstack) ->
    yeccpars2(State, element(1, Token), States, Vstack, Token, Tokens,
	      Tokenizer);
yeccpars1([], {M, F, A}, State, States, Vstack) ->
    case catch apply(M, F, A) of
        {eof, Endline} ->
            {error, {Endline, "end_of_file"}};
        {error, Descriptor, Endline} ->
            {error, Descriptor};
        {'EXIT', Reason} ->
            {error, {0, Reason}};
        {ok, Tokens, Endline} ->
	    case catch yeccpars1(Tokens, {M, F, A}, State, States, Vstack) of
		error ->
		    Errorline = element(2, hd(Tokens)),
		    {error, {Errorline, "syntax error at or after this line"}};
		Other ->
		    Other
	    end
    end;
yeccpars1([], false, State, States, Vstack) ->
    yeccpars2(State, '$end', States, Vstack, {'$end', 999999}, [], false).

% For internal use only.
yeccerror(Token) ->
    {error, ["syntax error before: ", yecctoken2string(Token)]}.

yecctoken2string({atom, _, A}) -> io_lib:write(A);
yecctoken2string({integer,_,N}) -> io_lib:write(N);
yecctoken2string({float,_,F}) -> io_lib:write(F);
yecctoken2string({char,_,C}) -> io_lib:write_char(C);
yecctoken2string({var,_,V}) -> io_lib:format('~s', [V]);
yecctoken2string({string,_,S}) -> io_lib:write_string(S);
yecctoken2string({reserved_symbol, _, A}) -> io_lib:format('~w', [A]);
yecctoken2string({Cat, _, Val}) -> io_lib:format('~w', [Val]);

yecctoken2string({'dot', _}) -> io_lib:format('~w', ['.']);
yecctoken2string({'$end', _}) ->
    [];
yecctoken2string({Other, _}) when is_atom(Other) ->
    io_lib:format('~w', [Other]);
yecctoken2string(Other) ->
    io_lib:write(Other).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


yeccpars2(0, 'PR_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 4, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'PR_NOT_SUPPORTED', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 5, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'HTTP_RESPONCE_HEADER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 3, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'HTTP_POST_HEADER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 2, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'HEADER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 1, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(1, 'VERSION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 156, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(2, 'HEADER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 1, [2 | __Ss], [__T | __Stack]);
yeccpars2(2, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(3, 'RET_DATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 141, [3 | __Ss], [__T | __Stack]);
yeccpars2(3, 'PING_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 140, [3 | __Ss], [__T | __Stack]);
yeccpars2(3, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(4, 'RET_DATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 141, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, 'PING_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 140, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(5, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(in, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(6, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(out, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(7, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(in, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(8, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(stream, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(9, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(stream, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(10, 'DGC_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, 'PING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, 'CALL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(11, '$end', _, __Stack, _, _, _) ->
 {ok, hd(__Stack)};
yeccpars2(11, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(12, 'OBJ_NUMBER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 22, [12 | __Ss], [__T | __Stack]);
yeccpars2(12, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(13, 'UID_NUMBER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [13 | __Ss], [__T | __Stack]);
yeccpars2(13, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(14, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(message, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(15, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(messages, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(16, 'DGC_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, 'PING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, 'CALL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __2,
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(out, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(17, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(messages, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(18, 'UID_TIME', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 20, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(19, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(message, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(20, 'UID_COUNT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 21, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(21, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(uniqueIdentifier, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(22, 'UID_NUMBER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [22 | __Ss], [__T | __Stack]);
yeccpars2(22, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(23, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(message, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(24, 'OPERATION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 25, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(25, 'HASH', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [25 | __Ss], [__T | __Stack]);
yeccpars2(25, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(26, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 30, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [26 | __Ss], [__T | __Stack]);
yeccpars2(26, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(callData, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(27, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(28, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(29, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(30, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(31, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(32, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(33, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(34, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(primitive, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(35, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(magic, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(36, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(37, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [37 | __Ss], [__T | __Stack]);
yeccpars2(37, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [37 | __Ss], [__T | __Stack]);
yeccpars2(37, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [37 | __Ss], [__T | __Stack]);
yeccpars2(37, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(38, 'CLASS_NAME', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 94, [38 | __Ss], [__T | __Stack]);
yeccpars2(38, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(39, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(40, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(nullReference, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(41, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(42, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 68, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(43, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 66, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(44, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 30, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [44 | __Ss], [__T | __Stack]);
%yeccpars2(44, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 32, [44 | __Ss], [__T | __Stack]);
%yeccpars2(44, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 34, [44 | __Ss], [__T | __Stack]);
%yeccpars2(44, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 28, [44 | __Ss], [__T | __Stack]);
%yeccpars2(44, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 27, [44 | __Ss], [__T | __Stack]);
%yeccpars2(44, __Cat, __Ss,  [__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2,__3,__4},
% __Nss = lists:nthtail(3, __Ss),
% yeccpars2(yeccgoto(callData, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(45, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(46, 'STREAM_VERSION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 57, [46 | __Ss], [__T | __Stack]);
%yeccpars2(46, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(47, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(48, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(49, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(50, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(51, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(52, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(53, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(value, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(54, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(object, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(55, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(value, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(56, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(arguments, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(57, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(version, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(58, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [58 | __Ss], [__T | __Stack]);
%yeccpars2(58, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(59, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(blockData, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(60, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(content, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(61, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  [__1],
% yeccpars2(yeccgoto(contents, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(62, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [62 | __Ss], [__T | __Stack]);
%yeccpars2(62, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __3,
% __Nss = lists:nthtail(2, __Ss),
% yeccpars2(yeccgoto(object, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(63, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(content, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(64, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  lists:append(__1,[__2]),
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(contents, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(65, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2},
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(arguments, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(66, 'UTF', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 67, [66 | __Ss], [__T | __Stack]);
%yeccpars2(66, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(67, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2,__3},
% __Nss = lists:nthtail(2, __Ss),
% yeccpars2(yeccgoto(newString, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(68, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2},
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(prevObject, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(69, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 73, [69 | __Ss], [__T | __Stack]);
%yeccpars2(69, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(70, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(71, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(72, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(73, 'CLASSDATAAREA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 74, [73 | __Ss], [__T | __Stack]);
%yeccpars2(73, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(74, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 29, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 30, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 31, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 33, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 32, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 34, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 28, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 27, [74 | __Ss], [__T | __Stack]);
%yeccpars2(74, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(75, 'TC_ENDBLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 82, [75 | __Ss], [__T | __Stack]);
%yeccpars2(75, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(76, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 29, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 30, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 31, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 33, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 32, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 34, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 28, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 27, [76 | __Ss], [__T | __Stack]);
%yeccpars2(76, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDataArray, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(77, 'ENDOFDATAAREA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 88, [77 | __Ss], [__T | __Stack]);
%yeccpars2(77, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(78, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(values, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(79, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(values, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(80, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 29, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 30, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 31, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 33, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 32, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 34, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 28, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 27, [80 | __Ss], [__T | __Stack]);
%yeccpars2(80, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  [__1],
% yeccpars2(yeccgoto(valuesArray, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(81, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_ENDBLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 82, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [81 | __Ss], [__T | __Stack]);
%yeccpars2(81, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classData, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(82, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(endBlockData, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(83, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_ENDBLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 82, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 59, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [83 | __Ss], [__T | __Stack]);
%yeccpars2(83, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(84, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(objectAnnotation, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(85, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  lists:append(__1,__2),
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(classData, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(86, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2},
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(objectAnnotation, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(87, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  lists:append([__1],__2),
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(valuesArray, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(88, __Cat, __Ss,  [__6,__5,__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2,__3,__5},
% __Nss = lists:nthtail(5, __Ss),
% yeccpars2(yeccgoto(newObject, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(89, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  lists:append(__1,__2),
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(classDataArray, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(90, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% __Nss = lists:nthtail(1, __Ss),
% yeccpars2(yeccgoto(values, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(91, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 35, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 39, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 40, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 42, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 43, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 41, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 36, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 38, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 37, [91 | __Ss], [__T | __Stack]);
%yeccpars2(91, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(92, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(93, __Cat, __Ss,  [__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  {__1,__2,__3,__4},
% __Nss = lists:nthtail(3, __Ss),
% yeccpars2(yeccgoto(exception, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(94, 'SERIAL_VERSION_UID', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 95, [94 | __Ss], [__T | __Stack]);
%yeccpars2(94, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(95, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 96, [95 | __Ss], [__T | __Stack]);
%yeccpars2(95, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(96, 'SC_EXTERNALIZABLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 97, [96 | __Ss], [__T | __Stack]);
%yeccpars2(96, 'SC_SERIALIZABLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 98, [96 | __Ss], [__T | __Stack]);
%yeccpars2(96, 'SC_WRRD_METHODS', __Ss, __Stack, __T, __Ts, __Tzr) ->
% yeccpars1(__Ts, __Tzr, 99, [96 | __Ss], [__T | __Stack]);
%yeccpars2(96, _, _, _, __T, _, _) ->
% yeccerror(__T);
%yeccpars2(97, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDescFlags, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
%yeccpars2(98, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
% __Val =  __1,
% yeccpars2(yeccgoto(classDescFlags, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(99, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(classDescFlags, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(100, 'FIELDS_SIZE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 102, [100 | __Ss], [__T | __Stack]);
yeccpars2(100, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(101, __Cat, __Ss,  [__5,__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3,__4,__5},
 __Nss = lists:nthtail(4, __Ss),
 yeccpars2(yeccgoto(newClassDesc, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(102, 'L', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 116, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, '[', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 119, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'Z', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 118, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'S', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 117, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'J', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 115, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'I', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 114, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'F', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 113, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'D', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 112, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'C', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 111, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, 'B', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 110, [102 | __Ss], [__T | __Stack]);
yeccpars2(102, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,[]},
 yeccpars2(yeccgoto(fields, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(103, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_ENDBLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 82, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 59, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [103 | __Ss], [__T | __Stack]);
yeccpars2(103, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(104, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [104 | __Ss], [__T | __Stack]);
yeccpars2(104, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [104 | __Ss], [__T | __Stack]);
yeccpars2(104, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [104 | __Ss], [__T | __Stack]);
yeccpars2(104, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(105, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_ENDBLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 82, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 59, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [105 | __Ss], [__T | __Stack]);
yeccpars2(105, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(106, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(classAnnotation, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(107, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(classAnnotation, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(108, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(superClassDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(109, __Cat, __Ss,  [__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3,__4},
 __Nss = lists:nthtail(3, __Ss),
 yeccpars2(yeccgoto(classDescInfo, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(110, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(111, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(112, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(113, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(114, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(115, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(116, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(obj_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(117, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(118, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(prim_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(119, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(obj_typecode, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(120, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  [__1],
 yeccpars2(yeccgoto(fieldDescArray, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(121, 'L', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 116, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, '[', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 119, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'Z', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 118, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'S', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 117, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'J', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 115, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'I', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 114, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'F', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 113, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'D', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 112, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'C', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 111, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, 'B', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 110, [121 | __Ss], [__T | __Stack]);
yeccpars2(121, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(fields, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(122, 'UTF', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 126, [122 | __Ss], [__T | __Stack]);
yeccpars2(122, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(123, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(fieldDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(124, 'UTF', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 126, [124 | __Ss], [__T | __Stack]);
yeccpars2(124, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(125, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(fieldDesc, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(126, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(fieldName, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(127, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(primitiveDesc, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(128, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 129, [128 | __Ss], [__T | __Stack]);
yeccpars2(128, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(129, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 130, [129 | __Ss], [__T | __Stack]);
yeccpars2(129, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(130, 'CLASS_NAME', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 131, [130 | __Ss], [__T | __Stack]);
yeccpars2(130, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(131, __Cat, __Ss,  [__5,__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(4, __Ss),
 yeccpars2(yeccgoto(objectDesc, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(132, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  lists:append(__1,[__2]),
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(fieldDescArray, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(133, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 134, [133 | __Ss], [__T | __Stack]);
yeccpars2(133, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(134, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(newClass, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(135, 'NEWHANDLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 136, [135 | __Ss], [__T | __Stack]);
yeccpars2(135, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(136, 'ARRAY_SIZE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 137, [136 | __Ss], [__T | __Stack]);
yeccpars2(136, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(137, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_BLOCKDATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 59, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 30, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [137 | __Ss], [__T | __Stack]);
yeccpars2(137, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(138, __Cat, __Ss,  [__5,__4,__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3,__4,__5},
 __Nss = lists:nthtail(4, __Ss),
 yeccpars2(yeccgoto(newArray, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(139, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(objIdentifier, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(140, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(return, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(141, 'EXC_HEAD', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 146, [141 | __Ss], [__T | __Stack]);
yeccpars2(141, 'VAL_HEAD', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 147, [141 | __Ss], [__T | __Stack]);
yeccpars2(141, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(142, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(returns, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(143, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(return, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(144, 'RET_DATA', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 141, [144 | __Ss], [__T | __Stack]);
yeccpars2(144, 'PING_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 140, [144 | __Ss], [__T | __Stack]);
yeccpars2(144, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(in, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(145, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(returns, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(146, 'UID_NUMBER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [146 | __Ss], [__T | __Stack]);
yeccpars2(146, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(147, 'UID_NUMBER', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [147 | __Ss], [__T | __Stack]);
yeccpars2(147, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(148, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(returnData, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(149, 'STREAM_MAGIC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 39, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_NULL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 40, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_REFERENCE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 42, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_STRING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 43, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_OBJECT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 41, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_ARRAY', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_CLASSDESC', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 38, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'TC_CLASS', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 37, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'CHAR', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'DOUBLE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 30, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'FLOAT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'LONG', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'INT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'SHORT', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'BYTE', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, 'BOOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [149 | __Ss], [__T | __Stack]);
yeccpars2(149, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(150, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(returnValue, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(151, 'EXCEPTION', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 152, [151 | __Ss], [__T | __Stack]);
yeccpars2(151, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(152, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(returnValue, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(153, __Cat, __Ss,  [__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2},
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto(httpReturn, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(154, 'DGC_ACK', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [154 | __Ss], [__T | __Stack]);
yeccpars2(154, 'PING', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [154 | __Ss], [__T | __Stack]);
yeccpars2(154, 'CALL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [154 | __Ss], [__T | __Stack]);
yeccpars2(154, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(155, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(httpMessage, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(156, 'MULTIPLEX_PROTOCOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 157, [156 | __Ss], [__T | __Stack]);
yeccpars2(156, 'SINGLE_OP_PROTOCOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 158, [156 | __Ss], [__T | __Stack]);
yeccpars2(156, 'STREAM_PROTOCOL', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 159, [156 | __Ss], [__T | __Stack]);
yeccpars2(156, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(157, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(protocol, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(158, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(protocol, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(159, __Cat, __Ss,  [__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  __1,
 yeccpars2(yeccgoto(protocol, hd(__Ss)), __Cat, __Ss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(160, __Cat, __Ss,  [__3,__2,__1|__Stack], __T, __Ts, __Tzr) ->
 __Val =  {__1,__2,__3},
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto(outHeader, hd(__Nss)), __Cat, __Nss, [__Val | __Stack], __T, __Ts, __Tzr);
yeccpars2(__Other, _, _, _, _, _, _) ->
 exit({parser, __Other, missing_state_in_action_table}).

yeccgoto(stream, 0) ->
 11;
yeccgoto(out, 0) ->
 9;
yeccgoto(in, 0) ->
 8;
yeccgoto(outHeader, 0) ->
 10;
yeccgoto(outHeader, 2) ->
 154;
yeccgoto(messages, 10) ->
 16;
yeccgoto(httpMessage, 0) ->
 6;
yeccgoto(protocol, 156) ->
 160;
yeccgoto(message, 10) ->
 15;
yeccgoto(message, 16) ->
 17;
yeccgoto(message, 154) ->
 155;
yeccgoto(callData, 12) ->
 23;
yeccgoto(uniqueIdentifier, 13) ->
 19;
yeccgoto(uniqueIdentifier, 22) ->
 139;
yeccgoto(uniqueIdentifier, 147) ->
 149;
yeccgoto(uniqueIdentifier, 146) ->
 151;
yeccgoto(arguments, 26) ->
 44;
yeccgoto(value, 26) ->
 56;
yeccgoto(value, 44) ->
 65;
yeccgoto(value, 149) ->
 150;
yeccgoto(return, 4) ->
 142;
yeccgoto(return, 144) ->
 145;
yeccgoto(return, 3) ->
 153;
yeccgoto(returns, 4) ->
 144;
yeccgoto(httpReturn, 0) ->
 7;
yeccgoto(returnData, 4) ->
 143;
yeccgoto(returnData, 144) ->
 143;
yeccgoto(returnData, 3) ->
 143;
yeccgoto(returnValue, 141) ->
 148;
yeccgoto(objIdentifier, 12) ->
 24;
yeccgoto(object, 26) ->
 53;
yeccgoto(object, 58) ->
 63;
yeccgoto(object, 62) ->
 63;
yeccgoto(object, 44) ->
 53;
yeccgoto(object, 74) ->
 78;
yeccgoto(object, 81) ->
 63;
yeccgoto(object, 83) ->
 63;
yeccgoto(object, 80) ->
 78;
yeccgoto(object, 76) ->
 78;
yeccgoto(object, 91) ->
 92;
yeccgoto(object, 103) ->
 63;
yeccgoto(object, 105) ->
 63;
yeccgoto(object, 137) ->
 78;
yeccgoto(object, 149) ->
 53;
yeccgoto(primitive, 26) ->
 55;
yeccgoto(primitive, 44) ->
 55;
yeccgoto(primitive, 74) ->
 79;
yeccgoto(primitive, 80) ->
 79;
yeccgoto(primitive, 76) ->
 79;
yeccgoto(primitive, 137) ->
 79;
yeccgoto(primitive, 149) ->
 55;
yeccgoto(magic, 26) ->
 46;
yeccgoto(magic, 58) ->
 46;
yeccgoto(magic, 62) ->
 46;
yeccgoto(magic, 44) ->
 46;
yeccgoto(magic, 74) ->
 46;
yeccgoto(magic, 81) ->
 46;
yeccgoto(magic, 83) ->
 46;
yeccgoto(magic, 80) ->
 46;
yeccgoto(magic, 76) ->
 46;
yeccgoto(magic, 91) ->
 46;
yeccgoto(magic, 103) ->
 46;
yeccgoto(magic, 105) ->
 46;
yeccgoto(magic, 137) ->
 46;
yeccgoto(magic, 149) ->
 46;
yeccgoto(version, 46) ->
 58;
yeccgoto(contents, 58) ->
 62;
yeccgoto(contents, 81) ->
 83;
yeccgoto(contents, 103) ->
 105;
yeccgoto(content, 58) ->
 61;
yeccgoto(content, 62) ->
 64;
yeccgoto(content, 81) ->
 61;
yeccgoto(content, 83) ->
 64;
yeccgoto(content, 103) ->
 61;
yeccgoto(content, 105) ->
 64;
yeccgoto(blockData, 58) ->
 60;
yeccgoto(blockData, 62) ->
 60;
yeccgoto(blockData, 74) ->
 75;
yeccgoto(blockData, 81) ->
 60;
yeccgoto(blockData, 83) ->
 60;
yeccgoto(blockData, 80) ->
 75;
yeccgoto(blockData, 76) ->
 75;
yeccgoto(blockData, 103) ->
 60;
yeccgoto(blockData, 105) ->
 60;
yeccgoto(blockData, 137) ->
 75;
yeccgoto(newObject, 26) ->
 50;
yeccgoto(newObject, 58) ->
 50;
yeccgoto(newObject, 62) ->
 50;
yeccgoto(newObject, 44) ->
 50;
yeccgoto(newObject, 74) ->
 50;
yeccgoto(newObject, 81) ->
 50;
yeccgoto(newObject, 83) ->
 50;
yeccgoto(newObject, 80) ->
 50;
yeccgoto(newObject, 76) ->
 50;
yeccgoto(newObject, 91) ->
 50;
yeccgoto(newObject, 103) ->
 50;
yeccgoto(newObject, 105) ->
 50;
yeccgoto(newObject, 137) ->
 50;
yeccgoto(newObject, 149) ->
 50;
yeccgoto(newClass, 26) ->
 48;
yeccgoto(newClass, 58) ->
 48;
yeccgoto(newClass, 62) ->
 48;
yeccgoto(newClass, 44) ->
 48;
yeccgoto(newClass, 74) ->
 48;
yeccgoto(newClass, 81) ->
 48;
yeccgoto(newClass, 83) ->
 48;
yeccgoto(newClass, 80) ->
 48;
yeccgoto(newClass, 76) ->
 48;
yeccgoto(newClass, 91) ->
 48;
yeccgoto(newClass, 103) ->
 48;
yeccgoto(newClass, 105) ->
 48;
yeccgoto(newClass, 137) ->
 48;
yeccgoto(newClass, 149) ->
 48;
yeccgoto(newArray, 26) ->
 47;
yeccgoto(newArray, 58) ->
 47;
yeccgoto(newArray, 62) ->
 47;
yeccgoto(newArray, 44) ->
 47;
yeccgoto(newArray, 74) ->
 47;
yeccgoto(newArray, 81) ->
 47;
yeccgoto(newArray, 83) ->
 47;
yeccgoto(newArray, 80) ->
 47;
yeccgoto(newArray, 76) ->
 47;
yeccgoto(newArray, 91) ->
 47;
yeccgoto(newArray, 103) ->
 47;
yeccgoto(newArray, 105) ->
 47;
yeccgoto(newArray, 137) ->
 47;
yeccgoto(newArray, 149) ->
 47;
yeccgoto(newString, 26) ->
 51;
yeccgoto(newString, 58) ->
 51;
yeccgoto(newString, 62) ->
 51;
yeccgoto(newString, 44) ->
 51;
yeccgoto(newString, 74) ->
 51;
yeccgoto(newString, 81) ->
 51;
yeccgoto(newString, 83) ->
 51;
yeccgoto(newString, 80) ->
 51;
yeccgoto(newString, 76) ->
 51;
yeccgoto(newString, 91) ->
 51;
yeccgoto(newString, 103) ->
 51;
yeccgoto(newString, 105) ->
 51;
yeccgoto(newString, 137) ->
 51;
yeccgoto(newString, 149) ->
 51;
yeccgoto(newClassDesc, 26) ->
 49;
yeccgoto(newClassDesc, 58) ->
 49;
yeccgoto(newClassDesc, 62) ->
 49;
yeccgoto(newClassDesc, 44) ->
 49;
yeccgoto(newClassDesc, 41) ->
 70;
yeccgoto(newClassDesc, 74) ->
 49;
yeccgoto(newClassDesc, 81) ->
 49;
yeccgoto(newClassDesc, 83) ->
 49;
yeccgoto(newClassDesc, 80) ->
 49;
yeccgoto(newClassDesc, 76) ->
 49;
yeccgoto(newClassDesc, 91) ->
 49;
yeccgoto(newClassDesc, 103) ->
 49;
yeccgoto(newClassDesc, 105) ->
 49;
yeccgoto(newClassDesc, 104) ->
 70;
yeccgoto(newClassDesc, 37) ->
 70;
yeccgoto(newClassDesc, 36) ->
 70;
yeccgoto(newClassDesc, 137) ->
 49;
yeccgoto(newClassDesc, 149) ->
 49;
yeccgoto(prevObject, 26) ->
 54;
yeccgoto(prevObject, 58) ->
 54;
yeccgoto(prevObject, 62) ->
 54;
yeccgoto(prevObject, 44) ->
 54;
yeccgoto(prevObject, 41) ->
 72;
yeccgoto(prevObject, 74) ->
 54;
yeccgoto(prevObject, 81) ->
 54;
yeccgoto(prevObject, 83) ->
 54;
yeccgoto(prevObject, 80) ->
 54;
yeccgoto(prevObject, 76) ->
 54;
yeccgoto(prevObject, 91) ->
 54;
yeccgoto(prevObject, 103) ->
 54;
yeccgoto(prevObject, 105) ->
 54;
yeccgoto(prevObject, 104) ->
 72;
yeccgoto(prevObject, 37) ->
 72;
yeccgoto(prevObject, 36) ->
 72;
yeccgoto(prevObject, 137) ->
 54;
yeccgoto(prevObject, 149) ->
 54;
yeccgoto(nullReference, 26) ->
 52;
yeccgoto(nullReference, 58) ->
 52;
yeccgoto(nullReference, 62) ->
 52;
yeccgoto(nullReference, 44) ->
 52;
yeccgoto(nullReference, 41) ->
 71;
yeccgoto(nullReference, 74) ->
 52;
yeccgoto(nullReference, 81) ->
 52;
yeccgoto(nullReference, 83) ->
 52;
yeccgoto(nullReference, 80) ->
 52;
yeccgoto(nullReference, 76) ->
 52;
yeccgoto(nullReference, 91) ->
 52;
yeccgoto(nullReference, 103) ->
 52;
yeccgoto(nullReference, 105) ->
 52;
yeccgoto(nullReference, 104) ->
 71;
yeccgoto(nullReference, 37) ->
 71;
yeccgoto(nullReference, 36) ->
 71;
yeccgoto(nullReference, 137) ->
 52;
yeccgoto(nullReference, 149) ->
 52;
yeccgoto(exception, 26) ->
 45;
yeccgoto(exception, 58) ->
 45;
yeccgoto(exception, 62) ->
 45;
yeccgoto(exception, 44) ->
 45;
yeccgoto(exception, 74) ->
 45;
yeccgoto(exception, 81) ->
 45;
yeccgoto(exception, 83) ->
 45;
yeccgoto(exception, 80) ->
 45;
yeccgoto(exception, 76) ->
 45;
yeccgoto(exception, 91) ->
 45;
yeccgoto(exception, 103) ->
 45;
yeccgoto(exception, 105) ->
 45;
yeccgoto(exception, 137) ->
 45;
yeccgoto(exception, 149) ->
 45;
yeccgoto(classDesc, 41) ->
 69;
yeccgoto(classDesc, 104) ->
 108;
yeccgoto(classDesc, 37) ->
 133;
yeccgoto(classDesc, 36) ->
 135;
yeccgoto(classDescInfo, 96) ->
 101;
yeccgoto(classDescFlags, 96) ->
 100;
yeccgoto(fields, 100) ->
 103;
yeccgoto(fieldDesc, 102) ->
 120;
yeccgoto(fieldDesc, 121) ->
 132;
yeccgoto(primitiveDesc, 102) ->
 125;
yeccgoto(primitiveDesc, 121) ->
 125;
yeccgoto(objectDesc, 102) ->
 123;
yeccgoto(objectDesc, 121) ->
 123;
yeccgoto(fieldName, 124) ->
 127;
yeccgoto(fieldName, 122) ->
 128;
yeccgoto(classAnnotation, 103) ->
 104;
yeccgoto(prim_typecode, 102) ->
 124;
yeccgoto(prim_typecode, 121) ->
 124;
yeccgoto(obj_typecode, 102) ->
 122;
yeccgoto(obj_typecode, 121) ->
 122;
yeccgoto(superClassDesc, 104) ->
 109;
yeccgoto(endBlockData, 81) ->
 84;
yeccgoto(endBlockData, 83) ->
 86;
yeccgoto(endBlockData, 75) ->
 90;
yeccgoto(endBlockData, 103) ->
 106;
yeccgoto(endBlockData, 105) ->
 107;
yeccgoto(classData, 74) ->
 76;
yeccgoto(classData, 76) ->
 76;
yeccgoto(objectAnnotation, 81) ->
 85;
yeccgoto(values, 74) ->
 80;
yeccgoto(values, 80) ->
 80;
yeccgoto(values, 76) ->
 80;
yeccgoto(values, 137) ->
 80;
yeccgoto(reset, 39) ->
 91;
yeccgoto(reset, 92) ->
 93;
yeccgoto(fieldDescArray, 102) ->
 121;
yeccgoto(valuesArray, 74) ->
 81;
yeccgoto(valuesArray, 80) ->
 87;
yeccgoto(valuesArray, 76) ->
 81;
yeccgoto(valuesArray, 137) ->
 138;
yeccgoto(classDataArray, 74) ->
 77;
yeccgoto(classDataArray, 76) ->
 89;
yeccgoto(__Symbol, __State) ->
 exit({__Symbol, __State, missing_in_goto_table}).


