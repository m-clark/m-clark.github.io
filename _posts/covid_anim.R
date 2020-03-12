library(rvest)
library(tidyverse)

site = 'https://en.wikipedia.org/wiki/Template:2019%E2%80%9320_coronavirus_outbreak_data/WHO_situation_reports'

init = read_html(site) %>% 
  html_table(fill = T)

length(init)

map(init, dim)

# map(init, glimpse)

# for now it starts at the fourth table and ends with the seventh table, but in general it's very poorly organized; 

# need to remove stupid bracket footnotes
clean_tables <- function(data, world = FALSE) {
  col_names = slice(data, 1)
  col_names[1] = 'region'
  
  world_data = filter(data, str_detect(X1, 'World|Doubling|Total'))
  
  data = filter(data, !str_detect(X1, 'Date|World|Doubling|Total|Notes'))
  
  colnames(data) = colnames(world_data) = col_names
  
  na_columns = which(map_lgl(data, function(x) all(is.na(x)))) # 'feature' that na columns can't be dealt with
  
  data[, na_columns] = NULL
  world_data[, na_columns] = NULL
  
  if (world) {
    data = world_data %>% 
      filter(!str_detect(tolower(region), 'doubling')) #%>% 
  } 
  
  data = data %>% 
    rename(first_report = `First reported case`) %>% 
    # remove footnotes and commas
    mutate_at(vars(-region, -first_report), function(x)
      str_remove_all(x, '\\[(.*?)\\]')) %>% 
    mutate_at(vars(-region, -first_report), function(x)
      as.numeric(str_remove_all(x, '[[:punct:]]'))) %>%
    # reshape
    pivot_longer(c(-region,-first_report),
                 names_to = 'date',
                 values_to = 'count') %>% 
    # deal with dates
    mutate(first_report = lubridate::as_date(first_report)) %>% 
    separate(date, into = c('month', 'day')) %>% 
    mutate(date = lubridate::ymd(glue::glue('2020-{month}-{day}'))) 
  
  if (world) 
    return(select(data, -first_report))
  else
    data
}

# check it hear
# debugonce(clean_tables)
clean_tables(init[[4]], world = F)
clean_tables(init[[4]], world = T)
clean_tables(init[[5]])

countries = map_df(init[4:7], clean_tables)
world = map_df(init[4:7], clean_tables, world = TRUE)

all = bind_rows(countries, world) %>% 
  filter(!grepl(region, pattern = 'Total|except'))

library(gganimate)

highlight = c('USA',
              'China',
              'Japan',
              'South Korea',
              'Italy',
              'Iran',
              'France',
              'Germany',
              'Spain')

p = all %>% 
  ggplot(aes(x = date, y = count)) +
  geom_path(aes(group = region), alpha = .01) +
  geom_point(
    aes(),
    size = 6,
    alpha = .1,
    data = filter(world, region == 'World')
  ) +
  geom_point(
    aes(color = region),
    size = 2,
    alpha = .5,
    data = filter(countries, region %in% highlight)
  ) +
  scico::scale_color_scico_d(begin = .1, end = .9) +
  scale_x_date(date_breaks = '2 weeks') +
  scale_y_continuous(trans = 'log',
                     breaks = c(50, 100, 500, 1000, 5000, 10000, 50000, 100000)) +
  visibly::theme_clean() + 
  labs(x = '', caption = 'Dark large dot is world total') +
  theme(
    axis.text.x = element_text(size = 6),
    legend.title = element_blank(),
    legend.key.size = unit(.25, 'cm'),
    legend.text = element_text(size = 6),
    legend.box.spacing =  unit(0, 'mm'),
    legend.box.margin =  margin(0),
    title = element_text(size = 12)
  )

p

# p +
#   transition_reveal(date) +
#   shadow_trail(alpha = 0.01) 

p_anim = p +
  transition_reveal(date) +
  shadow_wake(wake_length = 1/3, falloff = "cubic-in-out") 

animate(
  p_anim,
  nframes = 120,
  fps = 10,
  start_pause = 10,
  end_pause = 10,
  width = 800,
  height = 600,
  res = 144
)

anim_save('img/covid.gif')


# plot derivs
all_for_model = all %>% 
  mutate(region = factor(region),
         date_num = as.numeric(date)) %>% 
  group_by(region) %>% 
  mutate(N = n()) %>% 
  ungroup() %>% 
  filter((region %in% highlight | N >= 30 & region != 'World') & date >= '2020-02-01')

library(lubridate)

library(mgcv)

mod = bam(
  count ~ s(date_num, region, bs = 'fs', k = 5),
  # family = poisson,
  # family = Gamma(link = 'log'),
  # family = gaussian(link = 'log'),
  data = all_for_model,
  nthreads = 10
)
summary(mod)

visibly::plot_gam_by(mod, date_num, region, begin = .1, end = .8, alpha = .7) +
  geom_text(
    aes(label = region),
    size = 2,
    vjust = -.75,
    show.legend = FALSE,
    data = . %>% filter(date_num == max(date_num))
  )

plotly::ggplotly()

slibrary(gratia)

deriv_dat_1 = derivatives(mod, term = 'date_num', n = 250)

# draw(deriv_dat_1) #+
# lims(y = c(-2.25, 1.5))

plot_dat = deriv_dat_1 %>% 
  mutate(
    date = lubridate::as_date(data),
    region = str_remove_all(smooth, 's\\(date_num\\):region'),
    region = fs_var
  )



plot_dat_peaks_valleys = plot_dat %>%
  group_by(region) %>% 
  slice(quantmod::findPeaks(derivative)-1, 
        quantmod::findValleys(derivative)-1)  # see helpfile for why -1


library(ggrepel)

plot_dat %>% 
  ggplot(aes(date, y = derivative)) +
  # geom_ribbon(aes(ymin=lower, ymax=upper, group=region), alpha = .02) +
  geom_hline(yintercept = 0, color = 'gray92') +
  geom_line(aes(color = region), alpha = .5) +
  geom_point(aes(color = region), size = 2, data = plot_dat_peaks_valleys %>% filter(region == 'China')) +
  geom_text_repel(
    aes(label = as.character(date), color = region), 
    size = 2,
    alpha = .5,
    data = plot_dat_peaks_valleys %>% filter(region == 'China')) +
  geom_text_repel(
    aes(label = region), 
    size = 2,
    alpha = .5,
    data = plot_dat %>% filter(date == max(date) & derivative > 50)) +
  labs(x = '') +
  scico::scale_color_scico_d(begin = .25, end = .75) +
  visibly::theme_clean() +
  theme(
    legend.position = 'bottom',
  )
