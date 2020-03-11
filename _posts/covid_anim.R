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

p = countries %>% 
  ggplot(aes(x = date, y = count, group = region)) +
  # spline cannot work with gganimate as needs multiple points
  # ggalt::geom_xspline(alpha = .05, data = filter(countries %>% group_by(region) %>% mutate(N=n()) %>% ungroup(), N>9)) +
  geom_path(aes(),
            alpha = .01,
            # data = filter(countries,!region %in% highlight)
            ) +
  geom_point(
    aes(color = region),
    size = 3,
    alpha = .5,
    data = filter(countries, region %in% highlight)
  ) +
  geom_point(
    aes(group = NULL),
    size = 6,
    alpha = .5,
    data = filter(world, region == 'World')
  ) +
  scico::scale_color_scico_d(begin = .1, end = .9) +
  scale_y_continuous(trans = 'log',
                     breaks = c(50, 100, 500, 1000, 5000, 10000, 50000, 100000)) +
  visibly::theme_clean() + 
  theme(legend.title = element_blank())

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
  res = 72
)

anim_save('img/covid.gif')
