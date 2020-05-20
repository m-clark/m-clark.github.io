# Preliminaries -----------------------------------------------------------

library(tidyverse)

sim_re_crossed <- function(
  N = 5000,
  n_grps_a    = 500,
  n_grps_b    = 500,
  unbalanced_fraction = 0,
  seed   = NULL,
  sd_g_a = .5,
  sd_g_b = .5,
  sigma  = 1,
  b0     = 0,
  b1_a   = .5,
  b1_b   = .5,
  b2     = .1,
  c1_a   = .0,
  c1_b   = .0,
  c2_a   = .2,
  c2_b   = .2
) {
  
  if (!is.null(seed))
    set.seed(seed)
  
  g1 = rep(1:n_grps_a, each = N/n_grps_a)  # group ids 1
  g2 = rep(1:n_grps_b, each = N/n_grps_b)  # group ids 2
  
  d = data.frame(grp_a = g1, grp_b = g2)
  
  d = d %>% 
    group_by(grp_a) %>% 
    mutate(
      x_win_a = rnorm(n()),           # observation level covariate
      c1_a    = rnorm(1),             # contextual variable group mean g1 of x1
      x1_a    = x_win_a + c1_a,       # combine within and between variables into one variable
      c2_a    = sample(0:1, 1),       # another cluster level covariate
      re_a    = rnorm(1, sd = sd_g_a) # random effect
    ) %>% 
    group_by(grp_b) %>% 
    mutate(
      x_win_b = rnorm(n()),           # observation level covariate
      c1_b    = rnorm(1),             # contextual variable group mean g2 of x1
      x1_b    = x_win_b + c1_b,       # combine within and between variables into one variable
      c2_b    = sample(0:1, 1),       # another cluster level covariate
      re_b    = rnorm(1, sd = sd_g_b) # random effect
    ) %>% 
    ungroup() %>% 
    mutate(x2  = rnorm(n()))     # another observation level covariate
  
  # model matrix
  Xmat = d %>% 
    select(x1_a, x1_b, x2, c1_a, c1_b, c2_a, c2_b) %>% 
    as.matrix() %>% 
    cbind(Int = 1, .)  
  
  # conditional linear predictor  
  lp = Xmat %*% c(b0, b1_a, b1_b, b2, c1_a, c1_b, c2_a, c2_b) + 
    matrix(d$re_a, ncol = 1) +
    matrix(d$re_b, ncol = 1) 
  
  y     = rnorm(N, mean = lp, sd = sigma)          # create a continuous target variable
  y_bin = rbinom(N, size = 1, prob = plogis(lp))   # create a binary target variable for later
  
  d = tibble(d, y, y_bin) 
  
  if (unbalanced_fraction > 0) 
    d = d %>% 
    sample_frac(unbalanced_fraction)
  
  d %>% 
    select(grp_a, grp_b, x1_a, x1_b, x_win_a, x_win_b, everything()) %>% 
    rename_all(tolower) 
}



sim_re_crossed_single_x1 <- function(
  N = 5000,
  n_grps_a    = 500,
  n_grps_b    = 500,
  unbalanced_fraction = 0,
  seed   = NULL,
  sd_g_a = .5,
  sd_g_b = .5,
  sigma  = 1,
  b0     = 0,
  b1     = .5,
  b2     = .1,
  c1_a   = .0,
  c1_b   = .0,
  c2_a   = .2,
  c2_b   = .2
) {
  
  if (!is.null(seed))
    set.seed(seed)
  
  g1 = rep(1:n_grps_a, each = N/n_grps_a)  # group ids 1
  g2 = rep(1:n_grps_b, each = N/n_grps_b)  # group ids 2
  
  d = data.frame(grp_a = g1, grp_b = g2)
  
  d = d %>% 
    group_by(grp_a) %>% 
    mutate(
      x_win_a = rnorm(n(), sd = .5),           # observation level covariate
      c1_a    = rnorm(1),             # contextual variable group mean g1 of x1
      x1_a    = x_win_a + c1_a,       # combine within and between variables into one variable
      c2_a    = sample(0:1, 1),       # another cluster level covariate
      re_a    = rnorm(1, sd = sd_g_a) # random effect
    ) %>% 
    group_by(grp_b) %>% 
    mutate(
      x_win_b = rnorm(n(), sd = .5),  # observation level covariate
      c1_b    = rnorm(1),             # contextual variable group mean g2 of x1
      x1_b    = x_win_b + c1_b,       # combine within and between variables into one variable
      c2_b    = sample(0:1, 1),       # another cluster level covariate
      re_b    = rnorm(1, sd = sd_g_b) # random effect
    ) %>% 
    ungroup() %>% 
    mutate(
      x1 = rnorm(n()) + c1_a + c1_b,  # single within with two contexts
      x2 = rnorm(n())                 # another observation level covariate
      )     %>% 
    group_by(grp_a, grp_b) %>% 
    mutate(x_win = x1 - mean(x1)) %>% 
    ungroup()
  
  # model matrix
  Xmat = d %>% 
    select(x1, x2, c1_a, c1_b, c2_a, c2_b) %>% 
    as.matrix() %>% 
    cbind(Int = 1, .)  
  
  # conditional linear predictor  
  lp = Xmat %*% c(b0, b1, b2, c1_a, c1_b, c2_a, c2_b) + 
    matrix(d$re_a, ncol = 1) +
    matrix(d$re_b, ncol = 1) 
  
  y     = rnorm(N, mean = lp, sd = sigma)          # create a continuous target variable
  y_bin = rbinom(N, size = 1, prob = plogis(lp))   # create a binary target variable for later
  
  d = tibble(d, y, y_bin) 
  
  if (unbalanced_fraction > 0) 
    d = d %>% 
    sample_frac(unbalanced_fraction)
  
  d %>% 
    select(grp_a, grp_b, x1_a, x1_b, x_win, x_win_a, x_win_b, everything()) %>% 
    rename_all(tolower) 
}


# Tests -------------------------------------------------------------------

# debugonce(sim_re_crossed_single_x1)
# sim_re_crossed_single_x1()

# library(lme4)
# library(mixedup)
# 
# test = sim_re_crossed_single_x1(N = 10000, sd_g_a = .5, sd_g_b = .5, sigma = sqrt(1.5-sqrt(.5^2 + .5^2)))
# 
# 
# mod_test = lmer(y ~ x1 + x2 + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)
# 
# mod_test = lmer(y ~  x1 + x2 + c1_a + c1_b  + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)
# 
# mod_test = lmer(y ~ x_win_a + x_win_b + x2 + c1_a + c1_b  + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)
# 
# mod_test = lmer(y ~ x_win + x2 + c1_a + c1_b  + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)





