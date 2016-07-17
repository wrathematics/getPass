#include <Rinternals.h>

#ifdef HAS_TCLTK_
#include <tcl.h>
#endif

SEXP wcc_zerobuffer(SEXP args)
{
#ifdef HAS_TCLTK_
  char *str;
  Tcl_Obj *obj;

  obj = (Tcl_Obj *) R_ExternalPtrAddr(CADR(args));
  str = Tcl_GetStringFromObj(obj, NULL);

  while (str[0] != '\0')
  {
    str[0] = '\0';
    str++;
  }
#endif

  return(R_NilValue);
}

