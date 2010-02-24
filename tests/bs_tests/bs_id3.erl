%%==========================================================================
%% From: Tomas Stejskal -- 23/02/2008
%% I've found some strange behavior regarding binary matching. The module's
%% purpose is reading an id3 version 1 or version 1.1 tag from a mp3 file.
%% When I use the function read_v1_or_v11_tag on a mp3 file containing
%% version 1 tag, it returns an error. However, when the function
%% read_only_v1_tag is applied on the same file, it reads the tag data
%% correctly. The only difference between these two functions is that the
%% former has an extra branch to read version 1.1 tag.
%% This was a BEAM compiler bug which was fixed by a patch to beam_dead.
%%==========================================================================

-module(bs_id3).
-export([test/0, compile/1]).

test() ->
  File = "bs_id3.mp3",
  R1 = read_only_v1_tag(File),
  R2 = read_v1_or_v11_tag(File),
  %% io:format("~p\n~p\n", [R1,R2]),
  R1 = R2,	% crash if not equal
  ok.

read_only_v1_tag(File) ->
  read_id3_tag(File, fun parse_only_v1_tag/1).

read_v1_or_v11_tag(File) ->
  read_id3_tag(File, fun parse_v1_or_v11_tag/1).

read_id3_tag(File, Parse) ->
  case file:open(File, [read, binary, raw]) of
    {ok, S} ->
       Size = filelib:file_size(File),
       {ok, Bin} = file:pread(S, Size - 128, 128),
       Result = Parse(Bin),
       file:close(S),
       Result;
    Error ->
       {File, Error}
  end.

parse_only_v1_tag(<<"TAG", Title:30/binary,
	            Artist:30/binary, Album:30/binary,
	            _Year:4/binary, _Comment:30/binary,
	            _Genre:8>>) ->
   {ok,
    {"ID3v1",
     [{title, trim(Title)},
      {artist, trim(Artist)},
      {album, trim(Album)}]}};
parse_only_v1_tag(_) ->
   error.

parse_v1_or_v11_tag(<<"TAG", Title:30/binary,
		      Artist:30/binary, Album:30/binary,
		      _Year:4/binary, _Comment:28/binary,
		      0:8, Track:8, _Genre:8>>) ->
   {ok,
    {"ID3v1.1",
     [{track, Track}, {title, trim(Title)},
      {artist, trim(Artist)}, {album, trim(Album)}]}};
parse_v1_or_v11_tag(<<"TAG", Title:30/binary,
	              Artist:30/binary, Album:30/binary,
	              _Year:4/binary, _Comment:30/binary,
	              _Genre:8>>) ->
   {ok,
    {"ID3v1",
     [{title, trim(Title)},
      {artist, trim(Artist)},
      {album, trim(Album)}]}};
parse_v1_or_v11_tag(_) ->
  error.

trim(Bin) ->
  list_to_binary(trim_blanks(binary_to_list(Bin))).

trim_blanks(L) ->
  lists:reverse(skip_blanks_and_zero(lists:reverse(L))).

skip_blanks_and_zero([$\s|T]) ->
  skip_blanks_and_zero(T);
skip_blanks_and_zero([0|T]) ->
  skip_blanks_and_zero(T);
skip_blanks_and_zero(L) ->
  L. 

compile(Opts) ->
  hipe:c(?MODULE, Opts).
