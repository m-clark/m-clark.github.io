
# Preliminaries -----------------------------------------------------------

library(tidyverse) # required for functions


read_open_covid_data <- function(
  country = NULL,     # Filter to specific country
  current = FALSE,    # Only the current data
  totals  = FALSE     # Only totals (no regional)
) {
  
  if (current) {
    data = readr::read_csv('https://open-covid-19.github.io/data/data_latest.csv',
                           col_types = 'Dcccccddddd')
  }
  else {
    data = read_csv('https://open-covid-19.github.io/data/data.csv',
                    col_types = 'Dcccccddddd')
  }
  
  if (!is.null(country)) {
    data = filter(data, CountryCode == country | CountryName == country)
  }
  
  # other cleanup and additions
  data = data %>% 
    rename(
      country_code = CountryCode,
      country_name = CountryName,
      region_code  = RegionCode,
      region_name  = RegionName,
      total_confirmed = Confirmed,
      total_deaths    = Deaths
    ) %>% 
    rename_all(tolower) %>% 
    group_by(country_code, region_code) %>% 
    mutate(
      total_deaths    = ifelse(is.na(total_deaths), 0, total_deaths),
      daily_confirmed = total_confirmed - lag(total_confirmed),
      daily_deaths    = total_deaths - lag(total_deaths),
      region_name     = if_else(region_name == 'South Caroline', 'South Carolina', region_name),
      death_rate      = total_deaths/total_confirmed
    ) %>% 
    mutate_at(vars(contains('daily')), function(x) ifelse(is.na(x), 0, x)) %>% 
    select(date:region_name, contains('daily'), contains('total'), death_rate, everything()) %>% 
    ungroup()
  
  if (totals) data = filter(data, is.na(region_code))
  
  ungroup(data)
}

read_jh_covid_data <- function(
  first_date = lubridate::mdy('01-22-2020'),
  last_date  = Sys.Date() - 1,
  country_state = NULL,     # country if global data, state if US
  include_regions = FALSE,  # for world data, include province/state specific data?
  us         = FALSE,
  wider      = TRUE
) {
  
  if (!us) {
    cleanup_global = function(data) {
      data = data %>% 
        pivot_longer(
          -c(`Province/State`, `Country/Region`, Lat, Long),
          names_to = 'date',
          values_to = 'count'
        ) %>% 
        mutate(
          date = lubridate::mdy(date),
          Lat = round(Lat, 4),
          Long = round(Long, 4),   # because of odd insertion of extreme decimal values for some places (e.g. UK)
        ) %>%  
        rename(
          province_state = `Province/State`,
          country_region = `Country/Region`,
        ) %>% 
        rename_all(tolower)
    }
    
    init_confirmed  = readr::read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
    init_deaths  = readr::read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv')
    init_recovered  = readr::read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv')
    
    data = map_df(
      list(
        init_confirmed, 
        init_deaths, 
        init_recovered
      ),
      cleanup_global,
      .id = 'type') %>% 
      mutate(type = factor(type, 
                           labels = c(
                             'confirmed', 
                             'deaths', 
                             'recovered'
                           )))
    
    if (!is.null(country_state))
      data = data %>% filter(country_region == country_state)
    
    if (!include_regions) {
      
      # fix can, chin, aus by creating an 'NA' for total counts
      can_chin_aus = data %>% 
        filter(country_region %in% c('Australia', 'Canada', 'China')) %>% 
        group_by(type, country_region, date) %>% 
        summarise(count = sum(count)) %>% 
        mutate(lat = NA, long = NA)
      
      data = data %>% 
        filter(is.na(province_state)) %>%
        select(-province_state) %>% 
        bind_rows(can_chin_aus)
    }
  }
  
  if (us) {
    
    cleanup_us = function(data) {
      data = data %>% 
        pivot_longer(
          -c(UID:Combined_Key),
          names_to = 'date',
          values_to = 'count'
        ) %>% 
        mutate(date = lubridate::mdy(date)) %>%  
        rename(
          province_state = Province_State,
          country_region = Country_Region,
        ) %>% 
        rename_all(tolower)
    }
    
    init_confirmed  = readr::read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv')
    init_deaths  = readr::read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv')
    
    data = map_df(list(init_confirmed, init_deaths), cleanup_us, .id = 'type') %>%
      mutate(type = factor(type, labels = c('confirmed', 'deaths')))
    
    data = data %>%  
      rename(
        county = admin2,
        state  = province_state,
        long   = long_
      ) %>% 
      filter(
        country_region == 'US',
        !state %in% c(
          'Puerto Rico',
          'Guam',
          'Northern Mariana Islands',
          'American Samoa',
          'Wuhan Evacuee',
          'Virgin Islands',
          'Grand Princess',
          'Diamond Princess'
        )
      )
    
    if (!is.null(country_state))
      data = data %>% filter(state == country_state)
  }
  
  if (wider) {
    data = data %>%  
      pivot_wider(values_from = count, names_from = type) 
  }
  
  data
}


read_nyt_data <- function(states = TRUE) {
  if (states) {
    us_states0 <- readr::read_csv(
      "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv",
      col_types = 'Dccdd'
    )
    
    data = us_states0 %>%
      filter(!state %in% c(
        'Puerto Rico',
        'Guam',
        'Northern Mariana Islands',
        'Virgin Islands',
        'American Samoa')
      ) %>% 
      arrange(state, date) %>%
      group_by(state) %>%
      mutate(
        daily_cases = cases - lag(cases, default = NA),
        daily_cases = if_else(is.na(daily_cases), cases, daily_cases),
        daily_deaths = deaths - lag(deaths, default = NA),
        daily_deaths = if_else(is.na(daily_deaths), deaths, daily_deaths)
      ) %>% 
      ungroup() %>% 
      left_join(tibble(state = state.name, state_abb = state.abb)) %>% 
      mutate(state_abb = as.factor(state_abb))
  }
  else {
    counties0 <- readr::read_csv(
      "https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv",
      col_types = 'Dcccdd'
    )
    
    data = counties0 %>%
      filter(!state %in% c(
        'Puerto Rico',
        'Guam',
        'Northern Mariana Islands',
        'Virgin Islands',
        'American Samoa')
      ) %>% 
      arrange(state, date) %>%
      group_by(state, county) %>%
      mutate(
        daily_cases = cases - lag(cases, default = NA),
        daily_cases = if_else(is.na(daily_cases), cases, daily_cases),
        daily_deaths = deaths - lag(deaths, default = NA),
        daily_deaths = if_else(is.na(daily_deaths), deaths, daily_deaths)
      ) %>% 
      ungroup() %>% 
      left_join(tibble(state = state.name, state_abb = state.abb)) %>% 
      mutate(state_abb = as.factor(state_abb))
  }
  
  data
}