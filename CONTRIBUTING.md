# How to Contribute

If you're reading this and thinking of contributing, first, thanks so much! All contributions big and small are welcome. This document is a set of guidelines (not firm rules) to help the process.

Thanks!


## Reporting a Bug or Requesting a Feature
Please open an issue at the project repository's issue tracker on GitHub.  If there is already an open issue describing your problem/request, feel free to join the discussion inside the existing issue, but please do not open a new one.


## Submitting Changes
You can submit a pull request (PR) to the project repository on GitHub. Please try to keep PR's as "small" as possible (don't try to combine several large changes into one PR).

For small changes, the log can be simple, e.g. "fixed a typo". For large commits, make sure to give a reasonably detailed description of the change(s) (this can easily be the line for the `ChangeLog`; see section below).

If the project uses a continuous integration (CI) service, then the PR must pass CI before it will be merged.


## Coding Conventions
For both C and R code, please use the following conventions:

  * Indent using two spaces.
  * Use the [Allman](https://en.wikipedia.org/wiki/Indent_style#Allman_style) control statement style.  Do not use braces (but do indent) for one liners following a control statement.
  * Always put spaces after commas and around operators. So for example, use `foo(a, b, c)` not `foo(a,b,c)`; and use `x += 1` not `x+=1`.
  * If you create new functionality (new function, new arguments to an old function), add or expand a test in the `tests/` sub-tree.
  * The `master` branch of this repository should always pass `R CME check --as-cran` with no NOTEs and no WARNINGs.
  * Update the `ChangeLog` file in the root of this directory explainng what you did, and end the line with your initials or full name.  For example:
  ```
  Fixed a memory leak in src/foo.c. (ABC)
  ```


## Copyright
This document is released as [CC0, public domain](https://creativecommons.org/choose/zero/). Feel free to re-use as much of this as you like with or without attribution if you find the template useful.
