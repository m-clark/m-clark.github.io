
library(tidyverse)

plot_results_crossed = function(data, stat = 'bias') {
  
  # set the levels to be equivalent regardless of model
  data = data %>% 
    filter(term != 'Intercept') %>% 
    mutate(term = factor(
      term,
      levels = c(
        'x1_a',
        'x_win_a',
        'x1_b',
        'x_win_b',
        'x2',
        'c1_a',
        'c1_b',
        'c2_a',
        'c2_b'
      )
    ))
  
  
  data %>% 
    mutate(
      N         = factor(N),
      n_per_grp = factor(n_per_grp, labels = paste('n_per_grp =', unique(n_per_grp))),
      icc_a     = paste0('icc_a = ', icc_a),
      icc_b     = paste0('icc_b = ', icc_b),
      icc       = paste(icc_a, icc_b) 
    ) %>% 
    ggplot(aes(x = c1_a, y = !!ensym(stat))) +
    geom_hline(aes(yintercept = ifelse(stat  %in% c('bias', 'rmse'), 0, 1)), 
               color = '#99002440') +
    geom_point(aes(color = n_per_grp, shape = icc),
               size  = 2,
               alpha = .5) +
    facet_grid(c1_b ~ term) +
    scico::scale_color_scico_d(end = .6) +
    scale_x_continuous(breaks = c(-.25, 0, .25)) +
    guides(x = guide_axis(n.dodge = 2)) +
    visibly::theme_clean() +
    theme(
      axis.text.x = element_text(size = 6),
      panel.grid.major.y = element_line(color = 'gray92', size = .25
      )
    )
  
}
