
# Preliminaries -----------------------------------------------------------

library(tidyverse)

# This 


source('code/mixed_models/sim_ranef_crossed.R')
source('code/mixed_models/get_stats_ranef_crossed.R')

# Create test grid --------------------------------------------------------


test_grid = expand_grid(
  N        = c(2500, 10000, 50000),
  n_grps_a = 500,
  n_grps_b = 500,
  sd_g_a   = c(sqrt(.15), sqrt(.6)),
  sd_g_b   = c(sqrt(.15), sqrt(.6)),
  c1_a     = c(-.25, 0, .25),
  c1_b     = c(-.25, 0, .25),
  c2_a     = .1,
  c2_b     = .1
) 

test_grid = test_grid %>%
  mutate(
    var_g_a   = sd_g_a ^ 2,
    var_g_b   = sd_g_b ^ 2,
    sigma_sq = 1.5 - (var_g_a + var_g_b),
    icc_a    = var_g_a / (var_g_a + var_g_b + sigma_sq),
    icc_b    = var_g_b / (var_g_a + var_g_b + sigma_sq),
    icc_sum  = icc_a + icc_b
  ) %>%
  unite(
    col = 'setting',
    N,
    n_grps_a,
    n_grps_b,
    c1_a,
    c1_b,
    icc_a,
    icc_b,
    icc_sum,
    remove = F
  ) %>%
  mutate(
    sigma = sqrt(sigma_sq),
    # add constant coefs
    b0   = .25,
    b1_a = .5,
    b1_b = .5,
    b2   = -.2,
    c2_a = .1,
    c2_b = .1
  )


# REWB full model --------------------------------------------------------------

library(lme4)          # for models
library(mixedup)       # for model summaries

library(furrr)         # for parallelization
plan(multiprocess)

system.time({
  results_rewb_full <- 
    future_map(1:8, function(i) {
      init <- test_grid %>% 
        split(.$setting) %>% 
        map(
          ~ sim_re_crossed(
            n_grps_a = .x$n_grps_a,
            n_grps_b = .x$n_grps_b,
            sd_g_a = .x$sd_g_a,
            sd_g_b = .x$sd_g_b,
            sigma  = .x$sigma,
            b0    = .x$b0,
            b1_a  = .x$b1_a,
            b1_b  = .x$b1_b,
            c1_a  = .x$c1_a,
            c1_b  = .x$c1_b,
            c2_a  = .x$c2_a,
            c2_b  = .x$c2_b
          ) %>% 
            lmer(y ~ x_win_a + x_win_b + x2 + c1_a + c1_b  + c2_a + c2_b + 
                   (1 | grp_a) + (1 | grp_b),
                 data = .)
        ) ;
      results <- list(
        fe = get_fe_ranef_crossed(
          init,
          test_grid = test_grid,
          type = 'rewb'
        ),
        vc = get_vc_ranef_crossed(init, test_grid = test_grid),
        performance = get_perf_ranef_crossed(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_rewb_full_avg <- map(results_rewb_full, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(N, n_grps_a, n_grps_b, term, c1_a, c1_b, sd_g_a, sd_g_b, icc_a, icc_b) %>% 
  summarise(
    sd         = sd(value),
    opt1        = sqrt(sum((value - mean(value))^2)) / sqrt(sum(se^2)),
    opt2        =mean((value - mean(value))^2) / mean(se^2),
    value      = mean(value), 
    se         = mean(se),
    bias       = mean(bias),
    bias_ratio = mean(bias_ratio), # with small parameters, this is not as useful
    rmse       = mean(bias^2),
  ) #%>% 
  # ungroup() %>% 
  # select(n_grps_a:c1_b, value, se, sd, bias:rmse, opt)

results_rewb_avg

# plan(sequential)


# REWB half model --------------------------------------------------------------

library(lme4)          # for models
library(mixedup)       # for model summaries

library(furrr)         # for parallelization
plan(multiprocess)

system.time({
  results_rewb <- 
    future_map(1:500, function(i) {
      init <- test_grid %>% 
        split(.$setting) %>% 
        map(
          ~ sim_re_crossed(
            n_grps_a = .x$n_grps_a,
            n_grps_b = .x$n_grps_b,
            sd_g_a   = .x$sd_g_a,
            sd_g_b   = .x$sd_g_b,
            sigma = .x$sigma,
            b0    = .x$b0,
            b1    = .x$b1,
            c1_a  = .x$c1_a,
            c1_b  = .x$c1_b,
            c2_a  = .x$c2_a,
            c2_b  = .x$c2_b
          ) %>% 
            lmer(y ~ x_win_a + x1_b + x2 + c1_a + c2_a + c2_b + 
                   (1 | grp_a) + (1 | grp_b), 
                 data = .) 
        ) ;
      results <- list(
        fe = get_fe_ranef_crossed(
          init,
          test_grid = test_grid,
          type = 'rewb'
        ),
        vc = get_vc_ranef_crossed(init, test_grid = test_grid),
        performance = get_perf_ranef_crossed(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_rewb_avg <- map(results_rewb, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value, -sd_g) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, icc, term, c1) %>% 
  summarise(
    sd         = sd(value),
    opt        = sqrt(sum((value - mean(value))^2)) / sqrt(sum(se^2)),
    value      = mean(value), 
    se         = mean(se),
    bias       = mean(bias),
    bias_ratio = mean(bias_ratio), # with small parameters, this is not as useful
    rmse       = mean(bias^2),
  ) %>% 
  ungroup() %>% 
  select(n_grps:c1, value, se, sd, bias:rmse, opt)

results_rewb_avg

# plan(sequential)


# RE model ----------------------------------------------------------------


# plan(multiprocess)

system.time({
  results_re <- 
    future_map(1:500, function(i) {
      init <- test_grid %>% 
        split(.$setting) %>% 
        map(
          ~ sim_re_crossed(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g  = .x$sd_g,
            sigma = .x$sigma,
            b0    = .x$b0,
            b1    = .x$b1,
            b2    = .x$b2,
            c1    = .x$c1,
            c2    = .x$c2
          ) %>% 
            lmer(y ~ x1 + x2 + c2 + (1 | grp), data = .) 
        ) ;
      results <- list(
        fe = get_fe_ranef_crossed(
          init,
          test_grid = test_grid,
          type = 're'
        ),
        vc = get_vc_ranef_crossed(init, test_grid = test_grid),
        performance = get_perf_ranef_crossed(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_re_avg <- map(results_re, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value, -sd_g) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, icc, term, c1) %>% 
  summarise(
    sd         = sd(value),
    opt        = sqrt(sum((value - mean(value))^2)) / sqrt(sum(se^2)),
    value      = mean(value), 
    se         = mean(se),
    bias       = mean(bias),
    bias_ratio = mean(bias_ratio), # with small parameters, this is not as useful
    rmse       = mean(bias^2),
  ) %>% 
  ungroup() %>% 
  select(n_grps:c1, value, se, sd, bias:rmse, opt)

results_re_avg


# plan(sequential)



# Mundlak -----------------------------------------------------------------


# plan(multiprocess)

system.time({
  results_mundlak <- 
    future_map(1:500, function(i) {
      init <- test_grid %>% 
        split(.$setting) %>% 
        map(
          ~ sim_re_crossed(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g  = .x$sd_g,
            sigma = .x$sigma,
            b0    = .x$b0,
            b1    = .x$b1,
            b2    = .x$b2,
            c1    = .x$c1,
            c2    = .x$c2
          ) %>% 
            lmer(y ~ x1 + x2 + c1 + c2 + (1 | grp), data = .) 
        ) ;
      results <- list(
        fe = get_fe_ranef_crossed(
          init,
          test_grid = test_grid,
          type = 'mundlak'
        ),
        vc = get_vc_ranef_crossed(init, test_grid = test_grid),
        performance = get_perf_ranef_crossed(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_mundlak_avg <- map(results_mundlak, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value, -sd_g) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, icc, term, c1) %>% 
  summarise(
    sd         = sd(value),
    opt        = sqrt(sum((value - mean(value))^2)) / sqrt(sum(se^2)),
    value      = mean(value), 
    se         = mean(se),
    bias       = mean(bias),
    bias_ratio = mean(bias_ratio), # with small parameters, this is not as useful
    rmse       = mean(bias^2),
  ) %>% 
  ungroup() %>% 
  select(n_grps:c1, value, se, sd, bias:rmse, opt)

results_mundlak_avg


# Save results ------------------------------------------------------------

save(
  results_rewb,
  results_re,
  results_re_unb,
  results_mundlak, 
  file = 'data/bell_sim/raw/sim_ran_int_bal_unbal.RData'
)


save(
  results_rewb_avg,
  results_re_avg,
  results_re_unb_avg,
  results_mundlak_avg, 
  grp_n_avg,
  file = 'data/bell_sim/results/sim_ran_int_bal_unbal.RData'
)



# Visualize ---------------------------------------------------------------

source('code/mixed_models/plot_results_basic.R')


### Bias


p_rewb_bias = plot_results_ran_slope(results_rewb_avg)

p_re_bias = plot_results_ran_slope(results_re_avg, model = 're')

p_rewb_bias
p_re_bias


bind_rows(
  REWB = results_rewb_avg,
  RE = results_re_avg,
  Mundlak = results_mundlak_avg,
  .id = 'model'
) %>%
  plot_results_ran_slope() +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )



### Bias ratio

bind_rows(
  REWB = results_rewb_avg,
  RE = results_re_avg,
  Mundlak = results_mundlak_avg,
  .id = 'model'
) %>%
  plot_results_ran_slope(stat = 'bias_ratio') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )

### RMSE

bind_rows(
  REWB = results_rewb_avg,
  RE = results_re_avg,
  Mundlak = results_mundlak_avg,
  .id = 'model'
) %>%
  plot_results_ran_slope( stat = 'rmse') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )



### Opt

bind_rows(
  REWB = results_rewb_avg,
  RE = results_re_avg,
  Mundlak = results_mundlak_avg,
  .id = 'model'
) %>%
  plot_results_ran_slope( stat = 'opt') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )
