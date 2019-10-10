#
# aaa_new: implements algorithms for asynchronous transducers
#
# This file is a script which compiles the package manual.
# To complile the doc for aaa run the command AaaMakeDoc(); in gap.

PACKAGE := "aaa";
PrintTo("VERSION", PackageInfo(PACKAGE)[1].Version, "\n");
LoadPackage("GAPDoc");

_DocXMLFiles := ["main.xml",
                 "z-chap0.xml",
                 "z-chap1.xml",
                 "z-chap2.xml",
                 "z-chap3.xml",
                 "z-chap4.xml",
                 "z-chapint.xml",
                 "title.xml",
                 "toperations.xml",
                 "transducer.xml",
                 "utils.xml",
                 "woperations.xml",
                 "z-aaabib.xml",
                 "../PackageInfo.g"];

MakeGAPDocDoc(Concatenation(PackageInfo("aaa")[1]!.
                            InstallationPath, "/doc"),
              "main.xml", _DocXMLFiles, "aaa", "MathJax",
              "../../..");
CopyHTMLStyleFiles("doc");
GAPDocManualLab(PACKAGE);

QUIT;
