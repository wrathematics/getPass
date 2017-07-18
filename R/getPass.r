#' Password Input
#'
#' Password reader.  Like R's \code{readline()} but the user-typed input
#' text is not printed to the screen.
#' 
#' @details
#' Masking (i.e., not displaying the literal typed text
#' as input) is supported on most, but not all
#' platforms.  It is supported in RStudio, provided you
#' have a suitable version of the GUI.  It should also work in the
#' terminal on any major OS.  Finally, it will work in any environment
#' where the tcltk package is available (e.g., Windows with RGui).
#' Notably, this will not work with Emacs; passwords can be read, but
#' there will be no masking.
#' 
#' In the terminal, the maximum length for input is 255 characters.
#' Additionally, messages printed to the terminal (including the 
#' "*" masking) are printed to stderr.
#' 
#' @param msg
#' The message to enter into the R session before prompting
#' for the masked input.  This can be any single string,
#' possibly including a "blank" (\code{""}); see the \code{noblank}
#' argument.
#' @param noblank
#' Logical; should blank passwords (\code{""}) be banned?  By default,
#' they are allowed, except with RStudio where they are always banned.
#' @param forcemask
#' Logical; should the function stop with an error if masking
#' is not supported? If \code{FALSE}, the function will default
#' to use \code{readline()} with a warning message that the
#' input is not masked, and otherwise will stop with an error.
#' See the Details section for more information.
#' 
#' @return
#' If input is provided, then that is returned. If the user cancels
#' (e.g., cancel button on RStudio or ctrl+c in the terminal), then
#' \code{NULL} is returned.
#' 
#' @examples
#' \dontrun{
#' # Basic usage
#' getPass::getPass()
#' 
#' # Get password with a custom message
#' getPass::getPass("Enter the password: ")
#' }
#'
#' @export
getPass <- function(msg="PASSWORD: ", noblank=FALSE, forcemask=FALSE)
{
  if (!is.character(msg) || length(msg) != 1 || is.na(msg))
    stop("argument 'msg' must be a single string")
  if (!is.logical(noblank) || length(noblank) != 1 || is.na(noblank))
    stop("argument 'noblank' must be one of 'TRUE' or 'FALSE'")
  if (!is.logical(forcemask) || length(forcemask) != 1 || is.na(forcemask))
    stop("argument 'forcemask' must be one of 'TRUE' or 'FALSE'")
  
  if (tolower(.Platform$GUI) == "rstudio")
    pw <- readline_masked_rstudio(msg=msg, noblank=noblank, forcemask=forcemask)
  else if (isaterm())
    pw <- readline_masked_term(msg=msg, showstars=TRUE, noblank=noblank)
  else if (hastcltk())
    pw <- readline_masked_tcltk(msg=msg, noblank=noblank)
  else if (!forcemask)
    pw <- readline_nomask(msg, noblank=noblank)
  else
    stop("Masking is not supported on your platform!")
  
  
  if (is.null(pw))
    invisible()
  else
    pw
}
