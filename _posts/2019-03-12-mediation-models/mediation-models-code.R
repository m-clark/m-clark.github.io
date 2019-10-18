
# Preliminaries -----------------------------------------------------------

library(tidyverse) # some data processing


# mediation package -------------------------------------------------------



library(mediation)

data(jobs)

model_mediator <- lm(job_seek ~ treat + econ_hard + sex + age, data = jobs)
model_outcome  <- lm(depress2 ~ treat + econ_hard + sex + age + job_seek, data = jobs)

# Estimation via quasi-Bayesian approximation
?mediate
mediation_result <- mediate(
  model_mediator, 
  model_outcome,
  sims = 500,
  treat = "treat",
  mediator = "job_seek"
)

detach(package:mediation)
detach(package:MASS)

summary(mediation_result)
plot(mediation_result)


# lavaan package ----------------------------------------------------------


library(lavaan)

sem_model = '
  job_seek ~ a*treat + econ_hard + sex + age
  depress2 ~ c*treat + econ_hard + sex + age + b*job_seek
 
  # direct effect
  direct := c
 
  # indirect effect
  indirect := a*b
 
  # total effect
  total := c + (a*b)
'

model_sem = sem(sem_model, data=jobs, se='boot', bootstrap=500)
summary(model_sem, rsq=T)  # compare with ACME in mediation



# psych package -----------------------------------------------------------

library(psych)

mediation_psych = mediate(
  depress2 ~ treat + (job_seek) - econ_hard - sex - age, 
  data = jobs,
  n.iter = 500
)

print(mediation_psych, short = F, digits=3)  # short = F provides what you'd get from summary()

detach(package:psych)
# detach(package:MASS) if loaded



# brms package ------------------------------------------------------------

# you'll need to install rstan and then brms; rstan installation at this link:
# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

library(brms)

model_mediator <- bf(job_seek ~ treat + econ_hard + sex + age)
model_outcome  <- bf(depress2 ~ treat + job_seek + econ_hard + sex + age)

med_result = brm(
  model_mediator + model_outcome + set_rescor(FALSE), 
  data = jobs, 
  cores = 2
)
summary(med_result)

print(sjstats::mediation(med_result), digits=4)  # same output as mediation package

# same as
hypothesis(med_result, 'jobseek_treat*depress2_job_seek = 0')


pp_check(med_result, resp = 'depress2') + ggtitle('Depression Outcome')
pp_check(med_result, resp = 'jobseek') + ggtitle('Mediator')



# bnlearn package ---------------------------------------------------------

library(bnlearn)

whitelist = data.frame(
  from = c('treat', 'treat', 'job_seek'),
  to   = c('job_seek', 'depress2', 'depress2')
)

blacklist = expand.grid(
  from = colnames(mediation_result$model.y$model),
  to   = c('treat', 'sex', 'age')
)

# For simpler output we'll use treatment and sex as numeric (explained later)
jobs_trim = jobs %>% 
  dplyr::select(
    unique(colnames(mediation_result$model.y$model), 
           colnames(mediation_result$model.m$model))
    ) %>% 
  mutate(
    treat = as.numeric(treat),
    sex = as.numeric(sex)
    )

model = gs(jobs_trim, whitelist = whitelist, blacklist = blacklist)
plot(model)



whitelist = data.frame(
  from = c('treat', 'age', 'sex', 'econ_hard', 'treat', 'job_seek', 'age', 'sex', 'econ_hard'),
  to   = c('job_seek', 'job_seek','job_seek','job_seek', 'depress2', 'depress2', 'depress2', 'depress2', 'depress2')
)

blacklist = expand.grid(
  from = colnames(mediation_result$model.y$model),
  to   = c('treat', 'sex', 'age', 'econ_hard')
) 

model = gs(jobs_trim, whitelist = whitelist, blacklist = blacklist)

plot(model)

parameters = bn.fit(model, jobs_trim)

parameters$depress2$coefficients
parameters$job_seek$coefficients



# Python ------------------------------------------------------------------

## import statsmodels.api as sm
## from statsmodels.stats.mediation import Mediation
## import numpy as np
## import pandas as pd
## 
## outcome_model = sm.OLS.from_formula("depress2 ~ treat + econ_hard + sex + age + job_seek",
##                                     data = r.jobs)
##
## 
## mediator_model = sm.OLS.from_formula("job_seek ~ treat + econ_hard + sex + age",
##                                      data = r.jobs)
## 
## med = Mediation(outcome_model, mediator_model, "treat", "job_seek")
## 
## med_result = med.fit(n_rep=500)
## 
## np.round(med_result.summary(), decimals=3)
## 
## use "data\jobs.dta"
## 
## sem (job_seek <- treat econ_hard sex age) (depress2 <- treat econ_hard sex age job_seek), cformat(%9.3f) pformat(%5.2f)
## 
## estat teffects, compact cformat(%9.3f) pformat(%5.2f)
