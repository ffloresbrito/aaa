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

InstallMethod(\^, "for a transducer and a positive integer",
[IsTransducer, IsPosInt],
function(T, n)
  local tducer, x;
  tducer := CopyTransducerWithInitialState(T, 1);

  for x in [1 .. n - 1] do
    tducer := tducer * T;
  od;
  return tducer;
end);

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

InstallMethod(IsSurjectiveTransducer, "for a transducer",
[IsTransducer],
function(T)
  local usefulstates, prefixcodes, imagetrees, completeblocks, finalimagetree,
  currentblocks, containsantichain, currentword, x, flag, y, minwords, tyx,
  tree, pos, keys, subtree, check, pos2, prefix, block, state, imagekeys,
  minword, answer;
  imagetrees := States(T);
  completeblocks := [];
  usefulstates := [1];
  prefixcodes := [];

  containsantichain := function(list, n)
    local currentword, minwords, x, y, check, maxword, children, i;
    if IsEmpty(list) then
      return false;
    fi;

    currentword := [];
    minwords := [];
    check := false;
    for x in list do
      for y in [1 .. Size(minwords)] do
        if IsPrefix(x, minwords[y]) then
          minwords[y] := StructuralCopy(x);
          break;
        elif IsPrefix(minwords[y], x) then
          check := true;
          break;
        fi;
      od;
      if not check then
        Add(minwords, StructuralCopy(x));
      fi;
      check := false;
    od;
    while not minwords = [[]] do
      Sort(minwords, function(x, y)
                       return Size(x) > Size(y);
                     end);
      maxword := StructuralCopy(minwords[1]);
      Remove(maxword);
      children := [];
      minwords := Set(minwords);
      for i in [0 .. n - 1] do
        Add(children, Concatenation(maxword, [i]));
      od;
      if not IsSubset(minwords, children) then
        return false;
      else
        for i in children do
          RemoveSet(minwords, i);
        od;
        AddSet(minwords, maxword);
      fi;
    od;
    return true;
  end;

  for x in usefulstates do
    flag := true;
    Add(prefixcodes, []);
    currentword := [];
    while flag do
      while IsEmpty(TransducerFunction(T, currentword, x)[1]) do
        Add(currentword, 0);
      od;
      Add(prefixcodes[Position(usefulstates, x)], StructuralCopy(currentword));
      while currentword[Size(currentword)] = NrInputSymbols(T) - 1 do
        Remove(currentword);
        if IsEmpty(currentword) then
          break;
        fi;
      od;

      if not IsEmpty(currentword) then
        currentword[Size(currentword)] := currentword[Size(currentword)] + 1;
      else
        flag := false;
      fi;
    od;
    for y in prefixcodes[Size(prefixcodes)] do
      AddSet(usefulstates, TransducerFunction(T, y, x)[2]);
    od;
    imagetrees[x] := [];
    for y in prefixcodes[Size(prefixcodes)] do
      tyx := TransducerFunction(T, y, x);
      tree := imagetrees[x];
      pos := Position(List(tree, x -> x[1]), tyx[1]);
      if  not pos = fail then
        AddSet(tree[pos][2], tyx[2]);
      else
        AddSet(tree, [tyx[1], [tyx[2]]]);
      fi;
    od;
  od;
  finalimagetree := [[[], [1]]];
  currentblocks := [[[], [[[], [1]]]]];
  keys := [[]];
  while (not IsSubset(completeblocks, List(currentblocks, x -> x[2]))) and
      containsantichain(keys, NrInputSymbols(T)) do
    for block in currentblocks do
      if not block[2] in completeblocks then
        break;
      fi;
    od;
    keys := List(finalimagetree, x -> x[1]);
    for state in finalimagetree[Position(keys, block[1])][2] do
      imagekeys := List(imagetrees[state], x -> x[1]);
      for prefix in  imagekeys do
        keys   := List(finalimagetree, x -> x[1]);
        pos := Position(keys, Concatenation(block[1], prefix));
        if not pos = fail then
          pos2 := Position(imagekeys, prefix);
          Append(finalimagetree[pos][2], imagetrees[state][pos2][2]);
          Set(finalimagetree[pos][2]);
        else
          pos2 := Position(imagekeys, prefix);
          Add(finalimagetree, [StructuralCopy(Concatenation(block[1], prefix)),
              StructuralCopy(imagetrees[state][pos2][2])]);
        fi;
      od;
    od;
    keys := List(finalimagetree, x -> x[1]);
    pos := Position(keys, block[1]);
    Remove(finalimagetree, pos);
    Remove(currentblocks, Position(currentblocks, block));
    AddSet(completeblocks, block[2]);
    minwords := [];
    check := false;
    keys := List(finalimagetree, x -> x[1]);
    prefix := StructuralCopy(block[1]);
    for x in keys do
      if IsPrefix(x, prefix) then
        for y in [1 .. Size(minwords)] do
          if IsPrefix(x, minwords[y]) then
            minwords[y] := StructuralCopy(x);
            break;
          elif IsPrefix(minwords[y], x) then
            check := true;
            break;
          fi;
        od;

        if not check then
          Add(minwords, StructuralCopy(x));
        fi;
        check := false;
      fi;
    od;
    for minword in minwords do
      subtree := [];
      for x in [1 .. Size(keys)] do
         if IsPrefix(keys[x], minword) then
           Add(subtree, [Minus(keys[x], minword),
               StructuralCopy(finalimagetree[x][2])]);
         fi;
      od;
      Add(currentblocks, [minword, StructuralCopy(subtree)]);
    od;
    keys := List(finalimagetree, x -> x[1]);
  od;

  answer := containsantichain(keys, NrInputSymbols(T));
  SetIsSurjectiveTransducer(T, answer);
  return answer;
end);
