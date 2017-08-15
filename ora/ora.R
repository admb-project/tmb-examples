### Prepare data

x <- unique(Orange$age)
y <- xtabs(circumference~as.character(Tree)+age, Orange)
y <- as.matrix(as.data.frame(as.matrix(unclass(y))))
dimnames(y) <- NULL

data <- list(x=x, y=y)
parameters <- list(phi1=200, phi2=800, phi3=400, b=rep(0,nrow(y)),
                   logSigma=0, logSigmaB=0)

### Compile model

require(TMB)
compile("ora.cpp")
dyn.load(dynlib("ora"))

### Run model

model <- MakeADFun(data, parameters, DLL="ora", random="b")
time <- system.time(fit <- nlminb(model$par, model$fn, model$gr))

best <- model$env$last.par.best
rep <- sdreport(model)

print(best)
print(rep)
print(summary(rep))

### Plot

phi1 <- best[["phi1"]]
phi2 <- best[["phi2"]]
phi3 <- best[["phi3"]]
b <- best[names(best)=="b"]
yfit <- matrix(NA_real_, nrow=5, ncol=7)
for(i in 1:5)
  yfit[i,] <- (phi1 + b[i]) / (1+exp(-(x-phi2)/phi3))
matplot(x, t(y), xlim=c(0,1.1*max(x)), ylim=c(0,1.1*max(y)), ylab="y")
matlines(x, t(yfit), lty=1)
