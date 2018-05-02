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
    n := n + 1;
    for x in OutputAlphabet(T) do
      word := [];
      Append(word, q[1]);
      Append(word, [x]);
      preimage := GreatestCommonPrefix(PreimageConePrefixes(word, q[2], T));
      tdcrf := TransducerFunction(T, preimage, q[2]);

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

  return Transducer(NrOutputSymbols(T), NrInputSymbols(T), ntfunc, nofunc);
end);

InstallMethod(TransducerProduct, "for two transducers",
[IsTransducer, IsTransducer],
function(tdcr1, tdcr2)
  local newstates, newstate, ntfun, nofun, tducerf, word, x, y, q, n;
  newstates := [];
  ntfun := [];
  nofun := [];

  if NrOutputSymbols(tdcr1) <> NrInputSymbols(tdcr2) then
    ErrorNoReturn("aaa: TransducerProduct: usage,\n",
                  "the output alphabet of the first argument must be the ",
                  "input alphabet\nof the second argument,");
  fi;

  for x in States(tdcr1) do
    for y in States(tdcr2) do
      Add(newstates, [x, y]);
      Add(ntfun, []);
      Add(nofun, []);
    od;
  od;

  n := 0;
  for q in newstates do
    n := n + 1;
    for x in InputAlphabet(tdcr1) do
      word := OutputFunction(tdcr1)[q[1]][x + 1];
      tducerf := TransducerFunction(tdcr2, word, q[2]);
      newstate := [TransitionFunction(tdcr1)[q[1]][x + 1], tducerf[2]];
      ntfun[n][x + 1] := Position(newstates, newstate);
      nofun[n][x + 1] := tducerf[1];
    od;
  od;

  return Transducer(NrInputSymbols(tdcr1), NrOutputSymbols(tdcr2), ntfun,
  nofun);
end);

InstallMethod(\*, "for two transducers",
[IsTransducer, IsTransducer],
TransducerProduct);

InstallMethod(RemoveStatesWithIncompleteResponse, "for a transducer",
[IsTransducer],
function(T)
  local ntfunc, nofunc, n, x;
  ntfunc := [];
  nofunc := [];
  for x in [1 .. NrStates(T) + 1] do
    Add(ntfunc, []);
    Add(nofunc, []);
  od;
  for x in InputAlphabet(T) do
    ntfunc[1][x + 1] := TransducerFunction(T, [x], 1)[2] + 1;
    nofunc[1][x + 1] := ImageConeLongestPrefix([x], 1, T);
  od;
  for n in [2 .. NrStates(T) + 1] do
    for x in InputAlphabet(T) do
      nofunc[n][x + 1] := Minus(ImageConeLongestPrefix([x], n - 1, T),
                                ImageConeLongestPrefix([], n - 1, T));
      ntfunc[n][x + 1] := TransducerFunction(T, [x], n - 1)[2] + 1;
      od;
    od;

  return Transducer(NrInputSymbols(T), NrOutputSymbols(T), ntfunc, nofunc);
end);

InstallMethod(RemoveInaccessibleStates, "for a transducer",
[IsTransducer],
function(T)
  local states, newq, newl, new, q, n, x;

  states := [1];
  newq := [[]];
  newl := [[]];
  n := 0;

  for q in states do
    n := n + 1;
    for x in InputAlphabet(T) do
      new := TransducerFunction(T, [x], q);

      if not new[2] in states then
        Add(states, new[2]);
        Add(newq, []);
        Add(newl, []);
      fi;

      newq[n][x + 1] := Position(states, new[2]);
      newl[n][x + 1] := new[1];
    od;
  od;

  return Transducer(NrInputSymbols(T), NrOutputSymbols(T), newq, newl);
end);

InstallMethod(CopyTransducerWithInitialState,
"for a transducer and a positive integer",
[IsTransducer, IsPosInt],
function(T, i)
  local new, newq, newl, q, states, x, n;
  states := ShallowCopy(States(T));

  if not i in states then
    ErrorNoReturn("aaa: ChangeInitialState: usage,\n",
                  "the second argument is not a state of the first argument,");
  fi;

  newq := [];
  newl := [];
  n := 0;

  for x in states do
    Add(newq, []);
    Add(newl, []);
  od;

  Sort(states, function(x, y)
                 return x = i;
               end);

  for q in states do
    n := n + 1;
    for x in InputAlphabet(T) do
      new := TransducerFunction(T, [x], q);
      newq[n][x + 1] := Position(states, new[2]);
      newl[n][x + 1] := new[1];
    od;
  od;

  return Transducer(NrInputSymbols(T), NrOutputSymbols(T), newq, newl);
end);

InstallMethod(RemoveEquivalentStates, "for a transducer",
[IsTransducer],
function(T)
  local states, n, Eq, Reps, q, p, Eqclass, new, newq, newl, x, seen, dmy, nsr,
        ns;
  ns := NrStates(T);
  nsr := 0;
  dmy := CopyTransducerWithInitialState(T, 1);
  Eqclass := function(y)
               local class;
                 for class in Eq do
                   if y in class then
                     return Minimum(class);
                   fi;
                 od;
             end;

  while nsr < ns do
    ns := NrStates(dmy);
    states := [1 .. ns];
    n := 0;
    Eq := [];
    Reps := [];
    newq := [];
    newl := [];
    seen := [];
    for q in states do
      if not q in seen then
        n := n + 1;
        Add(Eq, []);
        Add(Reps, q);
        for p in states do
          if not p in seen then
            if TransitionFunction(dmy)[q] = TransitionFunction(dmy)[p] and
                OutputFunction(dmy)[q] = OutputFunction(dmy)[p] then
              Add(Eq[n], p);
              Add(seen, p);
            fi;
          fi;
        od;
      fi;
    od;
    n := 0;
    for q in Reps do
      n := n + 1;
      Add(newq, []);
      Add(newl, []);

      for x in InputAlphabet(dmy) do
        new := TransducerFunction(dmy, [x], q);
        newl[n][x + 1] := new[1];
        newq[n][x + 1] := Position(Reps, Eqclass(new[2]));
      od;
    od;
    dmy := Transducer(NrInputSymbols(dmy), NrOutputSymbols(dmy), newq, newl);
    nsr := NrStates(dmy);
  od;
  return dmy;
end);

InstallMethod(IsInjectiveTransducer, "for a transducer",
[IsTransducer],
function(T)
  local active, flag, outs, p, pair, pairs, t, tactive, u, v, w, x, y, z;
  active := List(InputAlphabet(T), x -> [[x]]);
  flag := true;
  pairs := [];

  while flag do
    tactive := List(InputAlphabet(T), x -> []);

    for w in InputAlphabet(T) do
      for u in active[w + 1] do
        for v in InputAlphabet(T) do
          p := Concatenation(u, [v]);
          Add(tactive[w + 1], p);
        od;
      od;
    od;

    active := ShallowCopy(tactive);
    outs := List(active, x -> List(x, y -> TransducerFunction(T, y, 1)));
    tactive := List(InputAlphabet(T), x -> []);

    for x in [1 .. Size(outs)] do
      for y in [x + 1 .. Size(outs)] do
        for z in [1 .. Size(outs[x])] do
          for t in [1 .. Size(outs[y])] do
            if IsPrefix(outs[x][z][1], outs[y][t][1]) or
                IsPrefix(outs[y][t][1], outs[x][z][1]) then

              AddSet(tactive[x], active[x][z]);
              AddSet(tactive[y], active[y][t]);

              if IsPrefix(outs[x][z][1], outs[y][t][1]) then
                pair := [Minus(outs[x][z][1], outs[y][t][1]), [outs[x][z][2],
                                                               outs[y][t][2]]];
              else
                pair := [Minus(outs[y][t][1], outs[x][z][1]), [outs[y][t][2],
                                                               outs[x][z][2]]];
              fi;

              if pair in pairs then
                SetEqualImagePrefixes(T, [active[x][z], active[y][t]]);
                SetIsInjectiveTransducer(T, false);
                return false;
              else
                Add(pairs, pair);
              fi;
            fi;
          od;
        od;
      od;
    od;

    active := ShallowCopy(tactive);

    if ForAll(active, x -> IsEmpty(x)) then
      flag := false;
    fi;
  od;

  SetIsInjectiveTransducer(T, true);
  return true;
end);

InstallMethod(EqualImagePrefixes, "for a transducer",
[IsTransducer],
function(T)
  local tducer;

  if HasEqualImagePrefixes(T) then
    return EqualImagePrefixes(T);
  elif HasIsInjectiveTransducer(T) then
    if IsInjectiveTransducer(T) = false then
      tducer := CopyTransducerWithInitialState(T, 1);
      IsInjectiveTransducer(tducer);
      SetEqualImagePrefixes(T, EqualImagePrefixes(tducer));
      return EqualImagePrefixes(T);
    fi;
  elif IsInjectiveTransducer(T) = false then
    return EqualImagePrefixes(T);
  else
    return fail;
  fi;
  return fail;
end);
