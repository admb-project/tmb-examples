#include <TMB.hpp>

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(x);    // length n
  DATA_ARRAY(y);     // dimensions M x n
  int M = y.dim[0];  // number of individuals
  int n = y.dim[1];  // number of time steps

  PARAMETER(phi1);
  PARAMETER(phi2);
  PARAMETER(phi3);
  PARAMETER_VECTOR(b);  // length M
  PARAMETER(logSigma);
  PARAMETER(logSigmaB);
  Type sigma = exp(logSigma);
  Type sigmaB = exp(logSigmaB);
  matrix<Type> yfit(M,n);
  Type jnll = 0.0;

  for (int i=0; i<M; i++)  // individuals
  {
    for (int j=0; j<n; j++)  // time steps
    {
      yfit(i,j) = (phi1 + b(i)) / (1.0 + exp(-(x(j)-phi2)/phi3));
      jnll += -dnorm(y(i,j), yfit(i,j), sigma, true);
    }
  }
  jnll += -sum(dnorm(b, Type(0.0), sigmaB, true));

  ADREPORT(sigma);
  ADREPORT(sigmaB);

  return jnll;
}
