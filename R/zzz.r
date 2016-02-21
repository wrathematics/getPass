.onLoad <- function(libname, pkgname)
{
  test <- tryCatch(requireNamespace("tcltk", quietly=TRUE), warning=identity)
  if (!is.logical(test))
    test <- FALSE
  
  assign(".__withtcltk", test, envir=getPassEnv)
  
  invisible()
}
