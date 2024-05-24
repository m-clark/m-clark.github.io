
# Preliminaries -----------------------------------------------------------

library(tidyverse)

bh = keras::dataset_boston_housing()
str(bh)

df_train = tibble(as_tibble(bh$train$x), y = bh$train$y)
df_test  = tibble(as_tibble(bh$test$x), y = bh$test$y)

library(lightgbm)

#' ps(
#'   #'   num_iterations = p_int(100, 500, tags = 'budget'),
#'   #'   max_depth = p_int(2, 3),
#'   #'   num_leaves = p_int(3,5)
#'   #' )

mod_basic = fit_model(
  X            = df_train,
  target       = 'y',
  learner      =  mlr3extralearners::lrn(
    'regr.lightgbm', 
    objective        = 'regression',
    feature_fraction =  .5, # made up heuristic: sqrt(ncol(df_train) - 1) / (ncol(df_train) - 1), else .5
    num_iterations   = 500,
    extra_trees      = TRUE
  ),
  # params       = base_params_lgb,  # only if not tuning, a list of named parameters
  importance   = TRUE,
  save_preds   = TRUE,
  optimize     = FALSE,
  # tune_params  = tune_params_lgb, 
  # tuner_args   = list(repetitions = 2), # only for a complete run with full
  save_tuning  = FALSE, 
  opt_measure  = mlr3::msr("regr.rmse"), # regr.srho
  test_measure =  mlr3measures::rmse,
  cv_folds     = 5,
  test_data    = df_test,
  seed         = 8675309
)

mod_basic$test_set_performance




df_train_col = df_train %>% 
  mutate(
    Vc11 = V1 + rnorm(n(), mean = V1, sd = .1),
    Vc12 = V1 + rnorm(n(), mean = V1, sd = sd(V1)),
    Vc13 = V1 + rnorm(n(), mean = V1, sd = 2*sd(V1)),
    # Vc21 = V1 + rnorm(n(), mean = V2, sd = .1),
    # Vc22 = V1 + rnorm(n(), mean = V2, sd = sd(V1)),
    # Vc23 = V1 + rnorm(n(), mean = V2, sd = 2*sd(V1)),
    # Vc31 = V1 + rnorm(n(), mean = V3, sd = .1),
    # Vc32 = V1 + rnorm(n(), mean = V3, sd = sd(V1)),
    # Vc33 = V1 + rnorm(n(), mean = V3, sd = 2*sd(V1)),
  ) #%>% cor()

df_test_col  = df_test %>% 
  mutate(
    Vc11 = V1 + rnorm(n(), mean = V1, sd = .1),
    Vc12 = V1 + rnorm(n(), mean = V1, sd = sd(V1)),
    Vc13 = V1 + rnorm(n(), mean = V1, sd = 2*sd(V1)),
    # Vc21 = V1 + rnorm(n(), mean = V2, sd = .1),
    # Vc22 = V1 + rnorm(n(), mean = V2, sd = sd(V1)),
    # Vc23 = V1 + rnorm(n(), mean = V2, sd = 2*sd(V1)),
    # Vc31 = V1 + rnorm(n(), mean = V3, sd = .1),
    # Vc32 = V1 + rnorm(n(), mean = V3, sd = sd(V1)),
    # Vc33 = V1 + rnorm(n(), mean = V3, sd = 2*sd(V1)),
  )
  


#' ps(
#'   #'   num_iterations = p_int(100, 500, tags = 'budget'),
#'   #'   max_depth = p_int(2, 3),
#'   #'   num_leaves = p_int(3,5)
#'   #' )
#'   

basic_error = map_df(
  1:250,
  \(seed){
    set.seed(seed)
    tibble(
      rmse = fit_model(
        X            = df_train,
        target       = 'y',
        learner      =  mlr3extralearners::lrn(
          'regr.lightgbm', 
          objective        = 'regression',
          feature_fraction =  .5, # made up heuristic: sqrt(ncol(df_train) - 1) / (ncol(df_train) - 1), else .5
          num_iterations   = 500,
          extra_trees      = TRUE,
          seed = seed
        ),
        # params       = base_params_lgb,  # only if not tuning, a list of named parameters
        importance   = FALSE,
        save_preds   = FALSE,
        optimize     = FALSE,
        # tune_params  = tune_params_lgb, 
        # tuner_args   = list(repetitions = 2), # only for a complete run with full
        save_tuning  = FALSE, 
        opt_measure  = mlr3::msr("regr.rmse"), # regr.srho
        test_measure = mlr3measures::rmse,
        cv_folds     = 5,
        test_data    = df_test,
        seed         = seed
      )$test_set_performance
    )
  }
)


col_error = map_df(
  1:250,
  \(seed)
  tibble(
    rmse = fit_model(
    X            = df_train_col,
    target       = 'y',
    learner      =  mlr3extralearners::lrn(
      'regr.lightgbm', 
      objective        = 'regression',
      feature_fraction =  .5, # made up heuristic: sqrt(ncol(df_train) - 1) / (ncol(df_train) - 1), else .5
      num_iterations   = 500,
      extra_trees      = TRUE,
      seed = seed
    ),
    # params       = base_params_lgb,  # only if not tuning, a list of named parameters
    importance   = FALSE,
    save_preds   = FALSE,
    optimize     = FALSE,
    # tune_params  = tune_params_lgb, 
    # tuner_args   = list(repetitions = 2), # only for a complete run with full
    save_tuning  = FALSE, 
    opt_measure  = mlr3::msr("regr.rmse"), # regr.srho
    test_measure = mlr3measures::rmse,
    cv_folds     = 5,
    test_data    = df_test_col,
    seed         = seed
  )$test_set_performance
  )
)

bind_rows(
  tibble(type = 'orig', rmse = basic_error$rmse),
  tibble(type = 'collinear', rmse = col_error$rmse),
) %>% 
  ggplot(aes(x = rmse)) +
  geom_vline(aes(xintercept = rmse, color = type),
             data = . %>% summarize(rmse = mean(rmse), .by = type)) +
  geom_density(aes(fill = type, color = type), alpha = .5)


# In general boosting should settle on one vs some other correlated feature
# during a specific run, but
# - what about across k-folds ?
# - what about across validation settings in tuning?
# - what about on the test set
# - what about features weakly correlated with target?
# - what about smaller N?