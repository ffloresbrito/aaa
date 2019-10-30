#
# aaa: implements algorithms for asynchronous transducers
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.0.0">
##  <!ENTITY GAPVERS "4.8.0">
##  <!ENTITY ARCHIVENAME "aaa-0.0.0">
##  <!ENTITY COPYRIGHTYEARS "2017-2018">
##  <#/GAPDoc>
SetPackageInfo( rec(

PackageName := "aaa",
Subtitle := "implements algorithms for asynchronous transducers",
Version := "0.0.0",
Date := "09/10/2019", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    IsAuthor := true,
    IsMaintainer := false,
    FirstNames := "Collin",
    LastName := "Bleak",
    WWWHome := "http://www-groups.mcs.st-andrews.ac.uk/~collin/",
    Email := "[cb211@st-andrews.ac.uk]",
    PostalAddress := "[Mathematical Institute, North Haugh, St Andrews, Fife, KY16 9SS, Scotland]",
    Place := "[St Andrews]",
    Institution := "[University of St Andrews]",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Luke",
    LastName := "Elliott",
    WWWHome := "https://le27.github.io/Luke-Elliott/",
    Email := "Y",
    PostalAddress := "Mathematical Institute, North Haugh, St Andrews, Fife, KY16 9SS, Scotland",
    Place := "St Andrews",
    Institution := "University of St Andrews",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := false,
    FirstNames := "Feyisayo",
    LastName := "Olukoya",
    WWWHome := "https://www.abdn.ac.uk/ncs/departments/mathematics/profiles/feyisayo.olukoya/",
    Email := "[feyisayo.olukoya@abdn.ac.uk]",
    PostalAddress := "[Institute of Mathematics, Aberdeen, AB24 3UE, UK]",
    Place := "[Aberdeen]",
    Institution := "[University of Aberdeen]",
  ),
  rec(
    IsAuthor := true,
    IsMaintainer := true,
    FirstNames := "Fernando",
    LastName := "Flores Brito",
    #WWWHome := TODO,
    Email := "[ffb3@st-andrews.ac.uk]",
    PostalAddress := "[Mathematical Institute, North Haugh, St Andrews, Fife, KY16 9SS, Scotland]",
    Place := "[St Andrews]",
    Institution := "[University of St Andrews]",
  ),
],

SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/le27/aaa",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
PackageWWWHome  := "https://le27.github.io/aaa/",
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "aaa",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "implements algorithms for asynchronous transducers",
),

Dependencies := rec(
  GAP := ">= 4.9",
  NeededOtherPackages := [["Automata", ">= 1.14" ], ["Digraphs", ">= 0.15.0"]],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testinstall.tst",

#Keywords := [ "TODO" ],

));


