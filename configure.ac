## This file is free and unencumbered software released into the public domain.
## See the Unlicense specification for full details http://unlicense.org/

## Process with:
## autoconf configure.ac && autoreconf -if

AC_INIT(DESCRIPTION)

TCLTK_CPPFLAGS=`${R_HOME}/bin/R CMD config TCLTK_CPPFLAGS`
TCLTK_LIBS=`${R_HOME}/bin/R CMD config TCLTK_LIBS`

HAS_TCLTK=""
if test "X${TCLTK_CPPFLAGS}" != "X" -a "X${TCLTK_LIBS}" != "X"; then
  echo "${TCLTK_CPPFLAGS}"
  echo "${TCLTK_LIBS}"
  HAS_TCLTK="-DHAS_TCLTK"
else
  dnl Need to get rid of NAMESPACE when there is no tcltk
  sed -i 's/import(tcltk)//' ./NAMESPACE
fi

AC_SUBST(HAS_TCLTK)
AC_OUTPUT(src/Makevars)
