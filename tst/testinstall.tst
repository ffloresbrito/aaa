#############################################################################
##
#W  testinstall.tst
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
gap> START_TEST("aaa package: testinstall.tst");
gap> LoadPackage("aaa", false);;

#T# Test TransducerFunction
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
>                      [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]); 
<Transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 3 states.>
gap> f!.TransducerFunction([0, 2, 0, 1, 0, 0, 2, 2, 1, 1, 2, 0, 1], 1);
[ [ 2, 1, 0, 0, 0, 2, 2, 1, 1, 2, 1, 0, 0, 0 ], 1 ]

#E#
gap> STOP_TEST("aaa package: testinstall.tst");
