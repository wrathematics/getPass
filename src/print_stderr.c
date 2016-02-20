#include <R.h>
#include <Rinternals.h>

#define CHARPT(x,i)	((char*)CHAR(STRING_ELT(x,i)))

SEXP getPass_print_stderr(SEXP msg)
{
  REprintf(CHARPT(msg, 0));
  
  return R_NilValue;
}
