#include <Rinternals.h>

#ifdef HAS_TCLTK
#include <tcl.h>
#endif

SEXP wcc_zerobuffer_tcltk(SEXP tclobj_ptr)
{
#ifdef HAS_TCLTK
  char *str;
  Tcl_Obj *obj;

  obj = (Tcl_Obj *) R_ExternalPtrAddr(tclobj_ptr);
  str = Tcl_GetStringFromObj(obj, NULL);
  // Rprintf("%s\n", str);    // for debug

  while (str[0] != '\0')
  {
    str[0] = '\0';
    str++;
  }
#endif

  return(R_NilValue);
}


SEXP wcc_zerobuffer(SEXP obj)
{
  int i;
  char *str;

  for(i = 0; i < length(obj); i++)
  {
    str = (char*) CHAR(STRING_ELT(obj, i));

    while (str[0] != '\0')
    {
      str[0] = '*';
      str++;
    }
  }

  return(R_NilValue);
}
