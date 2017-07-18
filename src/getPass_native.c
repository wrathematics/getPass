/* Automatically generated. Do not edit by hand. */

#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <stdlib.h>

extern SEXP getPass_print_stderr(SEXP msg);
extern SEXP getPass_readline_masked(SEXP msg, SEXP showstars_, SEXP noblank_);

static const R_CallMethodDef CallEntries[] = {
  {"getPass_readline_masked", (DL_FUNC) &getPass_readline_masked, 3},
  {NULL, NULL, 0}
};

void R_init_getPass(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
