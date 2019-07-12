
InstallMethod(ViewObj, "for an rtransducer",
[IsRTransducer],
function(T)
  local state, sym1, sym2;
  state := "states";
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

  Print("<rtransducer with input alphabet on ", T!.InputAlphabet, " ", sym1,
        ", output alphabet on ", T!.OutputAlphabet, " ", sym2, ", and ",
        T!.States, " ", state, ".>");
end);

InstallMethod(RTransducer, "for four positive integers and two dense lists",
[IsPosInt, IsPosInt, IsPosInt, IsPosInt, IsDenseList, IsDenseList],
function(inroots, outroots, inalph, outalph, tranfunc, outfunc)
  local transducer, T, state, rootstates, accnonrootstates, target, nrstates,
        letter, rootletter, i, j, accessiblestates, newoutfunc, newtranfunc;

  if IsEmpty(tranfunc) or IsEmpty(outfunc) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the fifth and sixth arguments must be non-empty,");
  elif Size(tranfunc) <> Size(outfunc) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the size of the fifth and sixth arguments must coincide,");
  elif ForAny(tranfunc, x -> not IsDenseList(x) or
              ForAny(x, y -> not y in [1 .. Size(tranfunc)])) then
    ErrorNoReturn("aaa: Transducer: usage,\n",
                  "the third argument contains invalid states,");
  fi;


  nrstates := Size(tranfunc);
  rootstates := [1];
  accnonrootstates := [];
  for i in rootstates do
    if i = 1 then
      if not Size(tranfunc[i]) = inroots then
        ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the first argument in incompatible with the fifth argument,");
      fi;
      if not Size(outfunc[i]) = inroots then
        ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the first argument in incompatible with the sixth argument,");
      fi;
      for rootletter in [0 .. inroots - 1] do
        target := tranfunc[i][rootletter + 1];
        if target = 1 then
          ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the initial states should not be revisuitable,");
        fi;
        if outfunc[i][rootletter + 1] = [] then
          if not target in rootstates then
            Add(rootstates, target);
          fi;
        else
          if not outfunc[i][rootletter + 1][1] in [0 .. outroots - 1] then
            ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the second argument is not compatible with the sixth argument,");
          fi;
          for j in [2 .. Size(outfunc[i][rootletter + 1])] do
            if not outfunc[i][rootletter + 1][j] in [0 .. outalph - 1] then
              ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the forth argument is not compatible with the sixth argument,");
            fi;
          od;
          if target in rootstates then
            ErrorNoReturn("aaa: Transducer: usage,\n",
                 "there is no valid state partition,");
          fi;
          if not target in accnonrootstates then
            Add(accnonrootstates, target);
          fi;
        fi;
      od;
    else
      if not Size(tranfunc[i]) = inalph then
        ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the first argument in incompatible with the fifth argument,");
      fi;
      if not Size(outfunc[i]) = inalph then
        ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the first argument in incompatible with the sixth argument,");
      fi;
      for letter in [0 .. inalph - 1] do
        target := tranfunc[i][letter + 1];
        if target = 1 then
          ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the initial states should not be revisuitable,");
        fi;
        if outfunc[i][letter + 1] = [] then
          if not target in rootstates then
            Add(rootstates, target);
          fi;
        else
          if not outfunc[i][letter + 1][1] in [0 .. outroots - 1] then
            ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the second argument is not compatible with the sixth argument,");
          fi;
          for j in [2 .. Size(outfunc[i][letter + 1])] do
            if not outfunc[i][letter + 1][j] in [0 .. outalph - 1] then
              ErrorNoReturn("aaa: Transducer: usage,\n",
                 "the forth argument is not compatible with the sixth argument,");
            fi;
          od;
          if target in rootstates then
            ErrorNoReturn("aaa: Transducer: usage,\n",
                 "there is no valid state partition,");
          fi;
          if not target in accnonrootstates then
            Add(accnonrootstates, target);
          fi;
        fi;
      od;
    fi;
  od;

  for state in accnonrootstates do
    for target in tranfunc[state] do
      if target in rootstates then
        ErrorNoReturn("aaa: Transducer: usage,\n",
                 "there is no valid state partition,");
      fi;
      if not target in accnonrootstates then
        Add(accnonrootstates, target);
      fi;
    od;
    for i in outfunc[state] do
      for j in i do
        if not j in [0 .. outalph - 1] then
          ErrorNoReturn("aaa: Transducer: usage,\n",
               "the forth argument is not compatible with the sixth argument,");
        fi;
      od;
    od;
  od;

  accessiblestates := Set(Concatenation(rootstates, accnonrootstates));
  newtranfunc := List(accessiblestates, x -> List(tranfunc[x], y -> Position(accessiblestates, y)));
  newoutfunc := List(accessiblestates, x -> outfunc[x]);
  Apply(rootstates, x -> Position(accessiblestates, x));

  transducer := function(input, state)
                  local ialph, oalph, tfunc, ofunc, output, n;
                  ialph := [0 .. inalph - 1];
                  oalph := [0 .. outalph - 1];
                  tfunc := newtranfunc;
                  ofunc := newoutfunc;
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
                  elif input <> [] and state = 1 and not input[1] in [0 .. inroots - 1] then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the first argument must be compatible with the input roots");
                  elif input <> [] and state <> 1 and not input[1] in ialph then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the first argument must be compatible with the input alphabet ");

                  elif ForAny(input{[2 .. Size(input)]}, x -> not x in ialph) then
                    ErrorNoReturn("aaa: Transducer: usage,\n",
                                  "the first argument must be compatible with the input alphabet ");
                  fi;

                  for n in input do
                    Append(output, ofunc[state][n + 1]);
                    state := tfunc[state][n + 1];
                  od;

                  return [output, state];
                end;

  T := Objectify(NewType(NewFamily("RTransducer"), IsRTransducer and
                 IsAttributeStoringRep), rec(InputRoots := inroots,
					     InputAlphabet := inalph,
					     OutputRoots := outroots,
                                             OutputAlphabet := outalph,
                                             States := Size(accessiblestates),
                                             RootStates := rootstates,
                                             TransitionFunction := newtranfunc,
                                             OutputFunction := newoutfunc,
                                             TransducerFunction := transducer));

  return T;
end);

InstallMethod(RootStates, "for an rtransducer",
[IsRTransducer],
function(T)
  return T!.RootStates;
end);

InstallMethod(InputRoots, "for an rtransducer",
[IsRTransducer],
function(T)
  return [0 .. T!.InputRoots - 1];
end);

InstallMethod(OutputRoots, "for an rtransducer",
[IsRTransducer],
function(T)
  return [0 .. T!.OutputRoots - 1];
end);

InstallMethod(NrInputRoots, "for an rtransducer",
[IsRTransducer],
function(T)
  return T!.InputRoots;
end);

InstallMethod(NrOutputRoots, "for an rtransducer",
[IsRTransducer],
function(T)
  return T!.OutputRoots;
end);

InstallMethod(TransducerToRTransducer, "for a transducer",
[IsTransducer],
function(T)
  local Pi, Lambda, i;
  Pi := StructuralCopy(TransitionFunction(T));
  Lambda := StructuralCopy(OutputFunction(T));
  for i in Pi do
    Apply(i, x -> x + 1);
  od;
  Pi := Concatenation([[2]], Pi);
  Lambda := Concatenation([[[0]]], Lambda);

  return RTransducer(1, 1, NrInputSymbols(T), NrOutputSymbols(T), Pi, Lambda);
end);
