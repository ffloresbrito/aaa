#############################################################################
##
#W  transducer.gd
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains functions defining a transducer, be it synchronous or
# asynchronous and operations related to transducers.

DeclareRepresentation("IsTransducer", IsComponentObjectRep and
                      IsAttributeStoringRep, ["InputAlphabet",
                                              "OutputAlphabet",
                                              "States",
                                              "TransitionFunction",
                                              "OutputFunction",
                                              "TransducerFunction"]);
DeclareOperation("Transducer", [IsPosInt, IsPosInt, IsDenseList, IsDenseList]);
