> NB: This post was revisited when updating the website early 2025, and some changes were required. Attempts to keep things consistent were made, but if you feel you’ve found an issue, please post it at [GitHub](http://github.com/m-clark/m-clark.github.io/issues).

## Introduction

In some cases we are interested in looking at group differences with regard to latent variables. For example, social scientists are interested in race and sex differences on psychological measures, or educational scientists might want to create exams in different languages. We cannot measure many constructs directly, but can get reliable measures of them indirectly, e.g. by asking a series of questions, or otherwise observing multiple instances of activity thought to be related to some construct. There are a variety of ways to assess group differences across latent structure, such as anxiety or verbal ability, and this post provides a demo using lavaan.

My motivation for doing this is that it comes up from time to time in consulting, and I wanted a quick reminder for the syntax to refer back to. As a starting point though, you can find some demonstration on the [lavaan website](https://lavaan.ugent.be). For more on factor analysis, structural equation modeling, and more, see [my document](https://m-clark.github.io/sem/).

## Multiple group analysis

A common way to assess group differences is via multiple group analysis, which amounts to doing separate structural equation models of some kind across the groups of interest. We will use a classic data set to demonstrate the approach. From the help file:

> The Holzinger and Swineford (1939) dataset consists of mental ability test scores of seventh- and eighth-grade children from two different schools (Pasteur and Grant-White). In the original dataset, there are scores for 26 tests. However, a smaller subset with 9 variables is more widely used in the literature…

``` r
library(lavaan)
data(HolzingerSwineford1939)
```

The basic model is a factor analysis with three latent variables, with items for visual-spatial ability (`x1-x3`), verbal comprehension (`x4-x6`), and so-called ‘speed’ tests (`x7-x9`), e.g. for addition and counting, which might be thought of general cognitive processing.

With lavaan, we specify the model for three factor (or latent variables). After that, a simple group argument will allow the multigroup analysis, providing the factor analysis for both school groups.

``` r
library(tidyverse)
library(lavaan)

hs_model_baseline <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
'

fit_baseline <- cfa(
  hs_model_baseline, 
  data = HolzingerSwineford1939, 
  group = "school"
)

summary(fit_baseline)  
```

    lavaan 0.6.17 ended normally after 57 iterations

      Estimator                                         ML
      Optimization method                           NLMINB
      Number of model parameters                        60

      Number of observations per group:                   
        Pasteur                                        156
        Grant-White                                    145

    Model Test User Model:
                                                          
      Test statistic                               115.851
      Degrees of freedom                                48
      P-value (Chi-square)                           0.000
      Test statistic for each group:
        Pasteur                                     64.309
        Grant-White                                 51.542

    Parameter Estimates:

      Standard errors                             Standard
      Information                                 Expected
      Information saturated (h1) model          Structured


    Group 1 [Pasteur]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                1.000                           
        x2                0.394    0.122    3.220    0.001
        x3                0.570    0.140    4.076    0.000
      verbal =~                                           
        x4                1.000                           
        x5                1.183    0.102   11.613    0.000
        x6                0.875    0.077   11.421    0.000
      speed =~                                            
        x7                1.000                           
        x8                1.125    0.277    4.057    0.000
        x9                0.922    0.225    4.104    0.000

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal            0.479    0.106    4.531    0.000
        speed             0.185    0.077    2.397    0.017
      verbal ~~                                           
        speed             0.182    0.069    2.628    0.009

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                4.941    0.095   52.249    0.000
       .x2                5.984    0.098   60.949    0.000
       .x3                2.487    0.093   26.778    0.000
       .x4                2.823    0.092   30.689    0.000
       .x5                3.995    0.105   38.183    0.000
       .x6                1.922    0.079   24.321    0.000
       .x7                4.432    0.087   51.181    0.000
       .x8                5.563    0.078   71.214    0.000
       .x9                5.418    0.079   68.440    0.000

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                0.298    0.232    1.286    0.198
       .x2                1.334    0.158    8.464    0.000
       .x3                0.989    0.136    7.271    0.000
       .x4                0.425    0.069    6.138    0.000
       .x5                0.456    0.086    5.292    0.000
       .x6                0.290    0.050    5.780    0.000
       .x7                0.820    0.125    6.580    0.000
       .x8                0.510    0.116    4.406    0.000
       .x9                0.680    0.104    6.516    0.000
        visual            1.097    0.276    3.967    0.000
        verbal            0.894    0.150    5.963    0.000
        speed             0.350    0.126    2.778    0.005


    Group 2 [Grant-White]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                1.000                           
        x2                0.736    0.155    4.760    0.000
        x3                0.925    0.166    5.583    0.000
      verbal =~                                           
        x4                1.000                           
        x5                0.990    0.087   11.418    0.000
        x6                0.963    0.085   11.377    0.000
      speed =~                                            
        x7                1.000                           
        x8                1.226    0.187    6.569    0.000
        x9                1.058    0.165    6.429    0.000

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal            0.408    0.098    4.153    0.000
        speed             0.276    0.076    3.639    0.000
      verbal ~~                                           
        speed             0.222    0.073    3.022    0.003

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                4.930    0.095   51.696    0.000
       .x2                6.200    0.092   67.416    0.000
       .x3                1.996    0.086   23.195    0.000
       .x4                3.317    0.093   35.625    0.000
       .x5                4.712    0.096   48.986    0.000
       .x6                2.469    0.094   26.277    0.000
       .x7                3.921    0.086   45.819    0.000
       .x8                5.488    0.087   63.174    0.000
       .x9                5.327    0.085   62.571    0.000

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                0.715    0.126    5.676    0.000
       .x2                0.899    0.123    7.339    0.000
       .x3                0.557    0.103    5.409    0.000
       .x4                0.315    0.065    4.870    0.000
       .x5                0.419    0.072    5.812    0.000
       .x6                0.406    0.069    5.880    0.000
       .x7                0.600    0.091    6.584    0.000
       .x8                0.401    0.094    4.249    0.000
       .x9                0.535    0.089    6.010    0.000
        visual            0.604    0.160    3.762    0.000
        verbal            0.942    0.152    6.177    0.000
        speed             0.461    0.118    3.910    0.000

So we’re left with visual inspection to note whether there are general differences on latent variables among the groups. This is all well and good, but given that none of the parameters will be identical from one group to the next, perhaps we want a more principled approach. Say our question specifically concerns a mean difference between schools on the visual latent variable. How do we go about it?

Note that at this point the intercepts for the latent variables are zero. They have to be for the model to be identified, much in the same way that at least one factor loading (the first by default) has to be fixed to one. We only have so much information to estimate the parameters in a latent variable setting. Now let’s see how we might go about changing things to get a better understanding of group differences on the latent variables.

## Latent variable intercepts

To get around this limitation, we could try and fix some parameters, thereby freeing the intercepts to be estimated. For example, if we fix the mean of one of the observed variables to be zero instead, we would be able to estimate the intercept for the latent variable. In the following we’ll do this for the visuo-spatial ability construct, which will be our point of focus for group differences going forward.

Recall that for the standard latent linear model, the observed variable is the dependent variable . For example, given an observed variable \\X\\, a latent variable \\F\\ and loading \\\lambda\\: \\X = b_0 + \lambda F \\

In the model we we also identify a new parameter, which will be the differences in these latent variable intercepts, simply called `diff`. I have omitted some output for brevity of space.

``` r
hs_model_1 <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  
  # intercepts: in order to have an identified model, you would have to fix the
  # intercepts of observed to 0, 1 represents the intercept, 0* fixes it to be 0
  x1 ~ 0*1   

  # intercept for Pasteur and Grant-White schools
  visual ~  c(int_p, int_gw)*1    
   
  # comparisons
  diff := int_p - int_gw
'

fit_1 <- cfa(hs_model_1, 
             data = HolzingerSwineford1939, 
             group = "school",
             meanstructure = T)
summary(fit_1, header=F, nd=2)
```


    Parameter Estimates:

      Standard errors                             Standard
      Information                                 Expected
      Information saturated (h1) model          Structured


    Group 1 [Pasteur]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                 1.00                           
        x2                 0.39     0.12     3.22     0.00
        x3                 0.57     0.14     4.08     0.00
      verbal =~                                           
        x4                 1.00                           
        x5                 1.18     0.10    11.61     0.00
        x6                 0.87     0.08    11.42     0.00
      speed =~                                            
        x7                 1.00                           
        x8                 1.12     0.28     4.06     0.00
        x9                 0.92     0.22     4.10     0.00

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal             0.48     0.11     4.53     0.00
        speed              0.19     0.08     2.40     0.02
      verbal ~~                                           
        speed              0.18     0.07     2.63     0.01

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.00                           
        visual  (int_)     4.94     0.09    52.25     0.00
       .x2                 4.04     0.61     6.61     0.00
       .x3                -0.33     0.70    -0.47     0.64
       .x4                 2.82     0.09    30.69     0.00
       .x5                 4.00     0.10    38.18     0.00
       .x6                 1.92     0.08    24.32     0.00
       .x7                 4.43     0.09    51.18     0.00
       .x8                 5.56     0.08    71.21     0.00
       .x9                 5.42     0.08    68.44     0.00

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.30     0.23     1.29     0.20
       .x2                 1.33     0.16     8.46     0.00
       .x3                 0.99     0.14     7.27     0.00
       .x4                 0.43     0.07     6.14     0.00
       .x5                 0.46     0.09     5.29     0.00
       .x6                 0.29     0.05     5.78     0.00
       .x7                 0.82     0.12     6.58     0.00
       .x8                 0.51     0.12     4.41     0.00
       .x9                 0.68     0.10     6.52     0.00
        visual             1.10     0.28     3.97     0.00
        verbal             0.89     0.15     5.96     0.00
        speed              0.35     0.13     2.78     0.01


    Group 2 [Grant-White]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                 1.00                           
        x2                 0.74     0.15     4.76     0.00
        x3                 0.92     0.17     5.58     0.00
      verbal =~                                           
        x4                 1.00                           
        x5                 0.99     0.09    11.42     0.00
        x6                 0.96     0.08    11.38     0.00
      speed =~                                            
        x7                 1.00                           
        x8                 1.23     0.19     6.57     0.00
        x9                 1.06     0.16     6.43     0.00

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal             0.41     0.10     4.15     0.00
        speed              0.28     0.08     3.64     0.00
      verbal ~~                                           
        speed              0.22     0.07     3.02     0.00

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.00                           
        visual  (int_)     4.93     0.10    51.70     0.00
       .x2                 2.57     0.77     3.35     0.00
       .x3                -2.56     0.82    -3.12     0.00
       .x4                 3.32     0.09    35.63     0.00
       .x5                 4.71     0.10    48.99     0.00
       .x6                 2.47     0.09    26.28     0.00
       .x7                 3.92     0.09    45.82     0.00
       .x8                 5.49     0.09    63.17     0.00
       .x9                 5.33     0.09    62.57     0.00

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.71     0.13     5.68     0.00
       .x2                 0.90     0.12     7.34     0.00
       .x3                 0.56     0.10     5.41     0.00
       .x4                 0.32     0.06     4.87     0.00
       .x5                 0.42     0.07     5.81     0.00
       .x6                 0.41     0.07     5.88     0.00
       .x7                 0.60     0.09     6.58     0.00
       .x8                 0.40     0.09     4.25     0.00
       .x9                 0.53     0.09     6.01     0.00
        visual             0.60     0.16     3.76     0.00
        verbal             0.94     0.15     6.18     0.00
        speed              0.46     0.12     3.91     0.00

    Defined Parameters:
                       Estimate  Std.Err  z-value  P(>|z|)
        diff               0.01     0.13     0.08     0.93

For clearer presentation, we’ll look at a table of the specific parameter estimates.

| term | op | block | group | label | estimate | std.error | statistic | p.value | conf.low | conf.high | std.lv | std.all | std.nox |
|:---|:---|---:|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| visual ~1 | ~1 | 1 | 1 | int_p | 4.941 | 0.095 | 52.249 | 0.000 | 4.756 | 5.127 | 4.718 | 4.718 | 4.718 |
| visual ~1 | ~1 | 2 | 2 | int_gw | 4.930 | 0.095 | 51.696 | 0.000 | 4.743 | 5.117 | 6.345 | 6.345 | 6.345 |
| diff := int_p-int_gw | := | 0 | 0 | diff | 0.011 | 0.134 | 0.085 | 0.933 | -0.252 | 0.275 | -1.627 | -1.627 | -1.627 |

The above shows the schools to be not much different from one another on the visual-spatial ability latent variable. But compare this result to the intercepts for `x1` in our baseline model. This model would would be identical to comparing the intercepts on whichever observed variable you had fixed to zero. Much like we must scale the latent variable to that of one of the observed variables by fixing the loading to be 1, we essentially come to the same type of issue by fixing its mean to be on that of the observed variable.

To make this more explicit, we’ll label the `x1` intercepts in our baseline model and look at their difference. I won’t show the model out put and simply focus on the parameter table instead.

``` r
hs_model_2 <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  x1 ~ c(a, b)*1   
   
  # comparisons
   diff := a - b
'

fit_2 <- cfa(hs_model_2, 
           data = HolzingerSwineford1939, 
           group = "school",
           meanstructure = T)

# summary(fit_2)
```

| term | op | block | group | label | estimate | std.error | statistic | p.value | conf.low | conf.high | std.lv | std.all | std.nox |
|:---|:---|---:|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| x1 ~1 | ~1 | 1 | 1 | a | 4.941 | 0.095 | 52.249 | 0.000 | 4.756 | 5.127 | 4.941 | 4.183 | 4.183 |
| x1 ~1 | ~1 | 2 | 2 | b | 4.930 | 0.095 | 51.696 | 0.000 | 4.743 | 5.117 | 4.930 | 4.293 | 4.293 |
| diff := a-b | := | 0 | 0 | diff | 0.011 | 0.134 | 0.085 | 0.933 | -0.252 | 0.275 | 0.011 | -0.110 | -0.110 |

Same difference.

## Observed variable group differences

The following approach is not the same model, but as we’ll see, would also provide the same result. In this case, each observed variable is affected by the school grouping, and the path coefficient for `x1` is the same difference in means as before.

``` r
hs_model_3 <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  x1 ~ diff*school 
  x2 + x3 + x4 + x5 + x6 +  x7 + x8 + x9 ~ school
'

fit_3 <- cfa(hs_model_3, 
             data = HolzingerSwineford1939,
             meanstructure = T)

# summary(fit_3)
```

A comparison of all three shows the same results, but that the third model has fewer parameters, as the loadings and latent variable variances are not changing across groups.

| model | estimate | std.error | conf.low | conf.high |
|:------|---------:|----------:|---------:|----------:|
| fit_1 |    0.011 |     0.134 |   -0.252 |     0.275 |
| fit_2 |    0.011 |     0.134 |   -0.252 |     0.275 |
| fit_3 |    0.011 |     0.134 |   -0.252 |     0.275 |

| fit_1 | fit_2 | fit_3 |
|------:|------:|------:|
|    60 |    60 |    39 |

Model N parameters {.table .caption-top .table-sm .table-striped .small}

|    fit_1 |    fit_2 |    fit_3 |
|---------:|---------:|---------:|
| 7484.395 | 7484.395 | 7474.493 |

Model AIC {.table .caption-top .table-sm .table-striped .small}

## Structural model

In the models I see, people would more commonly address such a theoretical question without a multigroup approach, simply regressing the latent variable of interest on the group factor. For lack of a better name, I’ll just call this a structural model in the sense we have an explicit regression model. We can do that here.

``` r
# standard cfa with school predicting visual
hs_model_4a <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  visual ~ diff*school
  
  visual ~~ speed + verbal  # lavaan will not estimate this by default
'

fit_4a = sem(hs_model_4a, data=HolzingerSwineford1939, meanstructure=T)
summary(fit_4a)
```

    lavaan 0.6.17 ended normally after 49 iterations

      Estimator                                         ML
      Optimization method                           NLMINB
      Number of model parameters                        31

      Number of observations                           301

    Model Test User Model:
                                                          
      Test statistic                               161.444
      Degrees of freedom                                32
      P-value (Chi-square)                           0.000

    Parameter Estimates:

      Standard errors                             Standard
      Information                                 Expected
      Information saturated (h1) model          Structured

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                1.000                           
        x2                0.570    0.100    5.723    0.000
        x3                0.797    0.111    7.212    0.000
      verbal =~                                           
        x4                1.000                           
        x5                1.113    0.065   17.021    0.000
        x6                0.928    0.055   16.741    0.000
      speed =~                                            
        x7                1.000                           
        x8                1.194    0.168    7.124    0.000
        x9                1.060    0.148    7.152    0.000

    Regressions:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~                                            
        school  (diff)    0.287    0.110    2.612    0.009

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
     .visual ~~                                           
        speed             0.241    0.054    4.446    0.000
        verbal            0.429    0.073    5.846    0.000
      verbal ~~                                           
        speed             0.172    0.049    3.483    0.000

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                4.500    0.180   24.997    0.000
       .x2                5.840    0.122   47.989    0.000
       .x3                1.903    0.151   12.631    0.000
       .x4                3.061    0.067   45.694    0.000
       .x5                4.341    0.074   58.452    0.000
       .x6                2.186    0.063   34.667    0.000
       .x7                4.186    0.063   66.766    0.000
       .x8                5.527    0.058   94.854    0.000
       .x9                5.374    0.058   92.546    0.000

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                0.604    0.105    5.739    0.000
       .x2                1.137    0.102   11.172    0.000
       .x3                0.795    0.090    8.879    0.000
       .x4                0.372    0.048    7.821    0.000
       .x5                0.448    0.058    7.698    0.000
       .x6                0.354    0.043    8.254    0.000
       .x7                0.796    0.081    9.775    0.000
       .x8                0.470    0.076    6.209    0.000
       .x9                0.580    0.071    8.195    0.000
       .visual            0.754    0.135    5.597    0.000
        verbal            0.978    0.112    8.735    0.000
        speed             0.387    0.087    4.462    0.000

At first blush, it would seem we are not getting the same result, as the mean difference is now estimated to be 0.287. Our difference is notably larger and significant. We can also see that the fit is different based on AIC and the number of parameters estimated.

|    fit_1 |    fit_2 |    fit_3 |   fit_4a | fit_baseline |
|---------:|---------:|---------:|---------:|-------------:|
| 7484.395 | 7484.395 | 7474.493 | 7531.852 |     7484.395 |

| fit_1 | fit_2 | fit_3 | fit_4a | fit_baseline |
|------:|------:|------:|-------:|-------------:|
|    60 |    60 |    39 |     31 |           60 |

#### Structural model as multigroup

However, we can recover the previous multigroup results by regressing the other observed variables on school as well. This leaves the only group effect remaining to be the effect on `x1`.

``` r
hs_model_4b <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  visual ~ diff*school
  
  x2 + x3 + x4 + x5 + x6 +  x7 + x8 + x9 ~ school
'

fit_4b = sem(hs_model_4b, data=HolzingerSwineford1939, meanstructure=T)
```

|    fit_1 |    fit_2 |    fit_3 |   fit_4a |   fit_4b | fit_baseline |
|---------:|---------:|---------:|---------:|---------:|-------------:|
| 7484.395 | 7484.395 | 7474.493 | 7531.852 | 7526.606 |     7484.395 |

| fit_1 | fit_2 | fit_3 | fit_4a | fit_4b | fit_baseline |
|------:|------:|------:|-------:|-------:|-------------:|
|    60 |    60 |    39 |     31 |     37 |           60 |

| model | estimate | std.error | conf.low | conf.high |
|:------|---------:|----------:|---------:|----------:|
| 1     |    0.011 |     0.134 |   -0.252 |     0.275 |
| 2     |    0.011 |     0.134 |   -0.252 |     0.275 |
| 3     |    0.011 |     0.134 |   -0.252 |     0.275 |
| 4b    |    0.011 |     0.134 |       NA |        NA |

### Multigroup as the structural model

Let’s see if we can get the structural model result from our multigroup approach. In fact we can. The following produces the same coefficient by summing the differences on the observed items. As we will see later, the statistical result is essentially what we’d get by using a linear regression on a sum score of visual items.

``` r
hs_model_baseline_2 <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 
  
  x1 ~ c(a1, a2)*1
  x2 ~ c(b1, b2)*1
  x3 ~ c(c1, c2)*1
  
  diff := (a1 - a2) + (b1 - b2) + (c1 - c2)
'

fit_baseline_2 <- cfa(
  hs_model_baseline_2, 
  data = HolzingerSwineford1939, 
  group = "school"
)

summary(fit_baseline_2)
```

    lavaan 0.6.17 ended normally after 57 iterations

      Estimator                                         ML
      Optimization method                           NLMINB
      Number of model parameters                        60

      Number of observations per group:                   
        Pasteur                                        156
        Grant-White                                    145

    Model Test User Model:
                                                          
      Test statistic                               115.851
      Degrees of freedom                                48
      P-value (Chi-square)                           0.000
      Test statistic for each group:
        Pasteur                                     64.309
        Grant-White                                 51.542

    Parameter Estimates:

      Standard errors                             Standard
      Information                                 Expected
      Information saturated (h1) model          Structured


    Group 1 [Pasteur]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                1.000                           
        x2                0.394    0.122    3.220    0.001
        x3                0.570    0.140    4.076    0.000
      verbal =~                                           
        x4                1.000                           
        x5                1.183    0.102   11.613    0.000
        x6                0.875    0.077   11.421    0.000
      speed =~                                            
        x7                1.000                           
        x8                1.125    0.277    4.057    0.000
        x9                0.922    0.225    4.104    0.000

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal            0.479    0.106    4.531    0.000
        speed             0.185    0.077    2.397    0.017
      verbal ~~                                           
        speed             0.182    0.069    2.628    0.009

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1        (a1)    4.941    0.095   52.249    0.000
       .x2        (b1)    5.984    0.098   60.949    0.000
       .x3        (c1)    2.487    0.093   26.778    0.000
       .x4                2.823    0.092   30.689    0.000
       .x5                3.995    0.105   38.183    0.000
       .x6                1.922    0.079   24.321    0.000
       .x7                4.432    0.087   51.181    0.000
       .x8                5.563    0.078   71.214    0.000
       .x9                5.418    0.079   68.440    0.000

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                0.298    0.232    1.286    0.198
       .x2                1.334    0.158    8.464    0.000
       .x3                0.989    0.136    7.271    0.000
       .x4                0.425    0.069    6.138    0.000
       .x5                0.456    0.086    5.292    0.000
       .x6                0.290    0.050    5.780    0.000
       .x7                0.820    0.125    6.580    0.000
       .x8                0.510    0.116    4.406    0.000
       .x9                0.680    0.104    6.516    0.000
        visual            1.097    0.276    3.967    0.000
        verbal            0.894    0.150    5.963    0.000
        speed             0.350    0.126    2.778    0.005


    Group 2 [Grant-White]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                1.000                           
        x2                0.736    0.155    4.760    0.000
        x3                0.925    0.166    5.583    0.000
      verbal =~                                           
        x4                1.000                           
        x5                0.990    0.087   11.418    0.000
        x6                0.963    0.085   11.377    0.000
      speed =~                                            
        x7                1.000                           
        x8                1.226    0.187    6.569    0.000
        x9                1.058    0.165    6.429    0.000

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal            0.408    0.098    4.153    0.000
        speed             0.276    0.076    3.639    0.000
      verbal ~~                                           
        speed             0.222    0.073    3.022    0.003

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1        (a2)    4.930    0.095   51.696    0.000
       .x2        (b2)    6.200    0.092   67.416    0.000
       .x3        (c2)    1.996    0.086   23.195    0.000
       .x4                3.317    0.093   35.625    0.000
       .x5                4.712    0.096   48.986    0.000
       .x6                2.469    0.094   26.277    0.000
       .x7                3.921    0.086   45.819    0.000
       .x8                5.488    0.087   63.174    0.000
       .x9                5.327    0.085   62.571    0.000

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                0.715    0.126    5.676    0.000
       .x2                0.899    0.123    7.339    0.000
       .x3                0.557    0.103    5.409    0.000
       .x4                0.315    0.065    4.870    0.000
       .x5                0.419    0.072    5.812    0.000
       .x6                0.406    0.069    5.880    0.000
       .x7                0.600    0.091    6.584    0.000
       .x8                0.401    0.094    4.249    0.000
       .x9                0.535    0.089    6.010    0.000
        visual            0.604    0.160    3.762    0.000
        verbal            0.942    0.152    6.177    0.000
        speed             0.461    0.118    3.910    0.000

    Defined Parameters:
                       Estimate  Std.Err  z-value  P(>|z|)
        diff              0.287    0.297    0.965    0.335

### Group difference as an indirect effect

Going back to the first structural model `hs_model_4a`, it might be interesting to some to see that the group difference *still* regards a difference on the observed `x1` observed variable. We can see this more clearly if we set the `x1` loading to be estimated rather than fixed at one, then use the product of coefficients approach (a la [mediation]()) to estimate the group difference.

``` r
hs_model_4c <- ' 
  visual =~ x2 + a*x1 + x3    # estimate x1 loading vs. scaling by it
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 

  visual ~ b*school
  
  visual ~~ verbal + speed
  
  diff := a*b    # "indirect" effect of school on x1
'

# same as fit_4a
fit_4c = cfa(hs_model_4c, data = HolzingerSwineford1939, meanstructure=T)
```

| model | label | estimate | std.error | statistic | p.value | conf.low | conf.high |
|:------|:------|---------:|----------:|----------:|--------:|---------:|----------:|
| 4a    | diff  |    0.287 |      0.11 |     2.612 |   0.009 |    0.072 |     0.503 |
| 4c    | diff  |    0.287 |      0.11 |     2.612 |   0.009 |    0.072 |     0.503 |

And what is this value of 0.287? We see it as the group difference on the latent construct rather than simply being a mean difference on `x1`. However, in `fit_4a` it is estimated on the metric of `x1`, which had it’s loading fixed to 1. We will see another interpretation later.

You might be thinking, why does my effect on the latent variable depend on a specific item? Well it *shouldn’t*. If the items are random observations measured in the same way of the same underlying construct, then the loadings will essentially be equal, and so it wouldn’t matter which one is chosen as a default.

## More structural models

The following is equivalent to the result one would get from `group.equal = c('loadings', 'intercepts')`, but to make things more clear, I show the explicit syntax (commented out are other options one could potentially play with). The first group would have latent variable means at zero, while the second group would be allowed to vary. This is more or less what is desired if we want to know a group difference on the latent structure. The first group mean is arbitrarily set to zero, so the estimated intercept for the second group tells us the relative difference, much like when we are dummy coding with standard regression models.

``` r
hs_model_4d <- ' 
  # make loadings equal across groups
  
  visual =~ c(1, 1)*x1 + c(v_x2, v_x2)*x2 + c(v_x3, v_x3)*x3
  verbal =~ c(1, 1)*x4 + c(v_x5, v_x5)*x5 + c(v_x6, v_x6)*x6
  speed  =~ c(1, 1)*x7 + c(v_x8, v_x8)*x8 + c(v_x9, v_x9)*x9 
  
  # make intercepts equal across groups
  
  x1 ~ c(0, 0) * 1
  x2 ~ c(int_x2, int_x2) * 1
  x3 ~ c(int_x3, int_x3) * 1
  x4 ~ c(0, 0) * 1
  x5 ~ c(int_x5, int_x5) * 1
  x6 ~ c(int_x6, int_x6) * 1
  x7 ~ c(0, 0) * 1
  x8 ~ c(int_x8, int_x8) * 1
  x9 ~ c(int_x9, int_x9) * 1
  
  # make covariances equal across groups
  
  # visual ~~ c(cov_vv, cov_vv) * verbal + c(cov_visp, cov_visp) * speed
  # verbal ~~ c(cov_vesp, cov_vesp) * speed
  
  # make variances equal
  
  # visual ~~ c(vvar, vvar) * visual
  # verbal ~~ c(tvar, tvar) * verbal
  # speed  ~~ c(svar, svar) * speed
  
  # x1 ~~ c(x1var, x1var) * x1
  # x2 ~~ c(x2var, x2var) * x2
  # x3 ~~ c(x3var, x3var) * x3
  # x4 ~~ c(x4var, x4var) * x4
  # x5 ~~ c(x5var, x5var) * x5
  # x6 ~~ c(x6var, x6var) * x6
  # x7 ~~ c(x7var, x7var) * x7
  # x8 ~~ c(x8var, x8var) * x8
  # x9 ~~ c(x9var, x9var) * x9
  
  
  visual ~ c(vis_int_p, vis_int_gw)*1
  verbal ~ c(verb_int_p, verb_int_gw)*1
  speed  ~ c(speed_int_p, speed_int_gw)*1
  
  
   
  # comparisons
   diff := vis_int_p - vis_int_gw
'

fit_4d  = sem(hs_model_4d, 
                data=HolzingerSwineford1939, 
                group = 'school',
                meanstructure=T)

summary(fit_4d, header=F, nd=2)
```


    Parameter Estimates:

      Standard errors                             Standard
      Information                                 Expected
      Information saturated (h1) model          Structured


    Group 1 [Pasteur]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                 1.00                           
        x2      (v_x2)     0.58     0.10     5.71     0.00
        x3      (v_x3)     0.80     0.11     7.15     0.00
      verbal =~                                           
        x4                 1.00                           
        x5      (v_x5)     1.12     0.07    16.97     0.00
        x6      (v_x6)     0.93     0.06    16.61     0.00
      speed =~                                            
        x7                 1.00                           
        x8      (v_x8)     1.13     0.15     7.79     0.00
        x9      (v_x9)     1.01     0.13     7.67     0.00

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal             0.41     0.10     4.29     0.00
        speed              0.18     0.07     2.69     0.01
      verbal ~~                                           
        speed              0.18     0.06     2.90     0.00

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.00                           
       .x2      (in_2)     3.27     0.50     6.54     0.00
       .x3      (in_3)    -1.72     0.55    -3.11     0.00
       .x4                 0.00                           
       .x5      (in_5)     0.92     0.21     4.36     0.00
       .x6      (in_6)    -0.66     0.18    -3.75     0.00
       .x7                 0.00                           
       .x8      (in_8)     0.84     0.60     1.39     0.17
       .x9      (in_9)     1.18     0.55     2.16     0.03
        visual  (vs__)     5.00     0.09    55.76     0.00
        verbal  (vr__)     2.78     0.09    31.95     0.00
        speed   (sp__)     4.24     0.07    57.97     0.00

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.56     0.14     3.98     0.00
       .x2                 1.30     0.16     8.19     0.00
       .x3                 0.94     0.14     6.93     0.00
       .x4                 0.45     0.07     6.43     0.00
       .x5                 0.50     0.08     6.14     0.00
       .x6                 0.26     0.05     5.26     0.00
       .x7                 0.89     0.12     7.42     0.00
       .x8                 0.54     0.09     5.71     0.00
       .x9                 0.65     0.10     6.80     0.00
        visual             0.80     0.17     4.64     0.00
        verbal             0.88     0.13     6.69     0.00
        speed              0.32     0.08     3.91     0.00


    Group 2 [Grant-White]:

    Latent Variables:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual =~                                           
        x1                 1.00                           
        x2      (v_x2)     0.58     0.10     5.71     0.00
        x3      (v_x3)     0.80     0.11     7.15     0.00
      verbal =~                                           
        x4                 1.00                           
        x5      (v_x5)     1.12     0.07    16.97     0.00
        x6      (v_x6)     0.93     0.06    16.61     0.00
      speed =~                                            
        x7                 1.00                           
        x8      (v_x8)     1.13     0.15     7.79     0.00
        x9      (v_x9)     1.01     0.13     7.67     0.00

    Covariances:
                       Estimate  Std.Err  z-value  P(>|z|)
      visual ~~                                           
        verbal             0.43     0.10     4.42     0.00
        speed              0.33     0.08     4.01     0.00
      verbal ~~                                           
        speed              0.24     0.07     3.22     0.00

    Intercepts:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.00                           
       .x2      (in_2)     3.27     0.50     6.54     0.00
       .x3      (in_3)    -1.72     0.55    -3.11     0.00
       .x4                 0.00                           
       .x5      (in_5)     0.92     0.21     4.36     0.00
       .x6      (in_6)    -0.66     0.18    -3.75     0.00
       .x7                 0.00                           
       .x8      (in_8)     0.84     0.60     1.39     0.17
       .x9      (in_9)     1.18     0.55     2.16     0.03
        visual  (vs__)     4.85     0.09    52.96     0.00
        verbal  (vr__)     3.35     0.09    38.16     0.00
        speed   (sp__)     4.06     0.08    50.75     0.00

    Variances:
                       Estimate  Std.Err  z-value  P(>|z|)
       .x1                 0.65     0.13     5.09     0.00
       .x2                 0.96     0.12     7.81     0.00
       .x3                 0.64     0.10     6.32     0.00
       .x4                 0.34     0.06     5.53     0.00
       .x5                 0.38     0.07     5.13     0.00
       .x6                 0.44     0.07     6.56     0.00
       .x7                 0.63     0.10     6.57     0.00
       .x8                 0.43     0.09     4.91     0.00
       .x9                 0.52     0.09     6.10     0.00
        visual             0.71     0.16     4.42     0.00
        verbal             0.87     0.13     6.66     0.00
        speed              0.51     0.12     4.38     0.00

    Defined Parameters:
                       Estimate  Std.Err  z-value  P(>|z|)
        diff               0.15     0.12     1.21     0.23

The fit is now estimated to be 0.148, as we are now taking into account the intercorrelations of the latent variables. However, there is a more simple and obvious way to do this model. We simply regress all latent variables on school.

``` r
hs_model_4e <- ' 
  visual =~ x1 + x2 + x3    # estimate x1 loading vs. scaling by it
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9 

  visual ~ diff*school
  
  verbal + speed ~ school
'

fit_4e = cfa(hs_model_4e, data = HolzingerSwineford1939, meanstructure=T)
# summary(fit_4e)
```

| model                           | estimate | std.error | conf.low | conf.high |
|---------------------------------|----------|-----------|----------|-----------|
| **Observed value differences**  |          |           |          |           |
| 1                               | 0.011    | 0.134     | -0.252   | 0.275     |
| 2                               | 0.011    | 0.134     | -0.252   | 0.275     |
| 3                               | 0.011    | 0.134     | -0.252   | 0.275     |
| 4b                              | 0.011    | 0.134     | NA       | NA        |
| **Latent variable differences** |          |           |          |           |
| 4a                              | 0.287    | 0.110     | 0.072    | 0.503     |
| 4c                              | 0.287    | 0.110     | 0.072    | 0.503     |
| 4d                              | 0.148    | 0.122     | NA       | NA        |
| 4e                              | 0.147    | 0.122     | NA       | NA        |

The primary differences we’ve seen thus far can be summarized as follows:

- 1:3 and 4b: These models are focusing on observed variable differences, specifically on `x1`.
- 4a and 4c: These models are latent variable differences on the visual factor, but do not control for indirect (or *backdoor*) effect school has on visual *through* speed and verbal. In that light, we might consider this the *total effect* of school on the visual factor. Had we regressed the verbal and speed factors on school also, thereby decomposing the total effect into those different paths, we’d get the same result for the school difference on the visual factor as we do in 4d and e
- 4d and 4e: This is generally what we want. A simple group difference on a latent variable(s) with other parameters assumed (relatively) equal across groups.

## Sum/Factor score

What would happen if we look at the structural/regression model with the estimated latent variable scores[^1]? How about we go even simpler, by not even running an SEM and simply using sum scores? Let’s see what results.

We’ll start with the estimated factor scores.

``` r
hs_model_5 <- ' 
  visual =~ x1 + x2 + x3
  verbal =~ x4 + x5 + x6
  speed  =~ x7 + x8 + x9
'

fit_5 = cfa(hs_model_5, data = HolzingerSwineford1939, meanstructure=T)

HolzingerSwineford1939 = HolzingerSwineford1939 %>% 
  mutate(
    visual = lavPredict(fit_5)[,'visual'],
    verbal = lavPredict(fit_5)[,'verbal'],
    speed  = lavPredict(fit_5)[,'speed']
  )

lm_1 = lm(visual ~ school + verbal + speed, data = HolzingerSwineford1939)
coef(lm_1)  
```

      (Intercept) schoolPasteur        verbal         speed 
      -0.07231513    0.13953111    0.34744541    0.63626370 

The estimated coefficient is pretty close to that estimated by the SEM when we regressed all the factors on school. Interestingly, if we fix the loadings to be constant, we recover the initial multigroup estimates.

``` r
hs_model_5b <- ' 
  visual =~ x1 + l1*x2 + l1*x3
  verbal =~ x4 + l2*x5 + l2*x6
  speed  =~ x7 + l3*x8 + l3*x9 
'

fit_5b = cfa(hs_model_5b,
             data = lavaan::HolzingerSwineford1939,
             meanstructure = T)

HolzingerSwineford1939 = HolzingerSwineford1939 %>%
  mutate(
    visual = lavPredict(fit_5b)[, 'visual'],
    verbal = lavPredict(fit_5b)[, 'verbal'],
    speed  = lavPredict(fit_5b)[, 'speed']
  )

lm_2 = lm(visual ~ school, data = HolzingerSwineford1939)
coef(lm_2)  # same as x1 diffs
```

      (Intercept) schoolPasteur 
     -0.005790171   0.011172061 

``` r
lm_3 = lm(x1 ~ school, data = HolzingerSwineford1939)
coef(lm_3)
```

      (Intercept) schoolPasteur 
       4.92988506    0.01135425 

Now lets do a sum score. It may not be obvious, but a sum score can be seen as assuming a latent variable model where there is only a single construct and loadings and variances are equal for each item. As such, it is a natural substitute for a latent variable if we don’t want to use SEM, especially if we’re dealing with a notably reliable measure.

``` r
HolzingerSwineford1939 = HolzingerSwineford1939 %>%
  rowwise() %>%
  mutate(
    visual_sum = sum(x1, x2, x3),
    verbal_sum = sum(x4, x5, x6),
    speed_sum  = sum(x7, x8, x9)
  ) %>%
  ungroup()

lm_sum = lm(visual_sum ~ school, HolzingerSwineford1939)

coef(lm_sum)  # same as structural diffs
```

      (Intercept) schoolPasteur 
       13.1255747     0.2868184 

That coefficient representing the group difference looks familiar- it’s the same value as we had for models `4a` and `4c`, where we looked at a group difference only for the visual factor. As with those, this can be seen as a total effect of school on the visual ‘factor’.

## Summary of differences

We can summarize our results as follows. The @ref(multiple-group-analysis) multigroup approach can be seen as an interaction of everything with the grouping variable. In some measurement scenarios, for example, the development of a nationwide achievement exam, this might be desirable as a means to establish measurement invariance (see below). However, I think this is probably rarely a theoretical goal for most applied researchers using SEM. Furthermore, group sizes may be prohibitively small given the number of parameters that need to be estimated. And if we consider other modeling contexts outside of SEM, it is exceedingly rare to interact every covariate with a moderator.

In general though, we may very well be interested in a specific group difference on some latent variable, possibly controlling for other effects in some fashion. It is far simpler to specify such a model as above by regressing the latent variable on the group indicator as in the demonstration above, and it is a notably simpler model as well.

## Supplemental: Measurement invariance

As a final note, in some cases we are instead looking for similarities across groups among the latent constructs, rather than differences. This is especially the case in scale development, where one would like a measure to be consistent across groups of individuals (e.g. sex, age, race, etc.).

Aside from general problems of ‘accepting the null hypothesis’, the basic idea is to test a restricted model (e.g. loadings, intercepts, etc. are equal) vs. the less restrictive one that assumes the differences across groups exist, and if the general fit of the models is not appreciably different, then one can claim equivalence across groups. As a starting point, we assume configural equivalence, or in other words, that the factor structure is the same. There is no point in testing measurement equivalence if there is not a similar factor structure. The first more restricted model is that the loadings are equivalent. The next is that observed variable intercepts are equivalent, followed by latent variable means, and finally residual variances/covariances.

I find in consulting and in published reports that researchers think that because they are interested in group differences that they are required to take a measurement invariance approach. This is not the case at all, as our previous models have shown. However, below is a demonstration using semTools. The package used to have a simple function that did exactly what most users want in a way easier than any other SEM package I’ve come across. In an effort to add flexibility and accommodate other data scenarios, they’ve made it much more complicated to do the default scenario, and have unfortunately deprecated the simple approach. I demonstrate both below.

``` r
hs_model_4 <- ' 
  visual  =~ x1 + x2 + x3
  verbal  =~ x4 + x5 + x6
  speed   =~ x7 + x8 + x9 
'

semTools::measurementInvariance(
  model = hs_model_4, 
  data  = HolzingerSwineford1939, 
  group = "school"
)
```

``` r
cat("
Measurement invariance models:

Model 1 : fit.configural
Model 2 : fit.loadings
Model 3 : fit.intercepts
Model 4 : fit.means

Chi-Squared Difference Test

               Df    AIC    BIC  Chisq Chisq diff Df diff Pr(>Chisq)    
fit.configural 48 7484.4 7706.8 115.85                                  
fit.loadings   54 7480.6 7680.8 124.04      8.192       6     0.2244    
fit.intercepts 60 7508.6 7686.6 164.10     40.059       6  4.435e-07 ***
fit.means      63 7543.1 7710.0 204.61     40.502       3  8.338e-09 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


Fit measures:

                 cfi rmsea cfi.delta rmsea.delta
fit.configural 0.923 0.097        NA          NA
fit.loadings   0.921 0.093     0.002       0.004
fit.intercepts 0.882 0.107     0.038       0.015
fit.means      0.840 0.122     0.042       0.015
    ")
```


    Measurement invariance models:

    Model 1 : fit.configural
    Model 2 : fit.loadings
    Model 3 : fit.intercepts
    Model 4 : fit.means

    Chi-Squared Difference Test

                   Df    AIC    BIC  Chisq Chisq diff Df diff Pr(>Chisq)    
    fit.configural 48 7484.4 7706.8 115.85                                  
    fit.loadings   54 7480.6 7680.8 124.04      8.192       6     0.2244    
    fit.intercepts 60 7508.6 7686.6 164.10     40.059       6  4.435e-07 ***
    fit.means      63 7543.1 7710.0 204.61     40.502       3  8.338e-09 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


    Fit measures:

                     cfi rmsea cfi.delta rmsea.delta
    fit.configural 0.923 0.097        NA          NA
    fit.loadings   0.921 0.093     0.002       0.004
    fit.intercepts 0.882 0.107     0.038       0.015
    fit.means      0.840 0.122     0.042       0.015
        

Now for the new approach. From a single line of code, we now have to do the following to produce the same result. Great if you need that additional functionality, not so much if you don’t. If you look at the visual latent variable intercepts model , their difference would equal that seen in models `4d/e`.

``` r
test.seq <- c("loadings","intercepts","means","residuals")

meq.list <- list()

for (i in 0:length(test.seq)) {
  if (i == 0L) {
    meq.label <- "configural"
    group.equal <- ""
  } else {
    meq.label <- test.seq[i]
    group.equal <- test.seq[1:i]
  }
  
  meq.list[[meq.label]] <- 
    semTools::measEq.syntax(
      configural.model = hs_model_baseline,
      data = lavaan::HolzingerSwineford1939,
      ID.fac = "auto.fix.first",
      group = "school",
      group.equal = group.equal,
      return.fit = TRUE
  )
}

semTools::compareFit(meq.list)
```

    The following lavaan models were compared:
        meq.list.configural
        meq.list.loadings
        meq.list.intercepts
        meq.list.means
        meq.list.residuals
    To view results, assign the compareFit() output to an object and  use the summary() method; see the class?FitDiff help page.

This last one just compares the means. We see that assuming no group difference results in a worse model all around.

``` r
# means_only
test.seq <- c("means")

meq.list <- list()

for (i in 0:length(test.seq)) {
  if (i == 0L) {
    meq.label <- "configural"
    group.equal <- ""
  } else {
    meq.label <- test.seq[i]
    group.equal <- test.seq[1:i]
  }
  
  meq.list[[meq.label]] <- 
    semTools::measEq.syntax(
      configural.model = hs_model_baseline,
      data = lavaan::HolzingerSwineford1939,
      ID.fac = "auto.fix.first",
      group = "school",
      group.equal = group.equal,
      return.fit = TRUE
  )
}

semTools::compareFit(meq.list)
```

    The following lavaan models were compared:
        meq.list.configural
        meq.list.means
    To view results, assign the compareFit() output to an object and  use the summary() method; see the class?FitDiff help page.

## Footnotes

## Reuse

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

## Citation

BibTeX citation:

``` quarto-appendix-bibtex
@online{clark2019,
  author = {Clark, Michael},
  title = {Comparisons of the {Unseen}},
  date = {2019-08-05},
  url = {https://m-clark.github.io/posts/2019-08-05-comparing-latent-variables/},
  langid = {en}
}
```

For attribution, please cite this work as:

Clark, Michael. 2019. “Comparisons of the Unseen.” August 5. <https://m-clark.github.io/posts/2019-08-05-comparing-latent-variables/>.

[^1]: Note that lavaan allows one to take this two step approach while estimating proper standard errors given the measurement error associated with the latent variable scores. The function is fsr, but as of this writing, it is undergoing development, has been hidden from the user, and was not working.
