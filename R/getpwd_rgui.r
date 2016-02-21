getpwd_rgui <- function(msg){
  if(.Platform$OS.type != "windows" && .Platform$GUI != "Rgui"){
    stop("This function is only support for windows with Rgui.")
  }

  eval(parse(text = "library('tcltk')"), envir = .GlobalEnv)
  tt <- tktoplevel()
  tktitle(tt) <- ""
  pwdvar <- tclVar("")
  flagvar <- tclVar(0)

  f1 <- tkframe(tt)
  tkpack(f1, side = "top")
  tkpack(tklabel(f1, text = msg), side = "left")
  tkpack(tkentry(f1, textvariable = pwdvar, show = "*"), side = "left")

  reset <- function(){
    tclvalue(pwdvar) <- "" 
  }
  reset.but <- tkbutton(f1, text = "Reset", command = reset)

  submit <- function(){
    tclvalue(flagvar) <- 1
    tkdestroy(tt)
  }
  submit.but <- tkbutton(f1, text = "Submit", command = submit)

  tkpack(reset.but, side = "left")
  tkpack(submit.but, side = "right")

  tkwait.window(tt)
  pwd <- tclvalue(pwdvar)
  flag <- tclvalue(flagvar)
  if(flag == 0){
    pwd <- NULL
  }
  return(pwd)
}

