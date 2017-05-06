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
DeclareOperation("ChangeInitialState", [IsTransducer, IsPosInt]);
DeclareOperation("ReducedTransducer", [IsTransducer]);
