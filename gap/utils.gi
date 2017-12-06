#############################################################################
##
#W  utils.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains utility functions.

InstallGlobalFunction(AaaMakeDoc,
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("aaa")[1]!.InstallationPath, "/doc"),
                "main.xml", ["../PackageInfo.g",
                             "transducer.xml",
                             "toperations.xml",
                             "utils.xml",
                             "woperations.xml"], "aaa", "MathJax", "../../..");
  return;
end);

InstallMethod(DotTransducer, "for a transducer",
[IsTransducer],
function(transducer)
  local verts, out, m, n, str, i, j, st;

  verts := [1 .. States(transducer)];
  out   := TransitionFunction(transducer);
  m     := States(transducer);
  str   := "//dot\n";

  Append(str, "digraph hgn{\n");
  Append(str, "node [shape=circle]\n");

  for i in verts do
    Append(str, Concatenation(String(i), "\n"));
  od;

  for i in verts do
    n := 0;
    for j in out[i] do
      n := n + 1;
      st := String(OutputFunction(transducer)[i][n]);
      RemoveCharacters(st, " [,]");
      Append(str, Concatenation(String(i), " -> ", String(j)));
      Append(str, Concatenation(" [label=\"", String(n - 1), "|", st, "\"]"));
      Append(str, "\n");
    od;
  od;
  Append(str, "}\n");
  return str;
end);
