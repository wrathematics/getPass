# getPass

* **Version:** 0.1-2
* **URL**: https://github.com/wrathematics/getPass
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/getPass.png)](https://travis-ci.org/wrathematics/getPass)
* **License:** [![License](http://img.shields.io/badge/license-BSD%202--Clause-orange.svg?style=flat)](http://opensource.org/licenses/BSD-2-Clause)
* **Download:** [![Download](http://cranlogs.r-pkg.org/badges/getPass)](https://cran.r-project.org/package=getPass)
* **Author:** Drew Schmidt and Wei-Chen Chen


A micro-package for reading user input in R with masking, i.e., the input is not displayed as it is typed.

Currently, RStudio, the command line (any OS), and platforms where the **tcltk** package is available are supported.  We believe this hits just about everything, but for unsupported platforms, non-masked reading (with a warning) is optionally available.  See the package vignette for more information.



## Usage

```r
getPass::getPass()
```



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
