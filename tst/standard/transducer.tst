############################################################################
##
#W  standard/transducer.tst
#Y  Copyright (C) 2017                                 Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
gap> START_TEST("aaa package: standard/transducer.tst");
gap> LoadPackage("aaa", false);;

#T# Transducer
gap> f := Transducer(2, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [1, []]]);
Error, aaa: Transducer: usage,
the fourth argument contains invalid output,
gap> f := Transducer(2, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1]]]);
Error, aaa: Transducer: usage,
the size of the elements of the third or fourth argument does not coincide
with the first argument,
gap> f := Transducer(2, 2, [[3, 2], [1, 0], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, aaa: Transducer: usage,
the third argument contains invalid states,
gap> f := Transducer(3, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, aaa: Transducer: usage,
the size of the elements of the third or fourth argument does not coincide
with the first argument,
gap> f := Transducer(2, 2, [[3, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, aaa: Transducer: usage,
the size of the third and fourth arguments must coincide,
gap> f := Transducer(2, 2, [], [[[1], [0]], [[1, 1], [1, 0]], [[1], []]]);
Error, aaa: Transducer: usage,
the third and fourth arguments must be non-empty,

#T# IdentityTransducer
gap> T := IdentityTransducer(2);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 1 state.>
gap> EqualTransducers(T, Transducer(2, 2, [[1, 1]], [[[0], [1]]]));
true
gap> T := IdentityTransducer(3);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 1 state.>
gap> EqualTransducers(T, Transducer(3, 3, [[1, 1, 1]], [[[0], [1], [2]]]));
true
gap> T := IdentityTransducer(4);
<transducer with input alphabet on 4 symbols, output alphabet on 
4 symbols, and 1 state.>
gap> EqualTransducers(T, Transducer(4, 4, [[1, 1, 1, 1]],
> [[[0], [1], [2], [3]]]));
true

#T# AlphabetChangeTransducer
gap> T := Transducer(2, 4, [[1, 2], [1, 3], [1, 1]],
> [[[0], []], [[1], []], [[2], [3]]]);;
gap> EqualTransducers(T, AlphabetChangeTransducer(2, 4));
true
gap> T3to5 := AlphabetChangeTransducer(3, 5);
<transducer with input alphabet on 3 symbols, output alphabet on 
5 symbols, and 4 states.>
gap> T5to3 := AlphabetChangeTransducer(5, 3);
<transducer with input alphabet on 5 symbols, output alphabet on 
3 symbols, and 2 states.>
gap> T3to3 := T3to5 * T5to3;
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 8 states.>
gap> T5to5 := T5to3 * T3to5;
<transducer with input alphabet on 5 symbols, output alphabet on 
5 symbols, and 8 states.>
gap> T3to3 = T3to3^0;
true
gap> T5to5 = T5to5^0;
true

#T# RandomTransducer
gap> T := RandomTransducer(3, 5);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 5 states.>
gap> T := RandomTransducer(4, 2);
<transducer with input alphabet on 4 symbols, output alphabet on 
4 symbols, and 2 states.>
gap> T := RandomTransducer(2, 5);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 5 states.>

#T# TransducerByNumber
gap> T := Transducer(2, 2, [[3, 1], [1, 1], [1, 1]], [[[0, 0, 0], [1, 1, 0]],
> [[], []], [[], []]]);;
gap> T2 := TransducerByNumber(3,4,1000);;
gap> EqualTransducers(T, T2);
true
gap> T := Transducer(2, 2, [[3, 2], [1, 1], [1, 1], [1, 1]],
> [[[0], [0]], [[1], []], [[], []], [[], []]]);;
gap> T2 := TransducerByNumber(4,3,8192);;
gap> EqualTransducers(T, T2);
true
gap> EqualTransducers(TransducerByNumber(1, 1, 8), IdentityTransducer(2));
true

#T# NumberByTransducer
gap> T := Transducer(2, 2, [[3, 1], [1, 1], [1, 1]], [[[0, 0, 0], [1, 1, 0]],
> [[], []], [[], []]]);;
gap> NumberByTransducer(3, 4, T);
1000
gap> T := Transducer(2, 2, [[3, 2], [1, 1], [1, 1], [1, 1]],
> [[[0], [0]], [[1], []], [[], []], [[], []]]);;
gap> NumberByTransducer(4, 3, T);
8192
gap> NumberByTransducer(1, 1, IdentityTransducer(2));
8

#T# NrTransducers
gap> NrTransducers(1,1);
9
gap> NrTransducers(1,2);
49
gap> NrTransducers(2,1);
1296
gap> NrTransducers(1,3);
225
gap> NrTransducers(2,2);
38416
gap> NrTransducers(3,1);
531441
gap> NrTransducers(1,4);
961
gap> NrTransducers(2,3);
810000
gap> NrTransducers(3,2);
85766121
gap> NrTransducers(4,1);
429981696

#T# DeBruijinTransducer
gap> T := DeBruijnTransducer(2, 2);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 4 states.>
gap> TransitionFunction(T);
[ [ 1, 3 ], [ 1, 3 ], [ 2, 4 ], [ 2, 4 ] ]
gap> OutputFunction(T);
[ [ [ 0 ], [ 1 ] ], [ [ 0 ], [ 1 ] ], [ [ 0 ], [ 1 ] ], [ [ 0 ], [ 1 ] ] ]
gap> T := DeBruijnTransducer(3, 4);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 81 states.>
gap> TransitionFunction(T);
[ [ 1, 28, 55 ], [ 1, 28, 55 ], [ 1, 28, 55 ], [ 2, 29, 56 ], [ 2, 29, 56 ], 
  [ 2, 29, 56 ], [ 3, 30, 57 ], [ 3, 30, 57 ], [ 3, 30, 57 ], [ 4, 31, 58 ], 
  [ 4, 31, 58 ], [ 4, 31, 58 ], [ 5, 32, 59 ], [ 5, 32, 59 ], [ 5, 32, 59 ], 
  [ 6, 33, 60 ], [ 6, 33, 60 ], [ 6, 33, 60 ], [ 7, 34, 61 ], [ 7, 34, 61 ], 
  [ 7, 34, 61 ], [ 8, 35, 62 ], [ 8, 35, 62 ], [ 8, 35, 62 ], [ 9, 36, 63 ], 
  [ 9, 36, 63 ], [ 9, 36, 63 ], [ 10, 37, 64 ], [ 10, 37, 64 ], 
  [ 10, 37, 64 ], [ 11, 38, 65 ], [ 11, 38, 65 ], [ 11, 38, 65 ], 
  [ 12, 39, 66 ], [ 12, 39, 66 ], [ 12, 39, 66 ], [ 13, 40, 67 ], 
  [ 13, 40, 67 ], [ 13, 40, 67 ], [ 14, 41, 68 ], [ 14, 41, 68 ], 
  [ 14, 41, 68 ], [ 15, 42, 69 ], [ 15, 42, 69 ], [ 15, 42, 69 ], 
  [ 16, 43, 70 ], [ 16, 43, 70 ], [ 16, 43, 70 ], [ 17, 44, 71 ], 
  [ 17, 44, 71 ], [ 17, 44, 71 ], [ 18, 45, 72 ], [ 18, 45, 72 ], 
  [ 18, 45, 72 ], [ 19, 46, 73 ], [ 19, 46, 73 ], [ 19, 46, 73 ], 
  [ 20, 47, 74 ], [ 20, 47, 74 ], [ 20, 47, 74 ], [ 21, 48, 75 ], 
  [ 21, 48, 75 ], [ 21, 48, 75 ], [ 22, 49, 76 ], [ 22, 49, 76 ], 
  [ 22, 49, 76 ], [ 23, 50, 77 ], [ 23, 50, 77 ], [ 23, 50, 77 ], 
  [ 24, 51, 78 ], [ 24, 51, 78 ], [ 24, 51, 78 ], [ 25, 52, 79 ], 
  [ 25, 52, 79 ], [ 25, 52, 79 ], [ 26, 53, 80 ], [ 26, 53, 80 ], 
  [ 26, 53, 80 ], [ 27, 54, 81 ], [ 27, 54, 81 ], [ 27, 54, 81 ] ]
gap> OutputFunction(T);
[ [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], 
  [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ], [ [ 0 ], [ 1 ], [ 2 ] ] ]

#
gap> STOP_TEST("aaa package: standard/transducer.tst");
