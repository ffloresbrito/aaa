InstallMethod(Draw, "for a Digraph",
[IsDigraph],
function(D)
  local i, j, label, m, n, out, st, str, verts;
  verts := DigraphVertices(D);
  out   := OutNeighbours(D);
  m     := DigraphNrVertices(D);
  str   := "//dot\n";
  label := List(DigraphVertexLabels(D), x -> String(x));

  Append(str, "digraph finite_state_machine{\n");
  Append(str, "rankdir=LR;\n");
  Append(str, "node [shape=circle]\n");

  for i in verts do
    Append(str, Concatenation(label[i], "\n"));
  od;

  for i in verts do
    for j in [1 .. Size(out[i])] do
      Append(str, Concatenation(String(i), " -> ", String(out[i][j])));
      if DigraphEdgeLabels(D)[i][j] = [] then
        Append(str, Concatenation(" [label=\"", "e", "\"]"));
      else
        Append(str, Concatenation(" [label=\"", String(DigraphEdgeLabels(D)[i][j]), "\"]"));
      fi;
      Append(str, "\n");
    od;
  od; 
  Append(str, "}\n");
  Splash(str);
end);

InstallMethod(TransducerImageDigraph, "for a transducer",
[IsTransducer],
function(T)
  local D, vertex, edge;
  D := Digraph(TransitionFunction(T));
  for vertex in DigraphVertices(D) do
    for edge in [1 .. Size(OutNeighbours(D)[vertex])] do
      SetDigraphEdgeLabel(D, vertex, OutNeighbours(D)[vertex][edge],
              Concatenation(List(OutputFunction(T)[vertex][edge], x-> String(x))));
    od;
  od;
  return D;
end);

InstallMethod(DigraphTransducer, "for a digraph", 
[IsDigraph],
function(D)
  local output, input, state, states, nrinputs, outputalphabet, pi, lambda;
  states := DigraphVertices(D);
  nrinputs := Maximum(List(OutNeighbours(D), x -> Size(x)));
  outputalphabet := Set(Flat(DigraphEdgeLabels(D)));
  pi := [];
  lambda := [];
  for state in states do
    Add(pi, []);
    Add(lambda, []);
    for input in [1 .. nrinputs] do
      Add(pi[state], OutNeighbours(D)[state][Minimum(input, Size(OutNeighbours(D)[state]))]);
      Add(lambda[state], DigraphEdgeLabels(D)[state][Minimum(input, Size(OutNeighbours(D)[state]))]);
    od;
    for output in lambda[state] do
      Apply(output, x-> Position(outputalphabet, x) - 1);
    od;
  od;
  return Transducer(nrinputs, Size(outputalphabet), pi, lambda);
end);

InstallMethod(ImageAsUnionOfCones, "for a transducer",
[IsDigraph, IsPosInt],
function(x, i)
  return ImageAsUnionOfCones(CopyTransducerWithInitialState(DigraphTransducer(x), i));
end);

InstallMethod(ReverseEdges, "for a digraph",
[IsDigraph],
function(D)
  local D2, edge;
  D2 := Digraph(List(DigraphVertices(D), x -> []));
  for edge in DigraphEdges(D) do
    D2 := DigraphAddEdge(D2, [edge[2], edge[1]]);
    SetDigraphEdgeLabel(D2, edge[2], edge[1], Reversed(DigraphEdgeLabels(D)[edge[1]][Position(OutNeighbours(D)[edge[1]], edge[2])]));
  od;
  return D2;
end);

