#' Password Input
#'
#' Password reader.  Like R's \code{readline()} but the user-typed input
#' text is not printed to the screen.
#' 
#' @details
#' Masking (i.e., not displaying the literal typed text
#' as input) is supported on most, but not all
#' platforms.  It is supported in RStudio, provided you
#' have a suitable version of the GUI.  It should also work in the
#' terminal on any major OS.  Finally, it will work in any environment
#' where the tcltk package is available.
#' 
#' In the terminal, the maximum length for input is 200 characters.
#' Additionally, messages printed to the terminal (including the 
#' "*" masking) are printed to stderr.
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
#' (e.g., cancel button on RStudio or ctrl+c in the terminal), then
#' \code{NULL} is returned.
#' 
#' @examples
#' \dontrun{
#' # Basic usage
#' getPass::getPass()
#' 
#' # Get password with a custom message
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



readline_nomask <- function(msg, silent=FALSE)
{
  if (!silent)
    print_stderr("WARNING: your platform is not supported. Input is not masked!\n")
  
  readline(msg)
}



readline_masked_rstudio <- function(msg, forcemask)
{
  if (!rstudioapi::hasFun("askForPassword"))
  {
    stopmsg <- "Masked input is not supported in your version of RStudio; please update to version >= 0.99.879"
    if (!forcemask)
    {
      print_stderr(paste0("NOTE: ", stopmsg, "\n"))
      pw <- readline_nomask(msg, silent=TRUE)
    }
    else
      stop(stopmsg)
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
  # Define event action
  reset <- function(){
    tcltk::tclvalue(pwdvar) <- ""
  }
  
  submit <- function(){
    tcltk::tclvalue(flagvar) <- 1
    tcltk::tkdestroy(tt)
  }
  
  cleanup <- function(){
    tcltk::tclvalue(flagvar) <- 0
    tcltk::tkdestroy(tt)
  }
  
  # Main window
  tt <- tcltk::tktoplevel()
  tcltk::tktitle(tt) <- ""
  pwdvar <- tcltk::tclVar("")
  flagvar <- tcltk::tclVar(0)
  
  # Main frame
  f1 <- tcltk::tkframe(tt)
  tcltk::tkpack(f1, side = "top")
  tcltk::tkpack(tcltk::tklabel(f1, text = msg), side = "left")
  
  # Main entry
  textbox <- tcltk::tkentry(f1, textvariable = pwdvar, show = "*")
  tcltk::tkpack(textbox, side = "left")
  tcltk::tkbind(textbox, "<Return>", submit)
  if(.Platform$OS == "windows")
    tcltk::tkbind(textbox, "<Escape>", cleanup)
  else
    tcltk::tkbind(textbox, "<Control-c>", cleanup)
  
  # Buttons for submit and reset
  reset.but <- tcltk::tkbutton(f1, text = "Reset", command = reset)
  submit.but <- tcltk::tkbutton(f1, text = "Submit", command = submit)
  tcltk::tkpack(reset.but, side = "left")
  tcltk::tkpack(submit.but, side = "right")
  
  # Add focus
  tcltk::tkwm.minsize(tt, "300", "40")
  tcltk::tkwm.deiconify(tt)
  tcltk::tkfocus(textbox)
  
  # Wait for destroy signal
  tcltk::tkwait.window(tt)
  pw <- tcltk::tclvalue(pwdvar)
  
  # Check for return
  flag <- tcltk::tclvalue(flagvar)
  if (flag == 0)
    pw <- NULL
  
  return(pw)
}
