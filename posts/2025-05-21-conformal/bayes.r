library(tidyverse)
library(brms)

# note that ys are already logged
df_train = read_csv("data/housing_X_train.csv")
y_train = read_csv("data/housing_y_train.csv")
df_test = read_csv("data/housing_X_test.csv")
y_test = read_csv("data/housing_y_test.csv")


glimpse(y_test)

summary(lm(y_train$median_house_value ~ ., data = df_train))

pr = prior(normal(0, .5), class = b) 

mod_bayes = brm(
  median_house_value ~ .,
  data = df_train |> bind_cols(y_train),
  family = gaussian(),
  prior = pr,
  iter = 2000,
  warmup = 1000,
  chains = 4,
  cores = 4,
  thin = 4,
  control = list(adapt_delta = 0.90, max_treedepth = 15)
)

summary(mod_bayes)


# posterior_predict() 
preds = predict(mod_bayes, newdata = df_test, summary = TRUE, probs = c(.05, .95)) |> 
  as_tibble() |> 
  rename(
      y_pred_bayes = Estimate,
      bayes_lower = Q5,
      bayes_upper = Q95
  ) 
    
preds |>
  write_csv("data/housing_CI_bayes_results.csv")

