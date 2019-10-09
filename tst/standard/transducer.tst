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

#
gap> STOP_TEST("aaa package: standard/transducer.tst");
