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

  gui <- .Platform$GUI

  if (tolower(gui) == "rstudio")
    pw <- readline_masked_rstudio(msg, forcemask)
  else if (gui == "X11" || gui == "RTerm")
    pw <- readline_masked_term(msg, showstars=TRUE)
  else if (get(".__withtcltk", envir=getPassEnv))
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
  stopmsg <- ""
  if (!get(".__withrstudioapi", envir=getPassEnv) || packageVersion("rstudioapi") < 0.5)
    stopmsg <- "For masked input with RStudio, please install the 'rstudioapi' package (>= 0.5)"
  else if (!rstudioapi::hasFun("askForPassword"))
    stopmsg <- "Masked input is not supported in your version of RStudio; please update to version >= 0.99.879"

  if (stopmsg == "")
    pw <- rstudioapi::askForPassword(msg)
  else if (!forcemask)
    pw <- readline_nomask(msg)
  else
    stop(stopmsg)

  pw
}



readline_masked_term <- function(msg, showstars)
{
  .Call(getPass_readline_masked, msg, as.integer(showstars))
}



readline_masked_tcltk <- function(msg)
{

  if(get(".__withtcltk", envir=getPassEnv))
    eval(parse(text = "require(tcltk, quietly = TRUE)"))
  else
    stop("tcltk is not available.")

  tt <- tktoplevel()
  tktitle(tt) <- ""
  pwdvar <- tclVar("")
  flagvar <- tclVar(0)

  f1 <- tkframe(tt)
  tkpack(f1, side = "top")
  tkpack(tklabel(f1, text = msg), side = "left")
  textbox <- tkentry(f1, textvariable = pwdvar, show = "*")


  reset <- function(){
    tclvalue(pwdvar) <- ""
  }
  reset.but <- tkbutton(f1, text = "Reset", command = reset)

  submit <- function(){
    tclvalue(flagvar) <- 1
    tkdestroy(tt)
  }


  tkpack(textbox, side = "left")
  tkbind(textbox, "<Return>", submit)

  submit.but <- tkbutton(f1, text = "Submit", command = submit)

  tkpack(reset.but, side = "left")
  tkpack(submit.but, side = "right")

  tkwait.window(tt)
  pw <- tclvalue(pwdvar)

  flag <- tclvalue(flagvar)
  if(flag == 0)
    pw <- NULL

  return(pw)
}
