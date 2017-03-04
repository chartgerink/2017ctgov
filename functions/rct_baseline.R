rct_baseline <- function(x)
{
  # 
}

rct_baseline_means <- function(
  x,
  mu,
  sigma,
  n
)
{
  diff <- x - mu
  se_m <- sigma / sqrt(n)
  
  smd <- diff / se_m
  smd2 <- sum((smd)^2)

  return(smd2)
}

rct_baseline_count <- function(){}

# Not done by Carlisle, but extension of method
rct_baseline_prop <- function(){}
