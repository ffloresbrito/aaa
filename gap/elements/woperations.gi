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
