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
[IsTransducer, IsInt],
function(T, n)
  local flag, tducer, x;
  if n = 1 then
    return CopyTransducerWithInitialState(T, 1);
  fi;
  if n < 0 then
    if not IsBijectiveTransducer(T) then
      ErrorNoReturn("aaa: ^: usage,\n",
                  "the given transducer must be bijective");
    fi;
    return InverseTransducer(T)^-n;
  fi;
  if not InputAlphabet(T) = OutputAlphabet(T) then
    ErrorNoReturn("aaa: ^: usage,\n",
                  "the given transducer must have the same domain and range");
  fi;
  if n = 0 then
   return IdentityTransducer(Size(InputAlphabet(T)));
  fi;

  tducer := CopyTransducerWithInitialState(T, 1);

  for x in [1 .. n - 1] do
    tducer := tducer * T;
  od;
 
  return tducer;
end);

InstallMethod(EqualTransducers, "for a pair of transducers",
[IsTransducer, IsTransducer],
function(T1,T2)
  return OutputFunction(T1)=OutputFunction(T2) and TransitionFunction(T1)=TransitionFunction(T2);
end);

InstallMethod(\^, "for a transducer and a bijective transducer",
[IsTransducer, IsTransducer],
function(T1,T2)
  if not IsBijectiveTransducer(T2) then
    return fail;
  fi;
  return T2^-1 * T1 * T2;
end);

InstallMethod(RemoveStatesWithIncompleteResponse, "for a transducer",
[IsTransducer],
function(T)
  local ntfunc, nofunc, n, x, const, target, pos, badpref, neededcopies,
        i, stufftowrite, out, edgestopushfrom, edge, pushstring;

  if IsDegenerateTransducer(T) then
    ErrorNoReturn("aaa: RemoveStatesWithIncompleteResponce: usage,\n",
                  "the given transducer must be nondegenerate ");
  fi;

  const := List(TransducerConstantStateOutputs(T),x-> List(x,y->y));
  for i in [1 .. Size(const[2])] do
    const[2][i]:= const[2][i]{[1 .. Size(const[2][i])-2]};
    const[2][i]:= SplitString(const[2][i],"(");
    const[2][i][1]:= List([1 .. Size(const[2][i][1])], x -> Int(const[2][i][1]{[x]}));
    const[2][i][2]:= List([1 .. Size(const[2][i][2])], x -> Int(const[2][i][2]{[x]}));
  od;
  edgestopushfrom := [];
  ntfunc := [];
  nofunc := [];
  for x in [1 .. NrStates(T) + 1] do
    Add(ntfunc, []);
    Add(nofunc, []);
  od;
  for x in InputAlphabet(T) do
    target := TransducerFunction(T, [x], 1)[2];
    ntfunc[1][x + 1] := target + 1;
    pos := Position(const[1], target);
    if pos = fail then
      nofunc[1][x + 1] := ImageConeLongestPrefix([x], 1, T);
    else
      out := TransducerFunction(T,[x],1)[1];
      nofunc[1][x + 1] := Concatenation(out, const[2][pos][1]);
      if out <> [] and const[2][pos][1] = [] and out[Size(out)] = const[2][pos][2][Size(const[2][pos][2])] then
        Add(edgestopushfrom, [1,x+1]);
      fi;
    fi;
  od;
  for n in [2 .. NrStates(T) + 1] do
    if not n - 1 in const[1] then
      for x in InputAlphabet(T) do
        target := TransducerFunction(T, [x], n - 1)[2];
        ntfunc[n][x + 1] := target + 1;
        pos := Position(const[1], target);
        if pos = fail then
          nofunc[n][x + 1] := Minus(ImageConeLongestPrefix([x], n - 1, T),
                                    ImageConeLongestPrefix([], n - 1, T));
        else
          badpref := ImageConeLongestPrefix([], n - 1, T);
          out := TransducerFunction(T, [x], n - 1)[1];
          neededcopies := Int(Ceil(Float(((Size(badpref) - Size(const[2][pos][1]))/Size(const[2][pos][2])))));
          neededcopies := Maximum(neededcopies, 0);
          stufftowrite := Concatenation(out, const[2][pos][1], Concatenation(ListWithIdenticalEntries(neededcopies, const[2][pos][2])));
          nofunc[n][x + 1] := Minus(stufftowrite, badpref);
          if nofunc[n][x + 1] <> [] and nofunc[n][x + 1][Size(nofunc[n][x + 1])]=const[2][pos][2][1] then
            Add(edgestopushfrom, [n, x + 1]);
          fi;
        fi;
      od;
    else
      for x in InputAlphabet(T) do;
        ntfunc[n][x + 1] := n;
        nofunc[n][x + 1] := const[2][Position(const[1],n - 1)][2];
      od;
    fi;
  od;
  for edge in edgestopushfrom do
    Add(ntfunc,ListWithIdenticalEntries(Size(InputAlphabet(T)),Size(ntfunc) + 1));
    pushstring := ShallowCopy(nofunc[ntfunc[edge[1]][edge[2]]][1]);
    out := nofunc[edge[1]][edge[2]];
    while out <> [] and out[Size(out)] = pushstring[Size(pushstring)] do
      Remove(out);
      pushstring := Concatenation([pushstring[Size(pushstring)]],pushstring{[1 .. Size(pushstring)-1]});
    od;
    Add(nofunc, ListWithIdenticalEntries(Size(InputAlphabet(T)), pushstring));
    ntfunc[edge[1]][edge[2]]:= Size(ntfunc);
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
function(t)
 local T, state, CurrentDigraph, D, tuple, out1, out2, out, newvertex, vertex, letter;

 if IsDegenerateTransducer(t) then
   ErrorNoReturn("aaa: IsInjectiveTransducer: usage,\n",
                  "the given transducer must be nondegenerate ");
 fi;

 T := RemoveInaccessibleStates(t);
 for state in States(T) do
   CurrentDigraph := [[],[]];
   for tuple in UnorderedTuples(InputAlphabet(T),2) do
     if not tuple[1] = tuple[2] then
        out1 := TransducerFunction(T,[tuple[1]],state);
        out2 := TransducerFunction(T,[tuple[2]],state);
        if IsPrefix(out1[1],out2[1]) then
          newvertex := [[out1[2],[]],[out2[2],Minus(out1[1],out2[1])]];
        elif IsPrefix(out2[1],out1[1]) then
          newvertex := [[out2[2],[]],[out1[2],Minus(out2[1],out1[1])]];
        else
          continue;
        fi;
        if newvertex[1] = newvertex[2] then
           SetIsInjectiveTransducer(T, false);
           return false;
        fi;
        if not newvertex in CurrentDigraph[1] then
          Add(CurrentDigraph[1],newvertex);
          Add(CurrentDigraph[2], []);
        fi;
     fi;
   od;
   for vertex in CurrentDigraph[1] do
     for letter in InputAlphabet(T) do
        out := TransducerFunction(T,[letter],vertex[2][1]);
        if IsPrefix(vertex[2][2],out[1]) then
          newvertex := [vertex[1],[out[2],Minus(vertex[2][2],out[1])]];
        elif IsPrefix(out[1],vertex[2][2]) then
          newvertex := [[out[2],[]],[vertex[1][1],Minus(out[1],vertex[2][2])]];
        else
          continue;
        fi;
        if newvertex[1] = newvertex[2] then
           SetIsInjectiveTransducer(T, false);
           return false;
        fi;
        if not newvertex in CurrentDigraph[1] then
          Add(CurrentDigraph[1],newvertex);
          Add(CurrentDigraph[2],[]);
        fi;
        Add(CurrentDigraph[2][Position(CurrentDigraph[1],vertex)],Position(CurrentDigraph[1],newvertex));
     od;
   od;
   D := Digraph(CurrentDigraph[2]);
   if DigraphHasLoops(D) or DigraphGirth(D) < infinity then
     return false;
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
  pos, keys, subtree, check, pos2, prefix, block, state, imagekeys,
  minword, answer;

  if IsDegenerateTransducer(T) then
    ErrorNoReturn("aaa: IsSurjectiveTransducer: usage,\n",
                  "the given transducer must be nondegenerate ");
  fi;

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
        if IsPrefix(minwords[y], x) then
          minwords[y] := StructuralCopy(x);
          break;
        elif IsPrefix(x, minwords[y]) then
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
    for y in prefixcodes[Size(prefixcodes)] do;
      tyx := TransducerFunction(T, y, x);
      if not tyx[2] in usefulstates then
         Add(usefulstates, tyx[2]);
      fi;
    od;
    imagetrees[x] := [];
    for y in prefixcodes[Size(prefixcodes)] do
      tyx := TransducerFunction(T, y, x);
      pos := Position(List(imagetrees[x], y -> y[1]), tyx[1]);
      if not pos = fail then
        AddSet(imagetrees[x][pos][2], tyx[2]);
      else
        AddSet(imagetrees[x], [tyx[1], [tyx[2]]]);
      fi;
    od;
  od;

  finalimagetree := [[[], [1]]];
  currentblocks := [[[], [[[], [1]]]]];
  keys := [[]];
  while (not IsSubset(completeblocks, List(currentblocks, x -> x[2]))) and
      containsantichain(keys, NrOutputSymbols(T)) do
    for block in currentblocks do
      if not block[2] in completeblocks then
        break;
      fi;
    od;
    keys := List(finalimagetree, x -> x[1]);
    for state in finalimagetree[Position(keys, block[1])][2] do
      imagekeys := StructuralCopy(List(imagetrees[state], x -> x[1]));
      for prefix in imagekeys do
        keys := List(finalimagetree, x -> x[1]);
        pos := Position(keys, Concatenation(block[1], prefix));
        if not pos = fail then
          pos2 := Position(imagekeys, prefix);
          Append(finalimagetree[pos][2], imagetrees[state][pos2][2]);
          finalimagetree[pos][2] := Set(finalimagetree[pos][2]);
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
          if IsPrefix(minwords[y], x) then
            minwords[y] := StructuralCopy(x);
          elif IsPrefix(x, minwords[y]) then
            check := true;
          fi;
        od;

        if not check then
          Add(minwords, StructuralCopy(x));
        fi;
        check := false;
      fi;
      minwords := Set(minwords);
    od;
    for minword in minwords do
      subtree := [];
      for x in [1 .. Size(keys)] do
         if IsPrefix(keys[x], minword) then
           Add(subtree, [Minus(keys[x], minword),
               StructuralCopy(finalimagetree[x][2])]);
         fi;
      od;
      Add(currentblocks, [ShallowCopy(minword), StructuralCopy(subtree)]);
    od;
    keys := List(finalimagetree, x -> x[1]);
  od;

  answer := containsantichain(keys, NrOutputSymbols(T));
  SetIsSurjectiveTransducer(T, answer);
  return answer;
end);

InstallMethod(TransducerImageAutomaton, "for a transducer", 
[IsTransducer],
function(T)
  local numberofstates, i, transitiontable, currentnewstate, j, k;
  numberofstates := Size(States(T));
  for i in Concatenation(OutputFunction(T)) do
    if not Size(i)=0 then
      numberofstates := numberofstates + Size(i) - 1;
    fi;
  od;
  transitiontable := List([1 .. Size(OutputAlphabet(T))+1], x -> List([1 .. numberofstates], y-> []));
  currentnewstate := Size(States(T)) + 1;
  for i in States(T) do
    for j in InputAlphabet(T) do
      if Size(OutputFunction(T)[i][j+1]) > 1 then
         Add(transitiontable[OutputFunction(T)[i][j+1][1]+1][i],currentnewstate);
         for k in [2 .. Size(OutputFunction(T)[i][j+1])-1] do
           AddSet(transitiontable[OutputFunction(T)[i][j+1][k]+1][currentnewstate],currentnewstate + 1);
           currentnewstate := currentnewstate + 1;
         od;
           AddSet(transitiontable[OutputFunction(T)[i][j+1][Size(OutputFunction(T)[i][j+1])]+1][currentnewstate],TransducerFunction(T,[j],i)[2]);
           currentnewstate := currentnewstate + 1;
      fi;
      if Size(OutputFunction(T)[i][j+1]) = 1 then 
          AddSet(transitiontable[OutputFunction(T)[i][j+1][1]+1][i],TransducerFunction(T,[j],i)[2]);
      fi;
      if Size(OutputFunction(T)[i][j+1]) < 1 then 
          AddSet(transitiontable[Size(OutputAlphabet(T))+1][i],TransducerFunction(T,[j],i)[2]);
      fi;
    od;
  od;
  return Automaton("epsilon", numberofstates, Concatenation(List(OutputAlphabet(T),x->String(x)[1]),"@"), transitiontable, [1], [1 .. numberofstates]);
end);

InstallMethod(TransducerConstantStateOutputs, "for a transducer",
[IsTransducer],
function(T)
  local constantstates, constantstateoutputs, currentstate, state,
  automatonhasbeenbuilt, stateisnotconstant, tuple, out1, out2, A, MinA,
  newstatenr, badstates, TMat, path, pos, root, circuit, next, Adata;
  constantstates := [];
  constantstateoutputs := [];
  automatonhasbeenbuilt := false;
  for state in States(T) do
    stateisnotconstant := false;
    for tuple in UnorderedTuples(InputAlphabet(T),2) do
       if not tuple[1] = tuple[2] then
         out1 := TransducerFunction(T,[tuple[1]],state);
         out2 := TransducerFunction(T,[tuple[2]],state);
         if not (IsPrefix(out1[1],out2[1]) or IsPrefix(out2[1],out1[1])) then
           stateisnotconstant:= true;
           break;
         fi;
       fi;
    od;
    if stateisnotconstant then
      continue;
    fi;
    if not automatonhasbeenbuilt then
      A := TransducerImageAutomaton(T);
      Adata := [NumberStatesOfAutomaton(A), AlphabetOfAutomaton(A), TransitionMatrixOfAutomaton(A)];
      automatonhasbeenbuilt := true;
    fi;
    MinA := MinimalAutomaton(Automaton("epsilon",Adata[1],Adata[2],Adata[3],[state],[1 .. Adata[1]]));
    newstatenr := NumberStatesOfAutomaton(MinA);
    badstates := Filtered([1 .. newstatenr], x-> not x in FinalStatesOfAutomaton(MinA));
    if not Size(badstates) = 1 then
      continue;
    fi;
    TMat := TransitionMatrixOfAutomaton(MinA);
    currentstate := InitialStatesOfAutomaton(MinA)[1];
    path := [];
    pos := fail;
    while pos = fail do
      next := Filtered([1 .. Size(TMat)], x-> TMat[x][currentstate]<>badstates[1]);
      if not Size(next) = 1 then
        stateisnotconstant := true;
        break;
      fi;
      Add(path,[currentstate,next[1]]);
      currentstate := TMat[next[1]][currentstate];
      pos := Position(List(path,x->x[1]),currentstate);
    od;
    if not Size(path) = newstatenr -1 then
      continue;
    fi;
    if stateisnotconstant then
      continue;
    fi;
    Add(constantstates,state);
    root := Concatenation(List(path{[1 .. pos-1]}, x->String(x[2]-1)));
    circuit := Concatenation(List(path{[pos .. Size(path)]}, x-> String(x[2]-1)));
    Add(constantstateoutputs, Concatenation(root,"(",circuit,")*"));
  od;
  return [constantstates,constantstateoutputs];
end);


InstallMethod(IsDegenerateTransducer, "for a transducer",
[IsTransducer],
function(T)
	local Out, D, OutNeigh;
	Out := States(T);
	OutNeigh := function(s)
		local Output, i;
		Output := [];
		for i in InputAlphabet(T) do
			if TransducerFunction(T,[i],s)[1] = [] then
				Add(Output,TransducerFunction(T,[i],s)[2]);
			fi;
		od;
		return Output;
	end;
	Apply(Out, OutNeigh);
	D := Digraph(Out);
	return DigraphHasLoops(D) or DigraphGirth(D) < infinity;
end);

QuotientTransducer := function(T,EqR)
  local Classes, class, i, Pi, Lambda, initialclass;
  Classes:=ShallowCopy(EquivalenceRelationPartition(EquivalenceRelationByPairs(Domain(States(T)),EqR)));

  class := function(q)
        local j;
        for j in [1 .. Length(Classes)] do
                if q in Classes[j] then
                        return j;
                fi;
        od;
	return fail;
  end;
  for i in States(T) do
	if class(i)=fail then
		Add(Classes,[i]);
	fi;
  od;
  for i in Classes do
	if 1 in i then
          initialclass := i;
        fi;
  od;
  Remove(Classes,Position(Classes,initialclass));
  Classes := Concatenation([initialclass],Classes);
  Pi:= ShallowCopy(Classes);
  Lambda := ShallowCopy(Classes);
  Apply(Pi,x -> TransitionFunction(T)[x[1]]);
  Apply(Lambda, x-> OutputFunction(T)[x[1]]);
  for i in Pi do
        Apply(i,class);
  od;
  return Transducer(Length(InputAlphabet(T)),Length(OutputAlphabet(T)),Pi,Lambda
);
end;

InstallMethod(CombineEquivalentStates, "for a transducer",
 [IsTransducer],
function(T)
  local  x, EqRelation, i, tuple, NewTuple, b, flag;
  EqRelation := Filtered(UnorderedTuples(States(T), 2),
                       x -> OutputFunction(T)[x[1]] = OutputFunction(T)[x[2]]);
  flag := true;
  while flag do
    flag := false;
    for tuple in EqRelation do
      for i in InputAlphabet(T) do
        NewTuple := [TransducerFunction(T, [i], tuple[1])[2],
                     TransducerFunction(T, [i], tuple[2])[2]];
        Sort(NewTuple);
        if not NewTuple in EqRelation then
          Remove(EqRelation,Position(EqRelation,tuple));
          flag := true;
          break;
        fi;
      od;
    od;
  od;
  return QuotientTransducer(T,EqRelation);
end);

InstallMethod(MinimalTransducer, "for a transducer",
[IsTransducer],
function(T)
  local output;
   if IsDegenerateTransducer(T) then
    ErrorNoReturn("aaa: MinimalTransducer: usage,\n",
                  "the given transducer must be nondegenerate ");
  fi;
  output := RemoveInaccessibleStates(T);
  output := RemoveStatesWithIncompleteResponse(output);
  output := RemoveInaccessibleStates(output);
  output := CombineEquivalentStates(output);
  SetIsMinimalTransducer(output, true);
  return output;
end);

InstallMethod(IsomorphicInitialTransducers, "for a pair of transducer",
[IsTransducer, IsTransducer],
function(T1,T2)
  local D1, D2, perm, Dtemp, i;
  if not States(T1) = States(T2) then
    return false;
  fi;
  if not InputAlphabet(T1)=InputAlphabet(T2) then
    return false;
  fi;
  if not OutputAlphabet(T1)= OutputAlphabet(T2) then
    return false;
  fi;
  D1 := List([1 .. Size(States(T1))], x -> [OutputFunction(T1)[x], TransitionFunction(T1)[x]]);
  D2 := List([1 .. Size(States(T2))], x -> [OutputFunction(T2)[x], TransitionFunction(T2)[x]]);
  for perm in SymmetricGroup(Size(States(T1))) do
     if 1^perm = 1 then
       Dtemp := StructuralCopy(List([1 .. Size(States(T1))],x-> D1[x^perm]));
       for i in [1 .. Size(Dtemp)] do
         Apply(Dtemp[i][2], x -> x ^ (perm ^ -1));
       od;
       if Dtemp = D2 then
         return true;
       fi;
     fi;
  od;
  return false;
end);

InstallMethod(OmegaEquivalentTransducers, "for a pair of transducers",
[IsTransducer,IsTransducer],
function(T1, T2)
  local M1, M2;
  M1:= MinimalTransducer(T1);
  M2:= MinimalTransducer(T2);
  return IsomorphicInitialTransducers(M1, M2);
end);

InstallMethod(\=, "for two transducers",
[IsTransducer, IsTransducer], OmegaEquivalentTransducers);

InstallMethod(IsBijectiveTransducer, "for a transducer",
[IsTransducer], T -> IsInjectiveTransducer(T) and IsSurjectiveTransducer(T));

InstallMethod(IsMinimalTransducer, "for a transducer",
[IsTransducer],
function(T)
  return IsomorphicInitialTransducers(T, MinimalTransducer(T));
end);

InstallMethod(IsSynchronousTransducer, "for a transducer",
[IsTransducer], T -> ForAll(OutputFunction(T), x-> ForAll(x, y -> Size(y)=1)));

InstallMethod(TransducerOrder, "for a transducer",
[IsTransducer],
function(T)
  local p;
  if not IsBijectiveTransducer(T) then
    ErrorNoReturn("aaa: TransducerOrder: usage,\n",
                  "the given transducer must be bijective");
  fi;
  p := 1;
  while not T^p = T^0 do
    p := p + 1;
  od;
  return p;
end);

InstallMethod(TransducerSynchronizingLength, "for a transducer", [IsTransducer],
function(T)
	local count, CopyT, TempT, flag;
	flag := true;
        CopyT := CopyTransducerWithInitialState(T,1);
	count := -1;
	while flag do
		count := count + 1;
		TempT := QuotientTransducer(CopyT,Filtered(Cartesian(States(CopyT), States(CopyT)),x-> TransitionFunction(CopyT)[x[1]]=TransitionFunction(CopyT)[x[2]]));
		flag := (States(CopyT) <> States(TempT));
		CopyT := TempT;
	od;
	if States(CopyT) = [1] then 
		return count;
	fi;
	return infinity;
end);

InstallMethod(IsSynchronizingTransducer, "for a transducer",
[IsTransducer], T -> TransducerSynchronizingLength(T)<infinity);

InstallMethod(IsBisynchronizingTransducer, "for a transducer",
[IsTransducer],
function(T)
  return IsBijectiveTransducer(T) and IsSynchronizingTransducer(T) and IsSynchronizingTransducer(InverseTransducer(T));
end);

InstallMethod(IsLipschitzTransducer, "for a transducer",
[IsTransducer],
function(T)
  local s, statepath, letterpath, currentstate, nonconstantstates;
  nonconstantstates := States(T);
  SubtractSet(nonconstantstates, TransducerConstantStateOutputs(T)[1]);
  for s in nonconstantstates do;
    statepath := [s];
    letterpath := [0];
    currentstate :=  TransducerFunction(T, [0], s)[2];
    while statepath <> [] do
      if currentstate = s and
        Size(TransducerFunction(T, letterpath, s)[1]) < Size(letterpath) then
        return false;
      fi;
      if not currentstate in statepath then
        Add(letterpath, 0);
        Add(statepath, currentstate);
      else
        letterpath[Size(letterpath)] := letterpath[Size(letterpath)] + 1;
        while letterpath <> [] and
              letterpath[Size(letterpath)] = NrInputSymbols(T) do;
          Remove(letterpath);
          Remove(statepath);
          if letterpath <> [] then
            letterpath[Size(letterpath)] := letterpath[Size(letterpath)] + 1;
          fi;
        od;
      fi;
      currentstate := TransducerFunction(T, letterpath, s)[2];
    od;
  od;
  return true;
end);

InstallMethod(IsomorphicTransducers, "for a pair of transducers",
[IsTransducer,IsTransducer],
function(T1,T2)
  return ForAny(States(T2), x -> IsomorphicInitialTransducers(T1,
                                 CopyTransducerWithInitialState(T2,x)));
end);
