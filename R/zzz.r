.onLoad <- function(libname, pkgname)
{
  test <- requireNamespace("tcltk", quietly=TRUE)
  assign(".__withtcltk", test, envir=getPassEnv)

  invisible()
}

