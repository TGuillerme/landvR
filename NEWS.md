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

landvR v0.3 (2019-09-02)
=========================

## NEW FEATURES

 * *New argument* in `procrustes.var.plot`: `col.range` now allows to attribute a range for the color gradient, allowing the color gradients to be absolute (previously they were only relative to the input data - suggest by [Pietro Viacava](https://github.com/pietroviama)).

## MINOR IMPROVEMENTS

 * `coordinates.difference` now has a `rounding` tolerance argument for rounding values (suggest by [Ellen Coombs](https://twitter.com/EllenCoombs)). Also, the function can not produce infinite angles anymore (`NaN` are replaced by `0`).



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
