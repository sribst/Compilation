type 'a tree =
  | Node of 'a tree * 'a tree
  | Leaf of 'a

let rec tolist t = match t with
  | Leaf v -> [v]
  | Node (a, b) -> tolist a @ tolist b

let rec tolist t acc =
  match t with
  | Leaf v -> v::acc
  | Node(a,b) ->
    tolist a (tolist b acc)

let rec tolist doleft t acc =
  match t with
  | Leaf v -> doleft v @ acc 
  |




let exemple =
  Node (Node (Leaf 1, Node (Leaf 2, Leaf 3)),
        Node (Node (Leaf 4, Leaf 5), Leaf 6))

let _ = tolist exemple []


