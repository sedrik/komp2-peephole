%%-------------------------------------------------------------------
%% File    : inf_loop1.erl
%% Author  : Kostis Sagonas <kostis@it.uu.se>
%% Description : File that seems to be sending the new type inference
%%               into an infinite loop because the analusis takes way
%%               too long.
%%
%% Created : 10 Feb 2005 by Kostis Sagonas <kostis@it.uu.se>
%%-------------------------------------------------------------------

-module(inf_loop1).

-export([adapt/3]).
-export([get_all_similar_match/2]).

-record(match, {val, tag}).
-record(match_group, {tag, vals}).
-record(b_clause, {segments, matches=[], guard, body, next_clause}).
-record(clause_tree, {instr, success=[], fail=[]}).
-record(label, {name}).
-record(goto, {label}).
-record(hash_cons, {tree=gb_trees:empty(), number=0}).

b_clause_segments(#b_clause{segments=X}) -> X.
match_tag(#match{tag=X}) -> X.
match_val(#match{val=X}) -> X.

%%-------------------------------------------------------------------
%% The culprit are these two mutually recursive functions: For
%% example, comment these two out (there is an appropriate export
%% directive that needs commenting too) and you will see that some
%% types are inferred for the remaining functions.
%%-------------------------------------------------------------------

adapt([], Hash, _ITree) ->
  {[], Hash};
adapt(BClause, Hash=#hash_cons{tree=Tree, number=Number}, ITree) ->
  NewLabelName = cerl:c_int(Number),
  Hash1 = Hash#hash_cons{tree=gb_trees:insert(BClause, NewLabelName, Tree),
			 number=Number+1},
  Lbl = #label{name=NewLabelName},
  {Succ, Hash2} = adapt0(BClause, Hash1, ITree),
  {#clause_tree{instr=Lbl, success=Succ}, Hash2}.
      
adapt0(BClause, Hash, ITree) ->
  BinSeg = choose_binseg(BClause),
  case BinSeg of
    #match{} ->
      MatchSet = get_all_similar_match(BinSeg,BClause),
      case gb_sets:size(MatchSet) of
	1 ->
	  NewSuccClause = remove_succ_match(BinSeg, BClause, ITree),
	  {Succ, Hash1} = adapt(NewSuccClause, Hash, ITree),
	  NewFailClause = remove_fail_match(BinSeg, BClause, ITree),
	  {Fail, Hash2} = adapt(NewFailClause, Hash1, ITree),
	  {#clause_tree{instr=BinSeg, success=Succ, fail=Fail}, Hash2}
      end
  end.

%%-------------------------------------------------------------------

get_all_similar_match(Match, BClause) ->
  List = get_all_similar_match(Match, BClause, []),
  gb_sets:from_list(List).

get_all_similar_match(Match, #b_clause{segments=BinSegs, next_clause=Next}, Acc) ->
  NewAcc = get_match(Match, BinSegs, Acc),
  get_all_similar_match(Match, Next, NewAcc);
get_all_similar_match(_Match, [], Acc) ->
  Acc.

get_match(Match1=#match{tag=Tag}, [Match2=#match{tag=Tag}|Rest], Acc) ->
  case have_same_match(Match2, Acc) of
    true ->
      get_match(Match1, Rest, Acc);
    false ->
      get_match(Match1, Rest, [Match2|Acc])
  end;
get_match(Match, [_|Rest], Acc) ->
  get_match(Match, Rest, Acc);
get_match(_Match, [], Acc) ->
  Acc.

have_same_match(Match1, [Match2|Rest]) ->
  Val1 = cerl:concrete(match_val(Match1)),
  Val2 = cerl:concrete(match_val(Match2)),
  case Val1 == Val2 of
    true ->
      true;
    false ->
      have_same_match(Match1, Rest)
  end;
have_same_match(_Match1, []) ->  
  false.
    
remove_succ_match(Match, BClause=#b_clause{segments=BinSegs, next_clause=Next}, ITree) -> 
  case mismatch(Match, BinSegs, ITree) of
    true ->
      remove_succ_match(Match, Next, ITree);
    NewBinSegs ->
      BClause#b_clause{segments=NewBinSegs, next_clause=remove_succ_match(Match, Next, ITree)} 
  end;
remove_succ_match(_Match, [], _ITree) ->
  [].

mismatch(Match, BinSegs, ITree) ->
  mismatch(Match,BinSegs, [], ITree).

mismatch(Match=#match{tag=Tag, val=Val1}, [#match{tag=Tag, val=Val2}|Rest], Acc, ITree) ->
  case cerl:concrete(Val1) == cerl:concrete(Val2) of
    true -> mismatch(Match, Rest, Acc, ITree);
    false -> true
  end;
mismatch(Match=#match{tag=Tag1, val=Val1}, [#match{tag=Tag2, val=Val2}=First|Rest], Acc, ITree) ->
  V1 = cerl:concrete(Val1),
  V2 = cerl:concrete(Val2),
  SearchKey = make_search_key(Tag1, Tag2),
  case gb_trees:lookup(SearchKey, ITree) of
    {value, Inter} ->
      case interference_conclusion_pos(Inter, Tag1, Tag2, V1, V2) of
	fails ->
	  true;
	succeeds ->
	  mismatch(Match, Rest, Acc, ITree);
	no_info -> 
	  mismatch(Match, Rest, [First|Acc], ITree)
      end;
    none ->
      mismatch(Match, Rest, [First|Acc], ITree)
  end;	   
mismatch(Match, [First|Rest], Acc, ITree) ->
  mismatch(Match, Rest, [First|Acc], ITree);
mismatch(_Match, [], Acc, _ITree) ->
  lists:reverse(Acc).

interference_conclusion_pos({encapsulated, Tag1, Diff, Size},
  			    Tag1, _Tag2, V1, V2) ->
    C2 = (V2 bsr Diff) band ((1 bsl Size) - 1), 
    C1 = V1,
    case C1 == C2 of
      true ->
        no_info;
      false ->
        fails
    end;
interference_conclusion_pos({encapsulated, Tag2, Diff, Size},
 			    _Tag1, Tag2, V1, V2) ->
   C2 = V2,
   C1 = (V1 bsr Diff) band ((1 bsl Size) - 1),
   case C1 == C2 of
     true ->
       succeeds;
     false ->
       fails
   end;
interference_conclusion_pos({overlapping, Tag1, Diff, Size},
 			    Tag1, _Tag2, V1, V2) ->
   C1 = (V1 bsr Diff) band ((1 bsl Size) - 1),
   C2 = V2 band ((1 bsl Size) - 1),
   case C1 == C2 of
     true ->
       no_info;
     false ->
       fails
   end;
interference_conclusion_pos({overlapping, Tag2, Diff, Size},
 			    _Tag1, Tag2, V1, V2) ->
   C2 = (V2 bsr Diff) band ((1 bsl Size) - 1),
   C1 = V1 band ((1 bsl Size) - 1),
   case C1 == C2 of
     true ->
       no_info;
     false ->
       fails
   end;
interference_conclusion_pos(_,_,_,_,_) ->
  no_info.

make_search_key(Tag1, Tag2) ->
  if Tag1 > Tag2 ->
      {Tag2, Tag1};
     true ->
      {Tag1, Tag2}
  end.

remove_fail_match(Match, BClause=#b_clause{segments=BinSegs, next_clause=Next}, ITree) -> 
  case match(Match, BinSegs, ITree) of
    true ->
      remove_fail_match(Match, Next, ITree);
    false ->
      BClause#b_clause{next_clause=remove_fail_match(Match, Next, ITree)} 
  end;
remove_fail_match(_Match, [], _ITree) ->
  [].

match(Match=#match{tag=Tag, val=Val1}, [#match{tag=Tag, val=Val2}|Rest], ITree) ->
  case cerl:concrete(Val1) == cerl:concrete(Val2) of
    true -> true;
    false -> match(Match, Rest, ITree)
  end;
match(Match=#match{tag=Tag1, val=Val1}, [#match{tag=Tag2, val=Val2}|Rest], ITree) ->
  V1 = cerl:concrete(Val1),
  V2 = cerl:concrete(Val2),
  SearchKey = make_search_key(Tag1, Tag2),
  case gb_trees:lookup(SearchKey, ITree) of
    {value, Inter} ->
      case interference_conclusion_neg(Inter, Tag1, Tag2, V1, V2) of
	fails ->
	  true;
	no_info -> 
	  match(Match, Rest, ITree)
      end;
    none ->
      match(Match, Rest, ITree)
  end;	   
match(Match, [_|Rest], ITree) ->
  match(Match, Rest, ITree);
match(_Match, [], _ITree) ->
  false.

interference_conclusion_neg({encapsulated, Tag1, Diff, Size},
			    Tag1, _Tag2, V1, V2) ->
  C1 = V1, 
  C2 = (V2 bsr Diff) band ((1 bsl Size) - 1),
  case C1 == C2 of
    true ->
      fails;
    false ->
      no_info
  end;
interference_conclusion_neg(_Inter, _Tag1, _Tag2, _V1, _V2) ->
  no_info.

choose_binseg(BClause) ->
  CountTree = simpl_count(BClause),
  BinSegs = b_clause_segments(BClause),
  get_largest_count(BinSegs, CountTree, {none, 0}).

get_largest_count([BinSeg|Rest], CountTree, Top={_,Count}) -> 
  NewTop =
    case BinSeg of
      #match{} ->
	Tag = match_tag(BinSeg),
	{value, {_, MC, _, _}} = gb_trees:lookup(Tag, CountTree),
	case MC >= Count of
	  true -> {BinSeg, MC};
	  false -> Top
	end
    end,
  get_largest_count(Rest, CountTree, NewTop);
get_largest_count([], _CountTree, {BinSeg, _Count}) ->
  BinSeg.

simpl_count(BinClauses) ->
  simpl_count(BinClauses, gb_trees:empty()).

simpl_count(#b_clause{segments=BinSegs, next_clause=Next}, Tree) ->
  NewTree = simpl_count_segs(BinSegs, Tree),
  simpl_count(Next, NewTree);
simpl_count([], Tree) ->
  Tree.

simpl_count_segs([Seg=#match{}|Rest], Tree) ->
  Tag = match_tag(Seg),
  Val = match_val(Seg),
  case gb_trees:lookup(Tag, Tree) of
    {value, {SC, MC, IC, Set}} ->
      case gb_sets:is_member(Val, Set) of
	false ->
	  simpl_count_segs(Rest, gb_trees:update(Tag, {SC, MC+1, IC+1, gb_sets:add(Val, Set)}, Tree));
	true ->
	  simpl_count_segs(Rest, gb_trees:update(Tag, {SC, MC+1, IC, Set}, Tree))
      end;
    none ->
      simpl_count_segs(Rest, gb_trees:insert(match_tag(Seg), {0,1,1,gb_sets:singleton(Val)}, Tree))
  end;
simpl_count_segs([], Tree) ->
  Tree.
