### We can't run the test on Windows because we have to pipe the output into a new process and I don't think that's possible :[
if (tolower(.Platform$OS.type) == "windows"){
  invisible(TRUE)
}else{
  passpassword <- function(pw, msg="", showstars=FALSE, noblank=FALSE)
  {
    syscmd <- paste0("echo '", pw, "' | Rscript -e 'cat(getPass:::readline_masked_term(msg=", paste0("\"", msg, "\""), ",", showstars, ",", noblank, "))'")
    test <- system(syscmd, intern=TRUE)
    
    ### This seems stupid, but I don't know how else to fix it
    badptrn <- "WARNING: ignoring environment value of R_HOME"
    if (length(test) > 0 && any(grepl(test, pattern=badptrn)))
    test[-which(test == "WARNING: ignoring environment value of R_HOME")]
    else
    test
  }
  
  pw <- 'asdf'
  test <- passpassword(pw)
  stopifnot(identical(test, pw))
  
  pw.preblank <- paste0("\n\n", pw)
  test <- passpassword(pw.preblank)
  stopifnot(identical(test, character(0)))
  
  test <- passpassword(pw.preblank, noblank=TRUE)
  stopifnot(identical(test, pw))
}
