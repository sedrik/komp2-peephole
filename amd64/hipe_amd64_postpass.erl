%%% -*- erlang-indent-level: 2 -*-
%%%
%%% %CopyrightBegin%
%%%
%%% Copyright Ericsson AB 2003-2009. All Rights Reserved.
%%%
%%% The contents of this file are subject to the Erlang Public License,
%%% Version 1.1, (the "License"); you may not use this file except in
%%% compliance with the License. You should have received a copy of the
%%% Erlang Public License along with this software. If not, it can be
%%% retrieved online at http://www.erlang.org/.
%%%
%%% Software distributed under the License is distributed on an "AS IS"
%%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%%% the License for the specific language governing rights and limitations
%%% under the License.
%%%
%%% %CopyrightEnd%
%%%
%%%----------------------------------------------------------------------
%%% File    : hipe_amd64_postpass.erl
%%% Author  : Fredrik Andersson <fran3639@student.uu.se>
%%%           Christian Axelsson <chax6693@student.uu.se>
%%% Purpose : Contain postpass optimisations for amd64-assembler code.
%%% Created : 3 Feb 2010 by Fredrik Andersson <fran3639@student.uu.se>
%%%                         Christian Axelsson <chax6693@student.uu.se>
%%%----------------------------------------------------------------------

-include("../x86/hipe_x86_postpass.erl").
