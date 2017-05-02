#############################################################################
##
#W  woperations.gd
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains the declaration of operations that relate to words accepted
# by transducers.

DeclareOperation("IsPrefix", [IsDenseList, IsDenseList]);
DeclareOperation("Minus", [IsDenseList, IsDenseList]);
DeclareOperation("Preimage", [IsDenseList, IsPosInt, IsTransducer]);
DeclareOperation("PreimageConePrefixes", [IsDenseList, IsPosInt, IsTransducer]);
DeclareOperation("GreatestCommonPrefix", [IsDenseList]);
DeclareOperation("ImageConeLongestPrefix",
                 [IsDenseList, IsPosInt, IsTransducer]);
