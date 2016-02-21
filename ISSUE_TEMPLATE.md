If you are having issues using the package, please provide some platform information which you can determine with the following R code:

```r
# Interface
.Platform$GUI

# OS
Sys.info()["sysname"]
```


If your interface is RStudio, please provide the following additional information:

```r
# RStudio version
rstudio::versionInfo()

# rstudioapi version
packageVersion("rstudioapi")
```
