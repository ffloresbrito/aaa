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

#T# Transducer build
gap> f := Transducer(2, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                    [1, 0]], [[1], []]]);
function( input, state ) ... end
gap> f := Transducer(2, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [1, []]]);
Error, AAA: Transducer: usage,
the fourth argument contains invalid output,
gap> f := Transducer(2, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1]]]);
Error, AAA: Transducer: usage,
the size of the elements of the third or fourth argument does not coincide wit\
h the first argument,
gap> f := Transducer(2, 2, [[3, 2], [1, 0], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, AAA: Transducer: usage,
the third argument contains invalid states,
gap> f := Transducer(3, 2, [[3, 2], [1, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, AAA: Transducer: usage,
the size of the elements of the third or fourth argument does not coincide wit\
h the first argument,
gap> f := Transducer(2, 2, [[3, 2], [3, 2]], [[[1], [0]], [[1, 1],
>                     [1, 0]], [[1], []]]);
Error, AAA: Transducer: usage,
the size of the third and fourth arguments must coincide,
gap> f := Transducer(2, 2, [], [[[1], [0]], [[1, 1], [1, 0]], [[1], []]]);
Error, AAA: Transducer: usage,
the third and fourth arguments must be non-empty,

#
gap> STOP_TEST("Semigroups package: standard/ident.tst");
