<!-- Release:

[![Build Status](https://travis-ci.org/TGuillerme/dispRity.svg?branch=release)](https://travis-ci.org/TGuillerme/dispRity)
[![codecov](https://codecov.io/gh/TGuillerme/dispRity/branch/release/graph/badge.svg)](https://codecov.io/gh/TGuillerme/dispRity)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![develVersion](https://img.shields.io/badge/devel%20version-1.1.0-green.svg?style=flat)](https://github.com/TGuillerme/dispRity/tree/release)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.846254.svg)](https://doi.org/10.5281/zenodo.846254)
 -->
 
Development (master):

[![Build Status](https://travis-ci.org/TGuillerme/landvR.svg?branch=master)](https://travis-ci.org/TGuillerme/landvR)
[![codecov](https://codecov.io/gh/TGuillerme/landvR/branch/master/graph/badge.svg)](https://codecov.io/gh/TGuillerme/landvR)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![develVersion](https://img.shields.io/badge/devel%20version-0.2-green.svg?style=flat)](https://github.com/TGuillerme/landvR)
[![DOI](https://zenodo.org/badge/141964125.svg)](https://zenodo.org/badge/latestdoi/141964125)

### **`landvR`** is a `R` utility package for measuring landmark variation based on [`geomorph`](https://github.com/geomorphR/geomorph) data.

<!-- <a href="https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.13022"><img src="http://tguillerme.github.io/images/OA.png" height="15" widht="15"/></a> 
Check out the [paper](https://besjournals.onlinelibrary.wiley.com/doi/abs/10.1111/2041-210X.13022) associated with this package.
 -->
## Installing `landvR`

```r
if(!require(devtools)) install.packages("devtools")
library(devtools)
install_github("TGuillerme/landvR")
library(landvR)
```

## Vignettes and manuals

A detailed vignette for performing the landmark Procrustes coordinates variation test is available [online](https://cdn.rawgit.com/TGuillerme/landvR/8a6a6bd5/inst/vignettes/Landmark_partition_test.html) or as in [Rmd](https://github.com/TGuillerme/landvR/blob/master/inst/vignettes/Landmark_partition_test.Rmd).

## Latest patch notes
* 2018/11/29 - v0.2

  * `linear.dist` function to measure linear distances between pairs of landmarks.
  * `array.to` utility function for converting `gpagen` arrays to lists or matrices.

Previous patch notes and notes for the *next version* can be seen [here](https://github.com/TGuillerme/landvR/blob/master/NEWS.md).

Authors and contributors
-------

* [Thomas Guillerme](http://tguillerme.github.io)
* [Vera Weisbecker](http://weisbeckerlab.com.au)

-------
If you are using this package, please cite the paper:

* Guillerme, T. and Weisbecker V. (**2019**). landvR: Tools for measuring landmark position variation. Zenodo. [doi:10.5281/zenodo.2620785](https://zenodo.org/record/2620785#.XKLvj6ZS8W8)
