#' getPass
#'
#' A micro-package for reading user input with masking, i.e.,
#' the input is not displayed as it is typed.  Currently the only
#' supported GUI is a very recent version of RStudio.  Running
#' from the command line is supported on every major OS.
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
