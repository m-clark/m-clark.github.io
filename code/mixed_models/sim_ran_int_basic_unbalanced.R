
# Preliminaries -----------------------------------------------------------

library(tidyverse)

# The way the data is generated is best shown by formula 11 in Explaining fixed
# effects, where c1 here is β_3, i.e. the *difference* between the contextual and
# observation level effects. In the saved results, we convert it back to the
# pure contextual effect for assessment of bias, etc. (commented).

sim_ran_ints <- function(
  n_grps    = 500,
  n_per_grp = 10,
  unbalanced_fraction = .75,
  seed  = NULL,
  sd_g  = .5,
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
  
  d = data.frame(grp = g)
  
  d = d %>% 
    group_by(grp) %>% 
    mutate(
      x_win = rnorm(n()),          # observation level covariate
      c1    = rnorm(1),            # contextual variable group mean of x1
      x1    = x_win + c1,          # combine within and between variables into one variable
      x2    = rnorm(n()),          # another observation level covariate
      c2    = sample(0:1, 1),      # another cluster level covariate
      re    = rnorm(1, sd = sd_g)  # random effect
    ) %>% 
    ungroup()
  
  Xmat = cbind(Int = 1, as.matrix(d %>% select(x1, x2, c1, c2)))  # model matrix
  
  # conditional linear predictor  
  lp = Xmat %*% c(b0, b1, b2, c1, c2) + matrix(d$re, ncol = 1)    
  
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

# debugonce(sim_ran_ints)
# sim_ran_ints()

library(lme4)
library(mixedup)
test = sim_ran_ints(
  n_grps = 500,
  n_per_grp = 50,
  sd_g = sqrt(.1),
  sigma = sqrt(.9),
  unbalanced_fraction = .75
)


mod_test = lmer(y ~ x1 + x2 + c2 + (1 | grp), test)
summarize_model(mod_test)

mod_test = lmer(y ~ x_win + x2 + c1 + c2 + (1 | grp), test)
summarize_model(mod_test)



# REWB model --------------------------------------------------------------

# icc is created at 10% and 50%

test_grid = expand_grid(
  n_grps    = c(500, 1000),
  n_per_grp = c(5, 20, 100),
  sd_g      = c(sqrt(.1), sqrt(.5)),
  c1        = c(-.5, -.25, 0, .25, .5)
)

test_grid = test_grid %>%
  mutate(
    var_g = sd_g ^ 2,
    sigma_sq = c(.9, .5)[factor(var_g)],
    icc = var_g / (var_g + sigma_sq)
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


library(lme4)          # for models
library(mixedup)       # for model summaries

library(furrr)         # for parallelization
plan(multiprocess)

system.time({
  results_rewb_unb_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g      = .x$sd_g,
            sigma     = .x$sigma,
            c1        = .x$c1,
            unbalanced_fraction = .75
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
    }
    ) %>% 
    map_df(bind_rows)
})


# get averge n_per_grp for reporting purposes
grp_n <- 
  future_map(1:100, function(i) {
    test_grid %>% 
      group_by(setting) %>% 
      group_map(
        ~ sim_ran_ints(
          n_grps    = .x$n_grps,
          n_per_grp = .x$n_per_grp,
          sd_g      = .x$sd_g,
          sigma     = .x$sigma,
          c1        = .x$c1,
          unbalanced_fraction = .75
        ) %>% 
          count(grp) %>% 
          summarise(
            N = mean(n),
            N_min = min(n),
            N_max = max(n)
          ) %>% 
          mutate(
            sim       = i,
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp
          ),
        keep = TRUE
        )
  })

avg_grp_n = grp_n %>% 
  map_df(bind_rows, .id = '.sim') %>% # some bug that disallows using 'sim'
  group_by(n_grps, n_per_grp) %>% 
  summarise(N_avg = mean(N), N_min_avg = mean(N_min), N_max_avg = mean(N_max))

# should be same nrow as test_grid
results_rewb_unb_avg = results_rewb_unb_raw %>% 
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

results_rewb_unb_avg



plan(sequential)


# RE model ----------------------------------------------------------------


plan(multiprocess)

system.time({
  results_re_unb_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g = .x$sd_g,
            sigma = .x$sigma,
            c1 = .x$c1,
            unbalanced_fraction = .75
          ) %>% 
            lmer(y ~ x1 + x2 + c2 + (1 | grp), data = .) %>% 
            extract_fixed_effects(ci_level = 0) %>% 
            mutate(
              truth = c(1, .5, .1, .1),
              sim = i,
              n_grps = .x$n_grps,
              n_per_grp = .x$n_per_grp,
              sd_g = .x$sd_g,
              icc = .x$icc,
              c1 = .x$c1
            ),
          keep = TRUE
        )
    }
    ) %>% 
    map_df(bind_rows)
})



# should be same nrow as test_grid
results_re_unb_avg = results_re_unb_raw %>% 
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

results_re_unb_avg

plan(sequential)

# Mundlak -----------------------------------------------------------------


plan(multiprocess)

system.time({
  results_mundlak_unb_raw <- 
    future_map(1:1000, function(i) {
      test_grid %>% 
        group_by(setting) %>% 
        group_map(
          ~ sim_ran_ints(
            n_grps    = .x$n_grps,
            n_per_grp = .x$n_per_grp,
            sd_g      = .x$sd_g,
            sigma     = .x$sigma,
            c1        = .x$c1,
            unbalanced_fraction = .75
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



# should be same nrow as test_grid
results_mundlak_unb_avg = results_mundlak_unb_raw %>% 
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

results_mundlak_unb_avg



# Save results ------------------------------------------------------------

save(
  results_re_unb_avg,
  results_rewb_unb_avg,
  results_mundlak_unb_avg, 
  file = 'data/bell_sim/sim_ran_int_unbalanced.RData'
)


# Plot  --------------------------------------------------------------------

plot_results = function(data, model = 'rewb', stat = 'bias') {
  
  if (model == 'rewb') {
    data = data %>% 
      filter(term %in% c('x_win', 'c1', 'c2')) %>% 
      mutate(term = factor(term, levels = c('x_win', 'c2', 'c1')))
  }
  else if (model == 're') {
    data = data %>% 
      filter(term %in% c('x1','c2')) %>% 
      mutate(term = factor(term, levels = c('x1', 'c2')))
  } 
  else if (model == 'mundlak') {
    data = data %>% 
      filter(term %in% c('x1', 'c1', 'c2')) %>% 
      mutate(term = factor(term, levels = c('x1', 'c2', 'c1')))
  } 
  else if (grepl(model, pattern = 'both|all')) {
    data = data %>% 
      filter(term %in% c('x_win', 'x1', 'c1', 'c2')) 
  }
  
  data %>% 
    mutate(
      n_grps    = factor(n_grps, labels = paste('n =', unique(n_grps))),
      n_per_grp = factor(n_per_grp, labels = paste('n_per_grp =', unique(n_per_grp))),
      icc       = paste0('icc = ', icc)
    ) %>% 
    ggplot(aes(x = c1, y = !!ensym(stat))) +
    geom_hline(aes(yintercept = ifelse(stat  %in% c('bias', 'rmse'), 0, 1)), color = '#99002440') +
    geom_point(aes(color = icc, shape = term), size = 2, alpha = .5) +
    facet_grid(n_grps ~   n_per_grp) +
    scico::scale_color_scico_d(end = .6) +
    guides(x = guide_axis(n.dodge = 2)) +
    visibly::theme_clean() +
    theme(
      axis.text.x = element_text(size = 6),
      panel.grid.major.y = element_line(color = 'gray92', size = .25)
    )
  
}



### Bias


p_rewb_bias = plot_results(results_rewb_unb_avg)

p_re_bias = plot_results(results_re_unb_avg, model = 're')

p_rewb_bias
p_re_bias

library(patchwork)


bind_rows(REWB = results_rewb_unb_avg, RE = results_re_unb_avg, .id = 'model') %>% 
  plot_results(model = 'both') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )

# 
# (p_rewb_bias + 
#     labs(subtitle = 'REWB') + 
#     guides(color = 'none', shape = 'none')
#   ) + 
#   (p_re_bias  + 
#      labs(subtitle = 'RE') #+ 
#      # guides(color = guide_legend(title.position = 'bottom'), shape = guide_legend(title.position = 'bottom'))
#    ) * 
#   lims(y = c(-.175, .175)) *
#   theme(legend.position = 'bottom')



### Bias ratio

p_rewb_bias_ratio = plot_results(results_rewb_unb_avg %>% filter(!is.infinite(bias_ratio), !is.nan(bias_ratio)), stat = 'bias_ratio')

p_re_bias_ratio = plot_results(results_re_unb_avg %>% filter(!is.infinite(bias_ratio), !is.nan(bias_ratio)), model = 're', stat = 'bias_ratio')

# p_rewb_bias_ratio
# p_re_bias_ratio


(p_rewb_bias_ratio + labs(subtitle = 'REWB')) / 
  (p_re_bias_ratio  + labs(subtitle = 'RE'))  *
  lims(y = c(-3,3))

### RMSE

p_rewb_rmse = plot_results(results_rewb_unb_avg, stat = 'rmse')

p_re_rmse = plot_results(results_re_unb_avg, model = 're', stat = 'rmse')

# p_rewb_rmse
# p_re_rmse


(p_rewb_rmse + labs(subtitle = 'REWB')) / 
  (p_re_rmse  + labs(subtitle = 'RE'))  *
  lims(y = c(0,.031))

save(
  avg_grp_n,
  results_re_unb_avg,
  results_rewb_unb_avg,
  file = 'data/bell_sim/sim_ran_int_unbalanced.RData'
)


### Opt



bind_rows(REWB = results_rewb_unb_avg, RE = results_re_unb_avg, .id = 'model') %>% 
  plot_results(model = 'both', stat = 'opt') +
  facet_grid(model ~ n_grps + n_per_grp) +
  theme(
    strip.text = element_text(size = 6)
  )
