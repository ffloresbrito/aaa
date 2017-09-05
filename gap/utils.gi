#############################################################################
##
#W  utils.gi
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# This file contains utility functions.

InstallGlobalFunction(AaaMakeDoc,
function()
  MakeGAPDocDoc(Concatenation(PackageInfo("aaa")[1]!.InstallationPath, "/doc"),
                "main.xml", ["../PackageInfo.g",
                             "transducer.xml",
                             "toperations.xml",
                             "utils.xml",
                             "woperations.xml"], "aaa", "MathJax", "../../..");
  return;
end);

