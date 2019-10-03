#############################################################################
##
#W  transducer.gi
#Y  Copyright (C) 2017                                 Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains methods that relate to the objects in this package,
# including appropiate ViewObj functions.

InstallMethod(ViewObj, "for a transducer",
[IsTransducer],
function(T)
  local state, sym1, sym2;
  if T!.States = 1 then
    state := "state";
  else
    state := "states";
  fi;
  if T!.InputAlphabet = 1 then
    sym1 := "symbol";
  else
    sym1 := "symbols";
  fi;
  if T!.OutputAlphabet = 1 then
    sym2 := "symbol";
  else
    sym2 := "symbols";
  fi;

  Print("<transducer with input alphabet on ", T!.InputAlphabet, " ", sym1,
        ", output alphabet on ", T!.OutputAlphabet, " ", sym2, ", and ",
        T!.States, " ", state, ".>");
end);

InstallMethod(Transducer, "for two positive integers and two dense lists",
[IsPosInt, IsPosInt, IsDenseList, IsDenseList],
function(inalph, outalph, tranfunc, outfunc)
  local transducer, T;

  if IsEmpty(tranfunc) or IsEmpty(outfunc) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the third and fourth arguments must be non-empty,");
  elif Size(tranfunc) <> Size(outfunc) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the size of the third and fourth arguments must coincide,");
  elif ForAny(tranfunc, x -> not IsDenseList(x) or
              ForAny(x, y -> not y in [1 .. Size(tranfunc)])) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the third argument contains invalid states,");
  elif ForAny(outfunc, x -> not IsDenseList(x) or
              ForAny(x, y -> not IsDenseList(y) or
                     ForAny(y, z -> not z in [0 .. outalph - 1]))) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the fourth argument contains invalid output,");
  elif ForAny(tranfunc, x -> Size(x) <> inalph) or
       ForAny(outfunc, x -> Size(x) <> inalph) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the size of the elements of the third or fourth argument ",
                  "does not coincide\nwith the first argument,");
  fi;

  transducer := function(input, state)
                  local ialph, oalph, tfunc, ofunc, output, n;
                  ialph := [0 .. inalph - 1];
                  oalph := [0 .. outalph - 1];
                  tfunc := tranfunc;
                  ofunc := outfunc;
                  output := [];

                  if not IsDenseList(input) then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the first argument must be a dense list,");
                  elif not IsPosInt(state) then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the second argument must be a positive ",
                                  "integer,");
                  elif state > Size(tfunc) then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the second argument must not be greater ",
                                  "than ", Size(tfunc), ",");
                  elif ForAny(input, x -> not x in ialph) then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the first argument must be a list of ",
                                  "integers in ", ialph, ",");
                  fi;

                  for n in input do
                    Append(output, ofunc[state][n + 1]);
                    state := tfunc[state][n + 1];
                  od;

                  return [output, state];
                end;

  T := Objectify(NewType(NewFamily("Transducer"), IsTransducer and
                 IsAttributeStoringRep), rec(InputAlphabet := inalph,
                                             OutputAlphabet := outalph,
                                             States := Size(tranfunc),
                                             TransitionFunction := tranfunc,
                                             OutputFunction := outfunc,
                                             TransducerFunction := transducer));

  return T;
end);

InstallMethod(TransducerFunction, "for a transducer, a dense list and a posint",
[IsTransducerOrRTransducer, IsDenseList, IsPosInt],
function(T, input, state)
  return T!.TransducerFunction(input, state);
end);

InstallMethod(TransitionFunction, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return T!.TransitionFunction;
end);

InstallMethod(OutputFunction, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return T!.OutputFunction;
end);

InstallMethod(States, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return [1 .. T!.States];
end);

InstallMethod(NrStates, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return T!.States;
end);

InstallMethod(InputAlphabet, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return [0 .. T!.InputAlphabet - 1];
end);

InstallMethod(OutputAlphabet, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return [0 .. T!.OutputAlphabet - 1];
end);

InstallMethod(NrOutputSymbols, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return T!.OutputAlphabet;
end);

InstallMethod(NrInputSymbols, "for a transducer",
[IsTransducerOrRTransducer],
function(T)
  return T!.InputAlphabet;
end);

InstallMethod(IdentityTransducer, "returns identity transducer on given alphabet size",
[IsPosInt],
function(AlphSize)
  return Transducer(AlphSize,AlphSize,[List([1 .. AlphSize], x -> 1)],
                    [List([0 .. AlphSize - 1], x-> [x])]);
end);

InstallMethod(AlphabetChangeTransducer, "gives transducer for changing alphabet",
[IsPosInt, IsPosInt],
function(n,m)
  local 2tok;
  2tok := function(k)
    local i, outputfunction, transitionfunction;
    if k = 2 then
      return IdentityTransducer(2);
    fi;
    transitionfunction := List([2 .. k], x-> [1, x]);
    transitionfunction[k - 1][2] := 1;
    outputfunction := List([0 .. k - 2], x -> [[x],[]]);
    outputfunction[k-1][2] := [k-1];
    return Transducer(2, k, transitionfunction, outputfunction);
  end;
  return InverseTransducer(2tok(n)) * 2tok(m);
end);

InstallMethod(RandomTransducer,"gives random transducers",
[IsPosInt,IsPosInt],
function(AlphSize,NrStates)
	local i, j, k, OutputLength, Pi, Lambda;
	Pi:= [];
	Lambda:= [];
	for i in [1 .. NrStates] do
	   Add(Pi,[]);
	   Add(Lambda,[]);
	   for j in [1 .. AlphSize] do
		Add(Pi[i],Random([1 .. NrStates]));
		OutputLength:= 0;
		if not Random([1,2,3,4]) = 1 then
			OutputLength := OutputLength + 1;
			while Random([1,2]) = 1 do
				OutputLength := OutputLength + 1;
			od;
		fi;
		Add(Lambda[i],[]);
		for k in [1 .. OutputLength] do
			Add(Lambda[i][j],Random([0 .. AlphSize - 1]));
		od;
	   od;
	od;
	return Transducer(AlphSize,AlphSize,Pi,Lambda);
end);

InstallMethod(TransducerByNumber,
 "returns the transducer with given number of states and maximum output size that corresponds to given number",
[IsPosInt, IsPosInt, IsPosInt],
function(StateNr, OutNr, TNr)
  local NrWords, TransNr, i, DdigitNbaseM, Pi, Lambda, Expansion;
  TransNr := TNr - 1;
  DdigitNbaseM := function(d,n,m)
     return List([0 .. (d-1)],x-> Int(RemInt(n,m^(x+1))/(m^x)));
  end;
  NrWords := 2^(OutNr + 1)-1;
  Expansion :=  DdigitNbaseM(StateNr * 2, TransNr, StateNr * NrWords);
  Pi := List([1 .. StateNr], x-> [Int(Expansion[2*x -1 ]/NrWords) + 1,Int(Expansion[2*x]/NrWords) + 1]);
  Lambda := List([1 .. StateNr], x-> [RemInt(Expansion[2*x - 1],NrWords),RemInt(Expansion[2*x],NrWords)]);
  for i in [1 .. StateNr] do
    Apply(Lambda[i], x-> DdigitNbaseM(LogInt(x+1,2),x+1-2^LogInt(x+1,2),2));
  od;
  return Transducer(2,2, Pi, Lambda);
end);

InstallMethod(NumberByTransducer, "given the number of states and max output length this inverts the function TransducerByNumber",
[IsPosInt, IsPosInt, IsTransducer],
function(StateNr, OutNr, T)
  local output, NrWords, L, j, k, n, base;
  NrWords := 2^(OutNr + 1)-1;
  output := 1;
  base := StateNr*NrWords;
    for n in [0 .. (StateNr * 2)-1] do
      j := Int(n/2)+1;
      k := RemInt(n,2)+1;
      L:= Size(OutputFunction(T)[j][k]);
      output := output + (2^L-1)*(base^n);
      output := output + Sum(List([1 .. L],x-> OutputFunction(T)[j][k][x]*(2^(x-1))))*(base^n);
      output := output + (TransitionFunction(T)[j][k]-1)*NrWords*(base^n);
    od;
  return output;
end);

InstallMethod(NrTransducers, "returns the number of transducers (with alphabet size 2) with given number of states and maximum output length",
[IsPosInt,IsPosInt],
function(StateNr, OutNr)
  return (StateNr*(2^(OutNr + 1) - 1))^(StateNr * 2);
end);

InstallMethod(DeBruijnTransducer, "returns a transducer",
[IsPosInt, IsPosInt],
function(Alph, WordLen)
  local StateToLabel, LabelToState, state, letter, target, Pi, Lambda;
  StateToLabel := function(n)
     return List([0 .. (WordLen - 1)], x -> Int(RemInt(n - 1, Alph ^ (x + 1))
                                                / (Alph ^ x)));
  end;
  LabelToState := function(l)
    return 1 + Sum(List([0 .. WordLen - 1], y -> l[y + 1] * (Alph ^ y)));
  end;
  Pi := [];
  for state in [1 .. Alph ^ WordLen] do
    Add(Pi, []);
    for letter in [0 .. Alph - 1] do
      target := Concatenation(StateToLabel(state){[2 .. WordLen]}, [letter]);
      Add(Pi[state], LabelToState(target));
    od;
  od;
  Lambda := ListWithIdenticalEntries(Alph ^ WordLen,
                                     List([0 .. Alph - 1], x -> [x]));
  return Transducer(Alph, Alph, Pi, Lambda);
end);

InstallMethod(BlockCodeTransducer, "for a positive integer and a block code function", [IsPosInt, IsInt, IsFunction],
function(Alph, WordLen, f)
  local StateToLabel, LabelToState, state, letter, target, Pi, Lambda;
  StateToLabel := function(n)
     return List([0 .. (WordLen - 1)], x -> Int(RemInt(n - 1, Alph ^ (x + 1))
                                                / (Alph ^ x)));
  end;
  LabelToState := function(l)
    return 1 + Sum(List([0 .. WordLen - 1], y -> l[y + 1] * (Alph ^ y)));
  end;
  Pi := [];
  Lambda := [];
  for state in [1 .. Alph ^ WordLen] do
    Add(Pi, []);
    Add(Lambda, []);
    for letter in [0 .. Alph - 1] do
      target := Concatenation(StateToLabel(state){[2 .. WordLen]}, [letter]);
      Add(Pi[state], LabelToState(target));
      Add(Lambda[state], f(Concatenation(StateToLabel(state), [letter])));
    od;
  od;
  return Transducer(Alph, Alph, Pi, Lambda);
end);

InstallMethod(ResizeZeroStringTransducer, "for three two positive integers", [IsPosInt, IsPosInt, IsPosInt],
function(AlphSize, i, j)
  local itoj, count, B;

  itoj := function(word)
    count := 0;
    if ForAll(word, x -> x = 0) then
      return [0];
    elif word[Size(word)] <> 0 then
      while count < Size(word) - 1 do
        if word[Size(word)-count - 1] = 0 then
          count := count + 1;
        else
          break;
        fi;
      od;
      if count in [i, j] and word[Size(word)] = 1 then
        count := i + j - count;
      fi;
      return Concatenation(ListWithIdenticalEntries(count, 0),
                           [word[Size(word)]]);
    else
      return [];
    fi;
  end;

  B := BlockCodeTransducer(AlphSize, Maximum(i, j) + 1, itoj);

  return TransducerCore(MinimalTransducer(B));
end);

InstallMethod(ResizeZeroStringTransducer, "for three two positive integers", [IsPosInt, IsPosInt, IsPosInt],
function(AlphSize, i, j)
  local pi, lambda, itoj, count, B;

  if AlphSize = 2 then
    if i = j then
      return L2Examples(1);
    fi;
    pi := [[1, 2], [3, 2]];
    lambda := [[[0], [1]], [[0], [1]]];
    for count in [1 .. Maximum(i,j) - 1] do
      Add(pi, [count + 3, 2]);
      Add(lambda, [[], Concatenation(ListWithIdenticalEntries(count - 1, 0), [1])]);
    od;
    Add(pi, [1, 2]);
    Add(lambda, [ListWithIdenticalEntries(Maximum(i, j), 0), 
                 Concatenation(ListWithIdenticalEntries(Minimum(i, j) - 1, 0),
                               [1])]);
    lambda[2 + Minimum(i, j)][2] :=
                  Concatenation(ListWithIdenticalEntries(Maximum(i, j) - 1, 0), [1]);
    return Transducer(2, 2, pi, lambda);
  fi;

  itoj := function(word)
    count := 0;
    if ForAll(word, x -> x = 0) then
      return [0];
    elif word[Size(word)] <> 0 then
      while count < Size(word) - 1 do
        if word[Size(word)-count - 1] = 0 then
          count := count + 1;
        else
          break;
        fi;
      od;
      if count in [i, j] and word[Size(word)] = 1 then
        count := i + j - count;
      fi;
      return Concatenation(ListWithIdenticalEntries(count, 0),
                           [word[Size(word)]]);
    else
      return [];
    fi;
  end;

  B := BlockCodeTransducer(AlphSize, Maximum(i, j) + 1, itoj);

  return TransducerCore(MinimalTransducer(B));
end);

InstallMethod(PrimeWordSwapTransducer, "for a positive integer and two dense lists", [IsPosInt, IsDenseList, IsDenseList],
function(alphsize, v, w)
  local word1, word2, pair, letterswap, B, len, flag, newword, i;
  len := Size(w);
  if not len = Size(v) then
    return fail;
  fi;
 if not (IsPrimeWord(v) and IsPrimeWord(w)) then
    return fail;
  fi;
  flag := false;
  for pair in Tuples([1 .. len], 2) do
    word1 := Concatenation(v{[pair[1] .. len]},v{[1 .. pair[1] - 1]});
    word2 := Concatenation(w{[pair[2] .. len]},v{[1 .. pair[2] - 1]});
    if word1 = word2 then
      return IdentityTransducer(alphsize);
    fi;
    if word1{[2 .. len]} = word2{[2 .. len]} then
      break;
    fi;
  od;
 
  letterswap := function(word)
    if word = Concatenation(word1, word1){[2 .. 2 * len]} then
      return [word2[1]];
    fi;
    if word = Concatenation(word2, word2){[2 .. 2 * len]} then
      return [word1[1]];
    fi;
    return [word[len]];
  end;

  B := BlockCodeTransducer(alphsize, 2* len -2, letterswap);
  SetInLn(B, true);
  return B;
end);

InstallMethod(Shift, "for a positive integer",
[IsPosInt],
function(n)
  return BlockCodeTransducer(n, 1, x->[x[1]]);
end);

InstallMethod(RandomBlockCodeTransducer, "for two positive integers",
[IsPosInt, IsPosInt],
function(n, k)
  local attempts, output;
  output := fail;
  attempts := 0;
  while output = fail do
    output := RandomBlockCodeTransducerAttempt(n, k);
    attempts := attempts + 1;
    Print("\rAttempts: ", attempts);
  od;
  return output;
end);

ln := function(n, k, m)
  local output, perm, necklaceedges, outslist, outs, activeedges, edge, edges,
        fixededges, changeableedges, necklaces, a, usedwords, newword, i, f,
        state, j, states, l, sstates, wordtoloopedges, wordtoloopedge, pword,
        length, goneback;
  outslist := [];
  outs := List([1 .. n^(k + 1)], x -> 0);
  wordtoloopedge := function(word)
    newword := [word[1]];
    while Size(newword) < k + 1 do
      newword := Concatenation(word, newword);
    od;
    newword := newword{[Size(newword) - k .. Size(newword)]};
    return 1 + Sum(List([0 .. Size(newword) - 1],
                        x -> newword[Size(newword) - x] * n ^ x));
  end;
  wordtoloopedges := function(word)
    states := [];
    for l in [1 .. Size(word)] do
      Add(states, wordtoloopedge(Concatenation(word{[l .. Size(word)]},
                                               word{[1 .. l - 1]})));
    od;
    return states;
  end;

  necklaces := List([1 .. m], x-> PrimeNecklaces(n, x));
  necklaceedges := List(necklaces, x-> List(x, y-> wordtoloopedges(y)));

  fixededges := [];
  length := 1;
  usedwords := [];
  a := 1;
  changeableedges := [];
  while changeableedges <> [1] do
    while a <= Size(necklaces[length]) do
      goneback := false;
      edges := necklaceedges[length][a];
      changeableedges := Set(ShallowCopy(edges));
      activeedges := Concatenation(fixededges);
      SubtractSet(changeableedges, activeedges);
      activeedges := Union(changeableedges, activeedges);
      for edge in [1 .. Size(outs)] do
        if not edge in activeedges then
          outs[edge] := 0;
        fi;
      od;
      while not IsPrimeWord(outs{edges}) or
            ForAny(usedwords, x -> ShiftEquivalent(x, outs{edges})) do
        while ForAll(changeableedges, x-> outs[x] = n - 1) do
          changeableedges := fixededges[Size(fixededges)];
          while changeableedges = [] do
            changeableedges := Remove(fixededges);
            Remove(usedwords);
            if a > 1 then
              a := a - 1;
            else
              length := length - 1;
              if length > 0 then
                a := Size(necklaces[length]);
              fi;
            fi;
          od;
          changeableedges := Remove(fixededges);
          Remove(usedwords);
          if not a = 1 then
            a := a - 1;
          else
            length := length - 1;
            if length > 0 then
              a := Size(necklaces[length]);
            fi;
          fi;
          goneback := true;
          if changeableedges = [1] then
            output := [];
            for perm in SymmetricGroup(n) do
               Append(output,
                      List(outslist, x-> List(x, y -> (y + 1) ^ perm - 1)));
            od;
            return List(output, x-> BlockCodeTransducer(n, k, function(word)
			return [x[1 + Sum(List([0 .. Size(word) - 1],
                                               x-> word[Size(word) - x]*n^x))]];
			end));
          fi;
        od;
        for i in [0 .. Size(changeableedges) - 1] do
          outs[changeableedges[Size(changeableedges) - i]] := 1 +
                               outs[changeableedges[Size(changeableedges) - i]];
          if outs[changeableedges[Size(changeableedges) - i]] < n then
            break;
          elif changeableedges = [1] then
            output := [];
            for perm in SymmetricGroup(n) do
               Append(output, List(outslist,
                                   x-> List(x, y -> (y + 1) ^ perm - 1)));
            od;
            return List(output, x-> BlockCodeTransducer(n, k, function(word)
                        return [x[1 + Sum(List([0 .. Size(word) - 1],
                                              x -> word[Size(word) - x]*n^x))]];
                        end));
          else
            outs[changeableedges[Size(changeableedges) - i]] := 0;
          fi;
        od;
        if goneback then
          break;
        fi;
      od;
      if not goneback then
        Add(usedwords, ShallowCopy(outs{edges}));
        Add(fixededges, changeableedges);
        a := a + 1;
      fi;
    od;
    a := 1;
    length := length + 1;
    if length > m then
      Add(outslist, ShallowCopy(outs));
      while ForAll(changeableedges, x-> outs[x] = n - 1) or length > m do
        changeableedges := fixededges[Size(fixededges)];
        while changeableedges = [] do
          changeableedges := Remove(fixededges);
          Remove(usedwords);
          if a > 1 then
            a := a - 1;
          else
            length := length - 1;
            if length > 0 then
              a := Size(necklaces[length]);
            fi;
          fi;
        od;
        changeableedges := Remove(fixededges);
        Remove(usedwords);
        if a > 1 then
          a := a - 1;
        else
          length := length - 1;
          if length > 0 then
            a := Size(necklaces[length]);
          fi;
        fi;
      od;
      for i in [0 .. Size(changeableedges) - 1] do
        outs[changeableedges[Size(changeableedges) - i]] := 1 +
                           outs[changeableedges[Size(changeableedges) - i]];
        if outs[changeableedges[Size(changeableedges) - i]] < n then
          break;
        elif changeableedges = [1] then
          output := [];
          for perm in SymmetricGroup(n) do
             Append(output, List(outslist,
                                 x -> List(x, y -> (y + 1) ^ perm - 1)));
          od;
          return List(output, x-> BlockCodeTransducer(n, k, function(word)
                        return [x[1 + Sum(List([0 .. Size(word) - 1],
                                               x-> word[Size(word) - x]*n^x))]];
                        end));
        else
          outs[changeableedges[Size(changeableedges) - i]] := 0;
        fi;
      od;
    fi;
    if n = 2 then
      Print(List(necklaceedges{[1 .. Minimum(5, Size(necklaceedges))]},
                 x -> List(x, y-> outs{y})), "\r");
    elif n = 3 then
      Print(List(necklaceedges{[1 .. Minimum(3, Size(necklaceedges))]},
                 x -> List(x, y-> outs{y})), "\r");
    fi;
  od;

  output := [];
  for perm in SymmetricGroup(n) do
    Append(output, List(outslist, x-> List(x, y -> (y + 1) ^ perm - 1)));
  od;
  return List(output, x-> BlockCodeTransducer(n, k, function(word)
                      return [x[1 + Sum(List([0 .. Size(word) - 1],
                                             x -> word[Size(word) - x]*n^x))]];
                      end));
end;

InstallMethod(AllSynchronousLn, "for two positive integers",
[IsPosInt, IsPosInt],
function(n, k)
  local output, m, i;
  output := ln(n, k, 2*k);
  Apply(output, x-> TransducerCore(MinimalTransducer(x)));
  output := Filtered(output, InOn);
  Sort(output, Onlessthan);
  m:= Size(output);
  for i in [0 .. m-2] do
    if IsomorphicTransducers(output[m-i], output[m-i-1]) then
      Remove(output, m-i);
    fi;
  od;
  return output;
end);

InstallMethod(InfiniteOrderInAbelianisation, "for two positive integers",
[IsPosInt, IsPosInt],
function(m, p)
  local pi, lambda, n;
  if not IsPrime(p) then
    return fail;
  fi;

  n := m * p;

  pi := List([1 .. m], x -> List([0 .. n - 1], y -> QuoInt(y, p) + 1));
  lambda := List([1 .. m], x -> List([0 .. n - 1],
                           y -> [(x - 1) * p + RemInt(y, p)]));
  
  return Transducer(n, n, pi, lambda);

end);

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

BakersList := [[[[0],[]], [[], [0]]], [[[1],[]], [[], [1]]]]; 

InstallMethod(2VtoR4, "for a dense list",
[IsDenseList],
function(L)
  local domprefixes, imgprefixes, n, beginingstates, Pi, Lambda,
        relabel, relabelword, applyelement, shiftdebruijintransducer,
        statesno, usedshiftingamounts, usedshiftings, state, y, result,
        newpart, partstart, newtransitions, shifting;
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

  shiftdebruijintransducer := function(k)
    local output;
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
          newpart := shiftdebruijintransducer(result[2]);
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
