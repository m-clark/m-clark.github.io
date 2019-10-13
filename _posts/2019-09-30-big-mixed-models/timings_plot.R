library(tidyverse)


# lme plot ----------------------------------------------------------------


load('_posts/2019-09-30-big-mixed-models/lme_results.RData')


lme_results_gathered %>% 
  mutate(
    re = if_else(tau_2 == 0, '1 Random Effect', '2 Random Effects'),
    balanced2 = if_else(balanced == 1, 'Balanced', 'Unbalanced'),
    elapsed_avg = elapsed/5
  ) %>% 
  rename(method = test) %>% 
  ggplot(aes(N, elapsed_avg)) +
  geom_point(aes(color = method)) +
  geom_line(aes(color = method, lty = balanced2)) +
  facet_grid(cols = vars(re)) +
  labs(
    x = 'Sample Size',
    y = 'Elapsed time in\nseconds averaged\nover 5 runs',
    title = 'Linear mixed model',
    caption = 'Sample size in the unbalanced case is 75% of balanced case'
  ) +
  scale_x_continuous(
    breaks = round(unique(lme_results_gathered$N)),
    limits = c(range(lme_results_gathered$N)),
    trans = 'log',
    labels = scales::comma) +
  scale_y_continuous(
    breaks = c(0, 1, 5, 10, 50, 100, 500, 1000), 
    limits = c(range(lme_results_gathered$elapsed/5)),
    trans = 'log'
  ) +
  scico::scale_color_scico_d(name = 'Method', begin = .33, end = .66) + 
  scale_linetype(name = 'Balanced') + 
  visibly::theme_clean() + 
  theme(
    axis.text.x = element_text(angle = -45, hjust = 0), 
    axis.title.y = element_text(hjust = 0), 
    panel.grid.major.y = element_line(colour = 'gray92'),
    panel.spacing = unit(3, "lines"),
    plot.caption = element_text(size = 8),
    plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
    legend.key = ggplot2::element_rect(fill='transparent', colour = NA),
    legend.background = ggplot2::element_rect(fill='transparent', colour = NA)
  )

ggsave('img/bam/lme_results.svg')

# lme_data %>% map_df(function(x) x %>% count(group_id_1) %>% pull(n) %>% range()) %>% t
# lme_data %>% map_df(function(x) x %>% count(group_id_2) %>% pull(n) %>% range()) %>% t


# gmm plot ----------------------------------------------------------------


load('_posts/2019-09-30-big-mixed-models/gmm_results.RData')


gmm_results_gathered %>% 
  mutate(
    re = if_else(tau_2 == 0, '1 Random Effect', '2 Random Effects'),
    balanced2 = if_else(balanced == 1, 'Balanced', 'Unbalanced'),
    elapsed_avg = elapsed/5
  ) %>% 
  rename(method = test) %>% 
  ggplot(aes(N, elapsed_avg)) +
  geom_point(aes(color = method)) +
  geom_line(aes(color = method, lty = balanced2)) +
  facet_grid(cols = vars(re)) +
  labs(
    x = 'Sample Size',
    y = 'Elapsed time in\nseconds averaged\nover 5 runs',
    title = 'Linear mixed model',
    caption = 'Sample size in the unbalanced case is 75% of balanced case'
  ) +
  scale_x_continuous(
    breaks = round(unique(gmm_results_gathered$N)),
    limits = c(range(gmm_results_gathered$N)),
    trans = 'log',
    labels = scales::comma) +
  scale_y_continuous(
    breaks = c(0, 1, 5, 10, 50, 100, 500, 1000), 
    limits = c(range(gmm_results_gathered$elapsed/5)),
    trans = 'log'
  ) +
  scico::scale_color_scico_d(name = 'Method', begin = .33, end = .66) + 
  scale_linetype(name = 'Balanced') + 
  visibly::theme_clean() + 
  theme(
    axis.text.x = element_text(angle = -45, hjust = 0), 
    axis.title.y = element_text(hjust = 0), 
    panel.grid.major.y = element_line(colour = 'gray92'),
    panel.spacing = unit(3, "lines"),
    plot.caption = element_text(size = 8),
    plot.background = ggplot2::element_rect(fill = "transparent", colour = NA),
    legend.key = ggplot2::element_rect(fill='transparent', colour = NA),
    legend.background = ggplot2::element_rect(fill='transparent', colour = NA)
  )

ggsave('img/bam/gmm_results.svg')