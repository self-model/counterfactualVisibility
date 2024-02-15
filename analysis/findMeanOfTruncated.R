x = seq(0,2,0.0001)
mu = 0
sd = 0.05


get_mean <- function(x,mu,sd) {
  density=dnorm(x,mean=mu,sd=sd)
  return(sum(x*density)/sum(density))
}

# fit mean given sd
df <- data.frame(guess = seq(-.03,0.03,0.0001))%>%
  rowwise()%>%
  mutate(mean = get_mean(x,guess,sd),
         diff=abs(mean-0.03))

df%>%ungroup%>%slice(which.min(diff))


#fit sd given mean=0
df <- data.frame(guess = seq(0.001,0.05,0.0001))%>%
  rowwise()%>%
  mutate(mean = get_mean(x,0,guess),
         diff=abs(mean-0.03))

df%>%ungroup%>%slice(which.min(diff))