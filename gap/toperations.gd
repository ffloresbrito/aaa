#############################################################################
##
#W  toperations.gd
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains the declaration of operations that relate to transducers.

DeclareOperation("InverseTransducer", [IsTransducerOrRTransducer]);
DeclareOperation("TransducerProduct", [IsTransducerOrRTransducer,
                                       IsTransducerOrRTransducer]);
DeclareOperation("RemoveStatesWithIncompleteResponse",
                 [IsTransducerOrRTransducer]);
DeclareOperation("RemoveInaccessibleStates", [IsTransducer]);
DeclareOperation("CopyTransducerWithInitialState", [IsTransducerOrRTransducer,
                                                    IsPosInt]);
DeclareOperation("RemoveEquivalentStates", [IsTransducer]);
DeclareAttribute("IsInjectiveTransducer", IsTransducerOrRTransducer);
DeclareAttribute("IsSurjectiveTransducer", IsTransducerOrRTransducer);
DeclareAttribute("IsBijectiveTransducer", IsTransducerOrRTransducer);
DeclareAttribute("TransducerImageAutomaton", IsTransducerOrRTransducer);
DeclareAttribute("TransducerConstantStateOutputs", IsTransducerOrRTransducer);
DeclareAttribute("IsDegenerateTransducer", IsTransducerOrRTransducer);
DeclareAttribute("IsMinimalTransducer", IsTransducerOrRTransducer);
DeclareAttribute("CombineEquivalentStates", IsTransducerOrRTransducer);
DeclareAttribute("MinimalTransducer", IsTransducerOrRTransducer);
DeclareAttribute("IsSynchronousTransducer", IsTransducer);
DeclareAttribute("IsSynchronizingTransducer", IsTransducerOrRTransducer);
DeclareAttribute("IsBisynchronizingTransducer", IsTransducer);
DeclareAttribute("IsLipschitzTransducer", IsTransducer);
DeclareAttribute("TransducerOrder", IsTransducer);
DeclareAttribute("TransducerSynchronizingLength", IsTransducerOrRTransducer);
DeclareAttribute("TransducerCore", IsTransducer);
DeclareAttribute("IsCoreTransducer", IsTransducer);
DeclareAttribute("ImageAsUnionOfCones", IsTransducer);
DeclareAttribute("HasClopenImage", IsTransducer);
DeclareAttribute("IsCompletableCore", IsTransducer);
DeclareAttribute("CoreCompletion", IsTransducer);
DeclareOperation("CoreProduct", [IsTransducer, IsTransducer]);
DeclareOperation("IsomorphicInitialTransducers", [IsTransducerOrRTransducer,
                                                  IsTransducerOrRTransducer]);
DeclareOperation("OmegaEquivalentTransducers", [IsTransducerOrRTransducer,
                                                IsTransducerOrRTransducer]);
DeclareOperation("EqualTransducers", [IsTransducer, IsTransducer]);
DeclareOperation("IsomorphicTransducers", [IsTransducer, IsTransducer]);
DeclareOperation("\*", [IsTransducerOrRTransducer, IsTransducerOrRTransducer]);
DeclareOperation("\^", [IsTransducer, IsInt]);
DeclareOperation("\^", [IsTransducer, IsTransducer]);
