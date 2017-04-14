#############################################################################
##
#W  toperations.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains operations that relate to transducers

InstallMethod(InverseTransducer, "for a transducer",
[IsTransducer],
function(T)
  local newstates, ntfunc, nofunc, n, x, q, word, preimage, pnstate;
  newstates := [];
  ntfunc := [];
  nofunc := [];

  for n in [1 .. T!.States] do
    Add(newstates, [[], n]);
  od;

  for x in [0 .. T!.InputAlphabet - 1] do
    for n in [1 .. T!.States] do
      if Preimage([x], n, T) = [] then
        Add(newstates, [[x], n]);
      fi;
    od;
  od;
  Add(newstates, [[0, 0], 3]);

  for n in [1 .. Size(newstates)] do
    Add(ntfunc, []);
    Add(nofunc, []);
  od;

  n := 0;
  for q in newstates do
    n := n + 1;
    for x in [0 .. T!.OutputAlphabet - 1] do
      word := [];
      Append(word, q[1]);
      Append(word, [x]);
      preimage := Preimage(word, q[2], T);
      pnstate := Position(newstates, [Minus(word,
                          T!.TransducerFunction(preimage, q[2])[1]),
                          T!.TransducerFunction(preimage, q[2])[2]]);

      if pnstate = fail then
        pnstate := n;
      fi;

      ntfunc[n][x + 1] := pnstate;
      nofunc[n][x + 1] := preimage;
    od;
  od;

  return Transducer(T!.OutputAlphabet, T!.InputAlphabet, ntfunc, nofunc);
end);
