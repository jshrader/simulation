
nsims <- 5000
se1 <- rep(0,nsims)
se2 <- se1
coef1 <- se1
coef2 <- se1
for(i in 1:nsims){
  x1 <- rnorm(10)
  x1 <- rep(x1,10)
  x2 <- rnorm(100)
  e <- rnorm(100,0,6)
  y1 <- x1+e
  y2 <- x2+e
  est1 <- lm(y1 ~ x1 - 1)
  est2 <- lm(y2 ~ x2 - 1)
  X1 <- model.matrix(est1)
  X2 <- model.matrix(est1)
  n <- dim(X1)[1]
  k <- dim(X1)[2]
  coef1[i] <- est1$coefficients
  coef2[i] <- est2$coefficients  
  se1[i] <- sqrt(diag(solve(crossprod(X1)) * as.numeric(crossprod(resid(est1))/(n-k))))
  se2[i] <- sqrt(diag(solve(crossprod(X2)) * as.numeric(crossprod(resid(est2))/(n-k))))
}

sig1 <- coef1/(2*se1)
sig2 <- coef2/(2*se2)
summary(sig1)
summary(sig2)
