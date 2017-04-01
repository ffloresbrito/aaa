#############################################################################
##
#W  woperations.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

InstallMethod(IsPrefix, "for two dense lists",
[IsDenseList, IsDenseList],
function (word1, word2)
  local i;

  if IsEmpty(word2) then
    return true;
  elif IsEmpty(word1) then
    return false;
  elif Size(word2) > Size(word2) then
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
  word3 := word1;

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

InstallMethod(Preimage, "for a dense lists a positive integer and a transducer",
[IsDenseList, IsPosInt, IsTransducer],
function(word, state, tducer)
  local preimage, i, input, word2, options, preimages, option, x, im,
        emptypositions, emptyimage;
  preimage := [];
  word2 := word;

  if state > tducer!.States then
    ErrorNoReturn("aaa: Preimage: usage,\n",
                  "the second argument is not a state of the third argument,");

  elif IsEmpty(word) then
    return [];
  fi;

  if word in tducer!.OutputFunction[state] then
    return [Position(tducer!.OutputFunction[state], word) - 1];

  elif Size(word) = 1 and not [] in tducer!.OutputFunction[state] then
    return [];

  else

    if not [word[1]] in tducer!.OutputFunction[state] and not [] in
        tducer!.OutputFunction[state] then
      return [];

    elif [word[1]] in tducer!.OutputFunction[state] then
      Remove(word2, 1);
      options := Positions(tducer!.OutputFunction[state], [word[1]]);
      preimages := [];

      for option in options do
        Add(preimages, Preimage(word2,
                                tducer!.TransitionFunction[state][option],
                                tducer));
      od;

      for x in [1 .. Size(preimages)] do
        for im in options - 1 do
          preimage := [im];
          Append(preimage, preimages[x]);

          if tducer!.TransducerFunction(preimage, state)[1] = word then
            return preimage;
          fi;
        od;
      od;

    elif not [word[1]] in tducer!.OutputFunction[state] and [] in
        tducer!.OutputFunction[state] then

      emptypositions := Positions(tducer!.OutputFunction[state], []);

      for input in emptypositions do
        if IsEmpty(preimage) then
          emptyimage := Preimage(word,
                                 tducer!.TransitionFunction[state][input],
                                 tducer);
        fi;
      od;

      for x in [1 .. Size(emptypositions)] do
        for im in emptypositions - 1 do
          preimage := [im];
          Append(preimage, emptyimage);

          if tducer!.TransducerFunction(preimage, state)[1] = word then
            return preimage;
          fi;
        od;
      od;
    fi;

  fi;

  return [];
end);
