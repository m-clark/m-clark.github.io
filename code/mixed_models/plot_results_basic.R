
library(tidyverse)

plot_results = function(data, stat = 'bias') {
  
  # set the levels to be equivalent regardless of model
  data = data %>% 
    filter(term != 'Intercept') %>% 
    mutate(term = factor(term, levels = c('x1', 'x_win', 'x2', 'c1', 'c2')))

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

plot_results_ran_slope = function(data, stat = 'bias') {
  
  # set the levels to be equivalent regardless of model
  data = data %>% 
    filter(term != 'Intercept') %>% 
    mutate(term = factor(term, levels = c('x1', 'x_win', 'x2', 'c1', 'c2')))
  
  data %>% 
    mutate(
      n_grps    = factor(n_grps, labels = paste('n =', unique(n_grps))),
      n_per_grp = factor(n_per_grp, labels = paste('n_per_grp =', unique(n_per_grp))),
      `RE cov` = factor(re_cor)
    ) %>%
    ggplot(aes(x = c1, y = !!ensym(stat))) +
    geom_hline(aes(yintercept = ifelse(stat  %in% c('bias', 'rmse'), 0, 1)), color = '#99002440') +
    geom_point(aes(color = `RE cov`, shape = term),
               size = 2,
               alpha = .5) +
    facet_grid(n_grps ~   n_per_grp) +
    scico::scale_color_scico_d(end = .6) +
    guides(x = guide_axis(n.dodge = 2)) +
    visibly::theme_clean() +
    theme(
      axis.text.x = element_text(size = 6),
      panel.grid.major.y = element_line(color = 'gray92', size = .25
      )
    )
  
}