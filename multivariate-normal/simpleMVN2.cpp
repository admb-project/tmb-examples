#include <TMB.hpp>
                          
template<class Type>
Type objective_function<Type>::operator() ()
{	
	DATA_MATRIX(X);
	int n = X.rows();
	int p = X.cols();
		
	PARAMETER_VECTOR(mu);
	PARAMETER_VECTOR(log_sd);
	PARAMETER_VECTOR(unconstrained_cor_params); // dummy variables to fill correlation matrix

	vector<Type> sd = exp(log_sd);

	vector<Type> residual(p);
	
	Type neglogL = 0.0;
	
	using namespace density;
	
	for(int i=0; i<n; i++)
	{
		residual = vector<Type>(X.row(i)) - mu;
		neglogL += VECSCALE(UNSTRUCTURED_CORR(unconstrained_cor_params), sd)(residual);
	}
	
	matrix<Type> Cor(p,p);
	Cor = UNSTRUCTURED_CORR(unconstrained_cor_params).cov();
	REPORT(Cor);
	REPORT(sd);

	return neglogL;
}
