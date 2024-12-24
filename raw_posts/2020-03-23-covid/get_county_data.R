
# Preliminaries -----------------------------------------------------------

library(tidyverse)
get_county_data = function(
  first_date = lubridate::mdy('03-22-2020'),
  last_date  = Sys.Date() - 1,
  parallel = FALSE
) {
  
  base_url = 'https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_daily_reports/'
  
  dates = first_date:last_date
  
  if (parallel) {
    library(future)
    library(furrr)
    
    suppressWarnings({plan(multiprocess)})
    
    result = future_map_dfr(
      dates, 
      function(date)
        suppressWarnings({
          read_csv(
            paste0(
              base_url,
              format(lubridate::as_date(date), format = '%m-%d-%Y'),
              '.csv'
            ),
            col_types = c('cccccddd')
          ) %>% mutate(date = lubridate::as_date(date))
        })
    )
    
    plan(sequential)
  }
  else {
    result = map_df(
      dates, 
      function(date)
        suppressWarnings({
          read_csv(
            paste0(
              base_url,
              format(lubridate::as_date(date), format = '%m-%d-%Y'),
              '.csv'
            ),
            col_types = c('cccccddd')
          ) %>% mutate(date = lubridate::as_date(date))
        })
    )
  }
  
  result %>%  
    rename_all(tolower) %>% 
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
      ),
      # these counties have two entries for 3-22; the zero is dropped
      !(state == 'District of Columbia' & confirmed == 0), 
      !(state == 'Florida' & county == 'DeSoto' & confirmed == 0),
    ) %>% 
    select(date, everything()) %>% 
    mutate_at(vars(lat, long, confirmed), as.numeric) %>% 
    mutate(last_update = lubridate::as_datetime(last_update))
}