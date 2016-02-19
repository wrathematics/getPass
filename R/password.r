#' Password Input
#' 
#' Masked user input (where supported; see details section) for
#' entering passwords.
#' 
#' @details
#' Masking (i.e., not displaying the password 
#' as input is provided) is supported on sevreal, but not all
#' platforms.  It is supported in RStudio, provided you
#' have a suitable version of the GUI and of the package 
#' 'rstudioapi'.  It should also work in the terminal on any
#' OS.  It is *NOT* supported in the Windows GUI RGui or on
#' the Mac GUI R.app.
#' 
#' @param query
#' The message to enter into the R session before prompting
#' for the masked input.  This can be any single string, 
#' including a "blank", namely \code{""}.
#' @param forcemask
#' Logical; should the function stop with an error if masking
#' is not supported? If \code{FALSE}, the function will default
#' to use \code{readline()} with a warning message that the
#' input is not masked, and otherwise will stop with an error.
#' 
#' @return
#' If input is provided, then that is returned. If the user cancels
#' (cancel button on RStudio or ctrl+c in the terminal), then
#' \code{NULL} is returned.
#' 
#' @examples
#' \dontrun{
#' getPass::getPass()
#' getPass::getPass("Enter the password: ")
#' }
#' 
#' @export
getPass <- function(query="PASSWORD: ", forcemask=FALSE)
{
  if (!is.character(query) || length(query) != 1)
    stop("argument 'query' must be a single string")
  if (!is.logical(forcemask) || length(forcemask) != 1 || is.na(forcemask))
    stop("argument 'forcemask' must be one of 'TRUE' or 'FALSE'")
  
  if (tolower(.Platform$GUI) == "rstudio")
    pw <- readline_masked_rstudio(query, forcemask)
  else if (.Platform$GUI == "X11" || .Platform$GUI == "RTerm")
    pw <- readline_masked_term(query)
  else if (!forcemask)
    pw <- readline_nomask(query) 
  else
    stop("Masking is not supported on your platform!")
  
  pw
}



readline_nomask <- function(query)
{
  cat("WARNING: input is not masked!\n")
  
  readline(query) 
}



readline_masked_rstudio <- function(query, forcemask)
{
  msg <- ""
  if (!get(".__withrstudioapi", env=getPassEnv) || packageVersion("rstudioapi") < 0.5)
    msg <- "For masked input with RStudio, please install the 'rstudioapi' package (>= 0.5)"
  else if (!rstudioapi::hasFun("askForPassword"))
    msg <- "Masked input is not supported in your version of RStudio; please update to version >= 0.99.879"
  
  if (msg == "")
    pw <- rstudioapi::askForPassword(query)
  else if (!forcemask)
    pw <- readline_nomask(query)
  else
    stop("Masking is not supported on your platform!")
  
  pw
}



readline_masked_term <- function(msg)
{
  ret <- .Call(getPass_readline_masked, msg)
  
  ret
}



getPassEnv <- new.env()
