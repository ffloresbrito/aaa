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
gap> T := Transducer(2, 2, [[1, 2], [2, 2]], [[[1], [1, 1]], [[1], [1, 1]]]);;
gap> R := RemoveStatesWithIncompleteResponse(T);;
gap> OutputFunction(R);
[ [ [  ], [  ] ], [ [ 1 ], [ 1 ] ], [ [ 1 ], [ 1 ] ], [ [ 1 ], [ 1 ] ], 
  [ [ 1 ], [ 1 ] ] ]
gap> TransitionFunction(R);
[ [ 4, 5 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 5, 5 ] ]
gap> T := Transducer(2, 3, [[2, 3], [2, 3], [2, 3]], [[[2, 0], [2]],
> [[1, 1, 0], [1, 1]], [[0], [0, 1, 1]]]);;
gap> R := RemoveStatesWithIncompleteResponse(T);;
gap> OutputFunction(R);
[ [ [ 2 ], [ 2 ] ], [ [ 0, 1, 1 ], [ 0, 1, 1 ] ], 
  [ [ 1, 1, 0 ], [ 1, 1, 0 ] ], [ [ 0, 1, 1 ], [ 0, 1, 1 ] ], 
  [ [ 0, 1, 1 ], [ 0, 1, 1 ] ] ]
gap> TransitionFunction(R);
[ [ 5, 4 ], [ 2, 2 ], [ 3, 3 ], [ 4, 4 ], [ 5, 5 ] ]

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

#T# TransducerConstantStateOutputs
gap> T := Transducer(2, 2, [[1, 2], [2, 2]], [[[1], [1, 1]], [[1], [1, 1]]]);;
gap> TransducerConstantStateOutputs(T);
[ [ 1, 2 ], [ "(1)*", "(1)*" ] ]
gap> T := Transducer(2, 3, [[2, 3], [2, 3], [2, 3]], [[[2, 0], [2]],
> [[1, 1, 0], [1, 1]], [[0], [0, 1, 1]]]);;
gap> TransducerConstantStateOutputs(T);
[ [ 1, 2, 3 ], [ "2(011)*", "(110)*", "(011)*" ] ]
gap> T := Transducer(2, 2, [[3, 3], [1, 1], [2, 1]], [[[1], []],
> [[0, 1, 1, 1], [0]], [[0], [1]]]);;
gap> TransducerConstantStateOutputs(T);
[ [  ], [  ] ]
gap> T := Transducer(5, 3, [[1, 1, 1, 1, 1], [1, 1, 1, 1, 2]],
> [[[0], [1], [2, 0], [2, 1], [2, 2]], [[1], [2, 0], [2, 1],
> [2, 2, 0], [2, 2]]]);;
gap> TransducerConstantStateOutputs(T);
[ [  ], [  ] ]

#T# IsDegenerateTransducer
gap> T := Transducer(2, 2, [[2, 2], [1, 3], [2, 1]], [[[0], [0]],
> [[0, 1, 0, 0, 0, 1], []], [[0, 0, 0], [0]]]);;
gap> IsDegenerateTransducer(T);
false
gap> T := Transducer(3, 3, [[1, 2, 2], [3, 2, 3], [1, 3, 3]], [[[2, 2],
> [2, 2, 2, 2, 1, 1, 0, 1], [2, 0]], [[], [0, 1], [2]], [[1], [1], []]]);;
gap> IsDegenerateTransducer(T);
true
gap> T := Transducer(3, 3, [[1, 1, 3], [3, 1, 1], [2, 3, 2]],
> [[[0, 2, 2], [0], [2, 2]], [[], [0], [0]], [[2], [1, 2], []]]);;
gap> IsDegenerateTransducer(T);
true
gap> T := Transducer(5, 3, [[1, 1, 1, 1, 1], [1, 1, 1, 1, 2]],
> [[[0], [1], [2, 0], [2, 1], [2, 2]], [[1], [2, 0], [2, 1],
> [2, 2, 0], [2, 2]]]);;
gap> IsDegenerateTransducer(T);
false

#T# CombineEquivalentStates
gap> T := Transducer(3, 4, [[1, 2, 2], [3, 2, 2], [3, 2, 2]],
> [[[1], [], [1, 0]], [[2], [2], [2]], [[1], [], [1, 0]]]);;
gap> CombineEquivalentStates(T);
<transducer with input alphabet on 3 symbols, output alphabet on 
4 symbols, and 2 states.>
gap> T := Transducer(3, 3, [[2, 3, 2], [2, 1, 4], [1, 4, 2], [4, 2, 3]],
> [[[2], [], [2]], [[2], [0, 1], [1, 2, 0]], [[0], [], [1]], [[], [1], [0]]]);;
gap> CombineEquivalentStates(T);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 4 states.>
gap> T := Transducer(2, 2, [[2, 4], [3, 2], [5, 4], [1, 5], [1, 4]],
> [[[0], [1, 0]], [[], [1]], [[0], [1 , 0]], [[], [1]], [[], [1]]]);;
gap> CombineEquivalentStates(T);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 2 states.>
gap> T := Transducer(2, 2, [[1, 4], [3, 2], [5, 4], [3, 5], [1, 4]],
> [[[0], [1, 0]], [[], [1]], [[0], [1 , 0]], [[], [1]], [[], [1]]]);;
gap> CombineEquivalentStates(T);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 5 states.>

#T# MinimalTransducer
gap> T := Transducer(3, 3, [[2, 2, 1], [4, 3, 1], [4, 2, 3], [1, 1, 4]],
> [[[2], [2, 0], [2]], [[2, 2, 0], [], [0, 1]], [[], [0], [2]],
> [[2, 1], [1, 0, 1], [1, 2]]]);;
gap> M := MinimalTransducer(T);
<transducer with input alphabet on 3 symbols, output alphabet on 
3 symbols, and 5 states.>
gap> OutputFunction(M);
[ [ [ 2 ], [ 2, 0 ], [ 2, 2 ] ], [ [ 2, 2, 0 ], [  ], [ 0, 1, 2 ] ], 
  [ [  ], [ 0 ], [ 2 ] ], [ [ 2, 1, 2 ], [ 1, 0, 1, 2 ], [ 1, 2 ] ], 
  [ [  ], [ 0 ], [ 2 ] ] ]
gap> TransitionFunction(M);
[ [ 2, 2, 3 ], [ 4, 5, 3 ], [ 2, 2, 3 ], [ 3, 3, 4 ], [ 4, 2, 5 ] ]
gap> T := Transducer(2, 2, [[2, 2], [3, 1], [3, 3], [5, 2], [2, 1]],
> [[[1, 0], [0, 0]], [[1], []], [[0], [1]], [[1], [1]], [[], [0, 0]]]);;
gap> M := MinimalTransducer(T);
<transducer with input alphabet on 2 symbols, output alphabet on 
2 symbols, and 3 states.>
gap> OutputFunction(M);
[ [ [ 1, 0 ], [ 0, 0 ] ], [ [ 1 ], [  ] ], [ [ 0 ], [ 1 ] ] ]
gap> TransitionFunction(M);
[ [ 2, 2 ], [ 3, 1 ], [ 3, 3 ] ]

#T# IsomorphicInitialTransducers
gap> T := Transducer(2, 3, [[1, 3], [2, 3], [3, 3]], [[[1], [2]], [[1], [2]],
> [[0, 0], [1, 0]]]);;
gap> T2 := CopyTransducerWithInitialState(T, 2);;
gap> T3 := CopyTransducerWithInitialState(T, 3);;
gap> T4 := CopyTransducerWithInitialState(T3, 3);;
gap> IsomorphicInitialTransducers(T, T2);
true
gap> IsomorphicInitialTransducers(T, T3);
false
gap> IsomorphicInitialTransducers(T, T4);
true

#T# OmegaEquivalentTransduces "="
gap> T := Transducer(2, 2, [[2, 2], [3, 1], [3, 3], [5, 2], [2, 1]],
> [[[1, 0], [0, 0]], [[1], []], [[0], [1]], [[1], [1]], [[], [0, 0]]]);;
gap> M := MinimalTransducer(T);;
gap> OmegaEquivalentTransducers(T, M);
true
gap> T = M;
true
gap> T := Transducer(2, 3, [[1, 3], [2, 3], [3, 3]], [[[1], [2]], [[1], [2]],
> [[0, 0], [1, 0]]]);;
gap> T2 := CopyTransducerWithInitialState(T, 2);;
gap> T3 := CopyTransducerWithInitialState(T, 3);;
gap> T4 := CopyTransducerWithInitialState(T3, 3);;
gap> OmegaEquivalentTransducers(T, T2);
true
gap> OmegaEquivalentTransducers(T, T3);
false
gap> OmegaEquivalentTransducers(T, T4);
true
gap> T = T4;
true
gap> T := Transducer(3, 4, [[1, 3, 2], [2, 1, 4], [1, 1, 1], [3, 2, 1]],
> [[[1], [3], [0]], [[1, 1], [], [3, 0]], [[1, 3], [2], [3, 2]],
> [[0], [0], [0]]]);;
gap> T2 := Transducer(3, 4, [[1, 2, 2], [2, 1, 4], [1, 1, 1], [3, 2, 1]],
> [[[1], [3], [0]], [[1, 1], [], [3, 0]], [[1, 3], [2], [3, 2]],
> [[0], [0], [0]]]);;
gap> OmegaEquivalentTransducers(T, T2);
false
gap> T = T2;
false

#T# EqualTransducers
gap> T := Transducer(2, 3, [[1, 3], [2, 3], [3, 3]], [[[1], [2]], [[1], [2]],
> [[0, 0], [1, 0]]]);;
gap> T2 := CopyTransducerWithInitialState(T, 2);;
gap> T3 := CopyTransducerWithInitialState(T, 3);;
gap> T4 := CopyTransducerWithInitialState(T3, 3);;
gap> EqualTransducers(T, T2);
true
gap> EqualTransducers(T, T3);
false
gap> EqualTransducers(T, T4);
false

#T# IsBijectiveTransducer
gap> T := Transducer(2, 2, [[2, 4], [3, 6], [3, 2], [5, 7], [5, 4], [6, 6],
>  [7, 7]], [[[0], []], [[0, 1], [1, 0, 1]], [[1, 1, 1], [1, 0]], [[0, 0],
>  [0, 1, 0]], [[0, 0, 0], [1, 1]], [[0], [1]], [[0], [1]]]);;
gap> IsBijectiveTransducer(T);
false
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
> [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);;
gap> IsBijectiveTransducer(f);
true
gap> T := Transducer(2, 2, [[3, 2], [4, 4], [4, 4], [4, 4]], [[[], []],
> [[0, 1], [1, 1]], [[0, 0], [1, 0]], [[0], [1]]]);;
gap> IsBijectiveTransducer(T);
true
gap> T := Transducer(2, 2, [[1, 2], [3, 4], [1, 5], [1, 6], [3, 4], [1, 6]],
> [[[0, 1, 0], []], [[1, 1], [0]], [[0, 1, 0], []], [[], [1, 0, 1, 0]],
> [[1], [0]], [[], [1, 0]]]);;
gap> IsBijectiveTransducer(T);
false
gap> T := Transducer(2, 4, [[1, 2], [1, 3], [1, 1]], [[[0], []], [[1], []],
> [[2], [3]]]);;
gap> IsBijectiveTransducer(T);
true
gap> T := Transducer(2, 2, [[3, 3], [2, 3], [3, 2]], [[[0, 1], []],
> [[1], [1, 0, 0, 1, 0, 1]], [[1, 1], [0, 1]]]);;
gap> IsBijectiveTransducer(T);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> IsBijectiveTransducer(T);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 3], [1, 3]], [[[1, 0], []], [[0],
> [1, 1]], [[0], [1]]]);;
gap> IsBijectiveTransducer(T);
true
gap> P := Transducer(2, 2, [[3, 4], [3, 2], [1, 3], [2, 4]], [[[1], [0]],
> [[], [1]], [[1], [0]], [[1, 0], [1]]]);;
gap> IsBijectiveTransducer(P);
false
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> IsBijectiveTransducer(T);
false

#T# Powers
gap> T := Transducer(2, 4, [[1, 2], [1, 3], [1, 1]], [[[0], []], [[1], []],
> [[2], [3]]]);;
gap> EqualTransducers(T^1, T);
true
gap> T^-1;
<transducer with input alphabet on 4 symbols, output alphabet on 
2 symbols, and 1 state.>
gap> T := Transducer(2, 2, [[1, 2], [1, 1]], [[[0], [1]], [[], []]]);;
gap> T2 := Transducer(2, 2, [[1, 4], [1, 3], [1, 1], [2, 2]],
> [[[0], [1]], [[], []], [[], []], [[], []]]);;
gap> EqualTransducers(T^2, T2);
true
gap> f := Transducer(3, 3, [[1, 1, 2], [1, 3, 2], [1, 1, 2]], [[[2], [0], [1]],
> [[0, 0], [], [1]], [[0, 2], [2], [0, 1]]]);;
gap> f^-3 * f^2 = f^-1;
true

#T# IsMinimalTransducer
gap> T := Transducer(3, 3, [[3, 4, 3], [1, 3, 1], [1, 3, 3], [2, 2, 3]],
> [[[2], [2], [0]], [[2, 0, 2, 1], [0, 0], []], [[], [2, 0], [1]],
> [[], [2], [1, 1, 0, 1, 0]]]);;
gap> IsMinimalTransducer(T);
true
gap> M := MinimalTransducer(T);;
gap> IsMinimalTransducer(M);
true
gap> IsMinimalTransducer(CopyTransducerWithInitialState(M, 2));
true
gap> T := Transducer(3, 3, [[3, 2, 1], [3, 3, 1], [2, 2, 1]],
> [[[1, 0], [], [0]], [[], [], [0]], [[2], [2, 2, 1], [2, 2]]]);;
gap> IsMinimalTransducer(T);
false

#
gap> STOP_TEST("aaa package: standard/toperations.tst");
