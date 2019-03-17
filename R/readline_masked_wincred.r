readline_masked_wincred = function(msg, noblank=FALSE)
{
  if (os_windows())
  {
    if (.Platform$r_arch ==  "i386")
      path_rel = "bin32/"
    else
      path_rel = "bin64/"
    
    file = system.file(paste0(path_rel, "getPass.exe"), package="getPass")
    if (file == "")
      stop("could not find getPass.exe")
    
    msg = paste0(noblank, " ", "\"", msg, "\"")
    # system2(file, msg, stdout=TRUE)

    cmd <- paste0(file, " ", msg)
    shell(cmd, intern = TRUE)
  }
  else
    stop("readline_masked_wincred() can only be called from a windows host")
}
