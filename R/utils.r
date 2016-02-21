getPassEnv <- new.env()



print_stderr <- function(msg)
{
  ret <- .Call(getPass_print_stderr, msg)
  invisible(ret)
}



isaterm <- function()
{
  gui <- .Platform$GUI

  if (!isatty(stdin()))
    return(FALSE)
  # ban emacs: here and everywhere else in life
  else if (Sys.getenv("EMACS") == "t" || identical(getOption("STERM"), "iESS"))
    return(FALSE)
  else if (gui == "RTerm" || gui == "X11")
    return(TRUE)
  else if (gui == "unknown" && .Platform$OS.type == "unix" && Sys.getenv("RSTUDIO") != 1 && Sys.getenv("R_GUI_APP_VERSION") == "")
    return(TRUE) # I think?
  else
    return(FALSE)
}



hastcltk <- function()
{
  test <- tryCatch(requireNamespace("tcltk", quietly=TRUE), warning=identity)
  if (!is.logical(test))
    test <- FALSE
  
  test
}
