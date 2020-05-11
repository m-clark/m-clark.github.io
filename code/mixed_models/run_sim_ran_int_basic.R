
# Preliminaries -----------------------------------------------------------

library(tidyverse)

# The way the data is generated is best shown by formula 11 in Explaining fixed
# effects, where c1 here is β_3, i.e. the *difference* between the contextual and
# observation level effects. In the saved results, we convert it back to the
# pure contextual effect for assessment of bias, etc. (commented).


source('code/mixed_models/sim_ran_int_basic.R')

# Create test grid --------------------------------------------------------


# icc is created at 10% and 50%

test_grid = expand_grid(
  n_grps    = c(500, 1000),
  n_per_grp = c(5, 20, 100),
  sd_g      = c(sqrt(.1), sqrt(.5)),
  c1        = c(-.5, -.25, 0, .25, .5)
)

test_grid = test_grid %>%
  mutate(
    var_g    = sd_g ^ 2,
    sigma_sq = c(.9, .5)[factor(var_g)],
    icc      = var_g / (var_g + sigma_sq)
  ) %>%
  unite(
    col = 'setting',
    n_grps,
    n_per_grp,
    icc,
    var_g,
    c1,
    remove = F
  ) %>%
  select(setting, icc) %>%
  mutate(sigma = sqrt(c(.9, .5))[factor(icc)]) %>%
  bind_cols(test_grid)


# REWB model --------------------------------------------------------------

library(lme4)          # for models
library(mixedup)       # for model summaries

library(furrr)         # for parallelization
plan(multiprocess)

system.time({
  results_rewb_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g      = .x$sd_g,
            sigma     = .x$sigma,
            c1        = .x$c1
          ) %>% 
            lmer(y ~ x_win + x2 + c1 + c2 + (1 | grp), data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth     = c(.25, .5, .1, .x$c1+.5, .1),   # B3 = B4 (c1)  - B1 (.5)
              sim       = i,
              n_grps    = .x$n_grps,
              n_per_grp = .x$n_per_grp,
              sd_g      = .x$sd_g,
              icc       = .x$icc,
              c1        = .x$c1
            ),
          keep = TRUE
        )
    },
    .progress = TRUE) %>% 
    map_df(bind_rows)
})

# should be same nrow as test_grid*n coef
results_rewb_avg = results_rewb_raw %>% 
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
  results_re_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g      = .x$sd_g,
            sigma     = .x$sigma,
            c1        = .x$c1
          ) %>% 
            lmer(y ~ x1 + x2 + c2 + (1 | grp), data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth     = c(1, .5, .1, .1),
              sim       = i,
              n_grps    = .x$n_grps,
              n_per_grp = .x$n_per_grp,
              sd_g      = .x$sd_g,
              icc       = .x$icc,
              c1        = .x$c1
            ),
          keep = TRUE
        )
    }
    ) %>% 
    map_df(bind_rows)
})


results_re_avg = results_re_raw %>% 
  select(-t, -p_value, -sd_g) %>% 
  mutate(bias = value - truth,
         bias_ratio  = truth/value) %>% 
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
  results_mundlak_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g      = .x$sd_g,
            sigma     = .x$sigma,
            c1        = .x$c1
          ) %>% 
            lmer(y ~ x1 + x2 + c1 + c2 + (1 | grp), data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth     = c(.25, .5, .1, .x$c1, .1),   
              sim       = i,
              n_grps    = .x$n_grps,
              n_per_grp = .x$n_per_grp,
              sd_g      = .x$sd_g,
              icc       = .x$icc,
              c1        = .x$c1
            ),
          keep = TRUE
        )
    }
    ) %>% 
    map_df(bind_rows)
})


results_mundlak_avg = results_mundlak_raw %>% 
  select(-t, -p_value, -sd_g) %>% 
  mutate(bias = value - truth,
         bias_ratio  = truth/value) %>% 
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
  results_re_avg,
  results_rewb_avg,
  results_mundlak_avg, 
  file = 'data/bell_sim/sim_ran_int_balanced.RData'
)




# Visualize ---------------------------------------------------------------

source('code/mixed_models/plot_results_basic.R')


### Bias


p_rewb_bias = plot_results(results_rewb_avg)

p_re_bias = plot_results(results_re_avg, model = 're')

p_rewb_bias
p_re_bias


bind_rows(
  REWB = results_rewb_avg,
  RE = results_re_avg,
  Mundlak = results_mundlak_avg,
  .id = 'model'
) %>%
  plot_results(model = 'all') +
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
  plot_results(model = 'all', stat = 'bias_ratio') +
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
  plot_results(model = 'all', stat = 'rmse') +
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
  plot_results(model = 'all', stat = 'opt') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )