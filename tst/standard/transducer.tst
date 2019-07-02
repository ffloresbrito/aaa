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

#
gap> STOP_TEST("aaa package: standard/transducer.tst");
