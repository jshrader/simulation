## A simple R script to simulate the effects of having an
## autocorrelated rhs variable (which is nothing).
##
## Jeff Shrader
## 2013-06-25

## Prelims
rm(list = ls())
init <- c(.5,.5,.5)
nobs <- 200

## Data
## x1 is AR(1), x2 is AR(2), x3 is AR(3)
x1 <- c(init[1], rep(0,nobs))
x2 <- c(init[1:2], rep(0,nobs))
x3 <- c(init[1:3], rep(0,nobs))
e1 <- rnorm(nobs)
e2 <- rnorm(nobs)
e3 <- rnorm(nobs)

for(i in 1:nobs){
  x1[(i+1)] <- -0.8*x1[i] + e1[i]
  x2[(i+2)] <- 0.8*x2[(i+1)] - 0.5*x2[i] + e2[i]
  x3[(i+3)] <- 0.8*x3[(i+2)] - 0.5*x3[(i+1)] + 0.2*x3[i] + e3[i]
}

x1 <- x1[2:(nobs+1)]
x2 <- x2[3:(nobs+2)]
x3 <- x3[4:(nobs+3)]
## You can see that these values are uncorrelated
cor(matrix(c(x1,x2,x3),ncol=3))

eps <- rnorm(nobs)
y <- .25*x1 + .35*x2 + .45*x3 + eps

## Testing
## The basic model fits very well
summary(lm(y ~ x1 + x2 + x3))

## Autocorrelation does not matter greatly
summary(lm(y[2:nobs] ~ x1[2:nobs] + x2[2:nobs] + x3[2:nobs] + x1[1:(nobs-1)] + x2[1:(nobs-1)] + x3[1:(nobs-1)]))
summary(lm(y[4:nobs] ~ x1[4:nobs] + x2[4:nobs] + x3[4:nobs] + x1[3:(nobs-1)] + x2[3:(nobs-1)] + x2[2:(nobs-2)] + x3[3:(nobs-1)] + x3[2:(nobs-2)] + x3[1:(nobs-3)]))

## What about misspecification?
summary(lm(y[4:nobs] ~ x1[3:(nobs-1)] + x2[3:(nobs-1)] + x2[2:(nobs-2)] + x3[3:(nobs-1)] + x3[2:(nobs-2)] + x3[1:(nobs-3)]))
