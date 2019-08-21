#############################################################################
##
#W  transducer.gd
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains the declarations of the representation of a transducer and
# that of objects that relate to this package. The appropiate ViewObj functions
# are defined in the transducer.gi file.

IsTransducerOrRTransducer := NewFilter("IsTransducerOrRTransducer");
DeclareRepresentation("IsTransducer", IsComponentObjectRep and
                      IsAttributeStoringRep and IsTransducerOrRTransducer,
                                             ["InputAlphabet",
                                              "OutputAlphabet",
                                              "States",
                                              "TransitionFunction",
                                              "OutputFunction",
                                              "TransducerFunction"]);
DeclareOperation("Transducer", [IsPosInt, IsPosInt, IsDenseList, IsDenseList]);
DeclareOperation("TransducerFunction",
                 [IsTransducerOrRTransducer, IsDenseList, IsPosInt]);
DeclareOperation("OutputFunction", [IsTransducerOrRTransducer]);
DeclareOperation("TransitionFunction", [IsTransducerOrRTransducer]);
DeclareOperation("InputAlphabet", [IsTransducerOrRTransducer]);
DeclareOperation("OutputAlphabet", [IsTransducerOrRTransducer]);
DeclareOperation("States", [IsTransducerOrRTransducer]);
DeclareOperation("NrStates", [IsTransducerOrRTransducer]);
DeclareOperation("NrOutputSymbols", [IsTransducerOrRTransducer]);
DeclareOperation("NrInputSymbols", [IsTransducerOrRTransducer]);
DeclareOperation("IdentityTransducer", [IsPosInt]);
DeclareOperation("AlphabetChangeTransducer", [IsPosInt, IsPosInt]);
DeclareOperation("RandomTransducer", [IsPosInt, IsPosInt]);
DeclareOperation("TransducerByNumber", [IsPosInt, IsPosInt, IsPosInt]);
DeclareOperation("NumberByTransducer", [IsPosInt, IsPosInt, IsTransducer]);
DeclareOperation("NrTransducers", [IsPosInt, IsPosInt]);
DeclareOperation("DeBruijnTransducer", [IsPosInt, IsPosInt]);
DeclareOperation("BlockCodeTransducer", [IsPosInt, IsInt, IsFunction]);
DeclareOperation("ResizeZeroStringTransducer", [IsPosInt, IsPosInt, IsPosInt]);
DeclareOperation("PrimeWordSwapTransducer", [IsPosInt, IsDenseList,
                                             IsDenseList]);
DeclareOperation("Shift", [IsPosInt]);
DeclareOperation("RandomBlockCodeTransducer", [IsPosInt, IsPosInt]);
DeclareOperation("RandomBlockCodeTransducerAttempt", [IsPosInt, IsPosInt]);
DeclareOperation("AllSynchronousLn", [IsPosInt, IsPosInt]);
