---
layout: page
title: Code
subtitle:
---

The vast majority of these code snippets are conceptual demonstrations of more complicated models. The audience is generally faculty, researchers, and graduate students in applied fields who, like I did, want to go beyond their basic statistical training.  However, I hope it helps anyone who happens to stumble across it.


## Model Fitting

[standard regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/standardlm.R), 
[penalized regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/penalizedML.R), 
[lasso regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/lasso.R),
[ridge regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/ridge.R),
[newton and IRLS](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/newton_irls.R),
nelder-mead [(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/nelder_mead.py) [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/nelder_mead.R),
[gradient descent regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/lm_gradientdescent.R) [(online)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/stochastic_gradientdescent.R), 
[bivariate probit](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/bivariateProbit.R),
[heckman selection](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/heckman_selection.R),
[tobit](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/tobit.R),
[naive bayes](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/naivebayes.R),
[multinomial regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/multinomial.R),
[ordinal regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/ordinal_regression.R),
[quantile regression](http://htmlpreview.github.io/?https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/quantileRegression.html),
[hurdle poisson](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/hurdle.R), 
[hurdle negbin](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/hurdle.R), 
[zero-inflated poisson](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/poiszeroinfl.R), 
[zero-inflated negbin](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/NBzeroinfl.R), 
[Cox survival](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/survivalCox.R),
[confirmatory factor analysis](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/cfa_ml.R),
[Markov model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/markov_model.R),
hidden Markov model [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/hmm_viterbi.R)
[(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/hmm_viterbi.py),
[stochastic volatility](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/stochasticVolatility.R),
[extreme learning machine](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/elm.R),
[Chinese restaurant process, Indian buffet process](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/crp.R),
[One-line models (an exercise)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/one_line_models.R), ...


### Mixed models

one factor random effects [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.R) 
[(Julia)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.jl) 
[(Matlab)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/onefactorRE.m), 
two factor random effects [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.R) 
[(Julia)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.jl) 
[(Matlab)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/twofactorRE.m),
[mixed model via ML](https://m-clark.github.io/docs/mixedModels/mixedModelML.html),
[mixed model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy.R), 
[mixed model with correlated random effects](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy_withREcorrelation.R), See the documents section for more...


### Bayesian

[BEST t-test](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstant_testBEST.R),
[linear regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_linregwithprior.R)
(Compare with [BUGS version](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/bugs_linreg.R), [JAGS](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/jags_linreg.R)),
[mixed model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy.R), 
[mixed model with correlated random effects](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelSleepstudy_withREcorrelation.R), 
[beta regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstanBetaRegression.R),
mixed model with beta response [(Stan)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixedModelBetaRegression.R) [(JAGS)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/jags_MixedModelBetaRegression.R),
[mixture model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_MixtureModel.R),
[topic model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/topicModelgibbs.R),
[multinomial models](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/multinomial),
[multilevel mediation](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/rstan_multilevelMediation.R), 
[variational bayes regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/variationalBayesRegression.Rmd), 
[gaussian process](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting//gp%20Examples/gaussianProcessStan.Rmd),
[horseshoe prior](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/horseshoe/README.md), 
[item response theory](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/Bayesian/StanBugsJags/IRT_models), ...


### EM

[EM mixture univariate](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20Mixture.R),
[EM mixture multivariate](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20Mixture%20MV.R),
[EM probit](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20algorithm%20for%20probit%20example.R),
[EM pca](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20for%20pca.R),
[EM probabilistic pca](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20algorithm%20for%20ppca.R),
[EM state space model](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/EM%20Examples/EM%20for%20state%20space%20unobserved%20components.R)

### Wiggly

#### Gaussian processses

[Gaussian Process noisy](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/gp%20Examples/gaussianprocessNoisy.R),
[Gaussian Process noise-free](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/gp%20Examples/gaussianprocessNoiseFree.R), 
[reproducing kernel hilbert space regression](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/RKHSReg/RKHSReg.md),
[Bayesian Gaussian process](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting//gp%20Examples/gaussianProcessStan.Rmd), ...

#### Additive models

[cubic spline](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/ModelFitting/cubicsplines.R), ...


## Programming Shenanigans


FizzBuzz test [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.R) [(julia)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.jl) [(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/fizzbuzz.py),
Reverse a string recursively [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/stringReverseRecursively.R) [(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/stringReverseRecursively.py),
Recursive Word Wrap [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/wordWrap.R) [(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/wordWrap.py),
[calculate compound interest recursively](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/compound.R),
[get US Congress roll call data](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/getRollCall.R),
Scrape xkcd [(R)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/xkcdscrape.R) [(Python)](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/xkcdscrape.py), 
[Shakespearean Insulter](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/shakespeareanInsulter.R), 
[spurious correlation with ratios](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/spuriousCorrelationwithRatios.R),
[R matrix speedups](https://github.com/m-clark/Miscellaneous-R-Code/blob/master/Other/Programming_Shenanigans/matrixOperations.md), ...


## Packages

I have a couple packages for personal use and to learn more about the code development process, but in case someone might find something useful therein, here they are:

[lazerhawk](https://github.com/m-clark/lazerhawk)

[heatR](https://github.com/m-clark/heatR)
