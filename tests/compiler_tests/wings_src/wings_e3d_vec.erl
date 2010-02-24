%%
%%  e3d_vec.erl --
%%
%%     Arithmetic on vectors and points (represented as three-tuples).
%%
%%  Copyright (c) 2001-2002 Bjorn Gustavsson
%%
%%  See the file "license.terms" for information on usage and redistribution
%%  of this file, and for a DISCLAIMER OF ALL WARRANTIES.
%%
%%     $Id: wings_e3d_vec.erl,v 1.1 2004/02/18 17:11:13 kostis Exp $
%%

-module(wings_e3d_vec).

-export([zero/0,is_zero/1,add/1,add/2,sub/1,sub/2,mul/2,divide/2,neg/1,
	 dot/2,cross/2,norm_cross/2,len/1,dist/2,norm/1,norm/3,
	 normal/3,normal/1,average/1,average/2,average/4,
	 bounding_box/1]).

-compile(inline).
-compile({inline_size,24}).

zero() ->
    {0.0,0.0,0.0}.

is_zero({0.0,0.0,0.0}) -> true;
is_zero(_) -> false.

add({V10,V11,V12}, {V20,V21,V22}) when is_float(V10), is_float(V11), is_float(V12),
				       is_float(V20), is_float(V21), is_float(V22) ->
    {V10+V20,V11+V21,V12+V22}.

add([{V10,V11,V12}|T]) ->
    add(T, V10, V11, V12).

add([{V10,V11,V12},{V20,V21,V22},{V30,V31,V32}|T], A0, A1, A2)
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22),
       is_float(V30), is_float(V31), is_float(V32),
       is_float(A0), is_float(A1), is_float(A2) ->
    add(T, A0+V10+V20+V30, A1+V11+V21+V31, A2+V12+V22+V32);
add([{V10,V11,V12},{V20,V21,V22}|T], A0, A1, A2)
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22),
       is_float(A0), is_float(A1), is_float(A2) ->
    add(T, A0+V10+V20, A1+V11+V21, A2+V12+V22);
add([{V10,V11,V12}|T], A0, A1, A2) when is_float(V10), is_float(V11), is_float(V12),
					is_float(A0), is_float(A1), is_float(A2) ->
    add(T, A0+V10, A1+V11, A2+V12);
add([], A0, A1, A2) -> {A0,A1,A2}.

sub({V10,V11,V12}, {V20,V21,V22}) when is_float(V10), is_float(V11), is_float(V12),
				       is_float(V20), is_float(V21), is_float(V22) ->
    {V10-V20,V11-V21,V12-V22}.

sub([{V10,V11,V12}|T]) ->
    sub(V10, V11, V12, T).

sub(A0, A1, A2, [{V10,V11,V12}|T]) ->
    sub(A0-V10, A1-V11, A2-V12, T);
sub(A0, A1, A2, []) -> {A0,A1,A2}.

mul({V10,V11,V12}, S) when is_float(V10), is_float(V11), is_float(V12), is_float(S) ->
    {V10*S,V11*S,V12*S}.

divide({V10,V11,V12}, S) when is_float(V10), is_float(V11), is_float(V12), is_float(S) ->
    {V10/S,V11/S,V12/S}.

neg({X,Y,Z}) -> {-X,-Y,-Z}.

dot({V10,V11,V12}, {V20,V21,V22}) when is_float(V10), is_float(V11), is_float(V12),
				       is_float(V20), is_float(V21), is_float(V22) ->
    V10*V20 + V11*V21 + V12*V22.

cross({V10,V11,V12}, {V20,V21,V22}) when is_float(V10), is_float(V11), is_float(V12),
					 is_float(V20), is_float(V21), is_float(V22) ->
    {V11*V22-V12*V21,V12*V20-V10*V22,V10*V21-V11*V20}.

norm_cross({V10,V11,V12}, {V20,V21,V22})
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22) ->
    norm(V11*V22-V12*V21, V12*V20-V10*V22, V10*V21-V11*V20).

len({X,Y,Z}) when is_float(X), is_float(Y), is_float(Z) ->
    math:sqrt(X*X+Y*Y+Z*Z).

dist({V10,V11,V12}, {V20,V21,V22}) when is_float(V10), is_float(V11), is_float(V12),
					is_float(V20), is_float(V21), is_float(V22) ->
    X = V10-V20,
    Y = V11-V21,
    Z = V12-V22,
    math:sqrt(X*X+Y*Y+Z*Z).

norm({V1,V2,V3}) ->
    norm(V1, V2, V3).

norm(V1, V2, V3) when is_float(V1), is_float(V2), is_float(V3) ->
    D = math:sqrt(V1*V1+V2*V2+V3*V3),
    case catch {V1/D,V2/D,V3/D} of
	{'EXIT',_} -> {0.0,0.0,0.0};
	R -> R
    end.

normal({V10,V11,V12}, {V20,V21,V22}, {V30,V31,V32})
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22),
       is_float(V30), is_float(V31), is_float(V32) ->
    D10 = V10-V20,
    D11 = V11-V21,
    D12 = V12-V22,
    D20 = V20-V30,
    D21 = V21-V31,
    D22 = V22-V32,
    N0 = D11*D22-D12*D21,
    N1 = D12*D20-D10*D22,
    N2 = D10*D21-D11*D20,
    D = math:sqrt(N0*N0+N1*N1+N2*N2),
    case catch {N0/D,N1/D,N2/D} of
	{'EXIT',_} -> {0.0,0.0,0.0};
	R -> R
    end.

%% normal([{X,Y,Z}]) ->
%%  Calculate the averaged normal for the polygon using Newell's method.

normal([{Ax,Ay,Az},{Bx,By,Bz},{Cx,Cy,Cz}])
  when is_float(Ax), is_float(Ay), is_float(Az),
       is_float(Bx), is_float(By), is_float(Bz) ->
    Sx = (Ay-By)*(Az+Bz) + (By-Cy)*(Bz+Cz) + (Cy-Ay)*(Cz+Az),
    Sy = (Az-Bz)*(Ax+Bx) + (Bz-Cz)*(Bx+Cx) + (Cz-Az)*(Cx+Ax),
    Sz = (Ax-Bx)*(Ay+By) + (Bx-Cx)*(By+Cy) + (Cx-Ax)*(Cy+Ay),
    norm(Sx, Sy, Sz);
normal([{Ax,Ay,Az},{Bx,By,Bz},{Cx,Cy,Cz},{Dx,Dy,Dz}])
  when is_float(Ax), is_float(Ay), is_float(Az),
       is_float(Bx), is_float(By), is_float(Bz),
       is_float(Cx), is_float(Cy), is_float(Cz) ->
    %% Daniel Sunday: "Fast Polygon Area and Newell Normal Computation"
    %% journal of graphics tools, 7(2):9-13, 2002
    CzMinusAz = Cz-Az, DzMinusBz = Dz-Bz,
    CxMinusAx = Cx-Ax, DxMinusBx = Dx-Bx,
    CyMinusAy = Cy-Ay, DyMinusBy = Dy-By,
    Nx = By*CzMinusAz + Cy*DzMinusBz - Dy*CzMinusAz - Ay*DzMinusBz,
    Ny = Bz*CxMinusAx + Cz*DxMinusBx - Dz*CxMinusAx - Az*DxMinusBx,
    Nz = Bx*CyMinusAy + Cx*DyMinusBy - Dx*CyMinusAy - Ax*DyMinusBy,
    norm(Nx, Ny, Nz);
normal([{Ax,Ay,Az},{Bx,By,Bz}|[{Cx,Cy,Cz}|_]=T]=First)
  when is_float(Ax), is_float(Ay), is_float(Az),
       is_float(Bx), is_float(By), is_float(Bz) ->
    Sx = (Ay-By)*(Az+Bz) + (By-Cy)*(Bz+Cz),
    Sy = (Az-Bz)*(Ax+Bx) + (Bz-Cz)*(Bx+Cx),
    Sz = (Ax-Bx)*(Ay+By) + (Bx-Cx)*(By+Cy),
    normal_1(T, First, Sx, Sy, Sz).

normal_1([{Ax,Ay,Az}], [{Bx,By,Bz}|_], Sx, Sy, Sz)
  when is_float(Ax), is_float(Ay), is_float(Az),
       is_float(Sx), is_float(Sy), is_float(Sz) ->
    norm(Sx + (Ay-By)*(Az+Bz),
	 Sy + (Az-Bz)*(Ax+Bx),
	 Sz + (Ax-Bx)*(Ay+By));
normal_1([{Ax,Ay,Az}|[{Bx,By,Bz}|_]=T], First, Sx0, Sy0, Sz0)
  when is_float(Ax), is_float(Ay), is_float(Az),
       is_float(Sx0), is_float(Sy0), is_float(Sz0) ->
    Sx = Sx0 + (Ay-By)*(Az+Bz),
    Sy = Sy0 + (Az-Bz)*(Ax+Bx),
    Sz = Sz0 + (Ax-Bx)*(Ay+By),
    normal_1(T, First, Sx, Sy, Sz).

%% average([{X,Y,Z}]) -> {Ax,Ay,Az}
%%  Average the given list of points.
average([{V10,V11,V12},B]) ->
    {V20,V21,V22} = B,
    V0 = if
	     V10 =:= V20 -> V10;
	     is_float(V10) -> 0.5*(V10+V20)
	 end,
    V1 = if
	     V11 =:= V21 -> V11;
	     is_float(V11) -> 0.5*(V11+V21)
	 end,
    if
	V12 =:= V22 -> {V0,V1,V12};
	is_float(V12) -> {V0,V1,0.5*(V12+V22)}
    end;
average([{V10,V11,V12}|T]=All) ->
    average(T, V10, V11, V12, length(All)).

average([{V10,V11,V12},{V20,V21,V22},{V30,V31,V32}|T], A0, A1, A2, L)
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22),
       is_float(V30), is_float(V31), is_float(V32),
       is_float(A0), is_float(A1), is_float(A2) ->
    average(T, A0+V10+V20+V30, A1+V11+V21+V31, A2+V12+V22+V32, L);
average([{V10,V11,V12},{V20,V21,V22}|T], A0, A1, A2, L)
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(V20), is_float(V21), is_float(V22),
       is_float(A0), is_float(A1), is_float(A2) ->
    average(T, A0+V10+V20, A1+V11+V21, A2+V12+V22, L);
average([{V10,V11,V12}|T], A0, A1, A2, L)
  when is_float(V10), is_float(V11), is_float(V12),
       is_float(A0), is_float(A1), is_float(A2) ->
    average(T, A0+V10, A1+V11, A2+V12, L);
average([], A0, A1, A2, L0) ->
    L = 1.0/float(L0),
    {A0*L,A1*L,A2*L}.

average({V10,V11,V12}, {V20,V21,V22}) ->
    V0 = if
	     V10 =:= V20 -> V10;
	     is_float(V10) -> 0.5*(V10+V20)
	 end,
    V1 = if
	     V11 =:= V21 -> V11;
	     is_float(V11) -> 0.5*(V11+V21)
	 end,
    if
	V12 =:= V22 -> {V0,V1,V12};
	is_float(V12) -> {V0,V1,0.5*(V12+V22)}
    end.

average({V10,V11,V12}, {V20,V21,V22}, {V30,V31,V32}, {V40,V41,V42})
    when is_float(V10), is_float(V11), is_float(V12) ->
    L = 0.25,
    {L*(V10+V20+V30+V40),L*(V11+V21+V31+V41),L*(V12+V22+V32+V42)}.

bounding_box([{X,Y,Z}|Vs]) ->
    bounding_box_1(Vs, X, X, Y, Y, Z, Z).

bounding_box_1([{X,_,_}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when X < X0 ->
    bounding_box_1(Vs, X, X1, Y0, Y1, Z0, Z1);
bounding_box_1([{X,_,_}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when X > X1 ->
    bounding_box_1(Vs, X0, X, Y0, Y1, Z0, Z1);
bounding_box_1([{_,Y,_}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when Y < Y0 ->
    bounding_box_1(Vs, X0, X1, Y, Y1, Z0, Z1);
bounding_box_1([{_,Y,_}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when Y > Y1 ->
    bounding_box_1(Vs, X0, X1, Y0, Y, Z0, Z1);
bounding_box_1([{_,_,Z}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when Z < Z0 ->
    bounding_box_1(Vs, X0, X1, Y0, Y1, Z, Z1);
bounding_box_1([{_,_,Z}|_]=Vs, X0, X1, Y0, Y1, Z0, Z1) when Z > Z1 ->
    bounding_box_1(Vs, X0, X1, Y0, Y1, Z0, Z);
bounding_box_1([_|Vs], X0, X1, Y0, Y1, Z0, Z1) ->
    bounding_box_1(Vs, X0, X1, Y0, Y1, Z0, Z1);
bounding_box_1([], X0, X1, Y0, Y1, Z0, Z1) ->
    [{X0,Y0,Z0},{X1,Y1,Z1}].
