# Content

![content logo](img/content_logo.svg)  

Here you’ll find documents of varying technical degree covering things of interest to me, or which I think will be interesting to those I engage with. Generally you’ll find a mix of demonstrations on statistical and machine learning topics, programming, and data processing and visualization. Most focus on application in R as that’s what I used to primarily program with, but you’ll find plenty of Python demonstrations as well. Be aware that some of the content is a bit dated, but even if the programming aspects are a bit off, the concepts should still be relevant.

## My Book!

[Models Demystified](https://m-clark.github.io/book-of-models/)

This book is a comprehensive overview of the statistical and machine learning landscape, along with mny other related topics. It is designed to be accessible to those starting out on their data science journey, but also to provide a deeper dive into the concepts for those with more experience. It covers an array of useful models from simple linear regression to deep learning. The book is designed to be a reference for those who want to understand the models and techniques they are using, and to provide a guide for those who want to learn new techniques.

## Long Form Docs

[Mixed Models with R](../mixed-models-with-R/)  
This document focuses on mixed effects models using R, covering basic random effects models (random intercepts and slopes) as well as extensions into generalized mixed models and discussion of realms beyond.

[Bayesian Basics](../bayesian-basics/)  
This serves as a conceptual introduction to Bayesian modeling with examples using R and Stan.

[Model Estimation by Example](../models-by-example/)  
This shows ‘by-hand’ code for various models and estimation approaches, from linear regression to Bayesian multilevel mediation models, and demonstrations from penalized maximum likelihood to stochastic gradient descent.

[Generalized Additive Models](../generalized-additive-models/)  
An introduction to generalized additive models with an emphasis on generalization from familiar linear models and using the mgcv package in R.

[Introduction to Machine Learning](../introduction-to-machine-learning/)  
A gentle introduction to machine learning concepts with some application in R. It covers topics such as loss functions, cross-validation, regularization, and bias-variance trade-off, techniques such as penalized regression, random forests, and neural nets, and more.

[Practical Data Science](../data-processing-and-visualization/)  
Focus is on common data science tools and techniques in R, including data processing, programming, modeling, visualization, and presentation of results. Exercises may be found in the document, and demonstrations of most content in Python is available via [Jupyter notebooks](https://github.com/m-clark/data-processing-and-visualization/tree/master/jupyter_notebooks).

[Structural Equation Modeling](../sem/)  
This document (and related workshop) focuses on structural equation modeling. It is conceptually based, and tries to generalize beyond the standard SEM treatment. Topics include: graphical models (directed and undirected, including path analysis, bayesian networks, and network analysis), mediation, moderation, latent variable models (including principal components analysis and ‘factor analysis’), measurement models, structural equation models, mixture models, growth curves, IRT, collaborative filtering/recommender systems, hidden Markov models, multi-group models etc.

## Blog Posts

- [Is Boosting Still All You Need for Tabular Data?](../posts/2026-03-01-dl-for-tabular-foundational/)
- [Uncertainty Estimation with Conformal Prediction](../posts/2025-06-01-conformal/)
- [Imbalanced Outcomes](../posts/2025-04-07-class-imbalance/)
- [Deep Linear Models](../posts/2022-09-deep-linear-models/)
- [Exploring Time](../posts/2021-05-time-series/)
- [Programming Odds and Ends](../posts/2022-07-25-programming/)
- [Deep Learning for Tabular Data II](../posts/2022-04-01-more-dl-for-tabular/)
- [The Double Descent Phenomenon](../posts/2021-10-30-double-descent/)
- [Deep Learning for Tabular Data](../posts/2021-07-15-dl-for-tabular/)
- [Practical Bayesian Analysis (I, II)](../posts/2021-02-28-practical-bayes-part-i/)
- [Micro-macro Models](../posts/2020-08-31-micro-macro-mlm/)
- [Predictions with an Offset](../posts/2020-06-15-predict-with-offset/)
- [Factor Analysis and Related Methods](../posts/2020-04-10-psych-explained/)
- [Convergence Problems in Mixed Models](../posts/2020-03-16-convergence/)
- [Categorical Random Effects](../posts/2020-03-01-random-categorical/)
- [Mixed Models for Big Data](../posts/2019-10-20-big-mixed-models/)
- [Fractional Regression](../posts/2019-08-20-fractional-regression/)
- [Group Comparisons in SEM](../posts/2019-08-05-comparing-latent-variables/)  
- [Empirical Bayes](../posts/2019-06-21-empirical-bayes/)
- [Shrinkage in Mixed Models](../posts/2019-05-14-shrinkage-in-mixed-models/)  
- [Mediation Models](../posts/2019-03-12-mediation-models/)

## Statistical

### Models By Example

[Model Estimation by Example](../models-by-example/)  
This shows ‘by-hand’ code for various models and estimation approaches, from linear regression to Bayesian multilevel mediation models, and demonstrations from penalized maximum likelihood to stochastic gradient descent.

### Modeling in R

[Data Modeling in R](../R-models/)  
This document demonstrates a wide array of statistical and other models in R. Generic code is provided for standard regression, mixed, additive, survival, and latent variable models, principal components, factor analysis, SEM, cluster analysis, time series, spatial models, zero-altered models, text analysis, Bayesian analysis, machine learning and more.

The document is designed for newcomers to R, whether in a statistical sense, or just a programming one. It also should appeal to those working in other packages who are curious how to do the same sorts of things in R.

### Bayesian

[Bayesian Basics](../bayesian-basics/)  
This serves as a conceptual introduction to Bayesian modeling with examples using R and Stan.

[MCMC algorithms](./docs/ld_mcmc/)  
List of MCMC algorithms with brief descriptions.

[Bayesian Demonstration](https://micl.shinyapps.io/prior2post/)  
A simple interactive demonstration for those just starting on their Bayesian journey.

### Mixed Models

[Mixed Models with R](../mixed-models-with-R/)  
This workshop focuses on mixed effects models using R, covering basic random effects models (random intercepts and slopes) as well as extensions into generalized mixed models and discussion of realms beyond.

[Mixed Models Overview](docs/mixedModels/mixedModels.llms.md)  
An overview that introduces mixed models for those with varying technical/statistical backgrounds.

[Mixed Models Introduction](docs/mixedModels/anovamixed.llms.md)  
A non-technical document to introduce mixed models for those who have used ANOVA.

[Clustered Data Situations](../clustered-data/)  
A comparison of standard models, cluster robust standard errors, fixed effect models, mixed models (random effects models), generalized estimating equations (GEE), and latent growth curve models for dealing with clustered data (e.g. longitudinal, hierarchical etc.).

[Mixed Model Estimation](docs/mixedModels/mixedModelML.llms.md)  
Demonstration of mixed models via maximum likelihood and link to additive models.

[Mixed and Growth Curve Models](../mixed-growth-comparison/)  
A comparison of the mixed model vs. latent variable approach for longitudinal data (growth curve models), with [simulation](docs/mixedModels/growth_vs_mixed_sim.llms.md) of performance in situations of small sample sizes.

### Latent Variables/SEM

[Structural Equation Modeling](../sem/)  
This document (and related workshop) focuses on structural equation modeling. It is conceptually based, and tries to generalize beyond the standard SEM treatment. The initial workshop was given to an audience of varying background and statistical skill, but the document should be useful to anyone interested in the techniques covered. It is completely R-based, with special emphasis on the [lavaan](https://lavaan.ugent.be/) package. It will continue to be a work in progress, particularly the sections after the SEM chapter. Topics include: graphical models (directed and undirected, including path analysis, bayesian networks, and network analysis), mediation, moderation, latent variable models (including principal components analysis and ‘factor analysis’), measurement models, structural equation models, mixture models, growth curves. Topics I hope to provide overviews of in the future include other latent variable techniques/extensions such as IRT, collaborative filtering/recommender systems, hidden Markov models, multi-group models etc.

[Factor Analysis and Related Methods](docs/FA_notes.llms.md)  
This document gives a brief overview of many matrix factorization, dimension reduction, and latent variable techniques. Here is a list:

Principal Components Analysis - Factor Analysis - Probabilistic Components Analysis - Non-negative Matrix Factorization - Latent Dirichlet Allocation - Structural Equation Modeling - Item Response Theory - Independent Components Analysis - Multidimensional Scaling - t-Distributed Stochastic Neighbor Embedding (t-sne) - Recommender Systems - Hidden Markov Models - Random Effects Models - Bayesian Approaches - Mixture Models - k-means Cluster Analysis - Hierarchical Cluster Analysis - Latent Class Analysis

[Latent Variables, Sum Scores, Single Items](docs/lv_sim.llms.md)  
It is very common to use sum scores of several variables as a single entity to be used in subsequent analysis (e.g. a regression model). Some may even more use a single variable even though multiple indicators are available. Assuming the multiple measures indicate a latent construct, such typical practice would be problematic relative to using estimated factor scores, either constructed as part of a two-stage process or as part of a structural equation model. This document covers simulations in which comparisons in performance are made between latent variable and sum score or single item approaches.

[Lord’s Paradox](docs/lord/index.llms.md)  
Summary of Pearl’s technical reports on some modeling situations such as Lord’s Paradox and Simpson’s Paradox that lead to surprising results that are initially at odds with our intuition. Looks particularly at the issue of change scores vs. controlling for baseline.

### Other Statistical

[Generalized Additive Models](../generalized-additive-models/)  
An introduction to generalized additive models with an emphasis on generalization from familiar linear models and using the mgcv package in R.

[Introduction to Machine Learning](../introduction-to-machine-learning/)  
A gentle introduction to machine learning concepts with some application in R.

[Reliability](../reliability/)  
An unfinished document that ties together some ideas regarding the statistical and conceptual notion of reliability..

[Fractional Regression](../posts/2019-08-20-fractional-regression/)  
A quick primer regarding data between zero and one, including zero and one.

[Categorical Regression Models](docs/logregmodels.llms.md)  
An overview of regression models for binary, multinomial, and ordinal outcomes, with connections among various types of models.

[Topic Modeling Demo](docs/topic_models/topic-model-demo.llms.md)  
A demonstration of Latent Dirichlet Allocation for topic modeling in R.

[Comparing Measures of Dependency](./docs/CorrelationComparison.pdf)  
A summary of articles that look at various measures of dependency Pearson’s r, Spearman’s rho, and Hoeffding’s D, and newer ones such as Distance Correlation and Maximal Information Coefficient.

## Programming

Check the old [workshops](workshops.llms.md) section also for programming-related content.

[Practical Data Science](../data-processing-and-visualization/) (more details about this document below). The intention was to cover five key topics: basic information processing, programming, modeling, visualization, and publication/presentation.

[Exploratory Data Analysis Tools](../exploratory-data-analysis-tools/) An overview of various packages useful for quick exploration of data.

[FastR](docs/fastr.llms.md)  
A notebook on how to make R faster before or irrespective of the machinery used. Topics include avoiding loops, vectorization, faster I/O etc.

[Engaging the Web with R](../webR/)  
Document regarding the use of R for web scraping, extracting data via an API, interactive web-based visualizations, and producing web-ready documents. It serves as an overview of ways one might start to use R for web-based activities as opposed to a hand-on approach.

## Workshops

I used to give workshops regularly when I worked in academia. Although they generally won’t age well, I have kept the content [here](workshops.llms.md) for any that might be interested.

## Miscellaneous

[R for Social Science](./docs/RSocialScience.pdf)  
This was put together in a couple of days under duress, and is put here in case someone can find it useful (and thus make the time spent on it not completely wasted).

## Reuse

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

## Citation

BibTeX citation:

``` quarto-appendix-bibtex
@online{untitled,
  author = {},
  title = {Content},
  url = {https://m-clark.github.io/documents.html},
  langid = {en}
}
```

For attribution, please cite this work as:

“Content.” n.d. <https://m-clark.github.io/documents.html>.
