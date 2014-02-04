# True model: there is one place along the closeness dimension
# where there is a change in productivity.

rm(list = ls())
library("ggplot2")
library(arm)

N <- 100
reps <- 100
breaks <- 11
br.l <- c(0.3, 0.35, 0.4, 0.45, 0.475, 0.5, 0.525, 0.55, 0.6, 0.65, 0.7)
  
lm.coef <- as.data.frame(matrix(rep(0, breaks*reps), ncol=breaks, nrow=reps))
lm.se <- as.data.frame(matrix(rep(0, breaks*reps), ncol=breaks, nrow=reps))

for(i in 1:reps){
  e <- rnorm(N)*1
  close <- runif(N) #rnorm(N) + c(rep(0,floor(N/2)), rep(1,ceiling(N/2)))
  x <- list()

  for(j in 1:breaks){
    x[[j]] <- ifelse(close < br.l[j], -.5, .5)
  }
  y <- x[[6]] + e
  for(j in 1:breaks){
    lm <- display(lm(y~x[[j]]))
    lm.coef[i, j] <- as.numeric(lm$coef[2])
    lm.se[i, j] <- as.numeric(lm$se[2])    
  }
}
lm.data <- data.frame(lm.coef, lm.se)
names(lm.data) <- c("coef3","coef35","coef4","coef45","coef475","coef5","coef525","coef55","coef6","coef65","coef7","se3","se35","se4","se45","se475","se5","se525","se55","se6","se65","se7")
names(lm.coef) <- c("coef3","coef35","coef4","coef45","coef475","coef5","coef525","coef55","coef6","coef65","coef7")
names(lm.se) <- c("se3","se35","se4","se45","se475","se5","se525","se55","se6","se65","se7")
c.r <- reshape(lm.coef, direction="long", varying=list(1:11))
s.r <- reshape(lm.se, direction="long", varying=list(1:11))
d.r <- merge(c.r, s.r, by=(c("time","id")))

write.csv(lm.data, file="break_test.csv")




size <- 10
reps <- 4

lm <- list()
t.t <- rep(0,reps)
s.t <- t.t
l.t <- t.t
l.f <- t.t

j <- 1
for(i in 1:reps){
  e <- rnorm(size)*7
  x1 <- rnorm(size)
  x2 <- rnorm(size)
  x3 <- rnorm(size)
  y <- x1 + x2 + x3 + x1*x2 + x2*x3 + e

  lm_true <- lm(y ~ x1 + x2 + x3 + x1*x2 + x2*x3)
  lm[[j]][1] <- lm_true
  t.t[j] <- summary(lm_true)$coefficients[5,3]
  
  lm_small <- lm(y ~ x1 + x2 + x3 + x1*x2)
  lm[[j]][2] <- lm_small
  s.t[j] <- summary(lm_small)$coefficients[5,3]  

  lm_large <- lm(y ~ x1 + x2 + x3 + x1*x2 + x2*x3 + x1*x3)
  lm[[j]][3] <- lm_large
  l.t[j] <- summary(lm_large)$coefficients[5,3]
  l.f[j] <- summary(lm_large)$coefficients[7,3]
  j <- j + 1
}

t <- c(t.t, s.t, l.t)
fac <- c(rep("true",reps), rep("small",reps), rep("large",reps))
t.data.clean <- data.frame(t, fac)

t.t <- rep(0,reps)
s.t <- t.t
l.t <- t.t
l.f <- t.t

j <- 1
for(i in 1:reps){
  e <- rnorm(size)*7
  x1 <- rnorm(size)
  x2 <- c(x1[1:200],rnorm(800))
  x3 <- c(x1[1:800],rnorm(200))
  y <- x1 + x2 + x3 + x1*x2 + x2*x3 + e

  lm_true <- lm(y ~ x1 + x2 + x3 + x1*x2 + x2*x3)
  #true[[j]] <- c(summary(lm_true)$coefficients[,1],summary(lm_true)$coefficients[,3])
  t.t[j] <- summary(lm_true)$coefficients[5,3]
  
  lm_small <- lm(y ~ x1 + x2 + x3 + x1*x2)
  #small[[j]] <- c(summary(lm_small)$coefficients[,1],summary(lm_small)$coefficients[,3])
  s.t[j] <- summary(lm_small)$coefficients[5,3]  

  lm_large <- lm(y ~ x1 + x2 + x3 + x1*x2 + x2*x3 + x1*x3)
  #large[[j]] <- c(summary(lm_large)$coefficients[,1],summary(lm_large)$coefficients[,3])
  l.t[j] <- summary(lm_large)$coefficients[5,3]
  l.f[j] <- summary(lm_large)$coefficients[7,3]
  j <- j + 1
}

t <- c(t.t, s.t, l.t)
fac <- c(rep("true",reps), rep("small",reps), rep("large",reps))
t.data.cor <- data.frame(t, fac)

## Plot the densities of each t stat. If all is good, they should be on top of each other
qplot(t, color=factor(fac), data=t.data.cor, geom="density")
## Proper size?
quantile(t.t, c(0.025, 0.05, 0.095, 0.0975))
