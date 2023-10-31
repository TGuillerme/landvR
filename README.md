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
[![develVersion](https://img.shields.io/badge/devel%20version-0.3-green.svg?style=flat)](https://github.com/TGuillerme/landvR)
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

The packages comes with several vignettes (some of them are still drafts) on:

 * How to perform the landmark Procrustes coordinates variation test: [online](https://raw.githack.com/TGuillerme/landvR/master/inst/vignettes/Landmark_partition_test.html) or in [Rmd](https://github.com/TGuillerme/landvR/blob/master/inst/vignettes/Landmark_partition_test.Rmd).

 * Some different systems for looking at landmark variation (displacement): [online](https://raw.githack.com/TGuillerme/landvR/master/inst/vignettes/Landmark_variation_differences.html) or in [Rmd](https://github.com/TGuillerme/landvR/blob/master/inst/vignettes/Landmark_variation_differences.Rmd).

 * Using landmark variation area as an alternative approach to Procrustes distance: [online](https://raw.githack.com/TGuillerme/landvR/master/inst/vignettes/Procrustes_dist_vs_landmark_integral.html) or in [Rmd](https://github.com/TGuillerme/landvR/blob/master/inst/vignettes/Procrustes_dist_vs_landmark_integral.Rmd).

 * How to rarefy a statistical test along a phylogeny: [online](https://raw.githack.com/TGuillerme/landvR/master/inst/vignettes/rarefy_regressions.html) or in [Rmd](https://github.com/TGuillerme/landvR/blob/master/inst/vignettes/rarefy_regressions.Rmd).


## Latest patch notes
* 2019/10/28 - v0.4

 * `prop.part.names`: a function for getting names of species within clades.
 * `rarefy.stat`: a function for rarefying statistics.

Previous patch notes and notes for the *next version* can be seen [here](https://github.com/TGuillerme/landvR/blob/master/NEWS.md).

Authors and contributors
-------

* [Thomas Guillerme](http://tguillerme.github.io)
* [Vera Weisbecker](http://weisbeckerlab.com.au)
* [Ariel Marcy](https://github.com/miracleray/)

-------
If you are using this package, please cite the paper:

* Guillerme, T and Weisbecker V (**2019**). landvR: Tools for measuring landmark position variation. Zenodo. [doi:10.5281/zenodo.2620785](https://zenodo.org/record/2620785#.XKLvj6ZS8W8)
    ##### [BibTeX](https://zenodo.org/record/2620785/export/hx), [CSL](https://zenodo.org/record/2620785/export/csl), [DataCite](https://zenodo.org/record/2620785/export/dcite3), [Dublin core](https://zenodo.org/record/2620785/export/xd), [Mendeley](https://www.mendeley.com/import/?url=https://zenodo.org/record/2620785), [more...](https://zenodo.org/record/2620785/#.XTpLtlBS8W8)


If you are using the landmark variation test, please cite the paper:

* Weisbecker, V, Guillerme, T, Speck, C, Sherratt, E, Mehari Abraha, H, Sharp, AC, Terhune, CE, Collins, S, Johnston, S, Panagiotopoulou, O. (**2019**) Individual variation of the masticatory system dominates 3D skull shape in the herbivory-adapted marsupial wombats. *Frontiers in Zoology*, 16, 41. [10.1186/s12983-019-0338-5](https://frontiersinzoology.biomedcentral.com/articles/10.1186/s12983-019-0338-5)
    ##### [RIS](https://frontiersinzoology.biomedcentral.com/articles/10.1186/s12983-019-0338-5.ris), [more...](https://frontiersinzoology.biomedcentral.com/articles/10.1186/s12983-019-0338-5#citeas)
    
    
You can find a list of papers that cited `landvR` and got picked by google scholar [here](https://scholar.google.co.uk/scholar?oi=bibs&hl=en&cites=3216410024546316584&as_sdt=5).
