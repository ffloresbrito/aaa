#############################################################################
##
#W  woperations.gd
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains operations that relate to words accepted by transducers

DeclareOperation("IsPrefix", [IsDenseList, IsDenseList]);
DeclareOperation("Minus", [IsDenseList, IsDenseList]);
DeclareOperation("Preimage", [IsDenseList, IsPosInt, IsTransducer]);
