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

DeclareOperation("InverseTransducer", [IsTransducer]);
DeclareOperation("TransducerProduct", [IsTransducer, IsTransducer]);
DeclareOperation("RemoveStatesWithIncompleteResponse", [IsTransducer]);
DeclareOperation("RemoveInaccessibleStates", [IsTransducer]);
DeclareOperation("CopyTransducerWithInitialState", [IsTransducer, IsPosInt]);
DeclareOperation("RemoveEquivalentStates", [IsTransducer]);
DeclareAttribute("IsInjectiveTransducer", IsTransducer);
DeclareAttribute("IsSurjectiveTransducer", IsTransducer);
DeclareAttribute("EqualImagePrefixes", IsTransducer);
DeclareAttribute("TransducerImageAutomaton", IsTransducer);
DeclareAttribute("TransducerConstantStateOutputs", IsTransducer);
DeclareAttribute("IsDegenerateTransducer", IsTransducer);
DeclareAttribute("CombineEquivalentStates", IsTransducer);
DeclareOperation("\*", [IsTransducer, IsTransducer]);
DeclareOperation("\^", [IsTransducer, IsPosInt]);
