## Serially correlated instruments
##

## Make x
p <- 2
T <- 105
x0 <- rep(0.5,p)
x <- c(x0, rep(0,T-p))
rho <- seq(1.1, (p+0.1), by=1)
rho <- 1/rho
for(i in (p+1):T){
  x[i] <- t(x[(i-p):(i-1)])%*%c(rho) + rnorm(1)
}
plot(1:T,x)
