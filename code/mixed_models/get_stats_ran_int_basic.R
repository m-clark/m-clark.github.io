
# Preliminaries -----------------------------------------------------------

library(tidyverse)
library(mixedup)
library(lme4)

get_fe_ran_int_basic <- function(model, test_grid, type = 'rewb') {
  settings <- data.frame(setting = names(model))
  test_grid = left_join(settings, test_grid, by = 'setting')
  
  if (type == 'rewb') {
    result = map2_df(model, test_grid %>% split(.$setting),
                     function(mod, .x)
                       extract_fixed_effects(mod) %>% 
                       mutate(
                         truth     = c(.x$b0, .x$b1, .x$b2, .x$c1 + .5,  .x$c2),   # B3 = B4 (c1)  - B1 (.5)
                         n_grps    = .x$n_grps,
                         n_per_grp = .x$n_per_grp,
                         sd_g      = .x$sd_g,
                         icc       = .x$icc,
                         c1        = .x$c1
                       )
                     , .id = 'setting')
  }
  else if (type == 're') {
    result = map2_df(model, test_grid %>% split(.$setting),
                     function(mod, .x)
                       extract_fixed_effects(mod) %>% 
                       mutate(
                         truth     = c(.x$b0, .x$b1, .x$b2, .x$c2),  
                         n_grps    = .x$n_grps,
                         n_per_grp = .x$n_per_grp,
                         sd_g      = .x$sd_g,
                         icc       = .x$icc,
                         c1        = .x$c1
                       )
                     , .id = 'setting')
  } 
  else if (type == 'mundlak') {
    result = map2_df(model, test_grid %>% split(.$setting),
                     function(mod, .x)
                       extract_fixed_effects(mod) %>%
                       mutate(
                         truth     = c(.x$b0, .x$b1, .x$b2, .x$c1,  .x$c2),
                         n_grps    = .x$n_grps,
                         n_per_grp = .x$n_per_grp,
                         sd_g      = .x$sd_g,
                         icc       = .x$icc,
                         c1        = .x$c1
                       )
                     , .id = 'setting')
  }
  
  result
}


get_vc_ran_int_basic <- function(model, test_grid) {
  settings  <- data.frame(setting = names(model))
  test_grid <- left_join(settings, test_grid, by = 'setting')
  
  result <- map2_df(model, test_grid %>% split(.$setting),
                    function(mod, .x)
                      extract_vc(mod, ci_level = 0) %>% 
                      mutate(
                        n_grps    = .x$n_grps,
                        n_per_grp = .x$n_per_grp,
                        sd_g      = .x$sd_g,
                        icc       = .x$icc,
                        c1        = .x$c1
                      ), 
                    .id = 'setting')
  
  result
}



get_perf_ran_int_basic <- function(model, test_grid) {
  settings  <- data.frame(setting = names(model))
  test_grid <- left_join(settings, test_grid, by = 'setting')
  
  result <- map2_df(model, test_grid %>% split(.$setting),
                    function(mod, .x)
                      data.frame(
                        R2_marg   = performance::r2_nakagawa(mod)$R2_marginal,
                        R2_cond   = performance::r2_nakagawa(mod)$R2_conditional,
                        rmse      = performance::rmse(mod),
                        AIC       = AIC(mod),
                        n_grps    = .x$n_grps,
                        n_per_grp = .x$n_per_grp,
                        sd_g      = .x$sd_g,
                        icc       = .x$icc,
                        c1        = .x$c1
                      ), 
                    .id = 'setting')
  
  result
}
