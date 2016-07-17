## This file is free and unencumbered software released into the public domain.
## See the Unlicense specification for full details http://unlicense.org/

## Process with:
## autoconf configure.ac && autoreconf -if

AC_INIT(DESCRIPTION)

TCLTK_CPPFLAGS=`${R_HOME}/bin/R CMD config TCLTK_CPPFLAGS`
TCLTK_LIBS=`${R_HOME}/bin/R CMD config TCLTK_LIBS`

HAS_TCLTK=""
if test "X$TCLTK_CPPFLAGS" != "X" -a "X$TCLTK_CPPFLAGS" = "X"; then
  HAS_TCLTK="-DHAS_TCLTK"
if

AC_SUBST(HAS_TCLTK)
AC_OUTPUT(src/Makevars)

