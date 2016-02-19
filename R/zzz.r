.onLoad <- function(libname, pkgname)
{
  test <- requireNamespace("rstudioapi", quietly=TRUE)
  assign(".__withrstudioapi", test, envir=getPassEnv)
  
  invisible()
}
