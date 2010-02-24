%%-------------------------------------------------------------------
%% File    : inf_loop2.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : File that sends the inference of refined success
%%               typings into an infinite loop when constraining the
%%               first argument of do_flatten/2 to be a string()
%%               instead of just a list().
%%		 See the last function/lines of this file.
%%
%% Note    : It is adapted from lib/stdlib/src/filename.erl
%%
%% Created : 9 September 2006 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(inf_loop2).

-export([find_src/1, find_src/2, rootname/2]).

-include_lib("kernel/include/file.hrl").

%%-------------------------------------------------------------------

skip_prefix1([L, DrvSep|Name], DrvSep) when is_integer(L) ->
    Name;
skip_prefix1([L], _) when is_integer(L) ->
    [L];
skip_prefix1(Name, _) ->
    Name.

%% Returns the last component of the filename, with the given
%% extension stripped.

basename(Name0, Ext0) ->
    Name = flatten(Name0),
    Ext = flatten(Ext0),
    {DirSep2,DrvSep} = separators(),
    NoPrefix = skip_prefix1(Name, DrvSep),
    basename(NoPrefix, Ext, [], DirSep2).

basename(Ext, Ext, Tail, _DrvSep2) ->
    lists:reverse(Tail);
basename([$/|[]], Ext, Tail, DrvSep2) ->
    basename([], Ext, Tail, DrvSep2);
basename([$/|Rest], Ext, _Tail, DrvSep2) ->
    basename(Rest, Ext, [], DrvSep2);
basename([$\\|Rest], Ext, Tail, DirSep2) when is_integer(DirSep2) ->
    basename([$/|Rest], Ext, Tail, DirSep2);
basename([Char|Rest], Ext, Tail, DrvSep2) when is_integer(Char) ->
    basename(Rest, Ext, [Char|Tail], DrvSep2);
basename([], _Ext, Tail, _DrvSep2) ->
    lists:reverse(Tail).

%% Returns the directory part of a pathname.

dirname(Name0) ->
    Name = flatten(Name0),
    dirname(Name, [], [], separators()).

dirname([[_|_]=List|Rest], Dir, File, Seps) ->
    dirname(List++Rest, Dir, File, Seps);
dirname([$/|Rest], Dir, File, Seps) ->
    dirname(Rest, File++Dir, [$/], Seps);
dirname([DirSep|Rest], Dir, File, {DirSep,_}=Seps) when is_integer(DirSep) ->
    dirname(Rest, File++Dir, [$/], Seps);
dirname([Dl,DrvSep|Rest], [], [], {_,DrvSep}=Seps)
  when is_integer(DrvSep), ((($a =< Dl) and (Dl =< $z)) or
			    (($A =< Dl) and (Dl =< $Z))) ->
    dirname(Rest, [DrvSep,Dl], [], Seps);
dirname([Char|Rest], Dir, File, Seps) when is_integer(Char) ->
    dirname(Rest, Dir, [Char|File], Seps);
dirname([], [], File, _Seps) ->
    case lists:reverse(File) of
	[$/|_] -> [$/];
	_ -> "."
    end;
dirname([], [$/|Rest], File, Seps) ->
    dirname([], Rest, File, Seps);
dirname([], [DrvSep,Dl], File, {_,DrvSep}) ->
    case lists:reverse(File) of
	[$/|_] -> [Dl,DrvSep,$/];
	_ -> [Dl,DrvSep]
    end;
dirname([], Dir, _, _) ->
    lists:reverse(Dir).

%% Joins two filenames with directory separators.

join(Name1, Name2) when is_list(Name1), is_list(Name2) ->
    OsType = major_os_type(),
    case pathtype(Name2) of
	relative -> join1(Name1, Name2, [], OsType);
	_Other -> join1(Name2, [], [], OsType)
    end;
join(Name1, Name2) when is_atom(Name1) ->
    join(atom_to_list(Name1), Name2);
join(Name1, Name2) when is_atom(Name2) ->
    join(Name1, atom_to_list(Name2)).

%% Internal function to join an absolute name and a relative name.
%% It is the responsibility of the caller to ensure that RelativeName
%% is relative.

join1([UcLetter, $:|Rest], RelativeName, [], win32)
  when is_integer(UcLetter), UcLetter >= $A, UcLetter =< $Z ->
    join1(Rest, RelativeName, [$:, UcLetter+$a-$A], win32);
join1([$\\|Rest], RelativeName, Result, win32) ->
    join1([$/|Rest], RelativeName, Result, win32);
join1([$\\|Rest], RelativeName, Result, vxworks) ->
    join1([$/|Rest], RelativeName, Result, vxworks);
join1([$/|Rest], RelativeName, [$., $/|Result], OsType) ->
    join1(Rest, RelativeName, [$/|Result], OsType);
join1([$/|Rest], RelativeName, [$/|Result], OsType) ->
    join1(Rest, RelativeName, [$/|Result], OsType);
join1([], [], Result, OsType) ->
    maybe_remove_dirsep(Result, OsType);
join1([], RelativeName, [$:|Rest], win32) ->
    join1(RelativeName, [], [$:|Rest], win32);
join1([], RelativeName, [$/|Result], OsType) ->
    join1(RelativeName, [], [$/|Result], OsType);
join1([], RelativeName, Result, OsType) ->
    join1(RelativeName, [], [$/|Result], OsType);
join1([[_|_]=List|Rest], RelativeName, Result, OsType) ->
    join1(List++Rest, RelativeName, Result, OsType);
join1([[]|Rest], RelativeName, Result, OsType) ->
    join1(Rest, RelativeName, Result, OsType);
join1([Char|Rest], RelativeName, Result, OsType) when is_integer(Char) ->
    join1(Rest, RelativeName, [Char|Result], OsType);
join1([Atom|Rest], RelativeName, Result, OsType) when is_atom(Atom) ->
    join1(atom_to_list(Atom)++Rest, RelativeName, Result, OsType).

maybe_remove_dirsep([$/, $:, Letter], win32) ->
    [Letter, $:, $/];
maybe_remove_dirsep([$/], _) ->
    [$/];
maybe_remove_dirsep([$/|Name], _) ->
    lists:reverse(Name);
maybe_remove_dirsep(Name, _) ->
    lists:reverse(Name).

%% Returns one of 'absolute' or 'relative'.

pathtype(Atom) when is_atom(Atom) ->
    pathtype(atom_to_list(Atom));
pathtype(Name) when is_list(Name) ->
    unix_pathtype(Name).

unix_pathtype([$/|_]) ->
    absolute;
unix_pathtype([List|Rest]) when is_list(List) ->
    unix_pathtype(List++Rest);
unix_pathtype([Atom|Rest]) when is_atom(Atom) ->
    unix_pathtype(atom_to_list(Atom)++Rest);
unix_pathtype(_) ->
    relative.

%% Returns all characters in the filename, except the given extension.
%% If the filename has another extension, the complete filename is
%% returned.

rootname(Name0, Ext0) ->
    Name = flatten(Name0),
    Ext = flatten(Ext0),
    rootname2(Name, Ext, []).

rootname2(Ext, Ext, Result) ->
    lists:reverse(Result);
rootname2([], _Ext, Result) ->
    lists:reverse(Result);
rootname2([[_|_]=List|Rest], Ext, Result) ->
    rootname2(List++Rest, Ext, Result);
rootname2([Char|Rest], Ext, Result) when is_integer(Char) ->
    rootname2(Rest, Ext, [Char|Result]).

separators() ->
    case os:type() of
	{unix, _}  -> {false, false};
	{win32, _} -> {$\\, $:};
	vxworks -> {$\\, false};
	{ose,_} -> {false, false}
    end.

%% Finds the source file name and compilation options for a compiled
%% module. Returns: {SourceFile, Options}

find_src(Mod) ->
    Default = [{"", ""}, {"ebin", "src"}, {"ebin", "esrc"}],
    Rules = 
	case application:get_env(kernel, source_search_rules) of
	    undefined -> Default;
	    {ok, []} -> Default;
	    {ok, R} when is_list(R) -> R
	end,
    find_src(Mod, Rules).

find_src(Mod, Rules) when is_atom(Mod) ->
    find_src(atom_to_list(Mod), Rules);
find_src(File0, Rules) when is_list(File0) ->
    Mod = list_to_atom(basename(File0, ".erl")),
    File = rootname(File0, ".erl"),
    case readable_file(File++".erl") of
	true  ->
	    try_file(File, Mod, Rules);
	false ->
	    try_file(undefined, Mod, Rules)
    end.

try_file(File, Mod, Rules) ->
    case code:which(Mod) of
	Possibly_Rel_Path when is_list(Possibly_Rel_Path) ->
	    {ok, Cwd} = file:get_cwd(),
	    Path = join(Cwd, Possibly_Rel_Path),
	    try_file(File, Path, Mod, Rules);
	Ecode when is_atom(Ecode) -> % Ecode = non_existing | preloaded | interpreted
	    {error, {Ecode, Mod}}
    end.

%% At this point, the Mod is known to be valid.
%% If the source name is not known, find it.
%% Then get the compilation options.
%% Returns: {SrcFile, Options}

try_file(undefined, ObjFilename, Mod, Rules) ->
    case get_source_file(ObjFilename, Mod, Rules) of
	{ok, File} -> try_file(File, ObjFilename, Mod, Rules);
	Error -> Error
    end;
try_file(Src, _ObjFilename, Mod, _Rules) ->
    List = apply(Mod, module_info, [compile]),
    {value, {options, Options}} = lists:keysearch(options, 1, List),
    {ok, Cwd} = file:get_cwd(),
    AbsPath = make_abs_path(Cwd, Src),
    {AbsPath, filter_options(dirname(AbsPath), Options, [])}.

%% Filters the options.

filter_options(Base, [{outdir, Path}|Rest], Result) ->
    filter_options(Base, Rest, [{outdir, make_abs_path(Base, Path)}|Result]);
filter_options(Base, [{i, Path}|Rest], Result) ->
    filter_options(Base, Rest, [{i, make_abs_path(Base, Path)}|Result]);
filter_options(Base, [Option|Rest], Result) when Option == trace ->
    filter_options(Base, Rest, [Option|Result]);
filter_options(Base, [Option|Rest], Result) when Option == export_all ->
    filter_options(Base, Rest, [Option|Result]);
filter_options(Base, [Option|Rest], Result) when Option == binary ->
    filter_options(Base, Rest, [Option|Result]);
filter_options(Base, [Option|Rest], Result) when Option == fast ->
    filter_options(Base, Rest, [Option|Result]);
filter_options(Base, [Tuple|Rest], Result) when element(1, Tuple) == d ->
    filter_options(Base, Rest, [Tuple|Result]);
filter_options(Base, [Tuple|Rest], Result)
when element(1, Tuple) == parse_transform ->
    filter_options(Base, Rest, [Tuple|Result]);
filter_options(Base, [_|Rest], Result) ->
    filter_options(Base, Rest, Result);
filter_options(_Base, [], Result) ->
    Result.

%% Gets the source file given path of object code and module name.

get_source_file(Obj, Mod, Rules) ->
    case catch(apply(Mod, module_info, [source_file])) of
	{'EXIT', _Reason} ->
	    source_by_rules(dirname(Obj), packages:last(Mod), Rules);
	File ->
	    {ok, File}
    end.

source_by_rules(Dir, Base, [{From, To}|Rest]) ->
    case try_rule(Dir, Base, From, To) of
	{ok, File} -> {ok, File};
	error      -> source_by_rules(Dir, Base, Rest)
    end;
source_by_rules(_Dir, _Base, []) ->
    {error, source_file_not_found}.

try_rule(Dir, Base, From, To) ->
    case lists:suffix(From, Dir) of
	true -> 
	    NewDir = lists:sublist(Dir, 1, length(Dir)-length(From))++To,
	    Src = join(NewDir, Base),
	    case readable_file(Src++".erl") of
		true -> {ok, Src};
		false -> error
	    end;
	false ->
	    error
    end.

readable_file(File) ->
    case file:read_file_info(File) of
	{ok, #file_info{type=regular, access=read}} ->
	    true;
	{ok, #file_info{type=regular, access=read_write}} ->
	    true;
	_Other ->
	    false
    end.

make_abs_path(BasePath, Path) ->
    join(BasePath, Path).

major_os_type() ->
    case os:type() of
	{OsT, _} -> OsT;
	OsT -> OsT
    end.
   
%% Flatten a list, also accepting atoms.

flatten(List) ->
    do_flatten(List, []).

%%---------------------------------------------------------------------
%% This is the culprit: depending on which body of the last clause is
%% uncommented, inferrence terminates or goes into an infinite loop.
%%---------------------------------------------------------------------

do_flatten([H|T], Tail) when is_list(H) ->
    do_flatten(H, do_flatten(T, Tail));
do_flatten([H|T], Tail) when is_atom(H) ->
    atom_to_list(H) ++ do_flatten(T, Tail);
do_flatten([], Tail) ->
    Tail;
do_flatten(Atom, Tail) when is_atom(Atom) ->
    atom_to_list(Atom) ++ flatten(Tail);
do_flatten(String, Tail) ->
    atom_to_list(list_to_atom(String)) ++ flatten(Tail).	% inf loop
    % String ++ flatten(Tail).  % No infinite loop.
