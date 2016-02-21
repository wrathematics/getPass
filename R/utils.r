getPassEnv <- new.env()



print_stderr <- function(msg)
{
  ret <- .Call(getPass_print_stderr, msg)
  invisible(ret)
}
