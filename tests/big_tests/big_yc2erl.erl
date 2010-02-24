%% An Erlang module containing support functions for Yhc Core Erlang back-end.

-module (big_yc2erl).

-export([test/0, compile/1]).
-export([hslist/1, force/1, cmp_w/2, cmp_l/2, cmp_c/2,
         quot_w/2, quot_l/2, rem_w/2, rem_l/2, div_w/2, mod_w/2, div_l/2, mod_l/2,
         shows_w/3, shows_l/3, cast_wl/1, cast_lw/1, sel_elem/3, strict_app/2,
         uni_cat/1]).

-include("big_yc2erl.hrl").

-compile(inline).

%%----------------------------------------------------------------------------------

compile(Opts) ->
  hipe:c(?MODULE, Opts).

test() ->
  ok.

%%----------------------------------------------------------------------------------

%% Force a Haskell-produced object to WHNF.

%% Some expressions are outright irreducible. These are tagged with
%% '@ird', and attention will be paid to them only when they are
%% applied to anything.

force ({'@ird', A}) -> ({'@ird', A});

%% CAFs are forced by calling them.

force ({'@fun', M, F, 0}) -> force ((M:F) ());
force ({'@prim', M, F, 0}) -> force ((M:F) ());

%% Applications are tagged with '@ap'.

%% Application of a CAF to anything causes CAF to evaluate first. This is just
%% an accelerator pattern; the default entry might handle this as well.

force ({'@ap', {'@fun', M, F, 0}, Args}) -> force ({'@ap', (M:F) (), Args});
force ({'@ap', {'@prim', M, F, 0}, Args}) -> force ({'@ap', (M:F) (), Args});

%% Application of another application to some arguments. Concatenate
%% arguments and proceed on.

force ({'@ap', {'@ap', F, Args1}, Args2}) -> force ({'@ap', F, Args1 ++ Args2});

%% Application of a data constructor is irreducible when undersaturated.
%% If the constructor is nullary, it is returned as an atom. If application
%% is saturated, it becomes a tuple with first member being constructor
%% tag, and second member is a tuple with data fields.

force ({'@tag', T, 0}) -> T;

force (X = {'@ap', {'@tag', T, A}, Args}) ->
  Nargs = length (Args),
  if
    Nargs == A -> {T, erlang:list_to_tuple (Args)};
    Nargs <  A -> {'@ird', X};
    true -> erlang:error (oversaturated, [X])
  end;

%% Application of a function/primitive to some number of arguments. It may be
%% saturated, undersaturated, or oversaturated. Undersaturated applications
%% are marked as irreducible. Oversaturated applications use some number of
%% arguments, and then result is applied to the remainder. Saturated applications
%% are called right away. 

force (X = {'@ap', {FP, M, F, A}, Args}) ->
  if 
    FP == '@fun' orelse FP == '@prim' ->
    Nargs = length (Args),
    if
      Nargs == A -> force (do_app (FP, M, F, Args));  %% do the actual application
      Nargs <  A -> {'@ird', X};                      %% mark as irreducible
      true ->                                         %% oversaturated
        {A1, A2} = lists:split (A, Args),
        force ({'@ap', do_app (FP, M, F, A1), A2})
    end;
    true -> X                                         %% not a valid application
  end;

%% Expressions marked as irreducible are given second chance.

force ({'@ap', {'@ird', X}, Args}) -> force ({'@ap', X, Args});

%% Application of anything to arguments results in forcing the "anything" first.

force ({'@ap', X, Args}) -> force ({'@ap', force (X), Args});

%% An Erlang list lazily converted to a Haskell list.

force ([H|T]) -> {'.CONS', {H, T}};

force ([]) -> '.EOL';

%% Anything else passes as is (irreducible).

force (X) -> X.

%% Do actual function application. Difference between functions and primitives:
%% primitives' arguments are forced before passing on to the primitive.
%% Function's arguments go as they are.

do_app ('@fun', M, F, Args) -> erlang:apply (M, F, Args);

do_app ('@prim', M, F, Args) -> erlang:apply (M, F, lists:map (fun force/1, Args)).

%% Convert a Haskell list (.CONS/.EOL application)
%% to Erlang-consumable form. The list must be finite otherwise the function
%% would hang. List elements will be forced to their WHNF's as well (but hslist
%% will not implicitly be applied to them).

hslist ('.EOL') -> [];

hslist ({'.CONS', {H, T}}) -> [force (H) | hslist (T)];

hslist (A = {'@ap', _Func, _Args}) -> hslist (force (A));

hslist (A = {'@fun', _M, _F, 0}) -> hslist (force (A));

hslist (X) -> throw ({"Not a Haskell list", X}).

%% Support for normal Core primitives.

divzero () -> erlang:throw ({'Prelude;ArithException', {'Prelude;DivideByZero'}}).

cmp_l (A, B) -> cmp_w (A, B).

cmp_c (A, B) -> cmp_w (A, B).

cmp_w (A, B) -> 
  if
    A > B -> '.GT';
    A < B -> '.LT';
    true  -> '.EQ'
  end.

quot_w (A, B) -> 
  if
    B == 0 -> divzero ();
    true -> A div B
  end.

quot_l (A, B) -> quot_w (A, B).

rem_w (A, B) ->
  if
    B == 0 -> divzero ();
    true -> A rem B
  end.

rem_l (A, B) -> rem_w (A, B).

%% The following code for flooring division/modulus was proposed by Igor Ribeiro Sucupira,
%% and it is also based on the Hugs implementation (in C) of the same.

div_l (A, B) -> div_w (A, B).

div_w (A, B) ->
  if
    B == 0 -> divzero ();
    true -> 
      R = A rem B,
      X = A div B,
        if 
          (B < 0 andalso R > 0) orelse (B > 0 andalso R < 0) -> X - 1;
          true -> X
        end
  end.

mod_l (A, B) -> mod_w (A, B).

mod_w (A, B) ->
  if
    B == 0 -> divzero ();
    true ->
      R = A rem B,
      if
        (R < 0 andalso B > 0) orelse (R > 0 andalso B < 0) -> R + B;
        true -> R
      end
  end.

%% Emulation of showsPrec-like functions (primShowsInt etc.). Hugs has these as primitives.
%% These functions ignore their first argument (precedence), convert their second argument
%% to string representation (that is, integer_to_list and such are used on Erlang side),
%% and the third argument is expected to be a String that will follow the result of conversion.
%% We make a shortcut here, assuming that the third argument is a finite list, forcing
%% its evaluation. If this is incorrect (time will show) then strictness of this primitive
%% on its third argument should be removed.

shows_gen (CFunc, CVal, Next) ->
  Val = CFunc (CVal),
  NList = hslist (Next),
  {Val ++ NList}.

shows_w (_, CVal, Next) -> shows_gen ({'erlang','integer_to_list'}, CVal, Next).

shows_l (_, CVal, Next) -> shows_gen ({'erlang','integer_to_list'}, CVal, Next).

%% No difference between Haskell's Int and Integer, so casts are identity functions.

cast_wl (A) -> A.

cast_lw (A) -> A.

%% Select a numbered component out of a data structure (tagged tuple).
%% We make a shortcut here: value of the tag (that is supposed to be the first
%% argument of this primitive) is ignored, so no validation is done.

sel_elem (_, {_D, Fs}, N) -> erlang:element (N, Fs).

%% Strict application. Since thunks are not updateable in this implementation,
%% just applies the function to its argument forcing the latter.

strict_app (F, A) -> {'@ap', F, [force (A)]}.

%% Binary search using a large tuple as an indexable array.
%% Based on http://ruslanspivak.com/2007/08/15/my-erlang-binary-search/
%% In the original code, lists:nth has been replaced with erlang:element.
%% Also a comparison function has been added to the function's parameters.

%% The comparison function should return negative when first arg less than second, etc.

binsearch (List, Key, Fcomp, LowerBound, UpperBound) ->
    if
        UpperBound < LowerBound -> failed;
        true ->
            Mid = (LowerBound + UpperBound) div 2,
            Item = erlang:element (Mid, List),
            C = Fcomp (Key, Item),
            if
                C < 0 ->
                    binsearch (List, Key, Fcomp, LowerBound, Mid-1);
                C > 0 ->
                    binsearch (List, Key, Fcomp, Mid+1, UpperBound);
                true ->
                    Item
            end
    end.

%% Find a character's Unicode category via binary search.

comp (Char, {Base, Length, _Props}) ->
  if
    Char <  Base -> -1;
    Char >= Base + Length -> 1;
    true -> 0
  end.

uni_cat (C) -> binsearch (char_block(), C, fun comp/2, 1, ?NUM_BLOCKS).


