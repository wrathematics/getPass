readline_nomask <- function(msg, silent=FALSE)
{
  if (!silent)
    print_stderr("WARNING: your platform is not supported. Input is not masked!\n")
  
  readline(msg)
}
