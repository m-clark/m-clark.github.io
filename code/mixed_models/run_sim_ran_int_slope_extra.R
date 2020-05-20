
# Preliminaries -----------------------------------------------------------

library(tidyverse)

# The way the data is generated is best shown by formula 11 in Explaining fixed
# effects, where c1 here is β_3, i.e. the *difference* between the contextual and
# observation level effects. In the saved results, we convert it back to the
# pure contextual effect for assessment of bias, etc. (commented). 
#
#
# The only real difference between this and the basic analysis is the addition
# of a random slope for x1.


source('code/mixed_models/sim_ran_int_slope.R')
source('code/mixed_models/get_stats_ran_int_slope.R')

# Create test grid --------------------------------------------------------


# icc is created at 10% and 50%

test_grid <- expand_grid(
  n_grps    = c(500, 1000),
  n_per_grp = c(5, 20, 100),
  re_cor    = c(-.2, 0, .2),
  c1        = c(-.5, -.25, 0, .25, .5)
)

test_grid <- test_grid %>%
  unite(
    col = 'setting',
    n_grps,
    n_per_grp,
    re_cor,
    c1,
    remove = F
  ) %>% 
  # add constant coefs
  mutate(
    b0 = 1,
    b1 = 1,
    b2 = -.5,
    c2 = .5
  )


# REWB model --------------------------------------------------------------

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
          ~ sim_ran_int_slope(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            re_cor    = .x$re_cor,
            b0    = .x$b0,
            b1    = .x$b1,
            b2    = .x$b2,
            c1    = .x$c1,
            c2    = .x$c2
          ) %>% 
            lmer(y ~ x_win + x2 + c1 + c2 + (1 + x_win | grp), data = .) 
        ) ;
      results <- list(
        fe = get_fe_ran_int_slope(
          init,
          test_grid = test_grid,
          type = 'rewb'
        ),
        vc = get_vc_ran_int_slope(init, test_grid = test_grid),
        performance = get_perf_ran_int_slope(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_rewb_avg <- map(results_rewb, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, re_cor, term, c1) %>% 
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
          ~ sim_ran_int_slope(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            re_cor    = .x$re_cor,
            b0    = .x$b0,
            b1    = .x$b1,
            b2    = .x$b2,
            c1    = .x$c1,
            c2    = .x$c2
          ) %>% 
            lmer(y ~ x1 + x2 + c2 + (1 + x1 | grp), data = .) 
        ) ;
      results <- list(
        fe = get_fe_ran_int_slope(
          init,
          test_grid = test_grid,
          type = 're'
        ),
        vc = get_vc_ran_int_slope(init, test_grid = test_grid),
        performance = get_perf_ran_int_slope(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_re_avg <- map(results_re, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, re_cor, term, c1) %>% 
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
          ~ sim_ran_int_slope(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            re_cor    = .x$re_cor,
            b0    = .x$b0,
            b1    = .x$b1,
            b2    = .x$b2,
            c1    = .x$c1,
            c2    = .x$c2
          ) %>% 
            lmer(y ~ x1 + x2 + c1 + c2 + (1 + x1 | grp), data = .) 
        ) ;
      results <- list(
        fe = get_fe_ran_int_slope(
          init,
          test_grid = test_grid,
          type = 'mundlak'
        ),
        vc = get_vc_ran_int_slope(init, test_grid = test_grid),
        performance = get_perf_ran_int_slope(init, test_grid = test_grid)
      )
    },
    .progress = TRUE
    )
})


# should be same nrow as test_grid*n coef
results_mundlak_avg <- map(results_mundlak, `[[`, 'fe') %>% 
  bind_rows() %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth) %>%  # description in article is truth/value, but their code is this way
  group_by(n_grps, n_per_grp, re_cor, term, c1) %>% 
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
  results_mundlak, 
  file = 'data/bell_sim/raw/sim_ran_int_slope.RData'
)


save(
  results_rewb_avg,
  results_re_avg,
  results_mundlak_avg, 
  file = 'data/bell_sim/results/sim_ran_int_slope.RData'
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
