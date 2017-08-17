# This example shows how to estimate parameters
# of the multivariate normal distribution
library(TMB)
library(MASS) #for mvrnorm

#########################################
#Simulate data
p <- 3     # dimension of the MVN
n <- 1000  # number of observations
mu <- c(10, 20, 30)  # mean of MVN 
sd <- c(3, 2, 1)
cor <- c(0.9, 0.5, 0.1) #correspond to pairs (1,2), (1,3), (2,3) chosen arbitrarily
Sigma <- matrix(c(sd[1]*sd[1],        cor[1]*sd[2]*sd[1], cor[2]*sd[3]*sd[1],
		          cor[1]*sd[1]*sd[2], sd[2]*sd[2],        cor[3]*sd[3]*sd[2],
		          cor[2]*sd[1]*sd[3], cor[3]*sd[2]*sd[3], sd[3]*sd[3]), 
		        nrow=p, ncol=p, byrow=TRUE)  # var-cov of MVN

set.seed(1)
X <- mvrnorm(n=n, mu=mu, Sigma)
pairs(X, lower.panel=frame())

#########################################
#Organize data for TMB
data <- list(X=X)
parameters <- list(mu=rep(0,p),
				   log_sd=rep(0,p),
			       unconstrained_cor_params=rep(0, p*(p-1)/2))

#########################################
#Build and fit model
compile("simpleMVN2.cpp")
dyn.load(dynlib("simpleMVN2"))
			
model <- MakeADFun(data, parameters, DLL="simpleMVN2")
fit <- nlminb(model$par, model$fn, model$gr)

########################################
#Output section
rep <- sdreport(model)
fit$par
rep

Sigma
model$report()

