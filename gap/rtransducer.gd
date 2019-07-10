DeclareRepresentation("IsRTransducer", IsComponentObjectRep and
                      IsAttributeStoringRep and IsTransducerOrRTransducer,
                                             ["InputRoots",
                                              "InputAlphabet",
					      "OutputRoots",
                                              "OutputAlphabet",
                                              "States",
                                              "TransitionFunction",
                                              "OutputFunction",
                                              "TransducerFunction"]);
DeclareOperation("RTransducer", [IsPosInt, IsPosInt, IsPosInt, IsPosInt, IsDenseList, IsDenseList]);
DeclareOperation("InputRoots", [IsRTransducer]);
DeclareOperation("OutputRoots", [IsRTransducer]);
DeclareOperation("NrInputRoots", [IsRTransducer]);
DeclareOperation("NrOutputRoots", [IsRTransducer]);
DeclareOperation("RootStates", [IsRTransducer]);
DeclareOperation("TransducerToRTransducer", [IsTransducer]);

