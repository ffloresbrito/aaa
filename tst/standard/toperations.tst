############################################################################
##
#W  standard/toperations.tst
#Y  Copyright (C) 2017                                 Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##
gap> START_TEST("aaa package: standard/toperations.tst");
gap> LoadPackage("aaa", false);;

#T# InverseTransducer
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
>                      [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);;
gap> g := InverseTransducer(f);;
gap> w := TransducerFunction(f, [0, 1], 1)[1];
[ 2, 0 ]
gap> TransducerFunction(g, w, 1)[1];
[ 0, 1 ]

#T# TransducerProduct
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
>                      [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 3 states.>
gap> ff := TransducerProduct(f, f);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 9 states.>

#T# RemoveStatesWithIncompleteResponse
gap> t := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], []],
>                           [[1, 0, 0], [1], [1]], [[0, 2], [2], [0]]]);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 3 states.>
gap> p := RemoveStatesWithIncompleteResponse(t);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 4 states.>
gap> TransducerFunction(t, [2], 1)[1]; TransducerFunction(t, [1], 2)[1];
[  ]
[ 1 ]
gap> TransducerFunction(p, [2], 2)[1];
[ 1 ]

#T# RemoveInaccessibleStates
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
>                      [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 3 states.>
gap> ff := TransducerProduct(f, f);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 9 states.>
gap> m := RemoveInaccessibleStates(ff);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 6 states.>

#T# CopyTransducerWithInitialState
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
>                      [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);;
gap> p := CopyTransducerWithInitialState(f, 3);;
gap> TransducerFunction(f, [0, 1, 0], 3);
[ [ 0, 2, 0, 2 ], 1 ]
gap> TransducerFunction(p, [0, 1, 0], 1);
[ [ 0, 2, 0, 2 ], 2 ]

#T# IsInjectiveTransducer
gap> T := Transducer(2, 2, [[2, 4], [3, 6], [3, 2], [5, 7], [5, 4], [6, 6],
>  [7, 7]], [[[0], []], [[0, 1], [1, 0, 1]], [[1, 1, 1], [1, 0]], [[0, 0],
>  [0, 1, 0]], [[0, 0, 0], [1, 1]], [[0], [1]], [[0], [1]]]);;
gap> IsInjectiveTransducer(T);
false
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
> [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);;
gap> IsInjectiveTransducer(f);
true
gap> T := Transducer(2, 2, [[3, 2], [4, 4], [4, 4], [4, 4]], [[[], []],
> [[0, 1], [1, 1]], [[0, 0], [1, 0]], [[0], [1]]]);;
gap> IsInjectiveTransducer(T);
true
gap> T := Transducer(2, 2, [[1, 2], [3, 4], [1, 5], [1, 6], [3, 4], [1, 6]],
> [[[0, 1, 0], []], [[1, 1], [0]], [[0, 1, 0], []], [[], [1, 0, 1, 0]],
> [[1], [0]], [[], [1, 0]]]);;
gap> IsInjectiveTransducer(T);
true
gap> T := Transducer(2, 4, [[1, 2], [1, 3], [1, 1]], [[[0], []], [[1], []],
> [[2], [3]]]);;
gap> IsInjectiveTransducer(T);
true
gap> T := Transducer(2, 2, [[3, 3], [2, 3], [3, 2]], [[[0, 1], []],
> [[1], [1, 0, 0, 1, 0, 1]], [[1, 1], [0, 1]]]);;
gap> IsInjectiveTransducer(T);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> IsInjectiveTransducer(T);
false

#T# IsSurjectiveTransducer
gap> T := Transducer(2, 2, [[1, 2], [1, 3], [1, 3]], [[[1, 0], []], [[0],
> [1, 1]], [[0], [1]]]);;
gap> IsSurjectiveTransducer(T);
true
gap> P := Transducer(2, 2, [[3, 4], [3, 2], [1, 3], [2, 4]], [[[1], [0]],
> [[], [1]], [[1], [0]], [[1, 0], [1]]]);;
gap> IsSurjectiveTransducer(P);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> IsSurjectiveTransducer(T);
true
gap> T := Transducer(2, 2, [[3, 3], [2, 3], [3, 2]], [[[0, 1], []],
> [[1], [1, 0, 0, 1, 0, 1]], [[1, 1], [0, 1]]]);;
gap> IsSurjectiveTransducer(T);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> IsSurjectiveTransducer(T);
true
gap> T := Transducer(5, 3, [[1, 1, 1, 1, 1], [1, 1, 1, 1, 2]],
> [[[0], [1], [2, 0], [2, 1], [2, 2]], [[1], [2, 0], [2, 1],
> [2, 2, 0], [2, 2]]]);;
gap> IsSurjectiveTransducer(T);
true
gap> T := Transducer(3, 3, [[3, 2, 3], [1, 3, 1], [1, 3, 1]],
> [[[1, 1], [0], [2]], [[1], [1], []], [[2, 0], [0, 1, 0], []]]);;
gap> IsSurjectiveTransducer(T);
false

#T# TransducerImageAutomaton
gap> T := Transducer(3, 3, [[3, 2, 3], [1, 3, 1], [1, 3, 1]],
> [[[1, 1], [0], [2]], [[1], [1], []], [[2, 0], [0, 1, 0], []]]);;
gap> String(TransducerImageAutomaton(T));
"Automaton(\"epsilon\",7,\"012@\",[ [ [ 2 ], [ ], [ 6 ], [ ], [ 1 ], [ ], [ 3 \
] ], [ [ 4 ], [ 1, 3 ], [ ], [ 3 ], [ ], [ 7 ], [ ] ], [ [ 3 ], [ ], [ 5 ], [ \
], [ ], [ ], [ ] ], [ [ ], [ 1 ], [ 1 ], [ ], [ ], [ ], [ ] ] ],[ 1 ],[ 1 .. 7\
 ]);;"
gap> T := Transducer(2, 2, [[2, 3], [5, 1], [4, 5], [2, 5], [3, 3]],
> [[[0], [0]], [[0, 1, 0, 0, 0, 1], [0, 0, 0]], [[], [0]],
> [[], []], [[0], [0]]]);;
gap> String(TransducerImageAutomaton(T));
"Automaton(\"epsilon\",12,\"01@\",[ [ [ 2, 3 ], [ 6, 11 ], [ 5 ], [ ], [ 3 ], \
[ ], [ 8 ], [ 9 ], [ 10 ], [ ], [ 12 ], [ 1 ] ], [ [ ], [ ], [ ], [ ], [ ], [ \
7 ], [ ], [ ], [ ], [ 5 ], [ ], [ ] ], [ [ ], [ ], [ 4 ], [ 2, 5 ], [ ], [ ], \
[ ], [ ], [ ], [ ], [ ], [ ] ] ],[ 1 ],[ 1 .. 12 ]);;"
gap> T := Transducer(3, 4, [[1, 1, 2], [1, 1, 3], [1, 1, 1]],
> [[[0], [1], []], [[2], [3,0], [3]], [[1], [2], [3]]]);;
gap> String(TransducerImageAutomaton(T));
"Automaton(\"epsilon\",4,\"0123@\",[ [ [ 1 ], [ ], [ ], [ 1 ] ], [ [ 1 ], [ ],\
 [ 1 ], [ ] ], [ [ ], [ 1 ], [ 1 ], [ ] ], [ [ ], [ 3, 4 ], [ 1 ], [ ] ], [ [ \
2 ], [ ], [ ], [ ] ] ],[ 1 ],[ 1 .. 4 ]);;"

#
gap> STOP_TEST("aaa package: standard/toperations.tst");
