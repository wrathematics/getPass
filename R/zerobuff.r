#' Zero Buffers
#'
#' Overwirte all characters by \code{\0}.
#' 
#' @details
#' Overwirte all characters by \code{\0}. This is a very dangeous function
#' which should be used with causion.
#' 
#' @param x
#' Character; a vector of all character elements.
#' 
#' @return
#' \code{NULL} is returned, but all \code{x} will be overwritten by \code{\0}.
#' 
#' @examples
#' \dontrun{
#' x <- c("123", "a", "ab", "abc")
#' y <- x
#' zerobuff(x)
#' print(y)
#'
#' ### zerobuff(letters)  # Don't do this. This may crash entired R.
#' }
#'
#' @export
zerobuff <- function(x)
{
  if (is.character(x))
    .Call("wcc_zerobuffer", x, PACKAGE = "getPass")
  else
    stop("x needs to be a character vector")

  return(invisible())
}
