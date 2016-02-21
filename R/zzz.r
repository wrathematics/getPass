.onLoad <- function(libname, pkgname)
{
  ### Preload to global environment.
  invisible(eval(parse(text = "getPass:::init_env()")))

  test <- requireNamespace("rstudioapi", quietly=TRUE)
  assign(".__withrstudioapi", test, envir=getPassEnv)
  
  test <- suppressWarnings(requireNamespace("tcltk", quietly=TRUE))
  assign(".__withtcltk", test, envir=getPassEnv)
  
  invisible()
}

