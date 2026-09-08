# Workshops

I used to give workshops regularly when I worked in academia, and I have kept the content here in case anyone who attended wanted to refer back to them. Some were not so much workshops as talks without any expectation of hands-on exercises or similar, so may not be as useful without the in-person context. Some of these, especially programming specific ones, are likely too dated to be useful beyond conceptual content, but the modeling focused ones may still have mostly relevant content.

## Recent

- [Polars](https://github.com/m-clark/polars-talk-2024): A notebook and related content providing an overview of polars with comparison to pandas and R package approaches like data.table.

I also have given internal talks on Media Mix Modeling and Models for Tabular Data at our yearly in-person gatherings.

## Previous efforts

These were among the last workshops I gave before leaving academia.

- [Distill for R Markdown](https://m-clark.github.io/distill-workshop/)
- [Exploratory Data Analysis Tools](https://m-clark.github.io/exploratory-data-analysis-tools/)
- [Mixed Models with R](../mixed-models-with-R/)
- [More Mixed Models](https://github.com/m-clark/more-mixed-models-2019)
- [Patchwork and gganimate](https://github.com/m-clark/patchmate-2019)
- [Library Learning Analytics Workshop](https://github.com/m-clark/LLAP-2019)
- [Getting More from RStudio](workshops/introRstudio.llms.md)
- [Latent Variable Models](https://github.com/m-clark/latent-variable-models-workshop-2019)
- [Generalized Additive Models](https://github.com/m-clark/generalized-additive-models-workshop-2019)
- [Mixed Models](https://github.com/m-clark/mixed-models-with-r-workshop-2019)

### Texts

These are the texts that serve as the basis for the workshops. At least a few of these were more recently updated.

[Practical Data Science](../data-processing-and-visualization/)  
Focus is on common data science tools and techniques in R, including data processing, programming, modeling, visualization, and presentation of results. Exercises may be found in the document, and demonstrations of most content in Python is available via [Jupyter notebooks](https://github.com/m-clark/data-processing-and-visualization/tree/master/jupyter_notebooks).

[Mixed Models with R](../mixed-models-with-R/)  
This workshop focuses on mixed effects models using R, covering basic random effects models (random intercepts and slopes) as well as extensions into generalized mixed models and discussion of realms beyond.

[Structural Equation Modeling](../sem/)  
This document regards a recent workshop given on structural equation modeling. It is conceptually based, and tries to generalize beyond the standard SEM treatment. The document should be useful to anyone interested in the techniques covered, though it is R-based, with special emphasis on the [lavaan](https://lavaan.ugent.be/) package.

[Easy Bayes with rstanarm and brms](../easy-bayes/)  
This workshop provides an overview of the rstanarm and brms packages. Basic modeling syntax is provided, as well as diagnostic checking, model comparison (posterior predictive checks , WAIC/LOO ), and how to get more from the models (marginal effects , posterior probabilities posterior probabilities, etc.).

[Factor Analysis and Related Methods](../sem/FA_notes.llms.md)  
This workshop will expose participants to a variety of related techniques that might fall under the heading of ‘factor analysis’, latent variable modeling, dimension reduction and similar, such as principal components analysis, factor analysis, and measurement models, with possible exposure to and demonstration of latent Dirichlet allocation, mixture models, item response theory, and others. Brief overviews with examples of the more common techniques will be provided.

[Introduction to R Markdown](../Introduction-to-Rmarkdown/)  
This workshop will introduce participants to the basics of R Markdown. After an introduction to concepts related to reproducible programming and research, demonstrations of standard markdown as well as overviews of different formats will be provided, including exercises. This document has been superseded by Practical Data Science, and will no longer be updated.

[Text Analysis with R](../text-analysis-with-R/)  
This document covers a wide range of topics, including how to process text generally, and demonstrations of sentiment analysis, parts-of-speech tagging, and topic modeling. Exercises are provided for some topics. It has practically no relevance in the modern large language model era.

## Been awhile…

These haven’t been given recently and are increasingly out date, but some content may be useful.

[My God, it’s full of STARs! Using astrology to get more from your data.](https://github.com/m-clark/stars) Talk on structured additive regression models, and generalized additive models in particular.

[Become a Bayesian in 10 Minutes](https://github.com/m-clark/easy-bayes) This document regards a talk aimed at giving an introduction Bayesian modeling in R via the Stan programming language. It doesn’t assume too much statistically or any prior Bayesian experience. For those with such experience, they can quickly work with the code or packages discussed. I post them here because they exist and provide a quick overview, but you’d get more from the more extensive [document](../bayesian-basics/).

[ENGAGING THE WEB WITH R](https://github.com/m-clark/webR) Document regarding the use of R for web scraping, extracting data via an API, interactive web-based visualizations, and producing web-ready documents. It serves as an overview of ways one might start to use R for web-based activities as opposed to a hand-on approach.

[Ceci n’est pas une %\>%](https://github.com/m-clark/data-manipulation-in-r) Exploring your data with R. A workshop that introduces some newer modes of data wrangling within R, with an eye toward visualization. Focus on dplyr and magrittr packages. No longer available as the javascript the slides were based on kept producing vulnerabilities for my website. Nowadays, using pipes is standard anyway.

## Reuse

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

## Citation

BibTeX citation:

``` quarto-appendix-bibtex
@online{untitled,
  author = {},
  title = {Workshops},
  url = {https://m-clark.github.io/workshops.html},
  langid = {en}
}
```

For attribution, please cite this work as:

“Workshops.” n.d. <https://m-clark.github.io/workshops.html>.
