## This file is free and unencumbered software released into the public domain.
## See the Unlicense specification for full details http://unlicense.org/

## Process with:
## autoconf configure.ac && autoreconf -if

AC_INIT(DESCRIPTION)

AC_CHECK_HEADERS([tcl.h], [TCL_H="yes"], [TCL_H="no"])

dnl Obtain flags from R
TCLTK_CPPFLAGS=`${R_HOME}/bin/R CMD config TCLTK_CPPFLAGS`
TCLTK_LIBS=`${R_HOME}/bin/R CMD config TCLTK_LIBS`

HAS_TCLTK=""
if test "X${TCLTK_CPPFLAGS}" != "X" -a
        "X${TCLTK_LIBS}" != "X" -a
        "X${TCL_H}" = "Xyes"; then
  HAS_TCLTK="-DHAS_TCLTK"
else
  dnl Need to get rid of NAMESPACE when there is no tcltk
  sed -i 's/import(tcltk)//' ./NAMESPACE
fi

dnl Report
echo " "
echo "******************* Results of getPass package configure ****************"
echo " "
echo ">> TCL_H = ${TCL_H}"
echo ">> TCLTK_CPPFLAGS = ${TCLTK_CPPFLAGS}"
echo ">> TCLTK_LIBS = ${TCLTK_LIBS}"
echo ">> HAS_TCLTK = ${HAS_TCLTK}"
echo " "
echo "*************************************************************************"
echo " "

dnl Start to substitute templates
AC_SUBST(HAS_TCLTK)
AC_OUTPUT(src/Makevars)
