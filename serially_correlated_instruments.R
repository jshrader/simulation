## Serially correlated instruments
##
## Turns out that the general version of this is contained in Nevo and Rosen (2012)
##
## I was interested in the use of Bartik-like instruments. My
## intuition was that these instruments might generally be better
## than nothing, in that they could reduce endogeneity bias a bit.
## When I started writing things down, however, I saw that the 
## lagged instrument could make things worse. This is an exploration
## of that phenomenon.
##
## Take-aways
## 1. I get some non-monotonic behavior in the simple case of contemporaneously correlated 
## x and z (rho != 0 and rho_z = 0). The OLS bias will be higher 
## for the usual cases (omitted variable is strongly predictive of y). 
## IV bias will be high if the AR structure is long. 
library('gmm')
nsims <- 100

## Set up a function for the correlation structure between the errors and x
calcrho<-function(rho,rho1,rho2) {
  rho*(1-rho1*rho2)/sqrt((1-rho1^2)*(1-rho2^2))
}

b <- vector(mode="list", length=nsims)
biv <- vector(mode="list", length=nsims)
for(i in 1:nsims){
## Make x
p <- 2
T <- 1000
## Generate exogenous part of y
e <- rnorm(T)
## And the autocorrelated endogenous variable
x <- arima.sim(model=list(ar=c(.9,-.8,.7,-.6,.5,-.4,.3,-.2,.1)),n=T) + 5*e



 
burn.in<-300
n<-1000 
rho <- 0.8
rho1 <- 0.5
rho2 <- 0.7
q12 <- calcrho(rho,rho1,rho2)
eps <- mvrnorm(n+burn.in,mu=c(0,0),Sigma=cbind(c(1,q12),c(q12,1)))
 
x <- arima.sim(list(ar=rho1),n,innov=eps[burn.in+1:n,1],start.innov=eps[1:burn.in,1])
z <- arima.sim(list(ar=rho2),n,innov=eps[burn.in+1:n,2],start.innov=eps[1:burn.in,2])


## And the dependent variable
y <- x + 5*e + rnorm(T)
##plot(1:T,x)

## Regressions
## OLS should be positively biased
b[i] <- lm(y[1:(T-1)] ~ x[1:(T-1)])$coefficients[2]

## IV
biv[i] <- gmm(y[1:(T-1)] ~ x[1:(T-1)], x[2:(T)])$coefficients[2]
}

print(mean(sapply(b, FUN='mean')))
print(sd(sapply(b, FUN='mean')))
print(mean(sapply(biv, FUN='mean')))
print(sd(sapply(biv, FUN='mean')))
