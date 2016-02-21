.onLoad <- function(libname, pkgname)
{
  test <- requireNamespace("rstudioapi", quietly=TRUE)
  assign(".__withrstudioapi", test, envir=getPassEnv)
  
  test <- requireNamespace("tcltk", quietly=TRUE)
  assign(".__withtcltk", test, envir=getPassEnv)
  
  invisible()
}
