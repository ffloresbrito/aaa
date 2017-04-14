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
  local newstates, ntfunc, nofunc, n, x, q, word, preimage, newstate;
  newstates := [];
  ntfunc := [[]];
  nofunc := [[]];
  newstates := [[[], 1]];

  n := 0;
  for q in newstates do
    n:= n + 1;
    for x in [0 .. T!.OutputAlphabet - 1] do
    word := [];
    Append(word, q[1]);
    Append(word, [x]);
    preimage := GreatestCommonPrefix(PreimageConePrefixes(word, q[2], T));
    newstate := [Minus(word, T!.TransducerFunction(preimage, q[2])[1]),
                 T!.TransducerFunction(preimage, q[2])[2]];

    if not newstate in newstates then
      Add(newstates, newstate);
      Add(ntfunc, []);
      Add(nofunc, []);
    fi;

      ntfunc[n][x + 1] := Position(newstates, newstate);
      nofunc[n][x + 1] := preimage;
    od;
  od;

  return Transducer(T!.OutputAlphabet, T!.InputAlphabet, ntfunc, nofunc);
end);
