---
layout: page
title: Code
subtitle:
---

I try to organize my github files here.  The vast majority of these code snippets are conceptual demonstrations of more complicated models. Still in progress of migration.

## Model Fitting

[standard regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/standardlm.R), 
[penalized regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/penalizedML.R), 
[gradient descent regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/lm_gradientdescent.R) [(online)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/stochastic_gradientdescent.R), 
[hurdle poisson](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/hurdle.R), 
[hurdle negbin](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/hurdle.R), 
[zero-inflated poisson](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/poiszeroinfl.R), 
[zero-inflated negbin](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/NBzeroinfl.R), 
[Cox survival](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/survivalCox.R),
[confirmatory factor analysis](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/cfa_ml.R),
[stochastic volatility](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/stochasticVolatility.R),
[bivariate probit](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/bivariateProbit.R),
[quantile regression](http://htmlpreview.github.io/?https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/quantileRegression.html)
...

### Mixed models
one factor random effects [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.R) 
[(Julia)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.jl) 
[(Matlab)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.m), 
two factor random effects [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.R) 
[(Julia)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.jl) 
[(Matlab)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.m),
[mixed model](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy.R), 
[mixed model with correlated random effects](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy_withREcorrelation.R), 
...

### Bayesian
[BEST t-test](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstant_testBEST.R),
[linear regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_linregwithprior.R)
(Compare with [BUGS version](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/bugs_linreg.R), [JAGS](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/jags_linreg.R)),
[mixed model](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy.R), 
[mixed model with correlated random effects](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy_withREcorrelation.R), 
[beta regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstanBetaRegression.R),
mixed model with beta response [(Stan)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelBetaRegression.R) [(JAGS)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/jags_MixedModelBetaRegression.R),
[mixture model](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixtureModel.R),
[topic model](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/topicModelgibbs.R),
[multilevel mediation](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_multilevelMediation.R), 
[variational bayes regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/variationalBayesRegression.Rmd), 
[gaussian process](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting//gp%20Examples/gaussianProcessStan.Rmd), ...


### EM
[EM mixture univariate](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20Mixture.R),
[EM mixture multivariate](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20Mixture%20MV.R),
[EM probit](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20algorithm%20for%20probit%20example.R),
[EM pca](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20for%20pca.R),
[EM probabilistic pca](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20algorithm%20for%20ppca.R),
[EM state space model](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20for%20state%20space%20unobserved%20components.R)

### Curvy

#### Gaussian processses

[Gaussian Process noisy](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/gp%20Examples/gaussianprocessNoisy.R),
[Gaussian Process noise-free](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/gp%20Examples/gaussianprocessNoiseFree.R), 
[reproducing kernel hilbert space regression](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/RKHSReg/RKHSReg.md)
[gaussian process](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting//gp%20Examples/gaussianProcessStan.Rmd), ...

#### Additive models

[cubic spline](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/cubicsplines.R), 

## Workshops


## Programming Shenanigans

FizzBuzz test [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.R) [(julia)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.jl) [(Python)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.py),
Reverse a string recursively [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/stringReverseRecursively.R) [(Python)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/stringReverseRecursively.py),
Recursive Word Wrap [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/wordWrap.R) [(Python)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/wordWrap.py),
[get US Congress roll call data](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/getRollCall.R),
Scrape xkcd [(R)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/xkcdscrape.R) [(Python)](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/xkcdscrape.py), 
[Shakespearean Insulter](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/shakespeareanInsulter.R), 
[ggplot2 theme](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/ggtheme.R),
[R matrix speedups](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/matrixOperations.md), ...

## Other stuff