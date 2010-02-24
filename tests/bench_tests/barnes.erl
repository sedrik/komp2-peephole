%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program     : Barnes-Hut algorithm Erlang version       		      %
% File        : barnes.erl                                                    %
% Author      : Alexander Jean-Claude Bottema (alexb@csd.uu.se)               %
% Datum       : Mar 14 1996                                                   %
% Revidated   : Mar 14 1996                                                   %
% --------------------------------------------------------------------------- %
% Changes:                                                                    %
% --------------------------------------------------------------------------- %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% Data representation:
%%%
%%% The QUAD-tree is represented as follows:
%%%
%%%   - A node in the tree is either a QUAD-tree, a body element or
%%%     the empty tree.
%%%   - Body elements (like empty trees) are the "leaves," since they
%%%     do not contain QUAD-trees
%%%
%%% A body element is represented as a vector of 3 components; its mass and
%%% its relative (x,y)-position w.r.t. the region defined by its parent.
%%%
%%% A body's velocity and other characteristics is stored elsewhere.
%%%
%%% A star is represented as a vector of 5 components:
%%%   {Mass,X,Y,DX,DY}
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Constants
%%%

-module(barnes).
-export([test/0,compile/1]).
%% The following triggers a native code compilation error
-compile({inline,[{quadrant_to_dx,2},{quadrant_to_dy,2}]}).

-define(THETA, 0.3).
-define(EPSILON, 0.000001).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Derived constants
%%%

-define(THETA2, ?THETA*?THETA).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create scenario
%%%

create_scenario(N, M) ->
    create_scenario0(0, 0, trunc(math:sqrt(N)), M).

create_scenario0(_X, SN, SN, _M) -> 
    [];

create_scenario0(SN, Y, SN, M) -> 
    create_scenario0(0, Y+1, SN, M);
create_scenario0(X, Y, SN, M) ->
    XPos0 = (((20000.0 * 2) / SN) * X) - 20000.0,
    YPos0 = (((20000.0 * 2) / SN) * Y) - 20000.0,
    Calibrate = ((20000.0 * 2) / SN) / 2,
    XPos = XPos0 + Calibrate,
    YPos = YPos0 + Calibrate,
    [{M, XPos, YPos, 0.0, 0.0} | create_scenario0(X+1, Y, SN, M)].


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% relpos_to_quadrant(DX,DY)
%%%

relpos_to_quadrant(DX, DY) when DX >= 0 ->
  if
    DY >= 0 -> 0;
    true -> 3
  end;
relpos_to_quadrant(_, DY) -> 
  if
    DY >= 0 -> 1; 
    true -> 2 
  end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% quadrant_to_dx(Q,D), quadrant_to_dy(Q,D)
%%%

quadrant_to_dx(0, D) -> 
    D;
quadrant_to_dx(1, D) -> 
    -D;
quadrant_to_dx(2, D) -> 
    -D ;
quadrant_to_dx(3, D) -> 
    D.

quadrant_to_dy(Q,D) ->
    if
      Q < 2 -> D;
      true -> -D 
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% create_tree(Stars)
%%%

create_tree(Stars) ->
   create_tree0(Stars, empty).

create_tree0([],Tree) ->
   Tree;
create_tree0([{M,X,Y,_,_} | Stars], Tree) ->
   create_tree0(Stars, insert_tree_element(Tree, M, X, Y, 0.0, 0.0, 20000.0)).

% Big Boys

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% insert_tree_element(Tree,M,X,Y,OX,OY,D)
%%%

insert_tree_element(empty, M, X, Y, _OX, _OY, _D) ->
    {body,M,X,Y};
insert_tree_element({branch,M0,SubTree}, M, X, Y, OX, OY, D) ->
    Q = relpos_to_quadrant(X-OX,Y-OY),
    D2 = D / 2,
    DX = quadrant_to_dx(Q,D2),
    DY = quadrant_to_dy(Q,D2),
    {branch,M0+M,setelement(Q+1,SubTree,
			    insert_tree_element(element(Q+1,SubTree),
						M, X, Y, OX+DX, OY+DY,D2))};
insert_tree_element({body,M0,X0,Y0},M,X,Y,OX,OY,D) ->
    resolve_body_conflict(M,X,Y,M0,X0,Y0,OX,OY,D).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% resolve_body_conflict(M0,X0,Y0,M1,X1,Y1,OX,OY,D)
%%%

resolve_body_conflict(_, _, _, _, _, _, _, _, D) when D < ?EPSILON ->
   empty;
resolve_body_conflict(M0, X0, Y0, M1, X1, Y1, OX, OY, D) ->
   T = {empty,empty,empty,empty},
   Q0 = relpos_to_quadrant(X0-OX,Y0-OY),
   Q1 = relpos_to_quadrant(X1-OX,Y1-OY),
   D2 = D / 2,
   if Q0 == Q1 ->
	 DX = quadrant_to_dx(Q0,D2),
	 DY = quadrant_to_dy(Q1,D2),
	 {branch,M0+M1,setelement(Q0+1,T,
				  resolve_body_conflict(M0,X0,Y0,
							M1,X1,Y1,
							OX+DX,OY+DY,
							D2))};
      true ->
	 {branch,M0+M1, setelement(Q1+1,
				   setelement(Q0+1,T,{body,M0,X0,Y0}),
				   {body,M1,X1,Y1})}
   end.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compute_acceleration(Tree,D,OX,OY,X,Y)
%%%

compute_acceleration(empty, _, _, _, _, _) -> 
    {0.0, 0.0};
compute_acceleration({body,BM,BX,BY}, _D, _OX, _OY, X, Y) ->
    DX = BX - X,
    DY = BY - Y,
    R2 = (DX * DX) + (DY * DY),
    Divisor = R2 * math:sqrt(R2),
    if Divisor < ?EPSILON -> 
	    {0.0, 0.0};
	true -> 
	    Expr = BM / Divisor,
	    {DX * Expr, DY * Expr}
    end;
compute_acceleration({branch,M,SubTree}, D, OX, OY, X, Y) ->
    DX = OX - X,
    DY = OY - Y,
    R2 = (DX * DX) + (DY * DY),
    DD = D*D,
    R2_THETA2 = ?THETA2*R2,
    if
	% Ok to approximate?
	DD < R2_THETA2 -> 
	    Divisor = R2 * math:sqrt(R2),
	    if Divisor < 0.000001 ->
		    {0.0,0.0};
		true -> 
		    Expr = M / Divisor,
		    {DX*Expr, DY*Expr}
	    end;

	% Not ok to approximate...
	true -> 
	    D2 = D / 2,
	    {AX0, AY0} = compute_acceleration(element(1,SubTree),
					      D2, OX + quadrant_to_dx(0,D2),
					      OY + quadrant_to_dy(0,D2),X,Y),
	    {AX1, AY1} = compute_acceleration(element(2,SubTree),
					      D2, OX + quadrant_to_dx(1,D2),
					      OY + quadrant_to_dy(1,D2),X,Y),
	    {AX2, AY2} = compute_acceleration(element(3,SubTree),
					      D2,OX + quadrant_to_dx(2,D2),
					      OY + quadrant_to_dy(2,D2),X,Y),
	    {AX3, AY3} = compute_acceleration(element(4,SubTree),
					      D2, OX + quadrant_to_dx(3,D2),
					      OY + quadrant_to_dy(3,D2),X,Y),
	    {AX0+AX1+AX2+AX3, AY0+AY1+AY2+AY3}
    end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compute_star_accelerations(Tree,Stars)
%%%

compute_star_accelerations(_,[]) -> 
    [];
compute_star_accelerations(Tree,[{_,X, Y,_,_}|Stars]) ->
    A = compute_acceleration(Tree, 20000.0, 0.0, 0.0, X, Y),
    B = compute_star_accelerations(Tree, Stars ),
    [A | B].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compute_next_state(Stars,Accs,Time)
%%%

compute_next_state([],_,_) ->
    [];
compute_next_state([{M,X,Y,VX,VY}|Stars],[{AX,AY}|Accs],Time) ->
    VX0 = VX + (AX * Time),
    VY0 = VY + (AY * Time),
    [{M,X+(VX*Time),Y+(VY*Time),VX0,VY0} | compute_next_state(Stars,Accs,Time)].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% iterate(Stars,Time,N)
%%%

iterate(Stars, _, 0) ->
    Stars;
iterate(Stars, Time, N) ->
    Tree = create_tree(Stars),
    Acc = compute_star_accelerations(Tree, Stars),
    NewStars = compute_next_state(Stars, Acc, Time),
    iterate(NewStars,Time,N-1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% main
%%%

-define(NO_OF_STARS,1000).
-define(MASS_OF_STARS,1.0).
-define(TIME_STEP,1000.0).
-define(ITERATIONS, 8).

test() ->
  test(?ITERATIONS).

test(N) ->
  Res = iterate(create_scenario(?NO_OF_STARS, ?MASS_OF_STARS), ?TIME_STEP, N),
  [{A,B1,B2,C1,C2}|_] = Res,
  io:format("~w ~w ~w ~w ~w\n", [A,B2,B2,C1,C2]),
  Res1 = if (abs(B1-B2) < ?EPSILON) %% differ really minimally
            and (B1 > -19277) and (B1 < -19275) -> true;
            true -> false
         end,
  Res2 = if (abs(C1-C2) < ?EPSILON) %% differ really minimally
            and (C1 > 0.0225) and (C1 < 0.0228027) -> true;
            true -> false
         end,
  {A, Res1, Res2}.

compile(Flags) ->
  hipe:c(?MODULE,Flags).
