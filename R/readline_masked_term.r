readline_masked_term <- function(msg, showstars, noblank=FALSE)
{
  .Call(getPass_readline_masked, msg, as.integer(showstars), as.integer(noblank))
}
