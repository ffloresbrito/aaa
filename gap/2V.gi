InstallMethod(In2V, "for a dense list",
[IsDenseList],
function(L)
  local domprefixes, imgprefixes, isC2partition;
  if not ForAll(L, x-> Size(x) = 2) then
    return false;
  fi;
  if not ForAll(L, x-> ForAll(x, y -> Size(y) = 2)) then
    return false;
  fi;
  if not ForAll(L, x-> ForAll(x, y -> ForAll(y, z-> ForAll(z, a-> a in [0, 1])))) then
    return false;
  fi;

  domprefixes := List(L, x-> x[1]);
  imgprefixes := List(L, x-> x[2]);

  isC2partition := function(prefixes)
    local word, wordrpartition, lprefixes, maxwords;
    lprefixes := List(prefixes, x-> x[1]);
    maxwords := MaximalWords(lprefixes);
    if not IsCompleteAntichain(maxwords, 2, 2) then
      return false;
    fi;
    for word in maxwords do
      wordrpartition := List(Filtered(prefixes, x-> IsPrefix(word, x[1])),
                             x-> x[2]);
      if not IsCompleteAntichain(wordrpartition, 2, 2) then
        return false;
      fi;
    od;
    return true;
  end;
  return isC2partition(domprefixes) and isC2partition(imgprefixes);
end);

InstallMethod(SynchronizingCores, "for a transducer",
[IsTransducer],
function(T)
  local state, n, zeroloopstates, output, word;
  zeroloopstates := Filtered([1 .. NrStates(T)], x -> TransitionFunction(T)[x][1] = x);
  output := List(zeroloopstates, x -> [x]);
  n := NrInputSymbols(T);
  for state in [1 .. Size(output)] do
    word := [0];
    while word <> [] do
      if not TransducerFunction(T, word, output[state][1])[2] in output[state] then
         Add(output[state], TransducerFunction(T, word, output[state][1])[2]);
         Add(word, 0);
      elif word[Size(word)] < n - 1 then
         word[Size(word)] := word[Size(word)] + 1;
      else
         Remove(word);
         if not word = [] then
           word[Size(word)] := word[Size(word)] + 1;
         fi;
      fi;
    od;
  od;
  return output;
end);

InstallMethod(4ShiftDeBruijinTransducer, "for an integer",
[IsInt],
function(k)
    local output, relabel;
    relabel := function(l)
      if IsDenseList(l) then
        return 2*l[1] + l[2];
      else
        return [Int(l/2), l mod 2];
      fi;
    end;

    if k = 0 then
      output := IdentityTransducer(4);
    fi;
    if k > 0 then
      output := BlockCodeTransducer(4, k,
             w -> [relabel([relabel(w[Size(w)])[1], relabel(w[1])[2]])]);
    fi;
    if k < 0 then
      output := BlockCodeTransducer(4, -k,
             w -> [relabel([relabel(w[1])[1], relabel(w[Size(w)])[2]])]);
    fi;
    return TransducerCore(MinimalTransducer(output));
end);

InstallMethod(2VCoreData, "for a transducer",
[IsTransducer],
function(T)
  local flag, base, M, S, i, core, word, coretrans, output, reachwords;
  if not NrInputSymbols(T) = 4 and NrOutputSymbols(T) = 4 then
    return false;
  fi;
  M := MinimalTransducer(T);
  S := SynchronizingCores(M);
  if M = IdentityTransducer(4) then
    return [[0, [[]]]];
  fi;
  word := [0];
  reachwords := List(S, x -> []);
  while word <> [] do
    if Size(word) > NrStates(M) + 1 then
      return fail;
    fi;
    flag := false;
    for core in S do
      if TransducerFunction(M, word, 1)[2] in core then
        Add(reachwords[Position(S, core)], ShallowCopy(word));
        flag := true;
      fi;
    od;
    if not flag then
       Add(word, 0);
    elif word[Size(word)] < 3 then
       word[Size(word)] := word[Size(word)] + 1;
    else
       while not word = [] and word[Size(word)] = 3 do
         Remove(word);
       od;
       if not word = [] then
         word[Size(word)] := word[Size(word)] + 1;
       fi;
    fi;
  od;
  output := [];
  for core in S do
    base := Log(Size(core), 2);
    if not Size(core) = 2^base then
      return false;
    fi;
    coretrans := RemoveInaccessibleStates(CopyTransducerWithInitialState(M, core[1]));
    if not IsomorphicTransducers(coretrans,
                                 4ShiftDeBruijinTransducer(base)) then
      if not IsomorphicTransducers(coretrans,
                                 4ShiftDeBruijinTransducer(-base)) then
        return fail;
      else
        Add(output, -base);
      fi;
    else
      Add(output, base);
    fi;
  od;
  return List([1 .. Size(S)], x -> [output[x], reachwords[x]]);
end);

InstallMethod(In2V, "for a Transducer",
[IsTransducer], T -> not 2VCoreData(T) = fail);

InstallMethod(2VtoR4, "for a dense list",
[IsDenseList],
function(L)
  local domprefixes, imgprefixes, n, beginingstates, Pi, Lambda,
        relabel, relabelword, applyelement, statesno, usedshiftingamounts,
        usedshiftings, state, y, result, newpart, partstart, newtransitions,
        shifting;
  domprefixes := List(L, x-> x[1]);
  imgprefixes := List(L, x-> x[2]);
  if not In2V(L) then
    return fail;
  fi;
  relabel := function(l)
    if IsDenseList(l) then
      return 2*l[1] + l[2];
    else
      return [Int(l/2), l mod 2];
    fi;
  end;
  relabelword := function(w)
    local output, letter;
    if IsDenseList(w[1]) then
       return List([1 .. Size(w[1])], x -> relabel([w[1][x], w[2][x]]));
    else
       output := [[], []];
       for letter in w do
         Add(output[1], relabel(letter)[1]);
         Add(output[2], relabel(letter)[2]);
       od;
       return output;
    fi;
  end;
  applyelement := function(w)
    local w2, p;
    w2 := relabelword(w);
    p := 1;
    while true do
      if IsPrefix(w2[1], domprefixes[p][1]) and
         IsPrefix(w2[2], domprefixes[p][2]) then
        w2[1] := Concatenation(imgprefixes[p][1], Minus(w2[1], domprefixes[p][1]));
        w2[2] := Concatenation(imgprefixes[p][2], Minus(w2[2], domprefixes[p][2]));
        if Size(w2[1]) <> Size(w2[2]) then
          w2[1] := w2[1]{[1 .. Minimum(Size(w2[1]), Size(w2[2]))]};
          w2[2] := w2[2]{[1 .. Minimum(Size(w2[1]), Size(w2[2]))]};
        fi;
        return [relabelword(w2), Size(domprefixes[p][1]) + Size(imgprefixes[p][2])
                               - Size(imgprefixes[p][1]) - Size(domprefixes[p][2])];
      fi;
      p := p + 1;
    od;
  end;

  n := Maximum(List(L, x -> Size(x[1][1]) + Size(x[2][2]) - Size(x[2][1]) - Size(x[1][2])));
  n := Maximum(n,  Maximum(List(Concatenation(domprefixes), x-> Size(x)))) + 1;
  beginingstates := Concatenation(List([0 .. n], x -> Tuples([0, 1, 2, 3], x)));
  Pi := [];
  Lambda := [];

  statesno := Size(beginingstates);
  usedshiftingamounts := [];
  usedshiftings := [];
  for state in beginingstates do
    if Size(state) < n then
       Add(Lambda, List([0 .. 3], y -> []));
       Add(Pi, List([0 .. 3], y -> Position(beginingstates, Concatenation(state, [y]))));
    fi;
    if Size(state) = n then
      Add(Lambda, []);
      Add(Pi, []);
      for y in [0 .. 3] do
        result := applyelement(Concatenation(state, [y]));
        Add(Lambda[Size(Lambda)], result[1]);
        if not result[2] in usedshiftingamounts then
          Add(usedshiftingamounts, result[2]);
          newpart := 4ShiftDeBruijinTransducer(result[2]);
          Add(usedshiftings, [statesno, newpart]);
          partstart := statesno;
          statesno := statesno + NrStates(newpart);
        else
          partstart := usedshiftings[Position(usedshiftingamounts, result[2])][1];
          newpart := usedshiftings[Position(usedshiftingamounts, result[2])][2];
        fi;
        Add(Pi[Size(Pi)], partstart + TransducerFunction(newpart, Concatenation(state, [y]), 1)[2]);
      od;
    fi;
  od;

  for shifting in usedshiftings do
    newtransitions := StructuralCopy(TransitionFunction(shifting[2]));
    for state in [1 .. Size(newtransitions)] do
      Apply(newtransitions[state], x -> x + shifting[1]);
    od;
    Append(Pi, newtransitions);
    Append(Lambda, OutputFunction(shifting[2]));

  od;
  return Transducer(4, 4, Pi, Lambda);
end);

InstallMethod(R4to2V, "for a transducer",
[IsTransducer],
function(trans)
  local T, relabel, relabelword, output, core, word, tuple;
  T := MinimalTransducer(trans);
  if not In2V(T) then
    return fail;
  fi;
  relabel := function(l)
    if IsDenseList(l) then
      return 2*l[1] + l[2];
    else
      return [Int(l/2), l mod 2];
    fi;
  end;
  relabelword := function(w)
    local output, letter;
    if IsDenseList(w[1]) then
       return List([1 .. Size(w[1])], x -> relabel([w[1][x], w[2][x]]));
    else
       output := [[], []];
       for letter in w do
         Add(output[1], relabel(letter)[1]);
         Add(output[2], relabel(letter)[2]);
       od;
       return output;
    fi;
  end;
  output := [];
  for core in 2VCoreData(T) do
    for word in core[2] do
      for tuple in Tuples([0, 1.. 3], AbsoluteValue(core[1])) do
         Add(output, [relabelword(Concatenation(word, tuple)),
                      relabelword(TransducerFunction(T, Concatenation(word, tuple), 1)[1])]);
         if core[1] >= 0 then
         Append(output[Size(output)][2][2], relabelword(tuple)[2]);
         else
           Append(output[Size(output)][2][1], relabelword(tuple)[1]);
         fi;
      od;
    od;
  od;
  return Minimise2V(output);
end);

InstallMethod(Minimise2V, "for a dense list",
[IsDenseList],
function(input)
  local i, j, flag, L, pair;
  L := StructuralCopy(input);
  if not In2V(L) then
    return fail;
  fi;

  for j in [1, 2] do
    flag := true;
    while flag do
      flag := false;
      for i in [1 .. Size(L)] do
        if not L[i][1][j] = [] and not L[i][2][j] = [] and L[i][1][j][Size(L[i][1][j])] = L[i][2][j][Size(L[i][2][j])] then
          pair := StructuralCopy(L[i]);
          pair[1][j][Size(pair[1][j])] := 1 - pair[1][j][Size(pair[1][j])];
          pair[2][j][Size(pair[2][j])] := 1 - pair[2][j][Size(pair[2][j])];
          if pair in L then
            Remove(L, i);
            Remove(L, Position(L, pair));
            Remove(pair[1][j]);
            Remove(pair[2][j]);
            Add(L, pair);
            flag := true;
            break;
          fi;
        fi;
      od;
    od;
  od;
  return L;
end);
