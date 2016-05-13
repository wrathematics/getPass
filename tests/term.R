passpassword <- function(pw, msg="", showstars=FALSE, noblank=FALSE)
{
  system(paste0("echo '", pw, "' | Rscript -e 'cat(getPass:::readline_masked_term(msg=", paste0("\"", msg, "\""), ",", showstars, ",", noblank, "))'"), intern=TRUE)
}

pw <- 'asdf'
test <- passpassword(pw)
stopifnot(identical(test, pw))

pw.preblank <- paste0("\n\n", pw)
test <- passpassword(pw.preblank)
stopifnot(identical(test, character(0)))

test <- passpassword(pw.preblank, noblank=TRUE)
stopifnot(identical(test, pw))
