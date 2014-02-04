# R package to create simulated data in a number of different forms.
#
# Jeff Shrader
# First version: 2013-04-04
# Time-stamp: "2013-04-14 12:51:28 jgs"
#
# TO DO:

#### Distribution helper ####
# I think there should be a way to call distributions
# as quoted names, a la 'apply', but I cannot figure
# it out, so this convenience function selects the
# appropriate distribution based on string inputs
select_dist <- function(dist='norm', prefix='r'){
  if(dist == 'norm'){
  }else if(dist == 'beta'){
  }
}


#### Data types ####
# IID
iid_data <- function(n, dist='norm', mean=0, sd=1){
  data <- rnorm(n, mean, sd)
}


# Serial/spatial correlation
corr_data <- function(n, dist='norm', mean=0, sd=1){
  
  data <- sadf
}

# Poisson process
poisson_data <- function(n, lambda=1){
  
}

# iota


#### Data structures ####
# Cross sectional/time series


## Panel data
# i is the entity index
i <- 10
# t is the time index for each entity
t <- 5
# n is the total size of the dataset
n <- i*t
nreps <- 50000

x_i_id <- c(1:n)%%i
data <- data.frame(index = c(1:n), x_i_id)
data <- data[order(data$x_i_id),]
x_t_id <- c(1:n)%%t
x_t_id <- ifelse(x_t_id == 0, t, x_t_id)
data <- cbind(data, x_t_id)


stats <- as.data.frame(matrix(rep(0, (4*nreps)), ncol=4, nrow=nreps))
names(stats) <- c('x_coef','x_se','xavg_coef','xavg_se')

for(k in 1:nreps){
  x <- rnorm(n)
  data <- cbind(data, x)
  x_avg <- c(by(data$x, data$x_t_id, mean))
  ## cor(x[1:(n-1)],x[2:n])
  ## cor(x_avg[1:(t-1)],x_avg[2:t])
  xlm <- lm(x[1:(n-1)] ~ x[2:n] - 1)
  xalm <- lm(x_avg[1:(t-1)] ~ x_avg[2:t] - 1)
  stats[k,1:2] <- summary(xlm)$coefficients[1:2]
  stats[k,3:4] <- summary(xalm)$coefficients[1:2]
  data$x <- NULL
}
stats$x_t <- stats$x_coef/(1.96*stats$x_se)
stats$xavg_t <- stats$xavg_coef/(1.96*stats$xavg_se)

mean(stats$x_coef/stats$xavg_coef)

par(mfrow=c(2,2), pch=1)
hist(stats$x_coef)
hist(stats$x_t)
hist(stats$xavg_coef[abs(stats$xavg_coef)<=5 & abs(stats$xavg_t) <= 15])
hist(stats$xavg_t[abs(stats$xavg_coef)<=5 & abs(stats$xavg_t) <= 15])

par(mfrow=c(2,1), pch=1)
plot(stats$x_coef, stats$x_t, cex=.5)
plot(stats$xavg_coef[abs(stats$xavg_coef)<=5 & abs(stats$xavg_t) <= 15], stats$xavg_t[abs(stats$xavg_coef)<=5 & abs(stats$xavg_t) <= 15], cex=.5)

quantile(stats$x_t, probs=c(0.025, 0.975))
quantile(stats$xavg_t, probs=c(0.025, 0.975))

# size


c <- rep(1, 100)
lm(c[2:100] ~ c[1:99] - 1)


                    
