
# Preliminaries -----------------------------------------------------------

library(tidyverse)

sim_ran_int_slope <- function(
  n_grps    = 500,
  n_per_grp = 10,
  unbalanced_fraction = 0,
  seed  = NULL,
  sd_int     = sqrt(.5),
  sd_slope   = sqrt(.25),
  re_cor = -.1,
  sigma = 1,
  b0    = .25,
  b1    = .5,
  b2    = .1,
  c1    = .0,
  c2    = .1
) {
  
  if (!is.null(seed))
    set.seed(seed)
  
  N = n_grps*n_per_grp                 # total sample size
  g = rep(1:n_grps, each = n_per_grp)  # group ids
  
  d  = data.frame(grp = g)
  
  # random effect
  re = mvtnorm::rmvnorm(
    n_grps, 
    mean = c(0, 0), 
    sigma = matrix(c(sd_int^2, re_cor, re_cor, sd_slope^2), ncol=2)
  )
  
  re = re[g,]
  
  
  d = d %>% 
    group_by(grp) %>% 
    mutate(
      x_win = rnorm(n()),          # observation level covariate
      c1    = rnorm(1),            # contextual variable group mean of x1
      x1    = x_win + c1,          # combine within and between variables into one variable
      x2    = rnorm(n()),          # another observation level covariate
      c2    = sample(0:1, 1),      # another cluster level covariate

    ) %>% 
    ungroup()
  
  Xmat = cbind(Int = 1, as.matrix(d %>% select(x1, x2, c1, c2)))  # model matrix
  
  # conditional linear predictor  
  lp = Xmat %*% c(b0, b1, b2, c1, c2) + rowSums(Xmat[,1:2] * re)
  
  y     = rnorm(N, mean = lp, sd = sigma)          # create a continuous target variable
  y_bin = rbinom(N, size = 1, prob = plogis(lp))   # create a binary target variable for later
  
  d = tibble(d, y, y_bin) 
  
  if (unbalanced_fraction > 0) 
    d = d %>% 
    sample_frac(unbalanced_fraction)
  
  d %>% 
    select(grp, x1, x_win, everything()) %>% 
    rename_all(tolower) 
}



# Tests -------------------------------------------------------------------



# debugonce(sim_ran_int_slope)
# sim_ran_int_slope()
# 
# library(lme4)
# library(mixedup)
# test = sim_ran_int_slope(
#   n_grps = 500,
#   n_per_grp = 50,
#   # sd_g = sqrt(.1),
#   # sigma = sqrt(.9)
# )
# 
# 
# mod_test = lmer(y ~ x1 + x2 + c2 + (1 + x1 | grp), test)
# summarize_model(mod_test, ci = 0, cor_re = T)
# 
# mod_test = lmer(y ~ x_win + x2 + c1 + c2 + (1 + x_win | grp), test)
# summarize_model(mod_test, ci=0)
