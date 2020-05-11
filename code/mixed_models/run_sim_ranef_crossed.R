
# Preliminaries -----------------------------------------------------------

library(tidyverse)


source('code/mixed_models/sim_ranef_crossed.R')

# Tests -------------------------------------------------------------------

# debugonce(sim_ran_ints)
# sim_ran_ints()

# library(lme4)
# library(mixedup)
# 
# test = sim_re_crossed(N = 10000, sd_g_a = .5, sd_g_b = .5, sigma = sqrt(1.5-sqrt(.5^2 + .5^2)))
# 
# 
# mod_test = lmer(y ~ x1_a + x1_b + x2 + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)
# 
# mod_test = lmer(y ~ x_win_a + x_win_b + x2 + c1_a + c1_b  + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), test)
# summarize_model(mod_test, ci = 0)



# Create test grid --------------------------------------------------------

test_grid = expand_grid(
  N        = c(2500, 10000, 50000),
  n_gprs_a = 500,
  n_gprs_b = 500,
  sd_g_a   = c(sqrt(.15), sqrt(.6)),
  sd_g_b   = c(sqrt(.15), sqrt(.6)),
  c1_a     = c(-.25, 0, .25),
  c1_b     = c(-.25, 0, .25),
  c2_a     = .1,
  c2_b     = .1
) 

test_grid = test_grid %>%
  mutate(
    var_ga   = sd_g_a ^ 2,
    var_gb   = sd_g_b ^ 2,
    sigma_sq = 1.5 - (var_ga + var_gb),
    icc_a    = var_ga / (var_ga + var_gb + sigma_sq),
    icc_b    = var_gb / (var_ga + var_gb + sigma_sq),
    icc_sum  = icc_a + icc_b
  ) %>%
  unite(
    col = 'setting',
    N,
    n_gprs_a,
    n_gprs_b,
    c1_a,
    c1_b,
    icc_a,
    icc_b,
    icc_sum,
    remove = F
  ) %>%
  mutate(sigma = sqrt(sigma_sq) )


# REWB full model --------------------------------------------------------------

library(lme4)          # for models
library(mixedup)       # for model summaries

library(furrr)         # for parallelization
plan(multiprocess)

system.time({
  results_rewb_full_raw <- 
    future_map(1:500, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_re_crossed(
            N        = .x$N,
            n_gprs_a = .x$n_gprs_a,
            n_gprs_b = .x$n_gprs_b,
            sd_g_a   = .x$sd_g_a,
            sd_g_b   = .x$sd_g_b,
            c1_a     = .x$c1_a,
            c1_b     = .x$c1_b,
            c2_a     = .x$c2_a,
            c2_b     = .x$c2_b,
            sigma    = .x$sigma
          ) %>% 
            lmer(y ~ x_win_a + x_win_b + x2 + c1_a + c1_b  + c2_a + c2_b + 
                   (1 | grp_a) + (1 | grp_b), 
                 data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth    = c(0, .5, .5, .1, .x$c1_a + .5, .x$c1_b + .5, .x$c2_a, .x$c2_b),  
              sim      = i,
              N        = .x$N,
              n_gprs_a = .x$n_gprs_a,
              n_gprs_b = .x$n_gprs_b,
              sd_g_a   = .x$sd_g_a,
              sd_g_b   = .x$sd_g_b,
              c1_a     = .x$c1_a,
              c1_b     = .x$c1_b,
              icc_a    = .x$icc_a,
              icc_b    = .x$icc_b,
              sigma    = .x$sigma
            ),
          keep = TRUE
        )
    },
    .progress = TRUE
    ) %>% 
    map_df(bind_rows)
})

# should be same nrow as test_grid*term
results_rewb_full_avg = results_rewb_full_raw2 %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth,
         n_per_grp = N/n_gprs_a) %>%  # description in article is truth/value, but their code is this way
  group_by(N, n_per_grp, term, c1_a, c1_b, sd_g_a, sd_g_b, icc_a, icc_b) %>% 
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
  select(N:icc_b, value, se, sd, bias:rmse, opt)

results_rewb_full_avg



plan(sequential)


# REWB half model --------------------------------------------------------------

# plan(multiprocess)

system.time({
  results_rewb_half_raw <- 
    future_map(1:500, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_re_crossed(
            N        = .x$N,
            n_gprs_a = .x$n_gprs_a,
            n_gprs_b = .x$n_gprs_b,
            sd_g_a   = .x$sd_g_a,
            sd_g_b   = .x$sd_g_b,
            c1_a     = .x$c1_a,
            c1_b     = .x$c1_b,
            c2_a     = .x$c2_a,
            c2_b     = .x$c2_b,
            sigma    = .x$sigma
          ) %>% 
            lmer(y ~ x_win_a + x1_b + x2 + c1_a + c2_a + c2_b + 
                   (1 | grp_a) + (1 | grp_b), 
                 data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth    = c(0, .5, .5, .1, .x$c1_a + .5, .x$c2_a, .x$c2_b),  
              sim      = i,
              N        = .x$N,
              n_gprs_a = .x$n_gprs_a,
              n_gprs_b = .x$n_gprs_b,
              sd_g_a   = .x$sd_g_a,
              sd_g_b   = .x$sd_g_b,
              c1_a     = .x$c1_a,
              c1_b     = .x$c1_b,
              icc_a    = .x$icc_a,
              icc_b    = .x$icc_b,
              sigma    = .x$sigma
            ),
          keep = TRUE
        )
    }, 
    .progress = TRUE
    ) %>% 
    map_df(bind_rows)
})


results_rewb_half_avg = results_rewb_half_raw %>% 
  select(-t, -p_value) %>% 
  mutate(
    bias       = value - truth,
    bias_ratio = value / truth,
    n_per_grp  = N / n_gprs_a
  ) %>%  # description in article is truth/value, but their code is this way
  group_by(N, n_per_grp, term, c1_a, c1_b, sd_g_a, sd_g_b, icc_a, icc_b) %>% 
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
  select(N:icc_b, value, se, sd, bias:rmse, opt)

results_rewb_half_avg

plot_results_crossed(results_rewb_half_avg)

plan(sequential)



# RE model ----------------------------------------------------------------


# plan(multiprocess)

system.time({
  results_re_raw <- 
    future_map(1:500, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_re_crossed(
            N         = .x$N,
            n_gprs_a  = .x$n_gprs_a,
            n_gprs_b  = .x$n_gprs_b,
            sd_g_a    = .x$sd_g_a,
            sd_g_b    = .x$sd_g_b,
            c1_a      = .x$c1_a,
            c1_b      = .x$c1_b,
            c2_a      = .x$c2_a,
            c2_b      = .x$c2_b,
            sigma     = .x$sigma
          ) %>% 
            lmer(y ~ x1_a + x1_b + x2 + c2_a + c2_b + (1 | grp_a) + (1 | grp_b), data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth    = c(0, .5, .5, .1, .x$c2_a, .x$c2_b),  
              sim      = i,
              N        = .x$N,
              n_gprs_a = .x$n_gprs_a,
              n_gprs_b = .x$n_gprs_b,
              sd_g_a   = .x$sd_g_a,
              sd_g_b   = .x$sd_g_b,
              c1_a     = .x$c1_a,
              c1_b     = .x$c1_b,
              icc_a    = .x$icc_a,
              icc_b    = .x$icc_b,
              sigma    = .x$sigma
            ),
          keep = TRUE
        )
    },
    .progress = TRUE
    ) %>% 
    map_df(bind_rows)
})



results_re_avg = results_re_raw %>% 
  select(-t, -p_value) %>% 
  mutate(
    bias = value - truth,
    bias_ratio  = truth / value,
    n_per_grp  = N / n_gprs_a
  ) %>% 
  group_by(N, n_per_grp, term, c1_a, c1_b, sd_g_a, sd_g_b, icc_a, icc_b) %>% 
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
  select(N:icc_b, value, se, sd, bias:rmse, opt)

results_re_avg

plot_results_crossed(results_re_avg)

plan(sequential)




# Mundlak -----------------------------------------------------------------


plan(multiprocess)

system.time({
  results_mundlak_raw <- 
    future_map(1:500, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_re_crossed(
            N        = .x$N,
            n_gprs_a = .x$n_gprs_a,
            n_gprs_b = .x$n_gprs_b,
            sd_g_a   = .x$sd_g_a,
            sd_g_b   = .x$sd_g_b,
            c1_a     = .x$c1_a,
            c1_b     = .x$c1_b,
            c2_a     = .x$c2_a,
            c2_b     = .x$c2_b,
            sigma    = .x$sigma
          ) %>% 
            lmer(y ~  x1_a + x1_b + x2 + c1_a + c1_b  + c2_a + c2_b + 
                   (1 | grp_a) + (1 | grp_b), 
                 data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth    = c(0, .5, .5, .1, .x$c1_a + .5, .x$c1_b + .5, .x$c2_a, .x$c2_b),  
              sim      = i,
              N        = .x$N,
              n_gprs_a = .x$n_gprs_a,
              n_gprs_b = .x$n_gprs_b,
              sd_g_a   = .x$sd_g_a,
              sd_g_b   = .x$sd_g_b,
              c1_a     = .x$c1_a,
              c1_b     = .x$c1_b,
              icc_a    = .x$icc_a,
              icc_b    = .x$icc_b,
              sigma    = .x$sigma
            ),
          keep = TRUE
        )
    },
    .progress = TRUE
    ) %>% 
    map_df(bind_rows)
})

# should be same nrow as test_grid*term
results_mundlak_avg = results_mundlak_raw %>% 
  select(-t, -p_value) %>% 
  mutate(bias        = value - truth,
         bias_ratio  = value / truth,
         n_per_grp = N/n_gprs_a) %>%  # description in article is truth/value, but their code is this way
  group_by(N, n_per_grp, term, c1_a, c1_b, sd_g_a, sd_g_b, icc_a, icc_b) %>% 
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
  select(N:icc_b, value, se, sd, bias:rmse, opt)

results_mundlak_avg


# Save results ------------------------------------------------------------

save(
  results_rewb_full_avg,
  results_rewb_half_avg,
  # results_re_avg,
  # results_mundlak_avg, 
  file = 'data/bell_sim/sim_ranef_crossed_balanced.RData'
)


