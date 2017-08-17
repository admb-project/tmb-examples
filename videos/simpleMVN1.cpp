#include <TMB.hpp>                                

template<class Type>
Type objective_function<Type>::operator() ()
{	
	DATA_MATRIX(X);
	int n = X.rows();
	int p = X.cols();
	
	PARAMETER_VECTOR(mu);
	PARAMETER_VECTOR(log_sd);
	PARAMETER(transformed_rho);
	
	vector<Type> sd = exp(log_sd);
	Type rho = 2.0 / (1.0 + exp(-transformed_rho)) - 1.0;
	matrix<Type> Sigma(p,p);
	Sigma.row(0) << sd[0]*sd[0],     sd[1]*sd[0]*rho, sd[2]*sd[0]*rho;
	Sigma.row(1) << sd[0]*sd[1]*rho, sd[1]*sd[1],     sd[2]*sd[1]*rho;
	Sigma.row(2) << sd[0]*sd[2]*rho, sd[1]*sd[2]*rho, sd[2]*sd[2];
	
	vector<Type> residual(p);
	
	Type neglogL = 0.0;
	
	using namespace density;
	MVNORM_t<Type> neg_log_dmvnorm(Sigma);
	
	for(int i=0; i<n; i++)
	{
		residual = vector<Type>(X.row(i)) - mu;
		neglogL += neg_log_dmvnorm(residual);
		//neglogL += MVNORM(Sigma)(residual);
	}
	
	REPORT(Sigma);
	REPORT(sd);
	REPORT(rho);
	
	return neglogL;
}
