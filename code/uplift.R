
# Preliminaries -----------------------------------------------------------

library(tidyverse)

qini0 = readxl::read_excel('data/uplift-perf-robler-2022.xlsx')
data_desc0 = readxl::read_excel('data/uplift-perf-robler-2022.xlsx', sheet = 2)


qini = qini0  %>% 
  mutate(across(everything(), \(x) str_remove(x, ' \\((.)*\\)'))) %>% 
  mutate(across(-Method, as.numeric)) %>% 
  janitor::clean_names()


qini_sd = qini0  %>% 
  mutate(across(-Method, \(x) str_extract(x, '\\((.)*\\)'))) %>% 
  mutate(across(everything(), \(x) str_remove_all(x, '\\(|\\)'))) %>% 
  mutate(across(-Method, as.numeric)) %>% 
  janitor::clean_names()

data_desc = data_desc0 %>% 
  janitor::clean_names() %>% 
  separate(number_of_samples_treatment_control, into = c('n_trt', 'n_ctr')) %>% 
  separate(response_rate_treatment_control_in_percent, into = c('rate_trt', 'rate_ctr'), sep = '/') %>% # warning but not clear why
  mutate(across(matches('^n_|^rate_|ate'), as.numeric)) %>% # sigh hyphens
  mutate(
    ate_in_percent = ifelse(data_set == 'Churn', -1.48, ate_in_percent),
    data_set = janitor::make_clean_names(data_set)
  ) 



qini_long = qini %>% 
  pivot_longer(-method, names_to = 'data_set', values_to = 'qini') %>% 
  left_join(data_desc)
qini_sd_long = qini_sd %>% 
  pivot_longer(-method, names_to = 'data_set', values_to = 'qini_sd') %>% 
  drop_na()

qini_long %>% 
  ggplot(aes(x = qini)) +
  geom_density(aes(fill = method), color = NA, alpha = .25) +
  geom_density(aes(fill = method), color = NA, alpha = 1, data = . %>% filter(method == 'LG')) +
  scico::scale_fill_scico_d()


qini_long %>% 
  ggplot(aes(x = qini)) +
  geom_density(aes(fill = method), color = NA, alpha = .25) +
  geom_density(aes(fill = method), color = NA, alpha = 1, data = . %>% filter(method == 'LG')) +
  scico::scale_fill_scico_d()

qini_sd_long %>% 
  ggplot(aes(x = qini_sd)) +
  geom_density(aes(fill = method), color = NA, alpha = .25) +
  geom_density(aes(fill = method), color = NA, alpha = 1, data = . %>% filter(method == 'LG')) +
  scico::scale_fill_scico_d()

qini_long %>% 
  ggplot(aes(ate_in_percent, qini)) +
  geom_point(aes(color = method), size = 1) +
  geom_point(aes(color = method), size = 3, data = . %>% filter(method == 'LG'))  +
  scico::scale_color_scico_d()
