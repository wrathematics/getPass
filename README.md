# getPass

* **Version:** 0.1-0
* **URL**: https://github.com/wrathematics/getPass
* **License:** [![License](http://img.shields.io/badge/license-BSD%202--Clause-orange.svg?style=flat)](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt and Wei-Chen Chen


A micro-package for reading user input in R with masking, i.e., the input is not displayed as it is typed.

Currently, RStudio and the commandline are both supported.  Other GUI's such as RGui on Windows and R.app on Mac are not supported (it's not possible at this time).  For unsupported platforms, non-masked reading (with a warning) is optionally available.  See the details section of this README for more information.





## Usage

```r
getPass::getPass()
```





## Installation

The package is not yet available on CRAN.

The development version is maintained on GitHub, and can easily be installed by any of the packages that offer installations from GitHub:

```r
### Pick your preference
devtools::install_github("wrathematics/getPass")
ghit::install_github("wrathematics/getPass")
remotes::install_github("wrathematics/getPass")
```





## Details

#### RStudio
To use this with RStudio, you need:

* RStudio desktop version >= 0.99.879.
* The rstudioapi package version >= 0.5.

In this case, the `getPass()` function wraps the **rstudioapi** function `askForPassword()`.

#### Command Line
Here, the input reader is custom.  It has been tested successfully on Windows (in the "RTerm" session), Mac (in the terminal, not R.app which will not work!), and Linux.  The maximum length for a password in this case is 200 characters.

On Windows, the reader is just `_getch()`.  On 'nix environments (Mac, Linux, ...), masking is made possible via `tcsetattr()`.  Special handling for each is provided for handling ctrl+c and backspace.

If you discover an issue, please [file an issue report](https://github.com/wrathematics/getPass/issues).

#### Unsupported Platforms

When a platform is unsupported, the function will optionally default to use R's `readline()` (without masking!) with a warning communicated to the user, or it can stop with an error.





## Acknowledgements

We thank Kevin Ushey for his assistance in answering questions in regard to supporting RStudio.

The development for this package was supported in part by the project *Harnessing Scalable Libraries for Statistical Computing on Modern Architectures and Bringing Statistics to Large Scale Computing* funded by the National Science Foundation Division of Mathematical Sciences under Grant No. 1418195.

Any opinions, findings, and conclusions or recommendations expressed in this material are those of the authors and do not necessarily reflect the views of the National Science Foundation.
