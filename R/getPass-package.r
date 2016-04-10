#' getPass
#'
#' A micro-package for reading "passwords", i.e.  reading
#' user input with masking, so that the input is not displayed as it 
#' is typed.  Currently we have support for RStudio, the command line
#' (every OS), and any platform where tcltk is present.
#' 
#' @references Project URL: \url{https://github.com/wrathematics/getPass}
#' @author Drew Schmidt and Wei-Chen Chen
#' 
#' @name getPass-package
#' 
#' @importFrom utils packageVersion
#' 
#' @useDynLib getPass getPass_readline_masked getPass_print_stderr
#'
#' @docType package
#' @keywords package
NULL
