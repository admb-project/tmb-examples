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
rho <- 0.5
Sigma <- matrix(c(sd[1]*sd[1],     rho*sd[2]*sd[1], rho*sd[3]*sd[1],
		          rho*sd[1]*sd[2], sd[2]*sd[2],     rho*sd[3]*sd[2],
		          rho*sd[1]*sd[3], rho*sd[2]*sd[3], sd[3]*sd[3]), 
		        nrow=p, ncol=p, byrow=TRUE)  # var-cov of MVN

set.seed(1)
X <- mvrnorm(n=n, mu=mu, Sigma)
pairs(X, lower.panel=frame())

#########################################
#Organize data for TMB
data <- list(X=X)
parameters <- list(log_sd=rep(0,p),
		           transformed_rho=0,
			       mu=rep(0,p))

#########################################
#Build and fit model
compile("simpleMVN3.cpp")
dyn.load(dynlib("simpleMVN3"))
			
model <- MakeADFun(data, parameters, DLL="simpleMVN3")
fit <- nlminb(model$par, model$fn, model$gr)

########################################
#Output section
rep <- sdreport(model)
fit$par
rep

Sigma
model$report()
