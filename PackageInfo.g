############################################################################
##
#W  PackageInfo.g
#Y  Copyright (C) 2017                               Fernando Flores Brito
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "0.0.1">
##  <!ENTITY GAPVERS "4.8.0">
##  <!ENTITY ARCHIVENAME "aaa-0.0.1">
##  <!ENTITY COPYRIGHTYEARS "2017-2018">
##  <#/GAPDoc>

BindGlobal("_RecogsFunnyNameFormatterFunction",
function(st)
  if Length(st) = 0 then
    return st;
  else
    return Concatenation(" (", st, ")");
  fi;
end);

BindGlobal("_RecogsFunnyWWWURLFunction",
function(re)
  if IsBound(re.WWWHome) then
    return re.WWWHome;
  else
    return "";
  fi;
end);

_STANDREWS := Concatenation(["Mathematical Institute, ",
                             "North Haugh, ",
                             "St Andrews, ",
                             "Fife, ",
                             "KY16 9SS, ",
                             "Scotland"]);

SetPackageInfo(rec(
PackageName := "aaa",
Subtitle := "",
Version := "0.0.1",
Date := "30/03/2017",
ArchiveFormats := ".tar.gz",

Persons := [
  rec(
    LastName      := "Flores Brito",
    FirstNames    := "F.",
    IsAuthor      := true,
    IsMaintainer  := true,
    Email         := "ffb3@st-andrews.ac.uk",
    WWWHome       := "",
    Place         := "St Andrews",
    Institution   := "University of St Andrews"),

  rec(
    LastName     := "Bleak",
    FirstNames    := "C. P.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "cb211@st-andrews.ac.uk",
    WWWHome       := "http://www-groups.mcs.st-andrews.ac.uk/~collin/",
    Place         := "St Andrews",
    Institution   := "University of St Andrews"),

  rec(
    LastName      := "Mitchell",
    FirstNames    := "J. D.",
    IsAuthor      := true,
    IsMaintainer  := false,
    Email         := "jdm3@st-and.ac.uk",
    WWWHome       := "http://www-groups.mcs.st-andrews.ac.uk/~jamesm/",
    PostalAddress := _STANDREWS,
    Place         := "St Andrews",
    Institution   := "University of St Andrews")],

Status := "deposited",

AbstractHTML :=
"""<p>The <strong class=\"pkg\">AAA</strong> package is a <strong
class=\"pkg\">GAP</strong> package containing methods for asynchronous
transducers.</p>
<p><strong class=\"pkg\">AAA</strong> contains methods not available in the
<strong class=\"pkg\">GAP</strong> library as therein only synchronous automata
are covered.</p> <p>There are methods for eliminating states of incomplete
response, remove inaccesible states, determine whether a transducer is
invertible and if it is to invert the transducer.</p>""",

PackageDoc := rec(
  BookName  := "aaa",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "aaa",
  Autoload  := true
),

Dependencies := rec(
  GAP := ">=4.8.0",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [],
  ExternalConditions := []),

BannerString := Concatenation(
  "----------------------------------------------------------------------",
  "-------\n",
  "Loading  aaa ", ~.Version, "\n",
  "by ", ~.Persons[1].FirstNames, " ", ~.Persons[1].LastName,
        " (", ~.Persons[1].WWWHome, ")\n",
  "with contributions by:\n",
  Concatenation(Concatenation(List(~.Persons{[2 .. Length(~.Persons) - 1]},
       p -> ["     ", p.FirstNames, " ", p.LastName,
       _RecogsFunnyNameFormatterFunction(
         _RecogsFunnyWWWURLFunction(p)), ",\n"]))),
  " and ", ~.Persons[Length(~.Persons)].FirstNames, " ",
  ~.Persons[Length(~.Persons)].LastName,
  _RecogsFunnyNameFormatterFunction(
    _RecogsFunnyWWWURLFunction(~.Persons[Length(~.Persons)])), ".\n",
  "-----------------------------------------------------------------------",
  "------\n"),

AvailabilityTest := ReturnTrue,

Autoload := false,
TestFile := "tst/testinstall.tst",
Keywords := []
));

MakeReadWriteGlobal("_RecogsFunnyWWWURLFunction");
MakeReadWriteGlobal("_RecogsFunnyNameFormatterFunction");
Unbind(_RecogsFunnyWWWURLFunction);
Unbind(_RecogsFunnyNameFormatterFunction);
Unbind(_STANDREWS);
