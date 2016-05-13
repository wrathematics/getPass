# Event actions
tcreset <- function(){
  tcltk::tclvalue(pwdvar) <- ""
}

tcsubmit <- function(){
  tcltk::tclvalue(flagvar) <- 1
  tcltk::tkdestroy(tt)
}

tccleanup <- function(){
  tcltk::tclvalue(flagvar) <- 0
  tcltk::tkdestroy(tt)
}

readline_masked_tcltk <- function(msg)
{
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
  tcltk::tkbind(textbox, "<Return>", tcsubmit)
  if(.Platform$OS.type == "windows")
    tcltk::tkbind(textbox, "<Escape>", tccleanup)
  else
    tcltk::tkbind(textbox, "<Control-c>", tccleanup)
  
  # Buttons for submit and reset
  reset.but <- tcltk::tkbutton(f1, text = "Reset", command = tcreset)
  submit.but <- tcltk::tkbutton(f1, text = "Submit", command = tcsubmit)
  tcltk::tkpack(reset.but, side = "left")
  tcltk::tkpack(submit.but, side = "right")
  
  # Add focus
  tcltk::tkwm.minsize(tt, "300", "40")
  tcltk::tkwm.deiconify(tt)
  message("Please enter password in TK window")
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
