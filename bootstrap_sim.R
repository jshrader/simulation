
n <- 30
R <- 1000
mu <- 0
sig2 <- 6

delta2 <- rep(0, R)
delta1 <- rep(0, R)
boot1 <- rep(0, R)
boot2 <- rep(0, R)
boot01 <- rep(0, R)
boot02 <- rep(0, R)
theta_hat_n <- rep(0, R)
theta_hat_b <- rep(0, R)
for(i in 1:R){
  X <- rnorm(n, mu, sig2)
  Xbar <- mean(X)
  theta_hat_n[i] <- exp(Xbar)

  sdhat <- sd(X)*theta_hat_n[i]

  delta2[i] <- theta_hat_n[i] + (n^(-1/2))*sdhat*1.96
  delta1[i] <- theta_hat_n[i] - (n^(-1/2))*sdhat*1.96

  B <- 250
  Tnb <- rep(0, B)
  for(j in 1:B){
    select <- round((n-1)*runif(n), 0) + 1
    Xb <- X[select]
    theta_hat_b[i] <- exp(mean(Xb))
    sdhat_b <- sd(Xb)*theta_hat_b[i]
    Tnb[j] <- (n^(1/2))*(theta_hat_b[i] - theta_hat_n[i])/sdhat_b
  }

  kb <- quantile(abs(Tnb), 1-0.05)
  boot2[i] <- theta_hat_b[i] + (n^(-1/2))*sdhat*kb
  boot1[i] <- theta_hat_b[i] - (n^(-1/2))*sdhat*kb

  B <- 1000
  Tnb <- rep(0, B)
  for(j in 1:B){
    select <- round((n-1)*runif(n), 0) + 1
    Xb <- X[select]
    theta_hat_b[i] <- exp(mean(Xb))
    sdhat_b <- sd(Xb)*theta_hat_b[i]
    Tnb[j] <- (n^(1/2))*(theta_hat_b[i] - theta_hat_n[i])/sdhat_b
  }

  kb <- quantile(abs(Tnb), 1-0.05)
  boot02[i] <- theta_hat_b[i] + (n^(-1/2))*sdhat*kb
  boot01[i] <- theta_hat_b[i] - (n^(-1/2))*sdhat*kb  
}
