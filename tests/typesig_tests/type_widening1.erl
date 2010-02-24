%% This used to be an infinite loop due to that ordering mattered when
%% building large tuple sets.

-module(type_widening1).
-export([from_records/1]).

-record(c_binary, {anno=[], segments}).
-record(c_bitstr, {anno=[],val, size, unit, type, flags}).
-record(c_cons, {anno=[], hd, tl}).
-record(c_tuple, {anno=[], es}).
-record(c_var, {anno=[], name}).
-record(c_clause, {anno=[], pats, guard, body}).
-record(c_receive, {anno=[], clauses, timeout, action}).
-record(c_apply, {anno=[], op, args}).
-record(c_module, {anno=[], name, exports, attrs, defs}).
-record(literal, {ann = [], val}).
-record(c_primop, {anno=[], name, args}).
-record(c_try, {anno=[], arg, vars, body, evars, handler}).

from_records(#c_binary{}) ->
  #c_binary{};
from_records(#c_bitstr{}) ->
  #c_bitstr{};
from_records(#c_cons{hd=H}) ->  
  case foo:bar(from_records(H)) of
    true ->
      #c_cons{};
    false ->
      #literal{}
  end;
from_records(#c_tuple{}) ->
  #c_tuple{};
from_records(#c_var{}) ->
  #c_var{};
from_records(#c_clause{}) ->
  #c_clause{};
from_records(#c_receive{}) ->
  #c_receive{};
from_records(#c_apply{}) ->
  #c_apply{};
from_records(#c_primop{}) ->
  #c_primop{};
from_records(#c_try{}) ->
  #c_try{};
from_records(#c_module{}) ->
  #c_module{}.
