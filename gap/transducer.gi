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
[IsTransducer, IsDenseList, IsPosInt],
function(T, input, state)
  return T!.TransducerFunction(input, state);
end);

InstallMethod(TransitionFunction, "for a transducer",
[IsTransducer],
function(T)
  return T!.TransitionFunction;
end);

InstallMethod(OutputFunction, "for a transducer",
[IsTransducer],
function(T)
  return T!.OutputFunction;
end);

InstallMethod(States, "for a transducer",
[IsTransducer],
function(T)
  return [1 .. T!.States];
end);

InstallMethod(NrStates, "for a transducer",
[IsTransducer],
function(T)
  return T!.States;
end);

InstallMethod(InputAlphabet, "for a transducer",
[IsTransducer],
function(T)
  return [0 .. T!.InputAlphabet - 1];
end);

InstallMethod(OutputAlphabet, "for a transducer",
[IsTransducer],
function(T)
  return [0 .. T!.OutputAlphabet - 1];
end);

InstallMethod(NrOutputSymbols, "for a transducer",
[IsTransducer],
function(T)
  return T!.OutputAlphabet;
end);

InstallMethod(NrInputSymbols, "for a transducer",
[IsTransducer],
function(T)
  return T!.InputAlphabet;
end);

InstallMethod(IdentityTransducer, "returns identity transducer on given alphabet size",
[IsPosInt],
function(AlphSize)
  return Transducer(AlphSize,AlphSize,[List([1 .. AlphSize], x -> 1)],
                    [List([0 .. AlphSize - 1], x-> [x])]);
end);
