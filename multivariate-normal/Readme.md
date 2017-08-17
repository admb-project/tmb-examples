# Multivariate Normal

##SimpleMVN1 
This example simulates and fits MVN data with a compound symmetric correlation structure.

##SimpleMVN2
This example simulates and fits MVN data with an unstructured correlation structure. It demonstrates how to keep the variance-covariance matrix positive definite by parameterizing it using the special TMB function`UNSTRUCTURED_CORR`.

The two examples introduce the following
 - namespace `density` to enable estimation  of multivariate normal distribution parameters
 - `.rows()` to extract the number of rows of a matrix
 - `.cols()` to extract the number of columns of a matrix
 - `.row(i)` to extract the `i`th row of a matrix
 - typecasting to use a row of a matrix as a vector
 - `<<` to assign values to elements of a matrix
 - the log transformation to keep a parameter positive
 - the shifted logistic transformation to keep a parameter between -1 and 1 