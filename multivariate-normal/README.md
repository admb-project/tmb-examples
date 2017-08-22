# Multivariate Normal

## SimpleMVN1
Simulate and fit MVN data with a compound symmetric correlation structure.

See **YouTube video** link in the in the [main overview](../../..#multivariate-normal).

## SimpleMVN2
Simulate and fit MVN data with an unstructured correlation structure. Demonstrates how to keep the variance-covariance matrix positive definite by parameterizing it using the special TMB function`UNSTRUCTURED_CORR`.

The two examples introduce:
- namespace `density` to enable estimation of multivariate normal distribution parameters
- `.rows()` to extract the number of rows of a matrix
- `.cols()` to extract the number of columns of a matrix
- `.row(i)` to extract the `i`th row of a matrix
- `<<` to assign values to elements of a matrix
- typecasting to use a row of a matrix as a vector
- log transformation to keep a parameter positive
- shifted logistic transformation to keep a parameter between -1 and 1
