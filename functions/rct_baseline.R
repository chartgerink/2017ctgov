rct_baseline <- function(x)
{
  # 
}

rct_baseline_ctgov <- function(x)
{
  tot_n <- find_n(x)
  interim <- plyr::ddply(x, .(title, sub_title, units, param), function(y)
  {
    if (unique(y$param) == 'Number')
    {
      cells <- head(y$value, -1)
      chi2 <- rct_baseline_count(cells)
    } else if (unique(y$param) == 'Mean')
    {
      cells <- head(y$value, -1)
      tot_m <- tail(y$value, n = 1)
      tot_sd <- tail(y$spread, n = 1)
      chi2 <- rct_baseline_means(cells, mu = tot_m, sigma = tot_sd, n = tot_n)
    } else
    {
      print('Cannot process this yet... \n')     
    }
  df <- length(head(y$param, -1)) - 1
  return(data.frame(chi2_part = chi2, df_part = df))
  })
  
  chi2 <- sum(interim$chi2_part, na.rm = TRUE)
  df <- sum(interim$df[!is.na(interim$chi2_part)])
  res <- data.frame(chi2 = chi2,
                    df = df,
                    pval = pchisq(q = chi2,
                                  df = df,
                                  lower.tail = TRUE))
  return(res)
}

find_n <- function(x)
{
  sel <- grepl(x$title, pattern = '*participants*', ignore.case = TRUE)
  res <- tail(x$value[sel], 1)

  return(res)
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
  deviation_squared <- sum((smd)^2)

  return(deviation_squared)
}

rct_baseline_count <- function(
  x
)
{
  n <- sum(x)
  exp_cell <- n / length(x)
  deviation_squared <- sum((x - exp_cell)^2 / exp_cell)

  return(deviation_squared)
}

# Not done by Carlisle, but extension of method
rct_baseline_prop <- function(){}
