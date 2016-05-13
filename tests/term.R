passpassword <- function(pw, msg="", showstars=FALSE, noblank=FALSE)
{
  syscmd <- paste0("echo '", pw, "' | Rscript -e 'cat(getPass:::readline_masked_term(msg=", paste0("\"", msg, "\""), ",", showstars, ",", noblank, "))'")
  test <- system(syscmd, intern=TRUE)
  
  test[-which(test == "WARNING: ignoring environment value of R_HOME")]
}

pw <- 'asdf'
test <- passpassword(pw)
stopifnot(identical(test, pw))

pw.preblank <- paste0("\n\n", pw)
test <- passpassword(pw.preblank)
print(test)
stopifnot(identical(test, character(0)))

test <- passpassword(pw.preblank, noblank=TRUE)
stopifnot(identical(test, pw))
