readline_nomask <- function(msg, noblank, silent=FALSE)
{
  if (!silent)
    message("WARNING: your platform is not supported. Input is not masked!")
  
  message(msg, appendLF=FALSE)
  pw <- readline()
  while (interactive() && isTRUE(noblank) && pw == "")
  {
    message("No blank input, please!", appendLF=FALSE)
    pw <- readline()
  }
  
  pw
}
