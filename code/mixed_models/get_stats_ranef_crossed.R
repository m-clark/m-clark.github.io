
# Preliminaries -----------------------------------------------------------

library(tidyverse)
library(mixedup)
library(lme4)

get_fe_ranef_crossed <- function(model, test_grid, type = 'rewb') {
  settings <- data.frame(setting = names(model))
  test_grid = left_join(settings, test_grid, by = 'setting')
  
  if (type == 'rewb') {
    result = map2_df(model, test_grid %>% split(.$setting),
                     function(mod, .x)
                       extract_fixed_effects(mod) %>% 
                       mutate(
                         truth    = c(.x$b0,
                                      .x$b1_a,
                                      .x$b1_b,
                                      .x$b2,
                                      .x$c1_a + .5,
                                      .x$c1_b + .5,
                                      .x$c2_a,
                                      .x$c2_b),
                         N        = .x$N,
                         n_grps_a = .x$n_grps_a,
                         n_grps_b = .x$n_grps_b,
                         sd_g_a   = .x$sd_g_a,
                         sd_g_b   = .x$sd_g_b,
                         c1_a     = .x$c1_a,
                         c1_b     = .x$c1_b,
                         icc_a    = .x$icc_a,
                         icc_b    = .x$icc_b,
                         sigma    = .x$sigma
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


get_vc_ranef_crossed <- function(model, test_grid) {
  settings  <- data.frame(setting = names(model))
  test_grid <- left_join(settings, test_grid, by = 'setting')
  
  result <- map2_df(model, test_grid %>% split(.$setting),
                    function(mod, .x)
                      extract_vc(mod, ci_level = 0) %>% 
                      mutate(
                        N        = .x$N,
                        n_grps_a = .x$n_grps_a,
                        n_grps_b = .x$n_grps_b,
                        sd_g_a   = .x$sd_g_a,
                        sd_g_b   = .x$sd_g_b,
                        c1_a     = .x$c1_a,
                        c1_b     = .x$c1_b,
                        icc_a    = .x$icc_a,
                        icc_b    = .x$icc_b,
                        sigma    = .x$sigma
                      ), 
                    .id = 'setting')
  
  result
}



get_perf_ranef_crossed <- function(model, test_grid) {
  settings  <- data.frame(setting = names(model))
  test_grid <- left_join(settings, test_grid, by = 'setting')
  
  result <- map2_df(model, test_grid %>% split(.$setting),
                    function(mod, .x)
                      data.frame(
                        R2_marg  = performance::r2_nakagawa(mod)$R2_marginal,
                        R2_cond  = performance::r2_nakagawa(mod)$R2_conditional,
                        rmse     = performance::rmse(mod),
                        AIC      = AIC(mod),
                        N        = .x$N,
                        n_grps_a = .x$n_grps_a,
                        n_grps_b = .x$n_grps_b,
                        sd_g_a   = .x$sd_g_a,
                        sd_g_b   = .x$sd_g_b,
                        c1_a     = .x$c1_a,
                        c1_b     = .x$c1_b,
                        icc_a    = .x$icc_a,
                        icc_b    = .x$icc_b,
                        sigma    = .x$sigma
                      ), 
                    .id = 'setting')
  
  result
}
