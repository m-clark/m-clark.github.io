---
layout: page
title: Documents
subtitle:
---


Here you'll find documents of varying technical degree covering things of interest to me.  Most are demonstration of statistical concepts or programming and may be geared towards beginners or more advanced.  I group them based on whether they are more focused on statistical concepts, programming or tools, or miscellaneous.

# Statistical

### Bayesian

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Bayesian Basics</span>](../docs/IntroBayes.html)     
<span itemprop="description">This serves as a conceptual introduction to <span itemprop="keywords">Bayesian</span> modeling with examples using <span itemprop="keywords">R</span>, <span itemprop="keywords">Stan</span>, and to a lesser extent, <span itemprop="keywords">BUGS</span> and <span itemprop="keywords">JAGS</span>.
<br>
[Recently updated content](../docs/bayesian_book/).  Notable changes to content, and changed layout. Not satisfied with the layout yet and may change it soon.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">MCMC algorithms</span>](../docs/ld_mcmc/)     
<span itemprop="description">List of MCMC algorithms with brief descriptions.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name">Bayesian Demonstration</span>](http://micl.shinyapps.io/prior2post/)     
<span itemprop="description">A simple interactive demonstration for those just starting on their <span itemprop="keywords">Bayesian</span> journey.
</span>
</span>


### Mixed Models

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Mixed Models Overview</span>](../docs/mixedModels/mixedModels.html)  
<span itemprop="description">An overview that introduces <span itemprop="keywords">mixed models</span> for those with varying technical/statistical backgrounds.</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Mixed Models Introduction</span>](../docs/mixedModels/anovamixed.html)  
<span itemprop="description">A non-technical document to introduce <span itemprop="keywords">mixed models</span> for those who have used ANOVA.</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Clustered Data Situations</span>](../docs/clustered/)  
<span itemprop="description">A comparison of standard models, <span itemprop="keywords">cluster robust standard errors</span>, <span itemprop="keywords">fixed effect models</span>,  <span itemprop="keywords">mixed models (random effects models)</span>, <span itemprop="keywords">generalized estimating equations (GEE)</span>, and <span itemprop="keywords">latent growth curve models</span> for dealing with clustered data (e.g. <span itemprop="keywords">longitudinal</span>, <span itemprop="keywords">hierarchical</span> etc.).
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Mixed Model Estimation</span>](../docs/mixedModels/mixedModelML.html)  
<span itemprop="description">Demonstration of <span itemprop="keywords">mixed models</span> via <span itemprop="keywords">maximum likelihood</span> and link to <span itemprop="keywords">additive models</span>.</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Mixed and Growth Curve Models</span>](../docs/mixedModels/growth_vs_mixed.html)  
<span itemprop="description">A comparison of the <span itemprop="keywords">mixed model</span> vs. <span itemprop="keywords">latent variable</span> approach for <span itemprop="keywords">longitudinal data</span> (<span itemprop="keywords">growth curve models</span>), with [simulation](../docs/mixedModels/growth_vs_mixed_sim.html) of performance in situations of small sample sizes.</span>
</span>




### Latent Variables/SEM

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Structural Equation Modeling</span>](../docs/sem/)   
<span itemprop="description">This document (and related workshop) focuses on <span itemprop="keywords">structural equation modeling</span>.  It is conceptually based, and tries to generalize beyond the standard SEM treatment. The initial workshop was given to an audience of varying background and statistical skill, but the document should be useful to anyone interested in the techniques covered. It is completely R-based, with special emphasis on the [<span itemprop="keywords">lavaan</span>](http://lavaan.ugent.be/) package. It will continue to be a work in progress, particularly the sections after the <span itemprop="keywords">SEM</span> chapter.  Topics include: <span itemprop="keywords">graphical</span> models (<span itemprop="keywords">directed</span> and <span itemprop="keywords">undirected</span>, including <span itemprop="keywords">path analysis</span>, <span itemprop="keywords">bayesian networks</span>, and <span itemprop="keywords">network analysis</span>), <span itemprop="keywords">mediation</span>, <span itemprop="keywords">moderation</span>, <span itemprop="keywords">latent variable</span> models (including <span itemprop="keywords">principal components</span> analysis and '<span itemprop="keywords">factor analysis</span>'), <span itemprop="keywords">measurement</span> models, <span itemprop="keywords">structural equation models</span>, <span itemprop="keywords">mixture models</span>, <span itemprop="keywords">growth curves</span>.  Topics I hope to provide overviews of in the future include other latent variable techniques/extensions such as <span itemprop="keywords">IRT</span>, <span itemprop="keywords">collaborative filtering</span>/<span itemprop="keywords">recommender systems</span>, <span itemprop="keywords">hidden markov models</span>, <span itemprop="keywords">multi-group models</span> etc.
</span>
</span>


<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Latent Variables</span>, <span itemprop="name keywords">Sum Scores</span>, Single Items](../docs/lv_sim.html)   
<span itemprop="description">It is very common to use sum scores of several variables as a single entity to be used in subsequent analysis (e.g. a regression model).  Some may even more use a single variable even though multiple indicators are available. Assuming the multiple measures indicate a latent construct, such typical practice would be problematic relative to using estimated <span itemprop="name keywords">factor scores</span>, either constructed as part of a two stage process or as part of a <span itemprop="name keywords">structural equation model</span>.  This document covers simulations in which comparisons in performance are made between latent variable and sum score or single item approaches.
</span>
</span>

<span itemscope itemtype ="http://schema.org/ScholarlyArticle http://schema.org/TechArticle">
[Lord's Paradox](../docs/lord/index.html)     
<span itemprop="description">Summary of <span itemprop="keywords">Pearl</span>’s 2014 and 2013 technical reports on some modeling situations such as <span itemprop="keywords">Lord's Paradox and Simpson's Paradox</span> that lead to surprising results that are initially at odds with our intuition.  Looks particularly at the issue of change scores vs. controlling for baseline.
</span>
</span>


### Other Statistical

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Generalized Additive Models</span>](../docs/GAM.html)     
<span itemprop="description">An introduction to <span itemprop="keywords">generalized additive models</span> with an emphasis on generalization from familiar linear models and using the <span itemprop="keywords">mgcv</span> package in <span itemprop="keywords">R</span>.
</span> An older pdf version available [here](../docs/GAMS.pdf).
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Introduction to Machine Learning</span>](../docs/machine_learning/)     
<span itemprop="description">A gentle introduction to <span itemprop="keywords">machine learning</span> concepts with some application in <span itemprop="keywords">R</span>.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Categorical Regression Models</span>](../docs/logregmodels.html)     
<span itemprop="description">An overview of regression models for <span itemprop="keywords">binary, multinomial, and ordinal outcomes</span>, with connections among various types of models.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords">Topic Modeling Demo</span>](../docs/machine_learning/)     
<span itemprop="description">A demonstration of <span itemprop="keywords">Latent Dirichlet Allocation</span> for <span itemprop="keywords">topic modeling</span> in <span itemprop="keywords">R</span>.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name">Comparing Measures of Dependency</span>](../docs/CorrelationComparison.pdf)     
<span itemprop="description">A summary of relatively recent articles that look at various measures of dependency <span itemprop="keywords">Pearson's r</span>, <span itemprop="keywords">Spearman's rho</span>, and <span itemprop="keywords">Hoeffding's D</span>, and newer ones such as <span itemprop="keywords">Distance Correlation</span> and <span itemprop="keywords">Maximal Information Coefficient</span>.</span>
</span>



# Tools (esp. R)

Check the workshops section also.

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords" style="font-variant:small-caps;">FastR</span>](../docs/fastr.html)     
<span itemprop="description">An in progress notebook on how to <span itemprop="keywords">make R faster</span> before or irrespective of the machinery used. Topics include <span itemprop="keywords">avoiding loops</span>, <span itemprop="keywords">vectorization</span>, faster <span itemprop="keywords">I/O</span> etc.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name keywords" style="font-variant:small-caps;">Engaging the Web with R</span>](../docs/web)     
<span itemprop="description">Document regarding the use of R for <span itemprop="keywords">web scraping</span>, extracting data via an <span itemprop="keywords">API</span>, <span itemprop="keywords">interactive</span> web-based <span itemprop="keywords">visualizations</span>, and producing <span itemprop="keywords">web-ready documents</span>.  It serves as an overview of ways one might start to use R for web-based activities as opposed to a hand-on approach.
</span>
</span>


# Miscellaneous

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name">A History of Tornados</span>](http://micl.shinyapps.io/tornados/)     
<span itemprop="description">Because I had too much time on my hands and wanted to try out the <span itemprop="keywords">dashboard</span> feature of <span itemprop="keywords">Rmarkdown</span>.  Maps <span itemprop="keywords">tornado</span> activity from 1950-2015.  At some point I'll go back and fix the lag issue.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name">Last Statements of the Texas Executed</span>](http://micl.shinyapps.io/texEx/texEx.Rmd)     
<span itemprop="description">A demonstration of both <span itemprop="keywords">text analysis</span> and <span itemprop="keywords">literate programming</span>/document generation with a dynamic and interactive research document. The texts regard the last statements of offenders in Texas.
</span>
</span>

<span itemscope itemtype ="http://schema.org/TechArticle">
[<span itemprop="name">R for Social Science</span>](../docs/RSocialScience.pdf)   
<span itemprop="description">This was put together in a couple of days under duress, and is put here in case someone can find it useful (and thus make the time spent on it not completely wasted).
</span>
</span>