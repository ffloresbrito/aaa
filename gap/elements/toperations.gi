#############################################################################
##
#W  toperations.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains methods for operations that relate to transducers.

InstallMethod(InverseTransducer, "for a transducer",
[IsTransducer],
function(T)
  local newstates, ntfunc, nofunc, n, x, q, word, preimage, newstate, tdcrf;
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
      tdcrf := T!.TransducerFunction(preimage, q[2]);

      newstate := [Minus(word, tdcrf[1]), tdcrf[2]];

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

InstallMethod(TransducerProduct, "for two transducers",
[IsTransducer, IsTransducer],
function(tdcr1, tdcr2)
  local newstates, newstate, ntfun, nofun, tducerf, word, x, y, q, n;
  newstates := [];
  ntfun := [];
  nofun := [];

  if tdcr1!.OutputAlphabet <> tdcr2!.InputAlphabet then
    ErrorNoReturn("aaa: TransducerProduct: usage,\n",
                  "the output alphabet of the first argument must be the ",
                  "input alphabet\nof the second argument,");
  fi;

  for x in [1 .. tdcr1!.States] do
    for y in [1 .. tdcr2!.States] do 
      Add(newstates, [x, y]);
      Add(ntfun, []);
      Add(nofun, []);
    od;
  od;

  n := 0;
  for q in newstates do
    n := n + 1;
    for x in [0 .. tdcr1!.InputAlphabet - 1] do
      word := tdcr1!.OutputFunction[q[1]][x + 1];
      tducerf := tdcr2!.TransducerFunction(word, q[2]);
      newstate := [tdcr1!.TransitionFunction[q[1]][x + 1], tducerf[2]];
      ntfun[n][x + 1] := Position(newstates, newstate);
      nofun[n][x + 1] := tducerf[1];
    od;
  od;

  return Transducer(tdcr1!.InputAlphabet, tdcr2!.OutputAlphabet, ntfun, nofun);
end);

InstallMethod(RemoveStatesWithIncompleteResponse, "for a transducer",
[IsTransducer],
function(T)
  local ntfunc, nofunc, n, x, new1;
  ntfunc := [];
  nofunc := [];
  for x in [1 .. T!.States + 1] do
    Add(ntfunc, []);
    Add(nofunc, []);
  od;
  for x in [0 .. T!.InputAlphabet - 1] do
    new1 := T!.TransducerFunction([x], 1);
    ntfunc[1][x + 1] := new1[2] + 1;
    nofunc[1][x + 1] := new1[1];
  od;
  for n in [2 .. T!.States + 1] do
    for x in [0 .. T!.InputAlphabet - 1] do
      nofunc[n][x + 1] := Minus(ImageConeLongestPrefix([x], n - 1, T),
                                ImageConeLongestPrefix([], n - 1, T));
      ntfunc[n][x + 1] := T!.TransducerFunction([x], n - 1)[2] + 1;
      od;
    od;

  return Transducer(T!.InputAlphabet, T!.OutputAlphabet, ntfunc, nofunc);
end);

InstallMethod(RemoveInaccessibleStates, "for a transducer",
[IsTransducer],
function(T)
  local states, newq, newl, new, q, n, x;

  states := [1];
  newq := [];
  newl := [];
  n := 0;

  for q in states do
    n := n + 1;
    for x in [0 .. T!.InputAlphabet - 1] do
      new := T!.TransducerFunction([x], q);
      newq[n][x + 1] := new[2];
      newl[n][x + 1] := new[1];

      if not new[2] in states then
        Add(states, new[2]);
        Add(newq, []);
        Add(newl, []);
      fi;
    od;
  od;

  return Transducer(T!.InputAlphabet, T!.OutputAlphabet, newq, newl);
end);
