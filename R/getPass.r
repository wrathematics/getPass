#' Password Input
#'
#' Masked user input (where supported; see details section) for
#' entering passwords.
#'
#' @details
#' Masking (i.e., not displaying the password
#' as input is provided) is supported on most, but not all
#' platforms.  It is supported in RStudio, provided you
#' have a suitable version of the GUI and of the package
#' 'rstudioapi'.  It should also work in the terminal on any
#' OS.  Finally, it will work in any environment where the tcltk
#' package is available.
#'
#' In the terminal, the maximum length for input is 200 characters.
#'
#' @param msg
#' The message to enter into the R session before prompting
#' for the masked input.  This can be any single string,
#' including a "blank", namely \code{""}.
#' @param forcemask
#' Logical; should the function stop with an error if masking
#' is not supported? If \code{FALSE}, the function will default
#' to use \code{readline()} with a warning message that the
#' input is not masked, and otherwise will stop with an error.
#'
#' @return
#' If input is provided, then that is returned. If the user cancels
#' (cancel button on RStudio or ctrl+c in the terminal), then
#' \code{NULL} is returned.
#'
#' @examples
#' \dontrun{
#' getPass::getPass()
#' getPass::getPass("Enter the password: ")
#' }
#'
#' @export
getPass <- function(msg="PASSWORD: ", forcemask=FALSE)
{
  if (!is.character(msg) || length(msg) != 1)
    stop("argument 'msg' must be a single string")
  if (!is.logical(forcemask) || length(forcemask) != 1 || is.na(forcemask))
    stop("argument 'forcemask' must be one of 'TRUE' or 'FALSE'")
  
  if (tolower(.Platform$GUI) == "rstudio")
    pw <- readline_masked_rstudio(msg, forcemask)
  else if (isaterm())
    pw <- readline_masked_term(msg, showstars=TRUE)
  else if (hastcltk())
    pw <- readline_masked_tcltk(msg)
  else if (!forcemask)
    pw <- readline_nomask(msg)
  else
    stop("Masking is not supported on your platform!")
  
  pw
}



readline_nomask <- function(msg)
{
  print_stderr("WARNING: your platform is not supported. Input is not masked!\n")
  
  readline(msg)
}



readline_masked_rstudio <- function(msg, forcemask)
{
  if (!rstudioapi::hasFun("askForPassword"))
  {
    if (!forcemask)
      pw <- readline_nomask(msg)
    else
      stop("Masked input is not supported in your version of RStudio; please update to version >= 0.99.879")
  }
  else
    pw <- rstudioapi::askForPassword(msg)
  
  pw
}



readline_masked_term <- function(msg, showstars)
{
  .Call(getPass_readline_masked, msg, as.integer(showstars))
}



readline_masked_tcltk <- function(msg)
{
  tt <- tcltk::tktoplevel()
  tcltk::tktitle(tt) <- ""
  pwdvar <- tcltk::tclVar("")
  flagvar <- tcltk::tclVar(0)
  
  f1 <- tcltk::tkframe(tt)
  tcltk::tkpack(f1, side = "top")
  tcltk::tkpack(tcltk::tklabel(f1, text = msg), side = "left")
  textbox <- tcltk::tkentry(f1, textvariable = pwdvar, show = "*")
  
  
  reset <- function(){
    tcltk::tclvalue(pwdvar) <- ""
  }
  reset.but <- tcltk::tkbutton(f1, text = "Reset", command = reset)
  
  submit <- function(){
    tcltk::tclvalue(flagvar) <- 1
    tcltk::tkdestroy(tt)
  }
  
  
  tcltk::tkpack(textbox, side = "left")
  tcltk::tkbind(textbox, "<Return>", submit)
  
  submit.but <- tcltk::tkbutton(f1, text = "Submit", command = submit)
  
  tcltk::tkpack(reset.but, side = "left")
  tcltk::tkpack(submit.but, side = "right")
  
  tcltk::tkwait.window(tt)
  pw <- tcltk::tclvalue(pwdvar)
  
  flag <- tcltk::tclvalue(flagvar)
  if (flag == 0)
    pw <- NULL
  
  return(pw)
}
