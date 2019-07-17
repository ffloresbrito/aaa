#############################################################################
##
#W  woperations.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains methods for operations that relate to the words that are
# accepted by transducers.

InstallMethod(IsPrefix, "for two dense lists",
[IsDenseList, IsDenseList],
function(word1, word2)
  local i;

  if IsEmpty(word2) then
    return true;
  elif IsEmpty(word1) then
    return false;
  elif Size(word2) > Size(word1) then
    return false;
  elif word1 = word2 then
    return true;
  fi;

  for i in [1 .. Size(word2)] do
    if word2[i] <> word1[i] then
      return false;
    fi;
  od;

  return true;
end);

InstallMethod(Minus, "for two dense lists",
[IsDenseList, IsDenseList],
function(word1, word2)
  local word3, i;
  word3 := ShallowCopy(word1);

  if not IsPrefix(word1, word2) then
    return fail;
  elif IsEmpty(word2) then
    return word3;
  fi;

  for i in [1 .. Size(word2)] do
    Remove(word3, 1);
  od;

  return word3;
end);

InstallMethod(Preimage, "for a dense list a positive integer and a transducer",
[IsDenseList, IsPosInt, IsTransducer],
function(word, state, tducer)
  local preimage, word2, options, preimages, option, x, im;
  preimage := [];
  word2 := ShallowCopy(word);

  if state > NrStates(tducer) then
    ErrorNoReturn("aaa: Preimage: usage,\n",
                  "the second argument is not a state of the third argument,");
  elif ForAny(word, x -> not x in OutputAlphabet(tducer)) then
    ErrorNoReturn("aaa: Preimage: usage,\n",
                  "the first argument contains symbols not in the output ",
                  "alphabet of the\nthird argument,");
  elif IsEmpty(word) then
    return [];
  fi;

  if word in OutputFunction(tducer)[state] then
    return [Position(OutputFunction(tducer)[state], word) - 1];

  elif Size(word) = 1 and not [] in OutputFunction(tducer)[state] then
    return [];

  else

    if not [word[1]] in OutputFunction(tducer)[state] and not [] in
        OutputFunction(tducer)[state] then
      return [];

    elif [word[1]] in OutputFunction(tducer)[state] or
         (not [word[1]] in OutputFunction(tducer)[state] and [] in
          OutputFunction(tducer)[state]) then

      if [word[1]] in OutputFunction(tducer)[state] then
        Remove(word2, 1);
        options := Positions(OutputFunction(tducer)[state], [word[1]]);
      else
        options := Positions(OutputFunction(tducer)[state], []);
      fi;

      preimages := [];

      for option in options do
        Add(preimages, Preimage(word2,
                                TransitionFunction(tducer)[state][option],
                                tducer));
      od;

      for x in [1 .. Size(preimages)] do
        for im in options - 1 do
          preimage := [im];
          Append(preimage, preimages[x]);

          if TransducerFunction(tducer, preimage, state)[1] = word then
            return preimage;
          fi;
        od;
      od;

    fi;

  fi;

  return [];
end);

InstallMethod(PreimageConePrefixes, "for a den. list a pos. int. and a transd.",
[IsDenseList, IsPosInt, IsTransducerOrRTransducer],
function(word, state, tducer)
  local word2, x, wordset, pos, words, y, omit, n, newword;
  if IsDegenerateTransducer(tducer) then
    ErrorNoReturn("aaa: PreimageConePrefixes: usage,\n",
                  "the given transducer must be nondegenerate ");
  fi;
  wordset := [];
  pos := [];
  words := [];
  if state > States(tducer) then
    ErrorNoReturn("aaa: PreimageConePrefixes: usage,\n",
                  "the second argument is not a state of the third argument,");
  elif (state > 1 or IsTransducer(tducer)) and
       ForAny(word, x -> not x in OutputAlphabet(tducer)) then
    ErrorNoReturn("aaa: PreimageConePrefixes: usage,\n",
                  "the first argument contains symbols not in the output ",
                  "alphabet of the\nthird argument,");
  elif (state = 1 and IsRTransducer(tducer)) and
       (not word[1] in OutputRoots(tducer) or
       ForAny(word{[2 .. Size(word)]},
              x -> not x in OutputAlphabet(tducer))) then
    ErrorNoReturn("aaa: PreimageConePrefixes: usage,\n",
                  "the first argument contains invalid symbols ");

  elif IsEmpty(word) and not [] in OutputFunction(tducer)[state] then
    return [[]];
  fi;

  if IsEmpty(word) then
    pos := Positions(OutputFunction(tducer)[state], []) - 1;
    for x in [1 .. Size(pos)] do
      Add(wordset, [pos[x]]);
    od;
  else
    for x in [1 .. Size(word)] do
      for y in [0 .. Size(OutputFunction(tducer)[state]) - 1] do
        if Size(OutputFunction(tducer)[state][y + 1]) >= x then
          if word{[1 .. x]} = OutputFunction(tducer)[state][y + 1]{[1 .. x]}
              then
            if not [y] in wordset then
              Add(wordset, [y]);
            fi;
          else
            if [y] in wordset then
              Remove(wordset, Position(wordset, [y]));
            fi;
          fi;
        fi;
      od;
    od;
  fi;
  if [] in OutputFunction(tducer)[state] then
    pos := Positions(OutputFunction(tducer)[state], []) - 1;
    for x in [1 .. Size(pos)] do
      Add(wordset, [pos[x]]);
    od;
  fi;
  n := 0;
  pos := [];
  for x in wordset do
    n := n + 1;
    omit := Size(OutputFunction(tducer)[state][x[1] + 1]);
    if omit < Size(word) then
      if omit = 0 then
        word2 := ShallowCopy(word);
      else
        word2 := Minus(word, word{[1 .. omit]});
      fi;
        Add(pos, [PreimageConePrefixes(word2, TransitionFunction(tducer)
                                       [state][x[1] + 1], tducer), n]);
    fi;
  od;
  for x in pos do
    for y in x[1] do
      if not IsEmpty(y) then
        newword := ShallowCopy(wordset[x[2]]);
        Append(newword, y);
        Add(wordset, newword);
      fi;
    od;
  od;
  if IsEmpty(word) then
    Add(wordset, []);
  fi;
  for x in wordset do
    if IsPrefix(TransducerFunction(tducer, x, state)[1], word) then
      Add(words, x);
    fi;
  od;
  if IsEmpty(words) then
    return [[]];
  fi;
  words := SSortedList(words);
  return words;
end);

InstallMethod(GreatestCommonPrefix, "for a dense list",
[IsDenseList],
function(L)
  local minword, sizeword, n, x, notomit;

  if IsEmpty(L) then
    return [];
  elif ForAny(L, x -> not IsDenseList(x)) then
    ErrorNoReturn("aaa: GreatestCommonPrefix: usage,\n",
                  "the elements of the argument must be dense lists,");
  fi;

  if [] in L then
    return [];
  fi;

  Sort(L, function(x, y)
            return Size(x) < Size(y);
          end);
  minword := ShallowCopy(L[1]);
  sizeword := Size(minword);
  n := 0;
  for x in [1 .. Size(minword)] do
    notomit := sizeword - n;
    if ForAll(L, x -> IsPrefix(x, minword{[1 .. notomit]})) then
      return minword{[1 .. notomit]};
    fi;
    n := n + 1;
  od;

  return [];
end);

InstallMethod(ImageConeLongestPrefix, "for a dens. list a pos. int and a tdcr.",
[IsDenseList, IsPosInt, IsTransducerOrRTransducer],
function(w, q, T)
  local tducerf, flag, active, tactive, outputs, retired, v, b, k, y, x, word,
        common, common1;

  if (IsTransducer(T) or q <> 1) and ForAny(w, x -> not x in InputAlphabet(T)) then
    ErrorNoReturn("aaa: ImageConeLongestPrefix: usage,\n",
                  "the first argument contains symbols not in the input ",
                  "alphabet of the third\n argument,");
  elif IsRTransducer(T) and q = 1 and w <> [] and
       (ForAny(w{[2 .. Size(w)]}, x -> not x in InputAlphabet(T)) or
        not w[1] in InputRoots(T)) then
    ErrorNoReturn("aaa: ImageConeLongestPrefix: usage,\n",
                  "the given word cannot be read from the start state");
  elif not q in States(T) then
    ErrorNoReturn("aaa: ImageConeLongestPrefix: usage,\n",
                  "the second argument is not a state of the third argument,");
  fi;

  tducerf := TransducerFunction(T, w, q);
  v := tducerf[1];
  b := tducerf[2];
  flag := false;
  retired := [];
  k := 0;

  while not flag do
    k := k + 1;
    outputs := [];
    if IsRTransducer(T) and b = 1 then
      active := List(Cartesian(InputRoots(T), Tuples(InputAlphabet(T), k - 1)),
                      x -> Concatenation([x[1]], x[2]));
    else
      active := Tuples(InputAlphabet(T), k);
    fi;
    for x in active do
      word := TransducerFunction(T, x, b)[1];
      if not word in outputs then
        Add(outputs, word);
      fi;
    od;
    for x in outputs do
      for y in outputs do
        if not IsPrefix(x, y) and not IsPrefix(y, x) then
          common := GreatestCommonPrefix([x, y]);
          common1 := ShallowCopy(common);
          flag := true;
        fi;
      od;
    od;
  od;
  while Size(active) <> 0 do
    while Size(common1) < Size(common) or flag do
      common := ShallowCopy(common1);
      tactive := ShallowCopy(active);
      for x in active do
        word := TransducerFunction(T, x, b)[1];
        if (Size(word) > Size(common)) or ((not IsPrefix(word, common)) and
            (not IsPrefix(common, word))) then
          Remove(tactive, Position(tactive, x));
          Add(retired, x);
        fi;
      od;
      active := ShallowCopy(tactive);
      outputs := [];
      for x in retired do
        word := TransducerFunction(T, x, b)[1];
        if not word in outputs then
          Add(outputs, word);
        fi;
      od;
      common1 := GreatestCommonPrefix(outputs);
      flag := false;
    od;
    tactive := [];
    for x in active do
      word := [];
      Append(word, x);
      for y in InputAlphabet(T) do
        Append(word, [y]);
        if not word in tactive then
          Add(tactive, word);
        fi;
        word := [];
        Append(word, x);
      od;
    od;
    active := ShallowCopy(tactive);
    flag := true;
  od;
  Append(v, common1);
  return v;
end);

InstallMethod(\^, "for a dens. list and a tdcr.",
[IsDenseList, IsTransducerOrRTransducer],
function(word, T)
  local newword;
  newword := [0];
  while Size(newword) - 1 <= TransducerSynchronizingLength(T) do
    Append(newword, word);
  od;
  return TransducerFunction(T, word, TransducerFunction(T, newword, 1)[2])[1];
end);

InstallMethod(ShiftEquivalent, "for two dense lists",
[IsDenseList, IsDenseList],
function(v, w)
  local i;
  if not Size(v) = Size(w) then
    return false;
  fi;
  for i in [1 .. Size(w)] do
    if Concatenation(w{[i .. Size(w)]},w{[1 .. i - 1]}) = v then
      return true;
    fi;
  od;
  return false;
  
end);

InstallMethod(IsPrimeWord, "for a dense lists",
[IsDenseList],
function(w)
  local i;
  for i in [2 .. Size(w)] do
    if Concatenation(w{[i .. Size(w)]},w{[1 .. i - 1]}) = w then
      return false;
    fi;
  od;
  return true;
end);

InstallMethod(PrimeNecklaces, "for two positive integers",
[IsPosInt, IsPosInt],
function(AlphSize, WordLength)
  local primewords, w;
  primewords := [];
  for w in Tuples([0 .. AlphSize - 1], WordLength) do
    if IsPrimeWord(w) and
       ForAll(primewords, x -> not ShiftEquivalent(x, w)) then
      Add(primewords, w);
    fi;
  od;
  return primewords;
end);

