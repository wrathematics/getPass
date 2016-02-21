# getPassEnv <- new.env()

init_env <- function(envir = .GlobalEnv)
{
  if(!exists("getPassEnv", envir = envir))
    envir$getPassEnv <- new.env()

  invisible()
}


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
  else if (gui == "X11" || gui == "RTerm")
    return(TRUE)
  else if (gui == "unknown")
    what()
  else
    return(FALSE)



  Sys.getenv("RSTUDIO") != 1 &&
  Sys.getenv("R_GUI_APP_VERSION") == "" &&
  .Platform$GUI != "Rgui" &&
  ! identical(getOption("STERM"), "iESS") &&
  Sys.getenv("EMACS") != "t"
}
