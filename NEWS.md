----
<!-- * 2017/10/18 - v1.0 *got you covered*  -->

<!-- 
dispRity 0.2.0 (2016-04-01)
=========================

### NEW FEATURES

  * Blabla

### MINOR IMPROVEMENTS

  * Blabla

### BUG FIXES

  * Blabla

### DEPRECATED AND DEFUNCT

  * Blabla
 -->
landvR v0.5.2 (1-07-29)
=========================

## NEW FEATURES

 * `prop.part.names`: a function for getting names of species within clades (with `inc.nodes` option).
 * `rarefy.stat`: a function for rarefying statistics.
 * `slope.diff`: a function for measuring slope differences. 
 * *New argument* in `procrustes.var.plot`: `col.range` now allows to attribute a range for the color gradient, allowing the color gradients to be absolute (previously they were only relative to the input data - suggest by [Pietro Viacava](https://github.com/pietroviama)).

## MINOR IMPROVEMENTS

 * `coordinates.difference` now has a `rounding` tolerance argument for rounding values (suggested by [Ellen Coombs](https://twitter.com/EllenCoombs)). Also, the function can not produce infinite angles anymore (`NaN` are replaced by `0`).
 * `variation.range` can now take an `"array"` as the `procrustes` argument.
 * `"mshape"` objects are now automatically coerced as `"matrix"` in `coordinates.difference`.
 * Improved test coverage.
 * Added a `lwd` argument to `procrustes.var.plot` (suggested by [Pietro Viacava](https://www.researchgate.net/profile/Pietro-Viacava))


landvR v0.2 (2019-02-05)
=========================

### NEW FEATURES

  * `linear.dist` function to measure linear distances between pairs of landmarks.
  * `array.to` utility function for converting `gpagen` arrays to lists or matrices.

### BUG FIXES

  * correct CI selection in `variation.range` when using `ordination = TRUE`.


landvR v0.1 (2018-07-23)
=========================

### NEW FEATURES

  * First release!
