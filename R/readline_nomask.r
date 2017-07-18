readline_nomask <- function(msg, silent=FALSE)
{
  if (!silent)
    message("WARNING: your platform is not supported. Input is not masked!")
  
  message(msg, appendLF=FALSE)
  readline()
}
