-module(refined1).
-export([tree_to_bin/5]).

%% Special for dets.
tree_to_bin(v, _F, _Max, Ws, WsSz) -> {Ws, WsSz};
tree_to_bin(T, F, Max, Ws, WsSz) ->
    {N, L1, Ws1, WsSz1} = tree_to_bin2(T, F, Max, 0, [], Ws, WsSz),
    {N1, L2, Ws2, WsSz2} = F(N, lists:reverse(L1), Ws1, WsSz1),
    {0, [], NWs, NWsSz} = F(N1, L2, Ws2, WsSz2),
    {NWs, NWsSz}.

tree_to_bin2(Tree, F, Max, N, Acc, Ws, WsSz) when N >= Max ->
    {NN, NAcc, NWs, NWsSz} = F(N, lists:reverse(Acc), Ws, WsSz),
    tree_to_bin2(Tree, F, Max, NN, lists:reverse(NAcc), NWs, NWsSz);
tree_to_bin2(Tree, F, Max, N, Acc, Ws, WsSz) ->
    S = bplus_get_size(Tree),
    case element(1, Tree) of
        l ->
            {N+S, leaf_to_bin(bplus_leaf_to_list(Tree), Acc), Ws, WsSz};
        n ->
            node_to_bin(Tree, F, Max, N, Acc, 1, S, Ws, WsSz)
    end.

node_to_bin(_Node, _F, _Max, N, Acc, I, S, Ws, WsSz) when I > S ->
    {N, Acc, Ws, WsSz};
node_to_bin(Node, F, Max, N, Acc, I, S, Ws, WsSz) ->
    {N1,Acc1,Ws1,WsSz1} =
        tree_to_bin2(bplus_get_tree(Node, I), F, Max, N, Acc, Ws, WsSz),
    node_to_bin(Node, F, Max, N1, Acc1, I+1, S, Ws1, WsSz1).

leaf_to_bin([N | L], Acc) ->
    leaf_to_bin(L, [<<N:32>> | Acc]);
leaf_to_bin([], Acc) ->
    Acc.

%%-----------------------------------------------------------------
%% Converts a leaf into list format.
%%-----------------------------------------------------------------
bplus_leaf_to_list(Leaf) ->
    [_|LeafList] = tuple_to_list(Leaf),
    LeafList.

%%-----------------------------------------------------------------
%% Calculates the number of items in a node/leaf.
%%-----------------------------------------------------------------
bplus_get_size(Tree) ->
    case element(1, Tree) of
        l ->
            size(Tree)-1;
        n ->
            size(Tree) div 2
    end.

%%-----------------------------------------------------------------
%% Returns a tree at position Pos from an internal node.
%%-----------------------------------------------------------------
bplus_get_tree(Tree, Pos) -> element(Pos*2, Tree).
