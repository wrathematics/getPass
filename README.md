# getPass

* **Version:** 0.2-3
* **URL**: https://github.com/wrathematics/getPass
* **License:** [BSD 2-Clause](https://opensource.org/license/bsd-2-clause/)
* **Author:** Drew Schmidt and Wei-Chen Chen


**getPass** is an R package for reading user input with masking, i.e., the input is not displayed as it is typed.  This is obviously ideal for entering passwords.  There is also a secure password hashing function included; see the package vignette for more information.

Currently, RStudio, the command line (any OS), and platforms where the **tcltk** package is available are supported.  We believe this hits just about everything, but for unsupported platforms, non-masked reading (with a warning) is optionally available.  See the package vignette for more information.  You can view the vignette by entering:

```r
vignette("getPass", package="getPass")
```

into your R session.



## Installation

You can install the stable version from CRAN using the usual `install.packages()`:

```r
install.packages("getPass")
```

The development version is maintained on GitHub, and can easily be installed by any of the packages that offer installations from GitHub:

```r
### Pick your preference
devtools::install_github("wrathematics/getPass")
ghit::install_github("wrathematics/getPass")
remotes::install_github("wrathematics/getPass")
```



## Usage

```r
getPass::getPass()
```

or

```r
library(getPass)
getPass()
```

The function has several options available.  See `?getPass` for more information.
