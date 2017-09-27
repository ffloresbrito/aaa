############################################################################
##
#W  standard/woperations.tst
#Y  Copyright (C) 2017                                 Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
gap> START_TEST("aaa package: standard/woperations.tst");
gap> LoadPackage("aaa", false);;

#T# IsPrefix
gap> u := [0, 1];; v := [0, 1, 0];; empty := [];;
gap> IsPrefix(u, v); IsPrefix(v, u); IsPrefix(u, empty);
false
true
true

#T# Minus
gap> u := [0, 1];; v := [0, 1, 1];;
gap> Minus(v, u);
[ 1 ]
gap> Minus(u, v);
fail

#T# GreatestCommonPrefix
gap> u := [0, 0];; v := [0, 0, 1, 2];; w := [0, 1, 2];;
gap> GreatestCommonPrefix([u, v, w]);
[ 0 ]
gap> empty := [];; z := [1];;
gap> GreatestCommonPrefix([u, v, w, empty]);
[  ]
gap> GreatestCommonPrefix([u, v, w, z]);
[  ]

#T# ImageConeLongestPrefix
gap> t := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], []],
>                           [[1, 0, 0], [1], [1]], [[0, 2], [2], [0]]]);;
gap> ImageConeLongestPrefix([], 2, t);
[ 1 ]

#
gap> STOP_TEST("aaa package: standard/woperations.tst");
