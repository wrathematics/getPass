readline_masked_rstudio <- function(msg, forcemask, noblank=FALSE)
{
  if (noblank)
  {
    while (TRUE)
    {
      pw <- readline_masked_rstudio_window(msg, forcemask)
      if (is.null(pw) || pw != "")
        break
    }
  }
  else
    pw <- readline_masked_rstudio_window(msg, forcemask)
  
  pw
}

readline_masked_rstudio_window <- function(msg, forcemask)
{
  if (!rstudioapi::hasFun("askForPassword"))
  {
    stopmsg <- "Masked input is not supported in your version of RStudio; please update to version >= 0.99.879"
    if (!forcemask)
    {
      message(paste0("NOTE: ", stopmsg, "\n"))
      pw <- readline_nomask(msg, silent=TRUE)
    }
    else
      stop(stopmsg)
  }
  else
    pw <- rstudioapi::askForPassword(msg)
  
  pw
}
