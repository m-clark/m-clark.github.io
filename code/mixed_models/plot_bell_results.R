
# Preliminaries -----------------------------------------------------------

library(tidyverse)


bell_sim_results = haven::read_dta('data/bell_sim/simscollapsedALLall.dta')

bell_sim_results %>% tidyext::describe_all()

# contextual is the effect of the aggregate variable, i.e. B3
# L2corX5 is unclear. The values are -1:3 and presumably it is the correlation between z3j and uj in the text
# L2var is level 2 variance is the group variance and constant at 4 (although expressed as standard deviation in text)
# L1var is residual variance and constant at 3 (although expressed as standard deviation in text)


re_results = bell_sim_results %>% 
  select(N, n, Contextual, balanced, L2corX5, L2Var, L1Var, matches('RE$|REWB$'))

# bias, not including 3b which is not estimated by RE model
re_bias = re_results %>% 
  filter(L2corX5 == 0) %>% 
  select(-L2Var, -L1Var, -L2corX5, -matches('opt|RMSE|3B')) %>% 
  pivot_longer(-(N:balanced), names_to = c('param', 'model'), names_prefix = 'MBias', names_pat = '(B[0-9])([A-Z]+)') 

re_bias %>%
  mutate(N = factor(N), n = factor(n, labels = paste0('n per grp = ', unique(n)))) %>% 
  rename(`# of groups` = N) %>% 
  ggplot(aes(x = Contextual, y = value)) +
  geom_hline(aes(yintercept = 1), color = '#99002440') +
  geom_point(aes(color = model, size = abs(value-1), shape = `# of groups`), alpha = .25) + 
  # lims(y = c(.93, 1.04)) +
  scico::scale_color_scico_d(end = .5) +
  guides(size = 'none') +
  # facet_wrap(param + n ~ model, ncol = 4) + 
  facet_grid(rows = vars(param, n), cols = vars(model)) + 
  visibly::theme_clean()
