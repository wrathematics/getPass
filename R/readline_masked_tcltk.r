#' @importFrom utils flush.console
readline_masked_tcltk <- function(msg, noblank=FALSE)
{
  msg.console <- "Please enter password in TK window (Alt+Tab)\n"
  cat(msg.console)
  utils::flush.console()
  readline_masked_tcltk_window(msg, noblank)
}

readline_masked_tcltk_window <- function(msg, noblank=FALSE)
{
  # Add noblank to msg
  if (noblank)
    msg <- paste0(msg, "\n(no blank)")

  # Define event actions
  # (This should be in this function because window "tt" is local.)
  tcreset <- function()
  {
    tcltk::tclvalue(pwdvar) <- ""
  }
  
  tcsubmit <- function()
  {
    if (noblank && tcltk::tclvalue(pwdvar) == "")
    {
      tcltk::tkmessageBox(title = "getPass noblank = TRUE",
                          message = "No blank input please!",
                          parent = textbox)
    }
    else
    {
      tcltk::tclvalue(flagvar) <- 1
      tcltk::tkdestroy(tt)
    }
  }
  
  tccleanup <- function()
  {
    tcltk::tclvalue(flagvar) <- 0
    tcltk::tclvalue(pwdvar) <- ""    ### Zero out tcltk buffer if escape
    tcltk::tkdestroy(tt)
  }
  
  # Main window
  tt <- tcltk::tktoplevel()
  tcltk::tktitle(tt) <- "getPass input"
  pwdvar <- tcltk::tclVar("")
  flagvar <- tcltk::tclVar(0)
  
  # Main frame
  f1 <- tcltk::tkframe(tt)
  tcltk::tkpack(f1, side = "top")
  tcltk::tkpack(tcltk::tklabel(f1, text = msg), side = "left")
  
  # Main entry
  textbox <- tcltk::tkentry(f1, textvariable = pwdvar, show = "*")
  tcltk::tkpack(textbox, side = "left")
  tcltk::tkbind(textbox, "<Return>", tcsubmit)
  if (.Platform$OS.type == "windows")
    tcltk::tkbind(textbox, "<Escape>", tccleanup)
  else
    tcltk::tkbind(textbox, "<Control-c>", tccleanup)
  
  # Buttons for submit and reset
  reset.but <- tcltk::tkbutton(f1, text = "Reset", command = tcreset)
  submit.but <- tcltk::tkbutton(f1, text = "Submit", command = tcsubmit)

  tcltk::tkpack(reset.but, side = "left")
  tcltk::tkpack(submit.but, side = "right")
  
  # Add focus
  tcltk::tkwm.minsize(tt, "320", "40")
  tcltk::tkwm.deiconify(tt)
  tcltk::tkfocus(textbox)
  
  # Wait for destroy signal
  tcltk::tkwait.window(tt)
  pw <- tcltk::tclvalue(pwdvar)
  tcltk::tclvalue(pwdvar) <- ""    ### Zero out tcltk buffer

  # Check for return
  flag <- tcltk::tclvalue(flagvar)
  if (flag == 0)
    pw <- NULL
  
  ### For return
  on.exit(gc(verbose = FALSE))
  return(pw)
}

