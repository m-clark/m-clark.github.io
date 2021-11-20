
# Preliminaries -----------------------------------------------------------

library(tidyverse)


library(tidymodels)



fit_ridgeless = function(X, y, x_test, y_test){
  b = psych::Pinv(crossprod(X)) %*% crossprod(X, y)
  
  predictions_train = X %*% b
  predictions_test  = x_test %*% b
  
  rmse_train = yardstick::rmse_vec(y,       predictions_train[,1])
  rmse_test  = yardstick::rmse_vec(y_test,  predictions_test[,1])
  
  list(b = b, rmse_train = rmse_train, rmse_test = rmse_test)
}

# fit_ridgeless(X_train, y_train, X_test, y_test)
# 
# ncol_X_main = 1 + ncol(mtcars)
# dim_cubic_wt = ncol(sc_wt)
# dim_cubic_hp = ncol(sc_hp)
# 
# total_explore = c(1:ncol_X_main,
#   ncol_X_main + ncol(sc_wt),
#   ncol(X))
# 
# 
# rmse_test = map_dbl(total_explore, ~ fit_ridgeless(X_train[,1:.x], y_train, X_test[,1:.x], y_test)[['rmse_test']])
# 
# qplot(x = total_explore, y = rmse_test, geom = 'point')



fit_reshuffle <-
  function(n,
           scale = TRUE,
           random = FALSE,
           bs = 'cs',
           k = 10
  ) {
    df_cars_shuffled = mtcars[sample(1:nrow(mtcars)), c(1, sample(2:ncol(mtcars)))] # shuffle rows/columns (keep mpg as first)
    
    if(scale) df_cars_shuffled = data.frame(scale(df_cars_shuffled))
    
    sc_wt   = mgcv::smoothCon(mgcv::s(wt, bs = bs, k = k),   data = df_cars_shuffled)[[1]]$X
    sc_hp   = mgcv::smoothCon(mgcv::s(hp, bs = bs, k = k),   data = df_cars_shuffled)[[1]]$X
    sc_disp = mgcv::smoothCon(mgcv::s(disp, bs = bs, k = k), data = df_cars_shuffled)[[1]]$X
    
    if(random) {
      ran_dim = 10
      sc_wt   = matrix(rnorm(nrow(df_cars_shuffled)*ran_dim), ncol = ran_dim)
      sc_hp   = matrix(rnorm(nrow(df_cars_shuffled)*ran_dim), ncol = ran_dim)
      sc_disp = matrix(rnorm(nrow(df_cars_shuffled)*ran_dim), ncol = ran_dim)
    }
    
    X = as.matrix(cbind(1, df_cars_shuffled[,-1], sc_wt, sc_hp, sc_disp))
    y = df_cars_shuffled$mpg
    
    train_idx = sample(1:nrow(df_cars_shuffled), n)
    
    X_train = X[train_idx,, drop = FALSE]
    X_test  = X[-train_idx,, drop = FALSE]
    
    y_train = y[train_idx]
    y_test  = y[-train_idx]
    
    ncol_X_main     = ncol(mtcars) # max model.matrix dim for original data
    ncol_cubic_wt   = ncol(sc_wt)
    ncol_cubic_hp   = ncol(sc_hp)
    ncol_cubic_disp = ncol(sc_disp)
    
    if (random) 
      total_explore = 1:ncol(X)
    else
      total_explore = c(
        1:ncol_X_main,
        ncol_X_main + ncol_cubic_wt,
        ncol_X_main + ncol_cubic_wt + ncol_cubic_hp,
        ncol(X)          # max dim
      )
    
    # for each dimension, run fit_ridgless  
    rmse = map_df(
      total_explore,
      ~ fit_ridgeless(X_train[, 1:.x], y_train, X_test[, 1:.x], y_test)[c('rmse_train', 'rmse_test')] %>% as_tibble()
    )
    
    tibble(p = total_explore, rmse)
  }

n = 10

res = map_df(1:250, ~ fit_reshuffle(
  n = n,
  random = FALSE,
  bs = 'cs',
  k = 10
), .id = 'sim')

test_error_summary = res %>% 
  group_by(p) %>% 
  summarize(
    rmse_train = mean(rmse_train, na.rm = TRUE),
    rmse_test = mean(rmse_test, na.rm = TRUE),
  ) %>% 
  pivot_longer(-p, names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) 

test_error_summary

p_dd_main = res %>% 
  pivot_longer(-c(p, sim), names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) %>% 
  ggplot(aes(as.integer(p), rmse)) +
  geom_vline(xintercept = n) +
  geom_line(aes(color = type, group = interaction(type, sim)), alpha = .25, size = .05) +
  geom_line(aes(color = type),
            size = .5,
            data = test_error_summary) +
  geom_point(aes(color = type),
             alpha = .75,
             size = 3,
             data = test_error_summary)+
  geom_point(
    # aes(color = type),
    color = 'gray50',
    alpha = .75,
    size = 6,
    data = test_error_summary %>% 
      filter(p < n, type == 'test') %>% 
      filter(rmse == min(rmse)), 
    show.legend = FALSE
  ) +
  geom_point(
    color = 'darkred',
    alpha = .75,
    size = 6,
    data = test_error_summary %>% filter(type == 'test') %>% filter(rmse == min(rmse)),
    show.legend = FALSE
  ) +
  scale_x_continuous(breaks = c(1, n, seq(20, 40, 10)), limits = c(1, max(res$p))) +
  coord_cartesian(
    # xlim = c(0, n),
    # ylim = c(0, max(test_error_summary$rmse) + 1)
    ylim = c(0, max(test_error_summary$rmse) + 1)
  ) +
  labs(x = 'Model Complexity', y = 'Test Error') +
  visibly::theme_clean()

p_dd_main


p_dd_under = p_dd_main +
  coord_cartesian(
    xlim = c(1, n),
    ylim = c(0, max(test_error_summary$rmse) + 1)
  ) + 
  guides(color = 'none') +
  scale_x_continuous(breaks = breaks_pretty(), limits = c(1, 10))

p_dd_over = p_dd_main +
  coord_cartesian(
    xlim = c(n, max(test_error_summary$p)),
    ylim = c(0, max(test_error_summary$rmse) + 1)
  ) + 
  scale_x_continuous(breaks = breaks_pretty(), limits = c(n, max(test_error_summary$p)))

# svg
ggsave(p_dd_main,  file = 'img/double-descent/dd_mtcars.svg')
ggsave(p_dd_under, file = 'img/double-descent/dd_mtcars_under.svg')
ggsave(p_dd_over,  file = 'img/double-descent/dd_mtcars_over.svg')

# png
ggsave(p_dd_main,  file = 'img/double-descent/dd_mtcars.png', height = 6.43)
ggsave(p_dd_under, file = 'img/double-descent/dd_mtcars_under.png')
ggsave(p_dd_over,  file = 'img/double-descent/dd_mtcars_over.png')


# p_dd_under +
#   p_dd_over
```

```{r pure-random, echo=FALSE, eval=FALSE}
# just to make sure
fit_reshuffle <- function(n, scale = TRUE) {
  nr = nrow(mtcars)
  nc = ncol(mtcars)
  df = matrix(rnorm(nr*nc), nrow = nr, ncol = nc)
  
  
  ran_dim = 10
  sc_1 = matrix(rnorm(nrow(df)*ran_dim), ncol = ran_dim)
  sc_2 = matrix(rnorm(nrow(df)*ran_dim), ncol = ran_dim)
  sc_3 = matrix(rnorm(nrow(df)*ran_dim), ncol = ran_dim)
  
  X = as.matrix(cbind(1, df[,-1], sc_1, sc_2, sc_3))
  y = mtcars$mpg
  
  train_idx = sample(1:nrow(df), n)
  
  X_train = X[train_idx,, drop = FALSE]
  X_test  = X[-train_idx,, drop = FALSE]
  
  y_train = y[train_idx]
  y_test  = y[-train_idx]
  
  ncol_X_main = nc # max model.matrix dim for original data ( - 1 for mpg, +1 for intercept)
  ncol_1 = ncol(sc_1)
  ncol_2 = ncol(sc_2)
  ncol_3 = ncol(sc_3)
  
  total_explore = c(
    1: ncol(X)          # max dim
  )
  
  # for each dimension, run fit_ridgless  
  rmse = map_df(
    total_explore,
    ~ fit_ridgeless(X_train[, 1:.x], y_train, X_test[, 1:.x], y_test)[c('rmse_train', 'rmse_test')] %>% as_tibble()
  )
  
  tibble(p = total_explore, rmse)
}

n = 10

res = map_df(1:250, ~fit_reshuffle(n = n), .id = 'sim')

test_error_summary = res %>% 
  group_by(p) %>% 
  summarize(
    rmse_train = mean(rmse_train),
    rmse_test = mean(rmse_test),
  ) %>% 
  pivot_longer(-p, names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) 

test_error_summary

res %>% 
  pivot_longer(-c(p, sim), names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) %>% 
  ggplot(aes(p, rmse)) +
  geom_vline(xintercept = n) +
  geom_line(aes(color = type, group = interaction(type, sim)), alpha = .25, size = .05) +
  geom_line(aes(color = type),
            size = .5,
            data = test_error_summary) +
  geom_point(aes(color = type),
             alpha = .75,
             size = 3,
             data = test_error_summary)+
  geom_point(
    aes(color = type),
    alpha = .75,
    size = 6,
    data = test_error_summary %>% filter(p < n, type == 'test') %>% filter(rmse == min(rmse)),
    show.legend = FALSE
  ) +
  geom_point(
    color = 'darkred',
    alpha = .75,
    size = 6,
    data = test_error_summary %>% filter(type == 'test') %>% filter(rmse == min(rmse)),
    show.legend = FALSE
  ) +
  scale_x_continuous(breaks = c(1, n, seq(20, 40, 10)), limits = c(1, max(res$p))) +
  coord_cartesian(
    # xlim = c(0, n),
    # ylim = c(0, max(test_error_summary$rmse) + 1)
    ylim = c(0, 100)
  ) +
  labs(x = 'Model Complexity', y = 'Test Error') +
  visibly::theme_clean()
```



```{r echo = FALSE, eval=FALSE}
fit_ridgeless = function(X, y, x_test, y_test){
  b = psych::Pinv(crossprod(X)) %*% crossprod(X, y)
  
  predictions_train = X %*% b
  predictions_test = x_test %*% b
  
  rmse_train = yardstick::rmse_vec(y,  predictions_train[,1])
  rmse_test = yardstick::rmse_vec(y_test,  predictions_test[,1])
  
  list(b = b, rmse_train = rmse_train, rmse_test = rmse_test)
}

df_sim = gamSim(n = 1000, scale = 1) # note that x3 is not correlated with y

fit_reshuffle <- function(n, data) {
  df_shuffled = data[sample(1:nrow(data)), ]
  
  sc_x0 = smoothCon(s(x0, bs = 'cs'), data = data)[[1]]$X
  sc_x1 = smoothCon(s(x1, bs = 'cs'), data = data)[[1]]$X
  sc_x2 = smoothCon(s(x2, bs = 'cs'), data = data)[[1]]$X
  sc_x3 = smoothCon(s(x3, bs = 'cs'), data = data)[[1]]$X
  
  X = as.matrix(cbind(1, df_shuffled[, -1], sc_x0, sc_x1, sc_x2 , sc_x3))
  y = df_shuffled$y
  
  train_idx = sample(1:nrow(data), n)
  X_train = X[train_idx,, drop = FALSE]
  X_test = X[-train_idx,, drop = FALSE]
  y_train = y[train_idx]
  y_test  = y[-train_idx]
  
  
  ncol_X_main = 1 + ncol(data)
  dim_cubic_x0 = ncol(sc_x0)
  dim_cubic_x1 = ncol(sc_x1)
  dim_cubic_x2 = ncol(sc_x2)
  dim_cubic_x3 = ncol(sc_x3)
  
  total_explore = c(1:ncol_X_main,
                    ncol_X_main + ncol(sc_x0),
                    ncol_X_main + ncol(sc_x0) + ncol(sc_x1),
                    ncol_X_main + ncol(sc_x0) + ncol(sc_x1) + ncol(sc_x2),
                    ncol(X))
  
  rmse = map_df(total_explore, ~ fit_ridgeless(X_train[,1:.x], y_train, X_test[,1:.x], y_test)[c('rmse_train', 'rmse_test')] %>% as_tibble())
  
  tibble(p = total_explore, rmse)
}

n = 16

res = map_df(1:500, ~fit_reshuffle(n = n, data= df_sim %>% select(y:x3)), .id = 'sim')

test_error_summary = res %>% 
  group_by(p) %>% 
  summarize(
    rmse_train = mean(rmse_train),
    rmse_test  = mean(rmse_test),
  ) %>% 
  pivot_longer(-c(p), names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) 

test_error_summary

res %>% 
  pivot_longer(-c(p, sim), names_to = 'type', values_to = 'rmse') %>% 
  mutate(type = str_remove(type, 'rmse_')) %>% 
  ggplot(aes(p, rmse)) +
  geom_vline(xintercept = n) +
  geom_line(aes(color = type, group = interaction(type, sim)), alpha = .25, size = .05) +
  geom_line(aes(color = type), size = .5, se = FALSE, data = test_error_summary) +
  geom_point(aes(color = type), alpha = .5, data = test_error_summary) +
  scale_x_continuous(breaks = c(1, ncol(mtcars) + 1, seq(20, 50, 10)), limits = c(1, max(res$p))) +
  coord_cartesian(xlim = c(1, 50), ylim = c(0, max(test_error_summary$rmse) + 5)) +
  labs(x = 'Model Complexity', y = 'Test Error') +
  visibly::theme_clean()