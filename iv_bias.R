# R program to explore the role of instrument number on bias
# in a linear IV model
#
# Jeff Shrader
# Time-stamp: "2012-12-08 01:03:39 jeff"
# First version: 2012-12-07
#

# Model set-up
num_obs <- 1000
u <- rnorm(num_obs)
x_c <- rnorm(num_obs)
x <- x_c + u
y <- 2*x + u

# OLS is biased upward, as we would expect:
biased_res <- lm(y ~ x - 1)
biased_res$coefficients

# Create instruments
z <- x_c + rnorm(num_obs)

# TSLS
first <- lm(x ~ z - 1)
x_hat <- z*first$coefficients
second <- lm(y ~ x_hat - 1)

# Yay! It worked.

# Now let's make lots of instruments
num_z <- 1000
coeffs <- rep(0, num_z)
rsq_first <- rep(0, num_z)
for(i in 1:num_z){
  Z <- matrix(rep(x_c,i) + rnorm(i*num_obs), ncol=i, nrow=num_obs)
  first <- lm(x ~ Z - 1)
  rsq_first[i] <- summary(first)$r.squared
  x_hat <- Z%*%first$coefficients
  second <- lm(y ~ x_hat - 1)
  coeffs[i] <- second$coefficients
}
plot(1:801, c(coeffs[1:800], 2.5), col="white",
     main="Bias of IV estimate approaches OLS",
     xlab="Number of IVs",
     ylab="2SLS Coefficient Estimate")
points(1:801, c(coeffs[1:800], coeffs[800]))
abline(a=2, b=0, col="blue")
abline(a=2.5, b=0, col="red")

# Does adding IV improve LATE


