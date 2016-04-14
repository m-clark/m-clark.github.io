# Graphical and Latent Variable Modeling in R
| Michael Clark
| Statistician Lead
| Consulting for Statistics, Computing and Analytics Research
| <span style="color:'#00274c'">Advanced Research Computing</span>
  
`r Sys.Date()`  








# Introduction 


This workshop will introduce participants to latent variable modeling techniques and graphical models more generally.  When first encountering these models, it may depend on one's discipline how such models may be presented.  This will take a broad view initially, but then focus on what is usually referred to as <span class="emph">*structural equation modeling*</span> in the social and educational science literature.  An attempt will be made to use a consistent, rather than discipline specific nomenclature and approach. 

One of the goals of this workshop is to *not* instill a false sense of comfort and/or familiarity with the techniques. No one is going to be an expert after a couple of afternoons with SEM, nor should they feel comfortable enough 'just running one' with their data.  SEM is typically taught over the course of a few weeks in a traditional multivariate statistics course, or given its own course outright.  Instead, one of the primary goals is to instill a firm conceptual foundation starting with common approaches (e.g. standard regression), while exposing you to a wide family of related techniques, any of which might be useful to your modeling and data situation.

## Prerequisites
### Statistical
One should at least have a *firm* understanding of standard regression modeling techniques. If you are new to statistical analysis in general, I'll be blunt and say you are probably not ready for SEM.  SEM employs knowledge of maximum likelihood, multivariate analysis, measurement error, indirect effects etc., and none of this is typically covered in a first semester of statistics in many applied disciplines.  SEM builds upon that basic regression foundation, and if that is not solid, SEM will probably be at best confusing.  

### Programming
SEM requires its own modeling language approach.  As such the syntax for Mplus and SEM specific programs, as well as SEM models within other languages or programs (e.g. R or Stata) are going to require you to learn something new.  


## Outline

### Graphical Models
The workshop will start with the familiar, a standard regression model.  It will then be presented as a <span class="emph">graphical model</span>, and extended to include indirect effects (e.g. $\mathcal{A} \rightarrow \mathcal{B} \rightarrow \mathcal{C}$).  At this point we will discuss *directed graphs*, and demonstrate a more theoretically motivated approach (sometimes called *path analysis*), and compare it to a more flexible approach (Bayesian network) that does not require prespecification of paths nor specific directional relations.  At this point we'll briefly discuss such undirected graphs, with an example utilizing 'network analysis', though any exercise will likely be left to the participant's own time.

### Latent Variables
We will then discuss the notion of <span class="emph">latent variables</span> in the context of *underlying causes or constructs* and an understanding of the notion of **measurement error**.  We will also note that latent variable models are actually even more broadly utilized when one includes other *dimension reduction*, or data compression, techniques, several of which fall under the heading of *factor analysis*.  A few common techniques will be demonstrated such as 'factor analysis', principal components analysis, and an overview will be provided for others. In addition, we will briefly discuss the relation of latent variable models to random effects models (something that will be demonstrated in more detail later), and note other places one might find latent variables (e.g. the EM algorithm, hidden Markov models).


### SEM
The bulk of the rest of the workshop will focus on <span class="emph">structural equation modeling</span>.  We will spend a good deal of time with measurement models first, comparing them to our previous efforts, and then extend those models to the case of regression with latent variables.  There are many issues to consider when developing such models, and an attempt will be made to cover quite a bit of ground in that regard.  


### Others
Time may permit discussion of other topics within the SEM realm. For example <span class="emph">latent growth curve</span> models, are an alternative to a standard mixed model. Also there are situations where the latent variable might be considered categorical, commonly called <span class="emph">mixture models</span> or cluster analysis, but in some specific contexts might go by other names (e.g. latent class analysis).  Finally, an overview of other types of latent variable or structural equation models, such as item response theory, collaborative filtering etc. may also be provided.


## Programming Language Choice

<img src="img/Rlogo.svg" style="display:block; margin: 0 auto; width:50%">

We will use **<span class='pack'>R</span>** for this workshop for a variety of reasons.  One is that all of the techniques mentioned thus far are fully developed within various R packages, often taking just a line or two of code to implement after the data has been prepped.  Furthermore, it is freely available and will work on Windows, Mac and Linux.  R is well-known as a powerful statistical modeling environment, and its flexible programming language allows for efficient data manipulation and exploration.  Furthermore, it has a vast array of visualization capabilities.  In short, it provides everything one might need in a single environment.


Among alternatives, Mplus is the most fully developed structural equation modeling package, and has been for years.  However, it is a poor tool for data management, the University of Michigan does not have a campus-wide license for it, and most of its functionality (and all we will need for this workshop) is implemented within the <span class='pack'>lavaan</span> family of R packages.  Stata has recently provided SEM capabilities, but it is less well-developed (something that might change in time), and it still requires a license, making non-campus usage difficult or costly.  SPSS Amos would perhaps be another alternative for some, but suffers the same licensing issues and is not as flexible as Mplus, historically it has lagged far behind Mplus in capabilities, and furthermore it is not supported for Unix operating systems such as Mac and Linux.  Other alternatives include Proc Calis in SAS and OpenMX (another R package).  Python implementation seems minimal presently.  Historically, people used EQS and LISREL, but the former is no longer developed and the latter is no longer relatively widely used, as well as being a Windows-only application.


## Setup for the workshop

For the following to go smoothly, you'll need to complete the following steps *precisely*.  

If you are not present or are bringing your laptop, you'll need to have both R and Rstudio installed on whatever machine you'll be using.  If this will be a new experience for you, [install R first](https://cloud.r-project.org/), then [Rstudio](https://www.rstudio.com/products/rstudio/download/).  For either you'll need to choose the version appropriate to your operating system.  As you go through the installation, for both just accept all defaults when prompted until the installation process begins.  Once both are installed, *you will only need to work with Rstudio*, and it will at all times be assumed you will be using Rstudio during the workshop.

Once those are installed, proceed through the following steps.

1. Download this [zipfile](http://www-personal.umich.edu/~micl/sem/workshop_files.zip), and unzip its contents to an area on your machine that you have write access to. It contains the course contents, data, etc. in a folder that will serve as an Rstudio project folder.

2. Open Rstudio.  File/Open Project/ then navigate to the folder contents you just unzipped.  Click on the SEM file (should look like a blue icon, but otherwise is the SEM.Rproj file).

3. If the file is not already opened after opening the Rstudio project, File/Open File/my_code.R . Run the one line of code there and you're set.

The lab for this workshop has Windows machines, and so the above is enough to proceed. For *nix systems, it's probably easiest to just install the packages as we use them.

## Color coding in text

- <span class="objclass">object or class of object</span>
- <span class="func">function</span>
- <span class="pack">package</span>
- <span class="emph">important term</span>








# Introduction to R 

This introduction to R is very brief and only geared toward giving you some basics so that you can understand and run the code for this course.


## Getting Started


### Installation

As mentioned previously, to begin with R for your own machine, you just need to go [R website](https://www.r-project.org/), download it for your operating system, and install. Then go to [Rstudio](https://www.rstudio.com/), download and install it.  From there on you only need Rstudio to use R.  

Updates occur every few months, and you should update R whenever a new version is released.


### Packages
R is the most powerful statistical environment within which to work as soon as you install it. However, its real strength comes from the community, which has added thousands of <span class="emph">packages</span> that provide additional or enhanced functionality.  You will regularly find packages that specifically do something you want, and will need to install them in order to use.

Rstudio provides a **Packages** tab, but it is usually just as or more efficient to use the <span class="func">install.packages</span> function.

<img src="img/packagesTab.png" style="display:block; margin: 0 auto;">


```r
install.packages('mynewfavorite')
```


At this point there are over 7000 packages available through standard sources, and many more through unofficial ones.  To start getting some ideas of what you want to use, you will want to spend time at places like [CRAN Task Views](https://cran.r-project.org/web/views/), [Rdocumentation](http://www.rdocumentation.org/), or with a list [like this one](https://github.com/qinwf/awesome-R).

The main thing to note is that if you want to use a package, you have to load it with the <span class="func">library</span> function.


```r
library(lazerhawk)
```

Sometimes, you only need the package for one thing and there is no reason to keep it loaded, in which case you can use the following approach.


```r
packagename::packagefunction(args)
```

I suggest using the library function for this workshop.

You'll get the hang of finding, installing, and using packages quite quickly. However, note that the increasing popularity and ease of using R means that packages can vary quite a bit in terms of quality, so you may need to try out a couple packages with seemingly similar functionality to find the best for your situation.


### Rstudio

Rstudio is an <span class="emph">integrated development environment</span> (**IDE**) specifically geared toward R (though it works for other languages too).  At the very least it will make your programming far easier and more efficient, at best you can create publish-ready documents, manage projects, create interactive website regarding your research, use version control, and much more.

See [Emacs Speaks Statistics](http://ess.r-project.org/) for an alternative. The point is, base R is not an efficient way to use R, and you have at least two very powerful options to make your coding easier.



## Key things to know for this course


### R is a programming language, not a 'stats package'

The first thing to note for those new to R is that R is a language that is oriented toward, but not specific to, dealing with statistics.  This means it's highly flexible, but does take some getting used to.  If you go in with a spreadsheet style mindset, you'll have difficulty, as well as miss out on the power it has to offer.


### Never ask if R can do what you want.  It can.

The only limitation to R is the user's programming sophistication. The better you get at statistical programming the further you can explore your data and take your research.  This holds for any statistical endeavor whether using R or not.


### Main components: script, console, graphics device

With R, the *script* is where you write your R code. While you could do everything at the console, this would be difficult at best and unreproducible.  The *console* is where the results are produced from running the script.  Again you can do one-liner stuff there, such as getting help for a function.  The *graphics device* is where visualizations are produced, and in Rstudio you have two, one for static plots, and a **viewer** for potentially interactive ones.


### R is easy to use, but difficult to master.

If you only want to use R in an applied fashion, as we will do here, R can be very easy to use.  As an example the following code would read in data and run a regression.


```r
mydata = read.csv(file='location/myfile.csv')
regModel = lm(y ~ x, data=mydata)
summary(regModel)
```

The above code demonstrates that R can be as easy to use as anything else, and in my opinion, it is for any standard analysis.  The nice part is that it can still be *easier* to use with more complex analyses you either won't find elsewhere or will only get with crippled functionality.


### Object-oriented
R is <span class="emph">object-oriented</span>.  For our purposes this means that we create what are called objects and use <span class="emph">functions</span> to manipulate those objects in some fashion. In the above code we created two objects, an object that held the data and an object that held the regression results.  

Objects can be ***anything***, a string, a list of 1000 data sets, the results of an analysis, ***anything***.

#### Assignment
In order to create an object, we must <span class="emph">assign</span> something to it.  You'll come across two ways to do this.


```r
myObject = something
myObject <- something
```

These result in the same thing, an object called myObject that contains 'something' in it. For all appropriate practical use, which you use is a matter of personal preference. The point is that typical practice in R entails that one assigns something to an object and then uses functions on that object to get something more from it.

### Functions
Functions are objects that take input and produce some output (called a value).  In the above code we used three functions: <span class="func">read.csv</span>, <span class="func">lm</span>, and <span class="func">summary</span>.  The inputs are called <span class="emph">arguments</span>.  With <span class="func">read.csv</span>, we merely gave it one argument the file name, but there are actually a couple dozen, each with some default.  Type `?read.csv` at the console to see the helpfile.

#### Classes
All objects have a certain class, which means that some functions will work in certain ways depending on the class.  Consider the following code.


```r
x = rnorm(100)
y = x + rnorm(100)
mod = lm(y ~ x)
summary(x)
```

```
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
-3.14700 -0.72570 -0.13570 -0.05376  0.84600  3.62400 
```

```r
summary(mod)
```

```

Call:
lm(formula = y ~ x)

Residuals:
    Min      1Q  Median      3Q     Max 
-2.2765 -0.5918 -0.1398  0.6933  2.5101 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.01803    0.08776  -0.205    0.838    
x            1.00996    0.08113  12.448   <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8766 on 98 degrees of freedom
Multiple R-squared:  0.6126,	Adjusted R-squared:  0.6086 
F-statistic:   155 on 1 and 98 DF,  p-value: < 2.2e-16
```

In both cases we used the `summary` function, but get different results.  There are two <span class="emph">methods</span> for summary at work here: <span class="">summary.default</span> and <span class="">summary.lm</span>.  Which is used depends on the class of the object given as an argument to the summary function.


```r
class(x)
```

```
[1] "numeric"
```

```r
class(mod)
```

```
[1] "lm"
```

One of the most common classes of objects used is the `data.frame`.  Data frames are matrices that contain multiple types of vectors that are the variables and observations of interest.  The contents can be numeric, factors (categorical variables), character strings and other types of objects.  


```r
nams = c('Bob Ross', 'Bob Marley', 'Bob Odenkirk')
places = c('Dirt', 'Dirt', 'New Mexico')
yod = c(1995, 1981, 2028)

bobs = data.frame(nams, places, yod)
bobs
```

```
          nams     places  yod
1     Bob Ross       Dirt 1995
2   Bob Marley       Dirt 1981
3 Bob Odenkirk New Mexico 2028
```


### Case sensitive

A great deal of the errors you will get when you start learning R will result from not typing something correctly.  For example, what if we try `summary(X)`?


```r
summary(X)
```

```
Error in summary(X): object 'X' not found
```

Errors are merely messages or calls for help from R. It can't do what you ask and needs something else in order to perform the task.  In this case, R is telling you it can't find anything called X, which makes sense because the object name is lowercase $x$.  This error message is somewhat straightforward, but error messages for all programming languages typically aren't, and depending on what you're trying to do, it may be fairly vague.  Your first thought as you start out with R should be to check the names of things if you get an error.

### The lavaan package

You'll see more later, but in order to use lavaan for structural equation modeling, you'll need two things primarily: an object that represents the **data**, and an object that represents the **model**. It will look something like the following.


```r
modelCode = "
  y ~ x1 + x2 + lv            # structural/regression model
  lv =~ z1 + z2 + z3 + z4     # measurement model with latent variable lv
"

library(lavaan)
mymodel = sem(modelCode, data=mydata)
```

The character string is our model, and it can actually be kept as a separate file (without the assignment) if desired. Using the lavaan library, we can then use one of its specific functions like <span class="func"></span>cfa, <span class="func"></span>sem, or <span class="func"></span>growth to use the model code object (<span class="objClass"></span>modelCode above) and the data object (<span. class="objClass"></span>mydata above).


The way to define things in lavaan can be summarized as follows.

----------------------------------------------------------------
       formulaType          operator           mnemonic         
-------------------------- ---------- --------------------------
latent variable definition     =~           is measured by      

        regression             ~           is regressed on      

 (residual) (co)variance       ~~         is correlated with    

        intercept             ~ 1             intercept         

     fixed parameter           _*     is fixed at the value of _
----------------------------------------------------------------

### Getting help
Use `?` to get the helpfile for a specific function, or `??` to do a search possibly on a quoted phrase.

Examples:


```r
?lm
??regression
??'nonlinear regression'
```



## Moving forward

Hopefully you'll get the hang of things as we run the code in later chapters.  You'll essentially only be asked to tweak code that's already provided.  This is not a 'learning R' course. The CSCAR group provides a couple of those if you're interested.  Here are some exercises though to make sure we start to get comfortable with it.

### Exercises

1. Create an object that consists of the numbers one through five.
using `c(1,2,3,4,5)` or `1:5`

2. Create a different object, that is the same as that object, but plus 1 (i.e. the numbers two through six).

3. Without creating an object, use `cbind` and `rbind`, feeding your objects as arguments. For example `cbind(obj1, obj2)`.

4. Create a new object using `data.frame` just as you did rbind or cbind in #3.

5. Inspect the class of the object, and use the summary function on it.

### Summary

There's a lot to learn with R, and the more time you spend with R the easier your research process will likely go, and the more you will learn about statistical analysis.






# Graphical Modeling

Graphical models can be seen as a mathematical or statistical construct connecting *nodes* via *edges*.  When pertaining to statistical models, the nodes might represent variables of interest in our data set, and edges specify the relationships among them.  Visually they are depicted in the style of the following examples.


<img src='img/graphicalModels.png' width=50% style="display:block; margin: 0 auto;">





Any statistical model you've conducted can be expressed as a graphical model.  As an example, the first graph with nodes X, Y, and Z might represent a regression model in which X and Z predict Y.  The ABC graph shows an indirect effect, and the 123 graph might represent a correlation matrix.

A key idea of a graphical model is that of *conditional independence*, something one should keep in mind when constructing their models.  The concept can be demonstrated with the following graph.




<img src='img/conditionalIndependence.png' width=25% style="display:block; margin: 0 auto">


In this graph, X is *conditionally independent* of Z given Y- there is no correlation between X and Z once Y is accounted for.  We will revisit this concept when discussing path analysis and latent variable models.  Graphs can be *directed*, *undirected*, or *mixed*. Directed graphs have arrows, sometimes implying a causal flow (a difficult endeavor to demonstrate explicitly) or noting a time component. Undirected graphs merely denote relations among the nodes, while mixed graphs might contain both directional and symmetric relationships.  Most of the models discussed in this course will be directed or mixed.

## Directed Graphs
As noted previously, we can represent standard models as graphical models.  In most of these cases we'd be dealing with directed or mixed graphs.  Almost always we are specifically dealing with directed *acyclic* graphs, where there are no feedback loops.

### Standard linear model
Let's start with the standard linear model (SLiM), i.e. a basic regression we might estimate via ordinary least squares (but not necessarily). In this setting, we want to examine the effect of each potential predictor (x* in the graph) on the target variable (y).  The following shows what the graphical model might look like.

<!--html_preserve--><div id="htmlwidget-1567" style="width:192px;height:288px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-1567">{"x":{"diagram":"digraph DAG {\n\ngraph [rankdir = LR]\n\nnode [shape = circle, style=filled, color=gray, fontcolor=gray10]\n\nnode [fillcolor=white, fontname=\"Helvetica\"]\nx1; x2; x3; \n\nnode [fillcolor=gray90]\ny;\n\nedge [color=gray50]\nx1 -> y; x2 -> y; x3 -> y;\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

We start with the SLiM as a way to keep us thinking about the more complex  models we will see later in the same way we do other models we might be more familiar with.  In what follows, we'll show that whether we use a standard R modeling approach (via the <span class="func">lm</span> function), or an SEM approach (via the <span class="func">sem</span> function in lavaan), the results are identical (aside from the fact that sem is using maximum likelihood).


```r
mcclelland = haven::read_dta('data/path_analysis_data.dta')
lmModel = lm(math21 ~ male + math7 + read7 + momed, data=mcclelland)
```

Here we can do the same model using the lavaan package, and while the input form will change a bit, and the output will be presented in a manner consistent with sem, the estimated parameters are identical. Note that the residual standard error in lm is the square root of the variance estimate in the lavaan output.


```r
library(lavaan)
model = "
  math21 ~ male + math7 + read7 + momed 
"
semModel = sem(model, data=mcclelland, meanstructure = TRUE)

summary(lmModel)
```

```

Call:
lm(formula = math21 ~ male + math7 + read7 + momed, data = mcclelland)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.9801 -1.2571  0.1376  1.4544  5.7471 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  4.84310    1.16418   4.160 4.08e-05 ***
male         1.20609    0.25831   4.669 4.44e-06 ***
math7        0.31306    0.04749   6.592 1.76e-10 ***
read7        0.08176    0.01638   4.991 9.81e-07 ***
momed       -0.01684    0.06651  -0.253      0.8    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 2.329 on 324 degrees of freedom
  (101 observations deleted due to missingness)
Multiple R-squared:  0.258,	Adjusted R-squared:  0.2488 
F-statistic: 28.16 on 4 and 324 DF,  p-value: < 2.2e-16
```

```r
summary(semModel, rsq=T)
```

```
lavaan (0.5-20) converged normally after  21 iterations

                                                  Used       Total
  Number of observations                           329         430

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)
  math21 ~                                            
    male              1.206    0.256    4.705    0.000
    math7             0.313    0.047    6.642    0.000
    read7             0.082    0.016    5.030    0.000
    momed            -0.017    0.066   -0.255    0.799

Intercepts:
                   Estimate  Std.Err  Z-value  P(>|z|)
    math21            4.843    1.155    4.192    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    math21            5.341    0.416   12.826    0.000

R-Square:
                   Estimate
    math21            0.258
```

As we will see in more detail later, SEM incorporates more complicated regression models, but at this point it has the exact same interpretation as our standard regression. As we go along, we can see the models as generalizations of those we are already well acquainted with, and so one can use that prior knowledge as a basis for understanding the newer content.

### Path Analysis
<span class='emph'>Path Analysis</span>, and thus SEM, while new to some, is in fact a very, very old technique, statistically speaking[^pathOld].  It can be seen as a generalization of the SLiM approach that can allow for indirect effects and multiple target variables.  Path analysis also has a long history in the econometrics literature though under different names (e.g. instrumental variable regression, 2-stage least squares etc.), and through the computer science realm through the use of graphical models more generally.  As such, there are many tools at your disposal for examining such models, and I'll iterate that much of the SEM perspective on modeling comes largely from specific disciplines, while other approaches may be better for your situation.

#### Types of relationships
The types of potential relationships examined by path analysis can be seen below.
<img src="img/correlationComponents.png" style="display:block; margin: 0 auto; width:50%; height:50%;">

#### Aside: Tracing rule
In a recursive model, <span class="emph">implied correlations</span> between two variables, X1 and X2, can be found using tracing rules. Implied correlations between variables in a model are equal to the sum of the product of all standardized coefficients for the paths between them. Valid tracings are all routes between X1 and X2 that a) do not enter the same variable twice and b) do not enter a variable through an arrowhead and leave through an arrowhead. The following examples assume the variables have been standardized (variance values equal to 1), if standardization has not occurred the variance of variables passed through should be included in the product of tracings.

Consider the following variables, A, B, and C (in a dataframe called abc) with a model seen in the below diagram. We are interested in identifying the implied correlation between x and z by decomposing the relationship into its different components and using tracing rules.


```
  vars   n mean sd median trimmed  mad   min  max range  skew kurtosis  se
A    1 100    0  1   0.12    0.02 0.91 -2.54 2.59  5.13 -0.15    -0.35 0.1
B    2 100    0  1   0.07    0.02 1.03 -2.84 2.01  4.85 -0.22    -0.29 0.1
C    3 100    0  1   0.03    0.01 1.00 -2.66 2.96  5.62 -0.04     0.03 0.1
```

```r
cor(abc)
```

```
    A   B   C
A 1.0 0.2 0.3
B 0.2 1.0 0.7
C 0.3 0.7 1.0
```

```r
model = "
  C ~ A + B
  B ~ A
"

pathMod = sem(model, data=abc)
coef(pathMod)
```

```
  C~A   C~B   B~A  C~~C  B~~B 
0.167 0.667 0.200 0.478 0.950 
```

```r
semPlot::semPaths(pathMod, whatLabels = 'par', style = 'lisrel')
```

<img src="index_files/figure-html/traceCoefs-1.png" title="" alt="" style="display: block; margin: auto;" />

To reproduce the correlation between A and C (sometimes referred to as a 'total effect':

- Corr = ac + ab * ac
- Corr = 0.167 + 0.133
- Corr = 0.3


#### Multiple Targets
While relatively seldom used, multivariate linear regression is actually very straightforward in some programming environments such as R.  Using the McClelland data, let's try it for ourselves. First, let's look at the data to get a sense of things.


```
                vars   n  mean   sd median trimmed  mad min max range  skew kurtosis   se
attention4         1 430 17.93 3.05     18   18.03 2.97   9  25    16 -0.31    -0.17 0.15
math21             2 364 11.21 2.69     11   11.30 2.97   3  17    14 -0.26    -0.18 0.14
college            3 286  0.37 0.48      0    0.34 0.00   0   1     1  0.52    -1.74 0.03
vocab4             4 386 10.18 2.53     10   10.23 2.97   4  17    13 -0.18    -0.37 0.13
math7              5 397 10.73 2.76     11   10.69 2.97   4  19    15  0.13    -0.47 0.14
read7              6 390 31.57 8.05     30   30.87 8.90  18  61    43  0.79     0.41 0.41
read21             7 360 73.67 8.52     76   74.69 7.41  35  84    49 -1.60     3.88 0.45
adopted            8 430  0.49 0.50      0    0.48 0.00   0   1     1  0.06    -2.00 0.02
male               9 430  0.55 0.50      1    0.56 0.00   0   1     1 -0.19    -1.97 0.02
momed             10 419 14.83 2.03     15   14.77 1.48  10  21    11  0.11    -0.45 0.10
college_missing   11 430  0.33 0.47      0    0.29 0.00   0   1     1  0.70    -1.52 0.02
```

<!--html_preserve--><div id="htmlwidget-5046" style="width:384px;height:384px;" class="d3heatmap html-widget"></div>
<script type="application/json" data-for="htmlwidget-5046">{"x":{"rows":null,"cols":null,"matrix":{"data":["1","0.347","0.347","0.386","0.187","0.076","-0.059","0.347","1","0.53","0.275","0.123","0.152","0.13","0.347","0.53","1","0.253","0.137","0.174","0.08","0.386","0.275","0.253","1","0.137","0.215","-0.004","0.187","0.123","0.137","0.137","1","0.068","0.013","0.076","0.152","0.174","0.215","0.068","1","0.18","-0.059","0.13","0.08","-0.004","0.013","0.18","1"],"dim":[7,7],"rows":["math21","read7","read21","math7","attention4","vocab4","momed"],"cols":["math21","read7","read21","math7","attention4","vocab4","momed"]},"image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAcAAAAHCAYAAADEUlfTAAAAzklEQVQImQXBMUsCUQDA8f899U5JeQUnKLcUHIhL9BkcW9oa3cJBRERHIYrGIkQcxCZxanNx7Bs0HTg55SKCQkN3h/fevX4/y75pm0arCUCcaOqexJMOlxcOotFq8jWd87P9pSLznBeyHMKEYBciAPzbOzarJdmMQGnDSRtKtkDEiea65nI/eODzdQYWxCeNW8wh6p7kqnxGVebpvnQYDcf4bgGlDcKTDrFKCVXK8S/h6a3HY/+d9T7CWnxvTbALKdkCt5hDacN6H/HxPOEfcs9HsBoDin8AAAAASUVORK5CYII=","theme":null,"options":{"xaxis_height":80,"yaxis_width":120,"xaxis_font_size":null,"yaxis_font_size":null,"brush_color":"#0000FF","show_grid":true,"anim_duration":500,"yclust_width":0,"xclust_height":0}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

While these are not the most strongly correlated variables to begin with, one plausible model might try to predict math and reading at age 21 with measures taken at prior years. The coefficients in the output with `~1` are the intercepts.


```r
model = "
  read21 ~ attention4 + vocab4 + read7
  math21 ~ attention4 + math7
  read21 ~~ 0*math21
"
mvregModel  = sem(model, data=mcclelland, missing='listwise', meanstructure = T)
coef(mvregModel)
```

```
read21~attention4     read21~vocab4      read21~read7 math21~attention4      math21~math7    read21~~read21 
            0.128             0.377             0.537             0.091             0.347            51.837 
   math21~~math21          read21~1          math21~1 
            5.965            50.290             5.856 
```

The last line of the model code clarifies that we are treating **math21** and **read21** as independent.  We can compare this to standard R regression.  A first step is taken to make the data equal to what was used in lavaan. For that we can use the dplyr package to select the necessary variables for the model, and then omit rows that have any missing.


```r
library(dplyr)
mcclellandComplete = select(mcclelland, read21, math21, attention4, vocab4, read7, math7) %>% 
  na.omit
lm(read21 ~ attention4 + vocab4 + read7, data=mcclellandComplete)
```

```

Call:
lm(formula = read21 ~ attention4 + vocab4 + read7, data = mcclellandComplete)

Coefficients:
(Intercept)   attention4       vocab4        read7  
    50.2904       0.1275       0.3770       0.5368  
```

```r
lm(math21 ~ attention4 + math7, data=mcclellandComplete)
```

```

Call:
lm(formula = math21 ~ attention4 + math7, data = mcclellandComplete)

Coefficients:
(Intercept)   attention4        math7  
    5.85633      0.09103      0.34732  
```

However, we can and probably should estimate the covariance of math and reading skill at age 21.  Let's rerun the path analysis removing that <span class="emph">constraint</span>.


```r
model = "
  read21 ~ attention4 + vocab4 + read7
  math21 ~ attention4 + math7
"
mvregModel  = sem(model, data=mcclelland, missing='listwise', meanstructure = T)
coef(mvregModel)
```

```
read21~attention4     read21~vocab4      read21~read7 math21~attention4      math21~math7    read21~~read21 
            0.140             0.388             0.494             0.092             0.330            51.958 
   math21~~math21    read21~~math21          read21~1          math21~1 
            5.968             3.202            51.316             6.020 
```

We can see now that the coefficients are now slightly different from the SLiM approach. The `read21~~math21` value represents the residual covariance between math and reading at age 21, i.e. after accounting for the other covariate relationships modeled, it tells us how correlated those skills are. Using <span class='func'>summary</span> will show it to be statistically significant (not shown here).


```r
summary(mvregModel)
```

Whether or not to take a multivariate/path-analytic approach vs. separate regressions is left to the researcher.  Assuming multivariate normality is perhaps less tenable than using the assumption for a single variable, and it's easy to conduct univariate models.  But as the above shows, it doesn't take much to take into account correlated target variables.


#### Indirect Effects
So path analysis allows for multiple target variables, with the same or a mix of covariates for each target.  What about <span class='emph'>indirect effects</span>? Normal regression models examine direct effects only, and the regression coefficients reflect that direct effect.  However, perhaps we think a particular covariate causes some change in another, which then causes some change in the target variable.  This is especially true when some measures are collected at different time points.  Note that in SEM, any variable in which an arrow is pointing to it in the graphical depiction is often called an <span class="emph">endogenous</span> variable, while those that only have arrows going out from them are <span class="emph">exogenous</span>.  Exogenous variables may still have (unanalyzed) correlations among them.  As we will see later, both observed and latent variables may be endogenous or exogenous.

Consider the following model.


<!--html_preserve--><div id="htmlwidget-2252" style="width:288px;height:192px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-2252">{"x":{"diagram":"digraph DAG {\ngraph [rankdir = LR]\n\nnode [shape = rectangle, style=filled, fontcolor=gray10, fontsize=8, \n      fixedsize=false, color=gray80]\n\nnode [fillcolor=white]\nattention4; read7; read21;\n\nedge [color=gray25]\nattention4 -> read7; vocab4 -> read7; read7 -> read21;\n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


Here we posit attention span and vocabulary at age 4 as indicative of what to expect for reading skill at age 7, and that is ultimately seen as a precursor to adult reading ability. In this model, attention span and vocabulary at 4 only have an indirect effect on adult reading ability through earlier reading skill.  At least temporally it makes sense, so let's code this up.


```r
model = "
  read21 ~ read7
  read7 ~ attention4 + vocab4
"

mediationModel  = sem(model, data=mcclelland)
summary(mediationModel, rsquare=TRUE)
```

```
lavaan (0.5-20) converged normally after  21 iterations

                                                  Used       Total
  Number of observations                           305         430

  Estimator                                         ML
  Minimum Function Test Statistic                6.513
  Degrees of freedom                                 2
  P-value (Chi-square)                           0.039

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)
  read21 ~                                            
    read7             0.559    0.050   11.152    0.000
  read7 ~                                             
    attention4        0.270    0.151    1.791    0.073
    vocab4            0.488    0.186    2.629    0.009

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    read21           53.047    4.296   12.349    0.000
    read7            66.779    5.408   12.349    0.000

R-Square:
                   Estimate
    read21            0.290
    read7             0.035
```

What does this tell us? As before, we interpret the results as we would any other regression model, though conceptually there are two sets of models to consider (though they are estimated simultaneously[^oldMediation]), one for reading at age 7 and one for reading at age 21. And indeed, one can think of path analysis as a series of linked regression models. Here we have positive relationships between attention and vocab on reading at age 7, and a positive effect of reading at age 7 on reading at age 21.  Statistically speaking, our model appears to be viable, as there appear to be notable effects for each path. 

However, look at the R^2^ value for reading at age 7.  We now see that there are actually no practical effects of the age 4 variables at all, as all we are accounting for is < 4% of the variance, and all that we have really discovered is that prior reading ability affects later reading ability.  

We can test the indirect effect itself by labeling the paths.  In the following code, I label them based on the first letter of the variables involved (e.g. vr refers to the vocab to reading path), but note that these are arbitrary names.  I also add the direct effects of the early age variable. While the indirect effect for vocab is statistically significant, as we already know there is not a strong correlation between these two variables, it's is largely driven by the strong relationship between reading at age 7 and reading at age 21, which is probably not all that interesting.  A comparison of AIC values, something we'll talk more about later, would favor a model with only direct effects[^medvsdirectModcomp].


```r
model = "
  read21 ~ rr*read7 + attention4 + vocab4
  read7 ~ ar*attention4 + vr*vocab4
  
  # Indirect effects
  att4_read21 := ar*rr
  vocab4_read21 := vr*rr
"

mediationModel  = sem(model, data=mcclelland)
summary(mediationModel, rsquare=TRUE, fit=T, std=T)
```

```
lavaan (0.5-20) converged normally after  27 iterations

                                                  Used       Total
  Number of observations                           305         430

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              121.544
  Degrees of freedom                                 5
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)              -3602.058
  Loglikelihood unrestricted model (H1)      -3602.058

  Number of free parameters                          7
  Akaike (AIC)                                7218.115
  Bayesian (BIC)                              7244.157
  Sample-size adjusted Bayesian (BIC)         7221.957

Root Mean Square Error of Approximation:

  RMSEA                                          0.000
  90 Percent Confidence Interval          0.000  0.000
  P-value RMSEA <= 0.05                          1.000

Standardized Root Mean Square Residual:

  SRMR                                           0.000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
  read21 ~                                                              
    read7     (rr)    0.536    0.050   10.607    0.000    0.536    0.515
    attentin4         0.134    0.134    0.998    0.318    0.134    0.015
    vocab4            0.381    0.166    2.299    0.021    0.381    0.044
  read7 ~                                                               
    attentin4 (ar)    0.270    0.151    1.791    0.073    0.270    0.033
    vocab4    (vr)    0.488    0.186    2.629    0.009    0.488    0.059

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
    read21           51.926    4.205   12.349    0.000   51.926    0.695
    read7            66.779    5.408   12.349    0.000   66.779    0.965

R-Square:
                   Estimate
    read21            0.305
    read7             0.035

Defined Parameters:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
    att4_read21       0.145    0.082    1.766    0.077    0.145    0.017
    vocab4_read21     0.261    0.102    2.552    0.011    0.261    0.030
```


In the original article, I did not find their description or diagrams of the models detailed enough to know precisely what the model was in the actual study[^mccnodescript], but here is at least one interpretation if you'd like to examine it further.


```r
modReading = "
  read21 ~ read7 + attention4 + vocab4 + male + adopted + momed
  read7 ~ attention4 + vocab4 + male + adopted + momed 
"
reading  = sem(modReading, data=mcclelland, missing='fiml', mimic = 'Mplus', std.ov=TRUE)
summary(reading, rsquare=TRUE)
```




A note about terminology: some refer to models with indirect effects as *mediation* models, and that terminology appears commonly in the SEM (and esp. psychology) literature (along with the notion of 'buffering').  Many applied researchers starting out with SEM often confuse the term with *moderation*, which is called an *interaction* in every other modeling context. As you start out, referring to indirect effects and interactions will likely keep you clear on what you're modeling, and perhaps be clearer to those who may not be as familiar with SEM.  Also, in moderation models, one will often see some variable denoted as 'the moderator', but this is completely arbitrary. In an interaction, it makes just as much sense to say that the A-Y relationship varies as a function of B as it does the B-Y relationship varies as a function of A.


#### Cavets about indirect effects

One should think very hard about positing an indirect effect, *especially if there is no time component*.  If the effect isn't immediately obvious, then one should probably just examine the direct effects.  Unlike other explorations one might do with models (e.g. look for nonlinear effects), the underlying causal connection is more explicit in this context.  Many models I've seen in consulting struck me as arbitrary as far as which covariate served as the mediator, required a notably convoluted explanation for its justification, or ignored other relevant variables because the reasoning would have to include a plethora of indirect effects if it were to be logically consistent.  Furthermore, I can usually ask one or two questions and will discover that they are actually interested in interactions (i.e. moderation), rather than indirect effects.

This document will not get into models that have *moderated mediation* and *mediated moderation*. In my experience these appear to be associated with situations that are difficult to interpret at best, or are otherwise not grounded very strongly in substantive concerns.  It is left to the reader to investigate those particular complications.


<div style="text-align:center">
<h3>---[PATH ANALYSIS EXERICISE](#path-analysis-1)---
</div>




## Bayesian Networks
In many cases of path analysis, the path model is not strongly supported by prior research or intuition, and people are also often willing to use <span class='emph'>modification indices</span> after the fact to change the paths in their model. This is unfortunate, as their model is generally *overfit* to begin with, and more so if altered in such an ad hoc fashion.

A more exploratory approach to graphical modeling is available however.  <span class="emph">Bayesian Networks</span> are an alternative to graphical modeling of the sort we've been doing. Though they can be used to produce exactly the same results that we obtain with path analysis via maximum likelihood estimation, they can also be used for constrained or wholly exploratory endeavors as well, with regularization in place to keep from overfitting.

As an example, I use the McClelland data to explore potential paths via the <span class='pack'>bnlearn</span> package.  I make the constraints that variables later in time do not effect variables earlier in time, no variables are directed toward background characteristics like sex, and at least for these purposes I keep math and reading at a particular time from having paths to each other.  I show some of the so-called **blacklist** of constraints, and use the bnlearn package for the model.


```r
head(blacklist)
```

```
    from         to
1 read21      read7
2 read21      math7
3 read21 attention4
4 read21     vocab4
5 read21    adopted
6 read21       male
```

```r
library(bnlearn)
model = gs(mcclellandNoCollege, blacklist = blacklist, test='mi-g-sh')
plot(model)
# bn.fit(model, data=mcclellandNoCollege) # extract parameters, not shown
```

<img src="index_files/figure-html/bn-1.svg" title="" alt="" style="display: block; margin: auto;" />

The plot of the model results shows that attention span at age 4 has no useful relationship to the other variables, something we'd already suspected based on previous models, and even could guess at the outset given its low correlations. Furthermore, the remaining paths make conceptual sense.  The parameters, fitted values, and residuals can be extracted with the <span class='func'>bn.fit</span> function, and other diagnostic plots, cross-validation and prediction on new data are also available.

We won't get into the details of these models except to say that one should have them in their tool box. And if one really is in a more exploratory situation, the tools available would typically come with methods far better suited for it than the SEM software approach.  The discovery process with Bayesian networks can also be a lot of fun.  Even if one has strong theory, nature is always more clever than we are, and you might find something interesting.

## Undirected graphs
So far we have been discussing directed graphs in which the implied causal flow tends toward one direction and there are no feedback loops.  However, sometimes the goal is not so much to estimate the paths as it is to find the structure.  <span class='emph'>Undirected graphs</span> simply specify the relations of nodes with edges, but without any directed arrows regarding the relationship.

While we could have used the <span class="pack">bnlearn</span> package for an undirected graph by adding the argument `undirected = T`, there are a slew of techniques available for what is often called <span class='emph'>network analysis</span>.  Often the focus is on *observations*, rather than variables, and what influences whether one sees a tie or not, with modeling techniques available for predicting ties (e.g. Exponential Random Graph models).  Often these are undirected graphs and that is our focus here, but they do not have to be.

### Network analysis
Networks can be seen everywhere.  Personal relationships, machines and devices, various business and academic units...  we can analyze the connections among any number of things. A starting point for a very common form of network analysis is an <span class='emph'>adjacency matrix</span>, which represents connections among items we wish to analyze.  Often it is just binary 0-1 values where 1 represents a connection. Any similarity matrix could potentially be used (e.g. a correlation matrix). Here is a simple example of an adjacency matrix:


---------------------------------------------------------------------
     &nbsp;       Bernadette   David   Josh   Lagia   Mancel   Nancy 
---------------- ------------ ------- ------ ------- -------- -------
 **Bernadette**       1          0      1       1       1        1   

   **David**          0          1      1       0       0        1   

    **Josh**          1          1      1       0       1        0   

   **Lagia**          1          0      0       1       0        1   

   **Mancel**         1          0      1       0       1        0   

   **Nancy**          1          1      0       1       0        1   
---------------------------------------------------------------------

Visually, we can see the connections among the nodes.  Click on a node to see the name.

<!--html_preserve--><div id="htmlwidget-8373" style="width:384px;height:384px;" class="forceNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-8373">{"x":{"links":{"source":[2,3,4,5,2,5,0,1,4,0,5,0,2,0,1,3],"target":[0,0,0,0,1,1,2,2,2,3,3,4,4,5,5,5],"value":[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]},"nodes":{"name":["Bernadette","David","Josh","Lagia","Mancel","Nancy"],"group":[1,1,1,1,1,1],"nodesize":[12,12,12,12,12,12]},"options":{"NodeID":"ID","Group":"Group","colourScale":"d3.scale.category20()","fontSize":12,"fontFamily":"serif","clickTextSize":30,"linkDistance":50,"linkWidth":"function(d) { return Math.sqrt(d.value); }","charge":-120,"linkColour":"#BFBFBF","opacity":0.8,"zoom":false,"legend":false,"nodesize":true,"radiusCalculation":" Math.sqrt(d.nodesize)+6","bounded":false,"opacityNoHover":0,"clickAction":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->



As an example of a network analysis, let's look at how states might be more or less similar on a few variables. We'll use the <span class='objclass'>state.x77</span> data set in base R.  It is readily available, no need for loading. To practice your R skills, use the function <span class='func'>str</span> on the state.x77 object to examine its structure, and <span class='func'>head</span> to see the first 6 rows, and `?` to find out more about it.


The following depicts a graph of the states based on the variables of Life Expectancy, Median Income, High School Graduation Rate, and Illiteracy.  The colors represent the <span class='objclass'>state.region</span> variable, and serves to show the clustering is not merely geographical, though one cluster is clearly geographically oriented. Before clicking on any node, can you guess which are the two nodes/states that are not connected to any others?

<!--html_preserve--><div id="htmlwidget-2862" style="width:384px;height:384px;" class="d3heatmap html-widget"></div>
<script type="application/json" data-for="htmlwidget-2862">{"x":{"rows":{"members":8,"height":3.25358353386548,"edgePar":{"col":""},"children":[{"members":4,"height":1.34256578639798,"edgePar":{"col":""},"children":[{"members":2,"height":0.75967650634029,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Income","edgePar":{"col":""}},{"members":1,"height":0,"label":"HS Grad","edgePar":{"col":""}}]},{"members":2,"height":1.14520500666872,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Life Exp","edgePar":{"col":""}},{"members":1,"height":0,"label":"Frost","edgePar":{"col":""}}]}]},{"members":4,"height":2.07934009917826,"edgePar":{"col":""},"children":[{"members":2,"height":1.51343056097249,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Area","edgePar":{"col":""}},{"members":1,"height":0,"label":"Population","edgePar":{"col":""}}]},{"members":2,"height":0.617403396609304,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Murder","edgePar":{"col":""}},{"members":1,"height":0,"label":"Illiteracy","edgePar":{"col":""}}]}]}]},"cols":{"members":8,"height":3.25358353386548,"edgePar":{"col":""},"children":[{"members":4,"height":1.34256578639798,"edgePar":{"col":""},"children":[{"members":2,"height":0.75967650634029,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Income","edgePar":{"col":""}},{"members":1,"height":0,"label":"HS Grad","edgePar":{"col":""}}]},{"members":2,"height":1.14520500666872,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Life Exp","edgePar":{"col":""}},{"members":1,"height":0,"label":"Frost","edgePar":{"col":""}}]}]},{"members":4,"height":2.07934009917826,"edgePar":{"col":""},"children":[{"members":2,"height":1.51343056097249,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Area","edgePar":{"col":""}},{"members":1,"height":0,"label":"Population","edgePar":{"col":""}}]},{"members":2,"height":0.617403396609304,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Murder","edgePar":{"col":""}},{"members":1,"height":0,"label":"Illiteracy","edgePar":{"col":""}}]}]}]},"matrix":{"data":["1","0.62","0.34","0.226","0.363","0.208","-0.23","-0.437","0.62","1","0.582","0.367","0.334","-0.098","-0.488","-0.657","0.34","0.582","1","0.262","-0.107","-0.068","-0.781","-0.588","0.226","0.367","0.262","1","0.059","-0.332","-0.539","-0.672","0.363","0.334","-0.107","0.059","1","0.023","0.228","0.077","0.208","-0.098","-0.068","-0.332","0.023","1","0.344","0.108","-0.23","-0.488","-0.781","-0.539","0.228","0.344","1","0.703","-0.437","-0.657","-0.588","-0.672","0.077","0.108","0.703","1"],"dim":[8,8],"rows":["Income","HS Grad","Life Exp","Frost","Area","Population","Murder","Illiteracy"],"cols":["Income","HS Grad","Life Exp","Frost","Area","Population","Murder","Illiteracy"]},"image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAYAAADED76LAAABDUlEQVQYlQXBwUrCAAAG4H9rlJZYsI516JAQdpnIIEjKSxD1BJ3boXeoUxAdI9pldPAyovOoSDzUKbAYDRQUErVaWNtKbGog+vd9UFSd+1aJjhfS77sstjr8+atzaGns7GUpbh2s4erwHjeOi1o7hqgkYrpxieCihHLhA3C8kMeFKhVVp9ttc1Q+4qhxQhMJVtUlCn7fZa0dw1yc2M6asO/mMTByaN3W0az0IBRbHUYlEcnPUwgLy0itv8HOywgmMpBFB+LiTICkfwZMTWJg5GDnZaQ2AryHcWA8AgwtjV87KzSR4OumQr/v8tn7paLq1IwHSt3rF9Qev5FWx9Cs9LAqOpBnI0jvpvB0buMfGNCG2H2sLjUAAAAASUVORK5CYII=","theme":null,"options":{"xaxis_height":80,"yaxis_width":120,"xaxis_font_size":null,"yaxis_font_size":null,"brush_color":"#0000FF","show_grid":true,"anim_duration":500}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

<!--html_preserve--><div id="htmlwidget-2668" style="width:750px;height:384px;" class="forceNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-2668">{"x":{"links":{"source":[3,9,16,17,23,32,39,41,47,7,8,20,21,31,37,42,45,0,16,32,41,47,5,6,8,14,15,20,21,22,26,29,31,36,46,49,4,6,11,14,15,20,22,25,26,28,36,43,46,48,49,4,5,14,15,20,22,26,29,33,36,46,48,2,8,12,13,19,20,21,24,25,28,29,31,34,37,45,49,2,4,7,12,13,19,20,21,24,25,28,29,31,34,35,37,38,45,0,16,17,32,39,41,47,5,13,14,15,18,20,22,24,25,26,28,34,35,36,40,43,44,46,48,49,7,8,13,19,20,21,24,25,29,31,34,37,45,49,7,8,11,12,14,15,18,19,20,21,24,25,26,28,29,31,34,35,36,37,38,40,44,45,46,48,49,4,5,6,11,13,15,20,22,25,26,28,33,34,36,40,43,44,46,48,4,5,6,11,13,14,20,22,25,26,28,33,34,36,40,43,44,46,48,0,3,9,32,41,47,0,9,23,39,11,13,24,25,28,34,35,37,40,44,7,8,12,13,21,29,31,34,37,45,2,4,5,6,7,8,11,12,13,14,15,21,22,25,26,28,29,31,33,34,35,36,37,38,40,44,46,48,49,2,4,7,8,12,13,19,20,24,25,28,29,31,34,35,36,37,38,40,45,46,48,49,4,5,6,11,14,15,20,26,28,33,36,40,43,44,46,48,0,17,39,7,8,11,12,13,18,21,25,28,31,34,35,37,38,40,44,45,48,5,7,8,11,12,13,14,15,18,20,21,24,26,28,34,35,36,37,40,44,46,48,49,4,5,6,11,13,14,15,20,22,25,28,33,34,36,40,43,44,46,48,49,5,7,8,11,13,14,15,18,20,21,22,24,25,26,34,35,36,37,40,44,46,48,49,4,6,7,8,12,13,19,20,21,31,33,34,37,38,45,42,2,4,7,8,12,13,19,20,21,24,29,34,37,38,45,0,3,9,16,39,41,47,6,14,15,20,22,26,29,36,38,48,7,8,11,12,13,14,15,18,19,20,21,24,25,26,28,29,31,35,36,37,38,40,44,45,46,48,49,8,11,13,18,20,21,24,25,28,34,37,38,40,44,48,4,5,6,11,13,14,15,20,21,22,25,26,28,33,34,40,43,44,46,48,49,2,7,8,12,13,18,19,20,21,24,25,28,29,31,34,35,38,40,44,45,8,13,20,21,24,29,31,33,34,35,37,45,48,0,9,17,23,32,11,13,14,15,18,20,21,22,24,25,26,28,34,35,36,37,44,48,0,3,9,16,32,42,47,2,30,41,5,11,14,15,22,26,36,44,11,13,14,15,18,20,22,24,25,26,28,34,35,36,37,40,43,48,49,2,7,8,12,13,19,21,24,29,31,34,37,38,4,5,6,11,13,14,15,20,21,22,25,26,28,34,36,48,49,0,3,9,16,32,41,5,6,11,13,14,15,20,21,22,24,25,26,28,33,34,35,36,38,40,44,46,4,5,7,11,12,13,20,21,25,27,28,34,36,44,46],"target":[0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,16,16,16,16,16,16,17,17,17,17,18,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,30,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,32,32,32,32,32,32,32,33,33,33,33,33,33,33,33,33,33,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,34,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,36,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,37,38,38,38,38,38,38,38,38,38,38,38,38,38,39,39,39,39,39,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,41,41,41,41,41,41,41,42,42,42,43,43,43,43,43,43,43,43,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,45,45,45,45,45,45,45,45,45,45,45,45,45,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,46,47,47,47,47,47,47,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,49,49,49,49,49,49,49,49,49,49,49,49,49,49,49],"value":[0.7588783174158,1.14982664979011,0.837592972096204,0.846824261156591,0.819831632736631,1.35646303205178,1.02324991651013,0.928160400883504,0.838300768501751,0.607754498962246,0.857992063075157,0.650310728478488,0.603719582194316,0.895821281670155,0.608060156173552,0.624589022999154,0.665649413353595,0.7588783174158,1.16109087028113,0.72973128918655,1.08425070264559,0.780591788037889,1.22661018167582,0.935867558827191,0.633838135876759,0.675101994100898,0.760476470030003,1.28352499978478,0.623046804444444,0.641024680626414,0.666370054542809,0.717708145461872,0.619077001947045,0.839092849385397,1.08408207009545,0.621538890814545,1.22661018167582,0.697511643211395,0.726687249417125,1.12651111320719,1.35500327234262,1.0254064965153,0.91268511452882,0.648494776194366,1.06147862490693,0.715436907749723,1.58976221966619,0.624558559114521,3.25166102094108,0.723450541222127,0.698665689909551,0.935867558827191,0.697511643211395,0.634559259865933,0.684762611412393,0.890305028274032,0.700214096904547,0.606719854895907,0.802279894107659,1.01501844978136,0.668186590765568,0.635503686473702,0.630424734127577,0.607754498962246,1.20225999445818,1.82555219785093,1.08376284728264,1.16945297525257,0.692198017628526,2.04605733234857,0.795904553835413,0.88713633574622,0.757309815832148,0.962049407960515,1.0630664428047,1.36034713137372,1.16021256935377,0.841318009740337,0.820894880048205,0.857992063075157,0.633838135876759,1.20225999445818,1.11350168473041,0.865565507851196,0.928520450357468,0.842023475011092,1.50310231265107,0.76066604124445,0.623514681696444,0.661149470515559,1.27007838695649,4.29166457365573,1.07614840187534,0.66272118622236,1.18289717074472,0.78629989307651,1.2897227550153,1.14982664979011,0.669774805782005,0.62278268650515,1.35093349608555,0.953543669567751,0.740183973316051,0.695101064261087,0.726687249417125,0.80506982909266,1.00957308816268,0.960755749554574,0.694378633376856,0.753689932851513,0.807556416735102,0.610439484322447,0.957221087939255,1.19770420411242,1.62422635814998,0.736153362751813,0.747246211985534,1.1066735332343,1.24349023604244,0.804196751463576,2.05549945861476,0.760787048318593,1.03185603505479,0.691429329686751,1.82555219785093,1.11350168473041,0.808856339697302,3.12248296282043,0.62569080684515,1.45940808149423,0.653274839179437,0.627751150528715,1.4157589875571,1.06809985251925,0.962877974960355,0.87417811332454,0.826297956612586,0.613590170182513,1.08376284728264,0.865565507851196,0.80506982909266,0.808856339697302,0.656416153131992,0.632495784927789,0.760545762533694,0.669929283254805,0.779491486666479,1.64427937344967,1.55259899962482,1.17463358104451,0.658935749403239,1.42921216392397,0.699847721165729,0.724641212138694,4.13835324776803,0.906867480523495,0.75063368227263,1.46399483602508,0.671090888754873,0.939269322853768,0.838613213903359,0.669783075301592,0.622892189093978,0.827568066697398,0.748726357487327,0.675101994100898,1.12651111320719,0.634559259865933,1.00957308816268,0.656416153131992,4.7669950920303,0.873291558640894,2.5683332796806,0.638045425536353,3.85410313816772,0.833846158520073,0.709362210014447,0.638890181238812,2.60321967430306,0.917184133859794,0.686856444650992,0.720050548515195,1.06819745239832,1.42942040597487,0.760476470030003,1.35500327234262,0.684762611412393,0.960755749554574,0.632495784927789,4.7669950920303,0.983101298147289,2.48978588294586,0.626658867169439,3.66637973907507,0.811619088294802,0.706173289636165,0.626763888783738,2.97822671932103,0.816281765173939,0.706242643501336,0.682256944127114,1.18695330851489,1.30582777254489,0.837592972096204,1.16109087028113,0.669774805782005,1.27247403540234,2.10647517674461,1.4253918256059,0.846824261156591,0.62278268650515,0.901293861418341,0.86185705248146,0.694378633376856,0.760545762533694,0.833040547691509,0.821247105845189,0.835348244938594,0.681225712147006,0.848833209855139,0.696186032833233,0.65721319680411,0.952402698516219,1.16945297525257,0.928520450357468,3.12248296282043,0.669929283254805,1.05853054558893,1.58471196913991,0.932058028927103,0.771151231442774,0.701426713815706,0.717720941686761,0.650310728478488,1.28352499978478,1.0254064965153,0.890305028274032,0.692198017628526,0.842023475011092,0.753689932851513,0.62569080684515,0.779491486666479,0.873291558640894,0.983101298147289,0.843699653557764,0.841897592091274,0.704237131539764,0.923197819433264,0.898789560718424,0.786492602809332,0.761363459879501,0.69577367731484,0.864325033486255,0.645291060160842,1.13138692282956,0.643015780778362,0.637911958901117,0.654583836905783,0.616918473045963,0.955948530007539,0.941337578333881,0.648157810595984,0.603719582194316,0.623046804444444,2.04605733234857,1.50310231265107,1.45940808149423,1.64427937344967,1.05853054558893,0.843699653557764,1.0378609970346,0.875345167690751,0.895984182641708,1.12898927842747,1.16421797313372,2.62602102485566,0.700446795801299,0.65832200108567,1.59255287004024,0.698053882457244,0.631885429159826,0.901452255325191,0.609672588983899,0.664699957291161,0.714158603889173,0.641024680626414,0.91268511452882,0.700214096904547,0.807556416735102,2.5683332796806,2.48978588294586,0.841897592091274,2.29365953785649,0.690243896715714,0.847559663112655,1.45682033176443,0.838131315925103,0.623346593550617,0.628335704551335,0.821590669150638,1.55124649032099,0.819831632736631,0.901293861418341,1.02221859886894,0.795904553835413,0.76066604124445,0.610439484322447,0.653274839179437,1.55259899962482,0.833040547691509,1.0378609970346,0.745795306951012,0.851965266438829,0.655327755089639,1.34139863377787,1.08296657210112,1.90371239306965,0.741570404992356,0.779710707987034,0.710064478990376,0.762498142983219,0.64225543207587,0.648494776194366,0.88713633574622,0.623514681696444,0.957221087939255,0.627751150528715,1.17463358104451,0.638045425536353,0.626658867169439,0.821247105845189,0.704237131539764,0.875345167690751,0.745795306951012,0.648447262632704,1.74927112342879,1.10546645346323,0.656587369354757,0.781552035619564,0.764899429499152,0.720108921191107,0.902543133905148,0.758522219351063,0.638876187076685,1.62795151051662,0.666370054542809,1.06147862490693,0.606719854895907,1.19770420411242,0.658935749403239,3.85410313816772,3.66637973907507,0.923197819433264,2.29365953785649,0.648447262632704,0.894698376438444,0.665907161747982,0.639696292313271,2.28643044883012,0.982109172674993,0.776962511633253,0.805233888962156,0.982569477580044,1.59655358277467,0.727545417884904,0.715436907749723,0.757309815832148,0.661149470515559,1.62422635814998,1.42921216392397,0.833846158520073,0.811619088294802,0.835348244938594,0.898789560718424,0.895984182641708,0.690243896715714,0.851965266438829,1.74927112342879,0.894698376438444,1.2653143078977,0.898857895463142,1.02861527696875,0.813374189495579,1.1000004432022,1.42206728162987,0.792072311108613,0.950441344885744,0.927295963604313,0.717708145461872,0.802279894107659,0.962049407960515,1.27007838695649,1.4157589875571,0.699847721165729,1.58471196913991,0.786492602809332,1.12898927842747,1.27160021739983,0.662952856630289,0.825695363057844,0.727142530840117,0.642660191937992,0.757513129273973,0.701542031074858,0.895821281670155,0.619077001947045,1.0630664428047,4.29166457365573,1.06809985251925,0.724641212138694,0.932058028927103,0.761363459879501,1.16421797313372,0.655327755089639,1.27160021739983,0.869391177468612,0.962098214000553,0.713938665763945,1.29240465297832,1.35646303205178,0.72973128918655,1.35093349608555,1.27247403540234,0.766956310473581,1.23933563849256,1.12175119689176,1.01501844978136,0.709362210014447,0.706173289636165,0.69577367731484,0.847559663112655,0.665907161747982,0.662952856630289,0.664121514756021,0.69388661509974,0.85684625669691,1.36034713137372,1.07614840187534,0.736153362751813,0.962877974960355,4.13835324776803,0.638890181238812,0.626763888783738,0.681225712147006,0.771151231442774,0.864325033486255,2.62602102485566,1.34139863377787,1.10546645346323,0.639696292313271,1.2653143078977,0.825695363057844,0.869391177468612,0.8555835805988,0.746449294516663,1.65920023050255,0.702038826688879,0.807253470920464,0.735861530918023,0.751277774476824,0.641960705801096,0.789361599992211,0.765644388542803,0.66272118622236,0.747246211985534,0.906867480523495,0.848833209855139,0.645291060160842,0.700446795801299,1.08296657210112,0.656587369354757,0.898857895463142,0.8555835805988,0.92214474645947,0.809601152007061,0.862370232715235,0.92106804541266,0.74410082953749,0.839092849385397,1.58976221966619,0.668186590765568,1.1066735332343,0.75063368227263,2.60321967430306,2.97822671932103,1.13138692282956,0.65832200108567,1.45682033176443,0.781552035619564,2.28643044883012,1.02861527696875,0.664121514756021,0.746449294516663,0.857457166262057,0.67056292735172,0.752950759148331,1.59866404750601,1.23445829256661,0.701673205392962,0.608060156173552,1.16021256935377,1.18289717074472,0.87417811332454,1.46399483602508,0.696186032833233,0.701426713815706,0.643015780778362,1.59255287004024,1.90371239306965,0.764899429499152,0.813374189495579,0.727142530840117,0.962098214000553,1.65920023050255,0.92214474645947,0.768275425767166,0.627255565421346,0.602918547029968,1.15078511630228,0.78629989307651,0.671090888754873,0.637911958901117,0.698053882457244,0.741570404992356,0.642660191937992,0.713938665763945,0.69388661509974,0.702038826688879,0.809601152007061,0.768275425767166,0.716247570066059,0.676850842547143,1.02324991651013,0.953543669567751,0.86185705248146,1.02221859886894,0.766956310473581,1.24349023604244,0.939269322853768,0.917184133859794,0.816281765173939,0.65721319680411,0.654583836905783,0.631885429159826,0.838131315925103,0.779710707987034,0.720108921191107,0.982109172674993,1.1000004432022,0.807253470920464,0.862370232715235,0.857457166262057,0.627255565421346,1.36751380745593,1.4768598915857,0.928160400883504,1.08425070264559,0.740183973316051,2.10647517674461,1.23933563849256,0.733896669770577,1.32068398586394,0.624589022999154,0.701542031074858,0.733896669770577,0.624558559114521,0.804196751463576,0.686856444650992,0.706242643501336,0.623346593550617,0.776962511633253,0.67056292735172,0.631091821815602,2.05549945861476,0.838613213903359,0.720050548515195,0.682256944127114,0.952402698516219,0.616918473045963,0.628335704551335,0.710064478990376,0.902543133905148,0.805233888962156,1.42206728162987,0.735861530918023,0.92106804541266,0.752950759148331,0.602918547029968,1.36751380745593,0.631091821815602,0.858872943883652,0.611165899054636,0.665649413353595,0.841318009740337,1.2897227550153,0.826297956612586,0.669783075301592,0.717720941686761,0.901452255325191,0.762498142983219,0.757513129273973,1.29240465297832,0.751277774476824,1.15078511630228,0.716247570066059,1.08408207009545,3.25166102094108,0.635503686473702,0.760787048318593,0.622892189093978,1.06819745239832,1.18695330851489,0.955948530007539,0.609672588983899,0.821590669150638,0.758522219351063,0.982569477580044,0.792072311108613,0.641960705801096,1.59866404750601,0.706333693062254,0.85264885312398,0.838300768501751,0.780591788037889,0.695101064261087,1.4253918256059,1.12175119689176,1.32068398586394,0.723450541222127,0.630424734127577,1.03185603505479,0.827568066697398,1.42942040597487,1.30582777254489,0.941337578333881,0.664699957291161,1.55124649032099,0.64225543207587,0.638876187076685,1.59655358277467,0.950441344885744,0.85684625669691,0.789361599992211,0.74410082953749,1.23445829256661,0.676850842547143,1.4768598915857,0.858872943883652,0.706333693062254,0.621538890814545,0.698665689909551,0.820894880048205,0.691429329686751,0.613590170182513,0.748726357487327,0.648157810595984,0.714158603889173,1.62795151051662,0.727545417884904,0.927295963604313,0.765644388542803,0.701673205392962,0.611165899054636,0.85264885312398]},"nodes":{"name":["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming"],"group":[2,4,4,2,4,4,1,2,2,2,4,4,3,3,3,3,2,2,1,2,1,3,3,2,3,4,3,4,1,1,4,1,2,3,3,2,4,1,1,2,3,2,2,4,1,2,4,2,3,4]},"options":{"NodeID":"ID","Group":"Region","colourScale":"d3.scale.category10()","fontSize":12,"fontFamily":"serif","clickTextSize":30,"linkDistance":50,"linkWidth":"function(d) { return Math.sqrt(d.value); }","charge":-120,"linkColour":"#BFBFBF","opacity":0.8,"zoom":true,"legend":false,"nodesize":false,"radiusCalculation":" Math.sqrt(d.nodesize)+6","bounded":true,"opacityNoHover":0,"clickAction":null}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


#### Understanding Networks
Networks can be investigated in an exploratory fashion or lead to more serious modeling approaches.  The following is a brief list of common statistics or modeling techniques.

##### Centrality 
- **Degree**: how many links a node has
- **Closeness**: how close a node is to other nodes
- **Betweenness**: how often a node serves as a bridge between the shortest path between two other nodes
- **PageRank**: From Google, a measure of node 'importance'
- **Hub**: a measure of the value of a node's links
- **Authority**: another measure of node importance

Characteristics of the network as a whole may also be examined, e.g. degree distribution, 'clusteriness', average path length etc.

##### Cohesion
Investigate how network members create communities and cliques. This is similar to cluster analysis used in other situations.  Some nodes may be isolated.


##### Modeling
- ERGM: exponential random graph models, regression modeling for network data
- Other link analysis

##### Comparison
A goal might be to compare multiple networks to see if they differ in significant ways.

##### Dynamics
While many networks are 'static', many others change over time. One might be interested in this structural change by itself, or modeling something like link loss.


## Nonrecursive Models
Recursive models have all unidirectional causal effects and disturbances are not correlated. A model is considered nonrecursive if there is a reciprocal relationship, feedback loop, or correlated disturbance in the model[^nonrecursiveName]. Nonrecursive models are potentially problematic when there is not enough information to estimate this model (unidentified model).

A classic example of a nonrecursive relationship is marital satisfaction: the more satisfied one partner is, the more satisfied the other, and vice versa. This can be represented by a simple model (below).


<img src="index_files/figure-html/nonRecursive-1.svg" title="" alt="" style="display: block; margin: auto;" />

Such models are notoriously difficult to specify in terms of identification, which we will talk more about later.  For now, we can simply say the above model would not even be estimated as there are more parameters to estimate (two paths, two variances) than there is information in the data (two variances and one covariance).

To make this model identified, one approach is to use what are called <span class="emph">instrumental variables</span>. Instrumental variables directly influence one of the variables in a recursive relationship, but not the other. For example, a wife’s education can influence her satisfaction directly and a husband’s education can influence his satisfaction directly, but a husband’s education cannot directly impact a wife’s satisfaction and vice versa (at least for this demonstration). These instrumental variables can indirectly impact a spouses’ satisfaction (below).  The dashed line represents an unanalyzed correlation.

<img src="index_files/figure-html/nonRecursive2-1.svg" title="" alt="" style="display: block; margin: auto;" />


Many instances of nonrecursive models might better be represented by a correlation.  One must have a very strong theoretical motivation for such models, which is probably why they aren't seen as often in the SEM literature, though they are actually quite common in some areas such as economics.

## Summary
Path analysis in SEM is a form of theoretically motivated graphical model involving only observed variables.  They might include indirect effects and multiple outcomes of interest. However, path analysis is a special case of a more broad set of graphical modeling tools widely used in many disciplines, any of which might be useful for a particular data situation.


## R packages used
- lavaan
- bnlearn
- network









# Latent Variables
Not everything we want to measure comes with an obvious yardstick.  If one wants to measure something like a person's happiness, what would they have at their disposal? 

- Are they smiling?
- Did they just get a pay raise?
- Are they interacting well with others?
- Are they relatively healthy?


Any of these might be useful as an *indicator* of their current state of happiness, but of course none of them would tell us whether they truly are happy or not. At best, they can be considered imperfect measures. If we consider those and other indicators collectively, perhaps we can get an underlying measure of something we might call happiness, contentment, or some other arbitrary but descriptive name.

Despite how they are typically used within psychology, educational and related fields, the use of <span class="emph">latent variable</span> models are actually seen all over, and in ways that may have little to do with what we will be focusing on in this course.  Broadly speaking, <span class='emph'>factor analysis</span> can be seen as a dimension reduction technique, or as an approach to  modeling measurement error and understanding underlying constructs.  We will give some description of the former while focusing on the latter.


## Dimension reduction/Compression

Many times we simply have the goal of taking a whole lot of variables, reducing them to much fewer, but while retaining as much information about the originals as possible.  For example, this is an extremely common goal in areas of image and audio compression.  Statistical techniques amenable to these approaches are commonly referred to as <span class='emph'>matrix factorization</span>.

### Principal components analysis
Probably the most commonly used factor-analytic technique is <span class='emph'>principal components analysis</span> (PCA).  It seeks to extract *components* from a set of variables, with each component containing as much of the original variance as possible.  Components can be seen as a linear combination of the original variables.

PCA works on a covariance/correlation matrix, and it will return as many components as there are variables in the data, each accounting for less variance than the previous component, and summing up to 100% of the total variance in the original data.  With appropriate steps, the components can completely reproduce the original correlation matrix.  However, as the goal is dimension reduction, we only want to retain some of these components, and so the reproduced matrix will not be exact.  This however gives us some sense of a goal to shoot for, and the same idea is also employed in factor analysis/SEM, where we also work with the covariance matrix and prefer models that can closely reproduce the original matrix seen with the observed data.

Visually, we can display PCA as a graphical model. Here is one with four components/variables. The size of the components represents the amount of variance each accounts for.

<div style='text-align:center'>

<!--html_preserve--><div style="width:250px; margin-left:auto;  margin-right:auto">
<div id="htmlwidget-4930" style="width:250px;height:250px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-4930">{"x":{"diagram":"\ndigraph DAG {\n  # Intialization of graph attributes\n  graph [overlap = false]\n\n  # Initialization of node attributes\n  node [shape = circle,\n        fontname = Helvetica,\n        color = gray80,\n        type = box,\n        fixedsize = true]\n\n\n  # Node statements\n  PC3 [width=.75, color=gray80];\n  PC4 [width=.5, color=gray80]; \n  PC1 [width=1.5, color=gray80]; \n  PC2 [width=1.25, color=gray80];    # reordered to deal with unusual ordering otherwise\n  node [width=1, shape=square, color=gray10]\n  I3; I4; I1; I2; \n\n  # Initialization of edge attributes\n  edge [color = gray50, rel = yields]\n\n  # Edge statements\n  edge [arrowhead=none]\n  PC1 -> I1[color=salmon]; PC1 -> I2[color=salmon]; PC1 -> I3[color=salmon]; PC1 -> I4[color=salmon];\n  PC2 -> I1; PC2 -> I2; PC2 -> I3; PC2 -> I4;\n  PC3 -> I1; PC3 -> I2; PC3 -> I3; PC3 -> I4;\n  PC4 -> I1; PC4 -> I2; PC4 -> I3; PC4 -> I4;\n\n  }\n","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

</div>

Let's see an example. The following regards a correlation matrix[^pcafacormat] of 24 psychological tests given to 145 seventh and eight-grade children in a Chicago suburb by Holzinger and Swineford. We'll use the  <span class='pack'>psych</span> package, and to use the <span class="func">principal</span> function, we provide the data (available via the psych package), specify the number of components/factors we want to retain, and other options (in this case, the *rotated* solution will be a little more interpretable[^rotation]).  We will use the <span class="pack">psych</span> package here as it gives us a little more output than standard PCA packages and functions, and one that is more consistent with the factor analysis technique we'll spend time with later.  While we will use lavaan for factor analysis to be consistent with the SEM approach, the psych package is a great tool for standard factor analysis, assessing reliability and other fun stuff.


```r
library(psych)
pc = principal(Harman74.cor$cov, nfactors=4,  rotate='varimax')
pc
```

```
Principal Components Analysis
Call: principal(r = Harman74.cor$cov, nfactors = 4, rotate = "varimax")
Standardized loadings (pattern matrix) based upon correlation matrix
                         PC1   PC3   PC2  PC4   h2   u2 com
VisualPerception        0.16  0.71  0.23 0.14 0.60 0.40 1.4
Cubes                   0.09  0.59  0.08 0.03 0.37 0.63 1.1
PaperFormBoard          0.14  0.66 -0.04 0.11 0.47 0.53 1.2
Flags                   0.25  0.62  0.09 0.03 0.45 0.55 1.4
GeneralInformation      0.79  0.15  0.22 0.11 0.70 0.30 1.3
PargraphComprehension   0.81  0.18  0.07 0.21 0.73 0.27 1.2
SentenceCompletion      0.85  0.15  0.15 0.06 0.77 0.23 1.1
WordClassification      0.64  0.31  0.24 0.11 0.57 0.43 1.8
WordMeaning             0.84  0.16  0.06 0.19 0.78 0.22 1.2
Addition                0.18 -0.13  0.83 0.12 0.76 0.24 1.2
Code                    0.18  0.05  0.63 0.37 0.57 0.43 1.8
CountingDots            0.02  0.17  0.80 0.05 0.67 0.33 1.1
StraightCurvedCapitals  0.18  0.41  0.62 0.03 0.59 0.41 1.9
WordRecognition         0.23 -0.01  0.06 0.68 0.52 0.48 1.2
NumberRecognition       0.12  0.08  0.05 0.67 0.48 0.52 1.1
FigureRecognition       0.06  0.46  0.05 0.58 0.55 0.45 1.9
ObjectNumber            0.14  0.01  0.24 0.68 0.54 0.46 1.4
NumberFigure           -0.02  0.32  0.40 0.50 0.51 0.49 2.7
FigureWord              0.14  0.25  0.20 0.42 0.30 0.70 2.4
Deduction               0.43  0.43  0.09 0.30 0.47 0.53 2.8
NumericalPuzzles        0.18  0.42  0.50 0.17 0.49 0.51 2.5
ProblemReasoning        0.42  0.41  0.13 0.29 0.45 0.55 3.0
SeriesCompletion        0.42  0.52  0.25 0.20 0.55 0.45 2.7
ArithmeticProblems      0.40  0.14  0.55 0.26 0.55 0.45 2.5

                       PC1  PC3  PC2  PC4
SS loadings           4.16 3.31 3.22 2.74
Proportion Var        0.17 0.14 0.13 0.11
Cumulative Var        0.17 0.31 0.45 0.56
Proportion Explained  0.31 0.25 0.24 0.20
Cumulative Proportion 0.31 0.56 0.80 1.00

Mean item complexity =  1.7
Test of the hypothesis that 4 components are sufficient.

The root mean square of the residuals (RMSR) is  0.06 

Fit based upon off diagonal values = 0.97
```

First focus on the last portion of the output where it says **SS loadings** . The first line is the sum of the squared loadings for each  component (in this case where we are using a correlation matrix, summing across all 24 components would equal the value of 24). The **Proportion Var** tells us how much of the overall variance the component accounts for out of all the variables (e.g. 4.16 / 24  =  0.17).  The **Cumulative Var** tells us that all 4 components make up over half the variance. The others are the same thing just based on the four components rather than all 24 variables. We can see that each component accounts for a decreasing amount of variance.

<span class='emph'>Loadings</span> in this scenario represent the estimated correlation of an item with its component, and provide the key way in which we interpret the factors. However, we have a lot of them, and rather than interpret that mess in our output, we'll look at it visually. In the following plot, stronger loadings are indicated by blue, and we can see the different variables associated with different components. 

Interpretation is the fun but commonly difficult part. As an example, we can see PC2 as indicative of mathematical ability, but in general this isn't the cleanest result.

<!--html_preserve--><div style="width:500px; margin-left:auto;  margin-right:auto">
<div id="htmlwidget-1137" style="width:500px;height:500px;" class="d3heatmap html-widget"></div>
<script type="application/json" data-for="htmlwidget-1137">{"x":{"rows":{"members":24,"height":1.18239183981698,"edgePar":{"col":""},"children":[{"members":18,"height":1.01626779366236,"edgePar":{"col":""},"children":[{"members":12,"height":0.900201537678125,"edgePar":{"col":""},"children":[{"members":7,"height":0.465050935615445,"edgePar":{"col":""},"children":[{"members":3,"height":0.203946866724314,"edgePar":{"col":""},"children":[{"members":2,"height":0.0483567340374332,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Deduction","edgePar":{"col":""}},{"members":1,"height":0,"label":"ProblemReasoning","edgePar":{"col":""}}]},{"members":1,"height":0,"label":"SeriesCompletion","edgePar":{"col":""}}]},{"members":4,"height":0.275257300585821,"edgePar":{"col":""},"children":[{"members":3,"height":0.191589178481197,"edgePar":{"col":""},"children":[{"members":2,"height":0.162753280501878,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"Flags","edgePar":{"col":""}},{"members":1,"height":0,"label":"Cubes","edgePar":{"col":""}}]},{"members":1,"height":0,"label":"PaperFormBoard","edgePar":{"col":""}}]},{"members":1,"height":0,"label":"VisualPerception","edgePar":{"col":""}}]}]},{"members":5,"height":0.321317896026218,"edgePar":{"col":""},"children":[{"members":4,"height":0.190348768758455,"edgePar":{"col":""},"children":[{"members":2,"height":0.0419751591533037,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"PargraphComprehension","edgePar":{"col":""}},{"members":1,"height":0,"label":"WordMeaning","edgePar":{"col":""}}]},{"members":2,"height":0.108846501450453,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"GeneralInformation","edgePar":{"col":""}},{"members":1,"height":0,"label":"SentenceCompletion","edgePar":{"col":""}}]}]},{"members":1,"height":0,"label":"WordClassification","edgePar":{"col":""}}]}]},{"members":6,"height":0.567918653696344,"edgePar":{"col":""},"children":[{"members":3,"height":0.394240414712534,"edgePar":{"col":""},"children":[{"members":2,"height":0.271925280387892,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"NumberFigure","edgePar":{"col":""}},{"members":1,"height":0,"label":"FigureWord","edgePar":{"col":""}}]},{"members":1,"height":0,"label":"FigureRecognition","edgePar":{"col":""}}]},{"members":3,"height":0.207982935754437,"edgePar":{"col":""},"children":[{"members":2,"height":0.149036179192612,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"WordRecognition","edgePar":{"col":""}},{"members":1,"height":0,"label":"NumberRecognition","edgePar":{"col":""}}]},{"members":1,"height":0,"label":"ObjectNumber","edgePar":{"col":""}}]}]}]},{"members":6,"height":0.644777202988318,"edgePar":{"col":""},"children":[{"members":4,"height":0.495676382000456,"edgePar":{"col":""},"children":[{"members":2,"height":0.274949340085288,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"ArithmeticProblems","edgePar":{"col":""}},{"members":1,"height":0,"label":"Code","edgePar":{"col":""}}]},{"members":2,"height":0.182465841342998,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"NumericalPuzzles","edgePar":{"col":""}},{"members":1,"height":0,"label":"StraightCurvedCapitals","edgePar":{"col":""}}]}]},{"members":2,"height":0.348670140618959,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"CountingDots","edgePar":{"col":""}},{"members":1,"height":0,"label":"Addition","edgePar":{"col":""}}]}]}]},"cols":{"members":4,"height":2.04935218382895,"edgePar":{"col":""},"children":[{"members":2,"height":1.77847781662787,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"PC4","edgePar":{"col":""}},{"members":1,"height":0,"label":"PC2","edgePar":{"col":""}}]},{"members":2,"height":1.87418928547757,"edgePar":{"col":""},"children":[{"members":1,"height":0,"label":"PC3","edgePar":{"col":""}},{"members":1,"height":0,"label":"PC1","edgePar":{"col":""}}]}]},"matrix":{"data":["0.296","0.089","0.434","0.432","0.291","0.13","0.413","0.416","0.203","0.246","0.525","0.416","0.026","0.089","0.617","0.248","0.029","0.081","0.593","0.087","0.108","-0.042","0.662","0.143","0.142","0.226","0.713","0.157","0.206","0.069","0.178","0.806","0.194","0.056","0.165","0.842","0.112","0.218","0.153","0.786","0.056","0.15","0.15","0.85","0.106","0.239","0.311","0.64","0.495","0.399","0.32","-0.016","0.421","0.197","0.251","0.136","0.582","0.048","0.457","0.061","0.68","0.058","-0.011","0.233","0.674","0.048","0.079","0.116","0.676","0.242","0.01","0.144","0.256","0.549","0.144","0.401","0.367","0.628","0.046","0.184","0.17","0.503","0.42","0.18","0.034","0.624","0.413","0.184","0.053","0.797","0.167","0.018","0.123","0.833","-0.132","0.179"],"dim":[24,4],"rows":["Deduction","ProblemReasoning","SeriesCompletion","Flags","Cubes","PaperFormBoard","VisualPerception","PargraphComprehension","WordMeaning","GeneralInformation","SentenceCompletion","WordClassification","NumberFigure","FigureWord","FigureRecognition","WordRecognition","NumberRecognition","ObjectNumber","ArithmeticProblems","Code","NumericalPuzzles","StraightCurvedCapitals","CountingDots","Addition"],"cols":["PC4","PC2","PC3","PC1"]},"image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAECAYAAACUY/8YAAAAOElEQVQYlWP4/v37/+/fv/9nNUj8z2qQ+J8UPoyNj8+ASwEphuDjMxDrMnSaWEsY0DWjW0hpcAEA2D0pYf0gpNgAAAAASUVORK5CYII=","theme":null,"options":{"xaxis_height":80,"yaxis_width":120,"xaxis_font_size":null,"yaxis_font_size":null,"brush_color":"#0000FF","show_grid":true,"anim_duration":500}},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

Some explanation of the other parts of the output:

- **h2**: the amount of variance in the item explained by the (retained) components. It is the sum of the squared loadings (a.k.a. <span class="emph">communality</span>).
- **u2**: 1 - h2
- **com**: A measure of complexity. A value of 1 might be seen for something that loaded on only one component, and zero otherwise (a.k.a. perfect simple structure)

We can get a quick graphical model display as follows:


```r
## fa.diagram(pc, cex=.5)
```

<!--html_preserve--><div style="width:500px; height:500px; margin-left:auto;  margin-right:auto">
<div id="htmlwidget-6223" style="width:500px;height:500px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-6223">{"x":{"diagram":"digraph Factor  {\n  rankdir=RL;\n  size=\"8,6\";\n  node [fontname=\"Helvetica\" fontsize=14 shape=box, width=2];\n  edge [fontname=\"Helvetica\" fontsize=10];\nV1  [label = \"VisualPerception\"];\nV2  [label = \"Cubes\"];\nV3  [label = \"PaperFormBoard\"];\nV4  [label = \"Flags\"];\nV5  [label = \"GeneralInformation\"];\nV6  [label = \"PargraphComprehension\"];\nV7  [label = \"SentenceCompletion\"];\nV8  [label = \"WordClassification\"];\nV9  [label = \"WordMeaning\"];\nV10  [label = \"Addition\"];\nV11  [label = \"Code\"];\nV12  [label = \"CountingDots\"];\nV13  [label = \"StraightCurvedCapitals\"];\nV14  [label = \"WordRecognition\"];\nV15  [label = \"NumberRecognition\"];\nV16  [label = \"FigureRecognition\"];\nV17  [label = \"ObjectNumber\"];\nV18  [label = \"NumberFigure\"];\nV19  [label = \"FigureWord\"];\nV20  [label = \"Deduction\"];\nV21  [label = \"NumericalPuzzles\"];\nV22  [label = \"ProblemReasoning\"];\nV23  [label = \"SeriesCompletion\"];\nV24  [label = \"ArithmeticProblems\"];\nnode [shape=ellipse, width =\"1\"];\nPC1-> V5 [ label = 0.8 ];\nPC1-> V6 [ label = 0.8 ];\nPC1-> V7 [ label = 0.8 ];\nPC1-> V8 [ label = 0.6 ];\nPC1-> V9 [ label = 0.8 ];\nPC1-> V22 [ label = 0.4 ];\nPC3-> V1 [ label = 0.7 ];\nPC3-> V2 [ label = 0.6 ];\nPC3-> V3 [ label = 0.7 ];\nPC3-> V4 [ label = 0.6 ];\nPC3-> V20 [ label = 0.4 ];\nPC3-> V23 [ label = 0.5 ];\nPC2-> V10 [ label = 0.8 ];\nPC2-> V11 [ label = 0.6 ];\nPC2-> V12 [ label = 0.8 ];\nPC2-> V13 [ label = 0.6 ];\nPC2-> V21 [ label = 0.5 ];\nPC2-> V24 [ label = 0.5 ];\nPC4-> V14 [ label = 0.7 ];\nPC4-> V15 [ label = 0.7 ];\nPC4-> V16 [ label = 0.6 ];\nPC4-> V17 [ label = 0.7 ];\nPC4-> V18 [ label = 0.5 ];\nPC4-> V19 [ label = 0.4 ];\n{ rank=same;\nV1;V2;V3;V4;V5;V6;V7;V8;V9;V10;V11;V12;V13;V14;V15;V16;V17;V18;V19;V20;V21;V22;V23;V24;}{ rank=same;\nPC1;PC3;PC2;PC4;}}<div style=\"width:500px; height:500px; margin-left:auto;  margin-right:auto\">\n  <div id=\"htmlwidget-6093\" style=\"width:500px;height:500px;\" class=\"grViz html-widget\">\u003c/div>\n  <script type=\"application/json\" data-for=\"htmlwidget-6093\">{\"x\":{\"diagram\":\"digraph Factor  {\\n  rankdir=RL;\\n  size=\\\"8,6\\\";\\n  node [fontname=\\\"Helvetica\\\" fontsize=14 shape=box, width=2];\\n  edge [fontname=\\\"Helvetica\\\" fontsize=10];\\nV1  [label = \\\"VisualPerception\\\"];\\nV2  [label = \\\"Cubes\\\"];\\nV3  [label = \\\"PaperFormBoard\\\"];\\nV4  [label = \\\"Flags\\\"];\\nV5  [label = \\\"GeneralInformation\\\"];\\nV6  [label = \\\"PargraphComprehension\\\"];\\nV7  [label = \\\"SentenceCompletion\\\"];\\nV8  [label = \\\"WordClassification\\\"];\\nV9  [label = \\\"WordMeaning\\\"];\\nV10  [label = \\\"Addition\\\"];\\nV11  [label = \\\"Code\\\"];\\nV12  [label = \\\"CountingDots\\\"];\\nV13  [label = \\\"StraightCurvedCapitals\\\"];\\nV14  [label = \\\"WordRecognition\\\"];\\nV15  [label = \\\"NumberRecognition\\\"];\\nV16  [label = \\\"FigureRecognition\\\"];\\nV17  [label = \\\"ObjectNumber\\\"];\\nV18  [label = \\\"NumberFigure\\\"];\\nV19  [label = \\\"FigureWord\\\"];\\nV20  [label = \\\"Deduction\\\"];\\nV21  [label = \\\"NumericalPuzzles\\\"];\\nV22  [label = \\\"ProblemReasoning\\\"];\\nV23  [label = \\\"SeriesCompletion\\\"];\\nV24  [label = \\\"ArithmeticProblems\\\"];\\nnode [shape=ellipse, width =\\\"1\\\"];\\nPC1-> V5 [ label = 0.8 ];\\nPC1-> V6 [ label = 0.8 ];\\nPC1-> V7 [ label = 0.8 ];\\nPC1-> V8 [ label = 0.6 ];\\nPC1-> V9 [ label = 0.8 ];\\nPC1-> V22 [ label = 0.4 ];\\nPC3-> V1 [ label = 0.7 ];\\nPC3-> V2 [ label = 0.6 ];\\nPC3-> V3 [ label = 0.7 ];\\nPC3-> V4 [ label = 0.6 ];\\nPC3-> V20 [ label = 0.4 ];\\nPC3-> V23 [ label = 0.5 ];\\nPC2-> V10 [ label = 0.8 ];\\nPC2-> V11 [ label = 0.6 ];\\nPC2-> V12 [ label = 0.8 ];\\nPC2-> V13 [ label = 0.6 ];\\nPC2-> V21 [ label = 0.5 ];\\nPC2-> V24 [ label = 0.5 ];\\nPC4-> V14 [ label = 0.7 ];\\nPC4-> V15 [ label = 0.7 ];\\nPC4-> V16 [ label = 0.6 ];\\nPC4-> V17 [ label = 0.7 ];\\nPC4-> V18 [ label = 0.5 ];\\nPC4-> V19 [ label = 0.4 ];\\n{ rank=same;\\nV1;V2;V3;V4;V5;V6;V7;V8;V9;V10;V11;V12;V13;V14;V15;V16;V17;V18;V19;V20;V21;V22;V23;V24;}{ rank=same;\\nPC1;PC3;PC2;PC4;}}\",\"config\":{\"engine\":\"dot\",\"options\":null}},\"evals\":[],\"jsHooks\":[]}\u003c/script>\n\u003c/div> \nlavaan (0.5-20) converged normally after  19 iterations\n\n                                                  Used       Total\n  Number of observations                          7183        8985\n\n  Estimator                                         ML\n  Minimum Function Test Statistic                0.000\n  Degrees of freedom                                 0\n  Minimum Function Value               0.0000000000000\n\nParameter Estimates:\n\n  Information                                 Expected\n  Standard Errors                             Standard\n\nLatent Variables:\n                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all\n  depressed =~                                                          \n    FeltDown          1.000                               0.541    0.813\n    BeenHappy        -0.732    0.020  -37.329    0.000   -0.396   -0.609\n    DeprssdLstMnth    0.719    0.019   37.992    0.000    0.388    0.655\n\nVariances:\n                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all\n    FeltDown          0.150    0.007   20.853    0.000    0.150    0.339\n    BeenHappy         0.266    0.006   46.489    0.000    0.266    0.629\n    DeprssdLstMnth    0.201    0.005   41.606    0.000    0.201    0.571\n    depressed         0.292    0.010   30.221    0.000    1.000    1.000\n\n[1] 0.441856","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
</div><!--/html_preserve-->

PCA is probably not the best choice (nor likely, is a 4 factor solution) in this scenario. One of the prime reasons is that this graphical model assumes the observed variables are measured without error.  In addition, the principal components do not correlate with one another, but it seems likely that we would want to allow the latent variables to do so (a different rotation would allow this).  However, if our goal is merely to reduce the 24 items to a few that account for the most variance, this would be a standard technique.


### Other Matrix Factorization Techniques

Before leaving PCA for factor analysis of the sort we'll mostly be concerned with, I'll mention other matrix factorization techniques that might be of use depending on your data situation.

- **SVD**: singular value decomposition. Works on a raw data matrix rather than covariance matrix, and is still a very viable technique that may perform better in a lot of situations relative to fancier latent variable models, and other more recently developed techniques.
- **ICA**: Independent components analysis. Extracts non-normal, independent components. The primary goal is to create independent latent variables.
- **Generalized PCA**: PCA techniques for different types of data, e.g. binary data situations.
- **PC Regression**: combining PCA with regression in one model.
- **NMF**: non-negative matrix factorization. Applied to positive valued matrices, produces positive valued factors. Useful, for example, when dealing with counts.
- **LSI**: Latent Semantic Indexing, an early form of topic modeling.
- Many others.



### Factor Analysis
<span class='emph'>Factor analysis</span> is a general technique for uncovering latent variables within data. While initially one might think it similar to PCA[^factpca], one difference from PCA is that the goal is not to recover maximum variance with each component.    However, we will move beyond factor analysis as a dimension reduction technique (and fully 'exploratory' technique, see below), and instead present it as an approach with a strong theoretical underpinning, and one that can help us assess measurement error, ultimately even leading to regression models utilizing the latent variables themselves.


So let us turn to what are typically called <span class="emph">measurement models</span> within SEM. The underlying model can be thought of as a case in which the observed variables, in some disciplines referred to as *indicators* of the latent construct (also *manifest* variables), are caused by the latent variable. The degree to which the observed variables correlate with one another depends in part on how much of the underlying (presumed) latent variable they reliably measure.  

For each indicator we can think of a regression model as follows, where $\beta_0$ is the intercept and $\lambda$ the regression coefficient that expresses the effect of the latent variable $F$ on the observed variable $X$.

$$X = \beta_0 + \lambda F$$

We will almost always have multiple indicators, and often multiple latent variables.  Some indicators may be associated with multiple factors.

$$\begin{aligned}
X_1 &= \beta_{01} + \lambda_{11} F_1 + \lambda_{21} F_2 \\
X_2 &= \beta_{02} + \lambda_{12} F_1 + \lambda_{22} F_2 \\
X_3 &= \beta_{03} + \lambda_{13} F_1
\end{aligned}$$


It is important to understand this regression model, because many who engage in factor analysis seemingly do not, and often think of it the other way around, where the observed variables cause the latent.  In factor analysis, the $\lambda$ coefficients are called <span class="emph">loadings</span> (as they were in PCA), but are interpreted as any other regression coefficient- a one unit change in the latent variable results in a $\lambda$ change in the observed variable. Most factor models assume that, controlling for the latent variable, the observed variables are independent (recall our previous discussion on conditional independence in graphical models), though this is sometimes relaxed.

#### Exploratory vs. Confirmatory
An unfortunate and unhelpful distinction in some disciplines is that of <span class="emph">exploratory</span> vs. <span class="emph">confirmatory</span> factor analysis (and even exploratory SEM).  In any regression analysis, there is a non-zero correlation between *any* variable and some target variable. We don't include everything for theoretical (and even practical) reasons, which is akin to fixing its coefficient to zero, and here it is no different.  Furthermore, most modeling endeavors could be considered exploratory, regardless of how the model is specified.  As such, this distinction doesn't tell us anything about the model, and is thus unnecessary in my opinion.

As an example, $X_3$ is not modeled by $F_2$, which is the same as fixing the  $\lambda_{23}$ coefficient for $F2$ to 0, but that doesn't tell me whether the model is exploratory or not, and yet that is all the distinction refers to, namely, whether we let all factors load with all indicators or not.  An analysis doesn't suddenly have more theoretical weight, validity etc. due to the paths specified.

### Example

Let's see a factor analysis in action.  The motivating example for this section comes from the National Longitudinal Survey of Youth (1997, NLSY97), which investigates the transition from youth to adulthood. For this example, a series of questions asked to the participants in 2006 pertaining to the government’s role in promoting well-being will be investigated. Questions regarded the government's responsibility for following issues: provide jobs for everyone, keep prices under control, provide health care, provide for elderly, help industry, provide for unemployed, reduce income differences, provide college financial aid, provide decent housing, protect environment.  They have four values 1:4, which range from 'definitely should be' to 'definitely should not be'[^backward]. We'll save this for the exercise.

There are also three items regarding their emotional well-being (depression). How often the person felt down or blue, how often they've been a happy person, and how often they've been depressed in the last month. These are also four point scales and range from 'all of the time' to 'none of the time'. We'll use this here.


```r
# nlsy = foreign::read.dta('data/nlsy97cfa.dta')          # original; not needed
depressed = read.csv('data/nlsy97_depressedNumeric.csv')

library(lavaan)
modelCode = "
  depressed =~ FeltDown + BeenHappy + DepressedLastMonth
"
famod = cfa(modelCode, data=depressed[,-1])   # drop id
summary(famod, standardized=T)
```

```
lavaan (0.5-20) converged normally after  19 iterations

                                                  Used       Total
  Number of observations                          7183        8985

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
  depressed =~                                                          
    FeltDown          1.000                               0.541    0.813
    BeenHappy        -0.732    0.020  -37.329    0.000   -0.396   -0.609
    DeprssdLstMnth    0.719    0.019   37.992    0.000    0.388    0.655

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
    FeltDown          0.150    0.007   20.853    0.000    0.150    0.339
    BeenHappy         0.266    0.006   46.489    0.000    0.266    0.629
    DeprssdLstMnth    0.201    0.005   41.606    0.000    0.201    0.571
    depressed         0.292    0.010   30.221    0.000    1.000    1.000
```

#### Raw results

In a standard measurement model such as this we must *scale the factor* by fixing one of the indicator's loadings to one.  This is done for identification purposes, so that we can estimate the latent variable variance.  Which variable is selected for scaling is arbitrary, but doing so means that the sum of the latent variable variance and the residual variance of the variable whose loading is fixed to one equals the variance of that observed variable[^residualModel].    

<img src="index_files/figure-html/plotFARaw-1.png" title="" alt="" style="display: block; margin: auto;" />


```r
var(depressed$FeltDown, na.rm=T)  # .29 + .15
```

```
[1] 0.441856
```


#### Standardized latent variable
An alternative way to scale the latent variable is to simply fix its variance to one (the Std.lv results). It does not need to be estimated, allowing us to obtain loadings for each observed variable.


#### Standardized latent and observed

With both standardized (Std.all), these loadings represent correlations between the observed and latent variables.  This is the default output in the factor analysis we'd get from non-SEM software (i.e. 'exploratory' FA).  If one is just doing a factor-analytic model, these loadings are typically reported. Standardized coefficients in a CFA are computed by taking the unstandardized coefficient (loading) and multiplying it by the model implied standard deviation of the indicator then dividing by the latent variable’s standard deviation. Otherwise, one can simply use standaridized variables in the analysis, or supply only the correlation matrix.

<img src="index_files/figure-html/plotFAStd-1.png" title="" alt="" style="display: block; margin: auto;" />

If you'd like to peel back the curtain and see maximum likelihood estimation based on the raw (covariance) and standardized (correlation) scales, with a comparison to lavaan output, [click here](https://github.com/mclark--/Miscellaneous-R-Code/blob/master/ModelFitting/cfa_ml.R).


## Constructs and Measurement models

### Scale development

A good use of factor analysis regards scale development.  If we come up with 10 items that reflect some underlying construct, factor analysis can provide a sense of how well the scale is put together.  Recall that in path analysis, residual variance, sometimes called disturbance, reflects both omitted causes as well as measurement error.  In this context, $1-R^2_{item}$ provides a sense of how unreliable the item is.  A perfectly reliable item would have a value of zero.  Strong loadings indicate a strong relationship between the item and the underlying construct.

### Factor Scores

In factor analysis, we can obtain estimated factor scores for each observation, possibly to be used in additional analyses or examined in their own right.  One common way is to simply use the loadings as one would regression weights/coefficients (actually scaled versions of them), and create a 'predicted' factor score as the linear combination of the indicator variables, just as we would in regression.




#### vs. Means/Sums

In many occasions, people reduce the number of variables in a model by using a mean or sum score. These actually reflect an underlying factor analysis where all loadings are fixed to be equal and the residual variance of the observed variables is fixed to zero, i.e. perfect measurement.  If you really think the items reflect a particular construct, you'd probably be better off using a score that comes from a model that doesn't assume perfect measurement.

#### vs. Composites

<span class="emph">Composites</span> scores are what we'd have if we turned the arrows around, and allowed different weights for the different variables, which may not be similar too similar in nature or necessarily correlated (e.g. think of how one might construct a measure of socioeconomic status).  Unlike a simple mean, these would have different weights associated with the items.  PCA is one way one could create such a composite.

<img src="img/composite.png" style="display:block; margin: 0 auto;"></img>




## Some Other Uses of Latent Variables

- **EM algorithm**: A very common technique to estimate model parameters for a variety of model situations, it incorporates a latent variable approach.

- **Item Response Theory**: uses latent variables, especially in test situations (though is much broader), to assess things like item discrimination, student ability etc.

- **Hidden Markov Model**:  A latent variable model approach commonly used for time series.

- **Topic Model**: In the analysis of text, one can discover latent 'topics' based on the frequency of words.



## Summary

Latent variable approaches are a necessary tool to have in your statistical toolbox.  Whether your goal is to compress data or explore underlying constructs, 'factor-analysis' will serve you well.



## R packages used

- psych
- lavaan




# Structural Equation Modeling

Structural equation modeling combines the path analytic and latent variable techniques together to allow for regression models among latent variables.  Any path

## Measurement model
The <span class="emph">measurement model</span> refers to the latent variable models, i.e. factor analysis, and typical practice in SEM is to investigate these separately and first.  The reason is that one wants to make sure that the measurement model holds before going any further with the underlying constructs. For example, for one's sample of data one might detect two latent variables work better for a set of indicators, or might find that some indicators are performing poorly.

## Structural model
The <span class="emph">structural model</span> specifies the relations among latent and observed variables that do not serve as indicators.  It can become quite complex, but at this stage one can lean on what they were exposed to with path analysis, as conceptually we're in the same place, except now some variables may be latent.

## Example
The following model is a classic example from Wheaton et al. (1977), which used longitudinal data to develop a model of the stability of alienation from 1967 to 1971, accounting for socioeconomic status as a covariate. Each of the three factors have two indicator variables, SES in 1966 is measured by education and occupational status in 1966 and alienation in both years is measured by powerlessness and anomia. The structural component of the model hypothesizes that SES in 1966 influences both alienation in 1967 and 1971 and alienation in 1967 influences the same measure in 1971.  We also let the disturbances correlate from one timepoint to the next.


```r
wheaton.model <- '
  # measurement model
    ses     =~ education + sei
    alien67 =~ anomia67 + powerless67
    alien71 =~ anomia71 + powerless71
 
  # structural model
    alien71 ~ aa*alien67 + ses
    alien67 ~ sa*ses
 
  # correlated residuals
    anomia67 ~~ anomia71
    powerless67 ~~ powerless71

  # Indirect effect
    IndirectEffect := sa*aa
'
```
<img src="index_files/figure-html/wheatonPlot-1.png" title="" alt="" style="display: block; margin: auto;" />

The standardized results of the structural model are shown below, and model results below that. In this case, the structural paths are statistically significant, as is the indirect effect specifically.  Higher socioeconomic status is affiliated with less alienation, while there is a notable positive relationship of prior alienation with later alienation.  We are also accounting for roughly 50% of the variance in 1971 alienation.

<img src="index_files/figure-html/wheatonStructural-1.png" title="" alt="" style="display: block; margin: auto;" />


```
lavaan (0.5-20) converged normally after  73 iterations

  Number of observations                           932

  Estimator                                         ML
  Minimum Function Test Statistic                4.735
  Degrees of freedom                                 4
  P-value (Chi-square)                           0.316

Model test baseline model:

  Minimum Function Test Statistic             2133.722
  Degrees of freedom                                15
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       0.999

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)             -15213.274
  Loglikelihood unrestricted model (H1)     -15210.906

  Number of free parameters                         17
  Akaike (AIC)                               30460.548
  Bayesian (BIC)                             30542.783
  Sample-size adjusted Bayesian (BIC)        30488.792

Root Mean Square Error of Approximation:

  RMSEA                                          0.014
  90 Percent Confidence Interval          0.000  0.053
  P-value RMSEA <= 0.05                          0.930

Standardized Root Mean Square Residual:

  SRMR                                           0.007

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)
  ses =~                                              
    education         1.000                           
    sei               5.219    0.422   12.364    0.000
  alien67 =~                                          
    anomia67          1.000                           
    powerless67       0.979    0.062   15.895    0.000
  alien71 =~                                          
    anomia71          1.000                           
    powerless71       0.922    0.059   15.498    0.000

Regressions:
                   Estimate  Std.Err  Z-value  P(>|z|)
  alien71 ~                                           
    alien67   (aa)    0.607    0.051   11.898    0.000
    ses              -0.227    0.052   -4.334    0.000
  alien67 ~                                           
    ses       (sa)   -0.575    0.056  -10.195    0.000

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  anomia67 ~~                                         
    anomia71          1.623    0.314    5.176    0.000
  powerless67 ~~                                      
    powerless71       0.339    0.261    1.298    0.194

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    education         2.801    0.507    5.525    0.000
    sei             264.597   18.126   14.597    0.000
    anomia67          4.731    0.453   10.441    0.000
    powerless67       2.563    0.403    6.359    0.000
    anomia71          4.399    0.515    8.542    0.000
    powerless71       3.070    0.434    7.070    0.000
    ses               6.798    0.649   10.475    0.000
    alien67           4.841    0.467   10.359    0.000
    alien71           4.083    0.404   10.104    0.000

R-Square:
                   Estimate
    education         0.708
    sei               0.412
    anomia67          0.600
    powerless67       0.726
    anomia71          0.649
    powerless71       0.692
    alien67           0.317
    alien71           0.497

Defined Parameters:
                   Estimate  Std.Err  Z-value  P(>|z|)
    IndirectEffect   -0.349    0.041   -8.538    0.000
```

## Issues in SEM

### Identification
Identification generally refers to the problem of finding a unique estimate of the value for each parameter in the model. Consider the following:
$$ a + b = 2$$

There is no way for us to determine a unique solution for $a$ and $b$, e.g. the values of -2 and 4 work just as well as -1052 and 1054 and infinite other combinations.  We can talk about 3 basic scenarios, and the problem generally regards how much information we have (in terms of (co)variances) vs. how many parameters we want to estimate in the model.

- A model which has an equal number of observations (again, in terms of (co)variances) and parameters to estimate would have zero degrees of freedom and is known as a <span class="emph">just identified</span> model. In a just identified model there are no extra degrees of freedom leftover to test model fit. 
- <span class="emph">Underidentified models</span> are models where it is not possible to find a unique estimate for each parameter. These models may have negative degrees of freedom or problematic model structures, and you'll generally know right away there is a problem as whatever software package will note an error, warning, or not provide output.
- <span class="emph">Overidentified models</span> have positive degrees of freedom, meaning there is more than enough pieces of information to estimate each parameter. It is desirable to have overidentified models as it allows us to use other measures of model fit.

Consider the following CFA example in which we try to estimate a latent variable model with only two observed variables, as would be the case in the prior Alienation measurement models if they are examined in isolation. We have only two variances and one covariance to estimate two paths, the latent variable variance and the two residual variances.  By convention, a path is always fixed at 1 to scale the latent variable, but that still leaves us with four parameters to estimate with only three pieces of information, hence the -1 degrees of freedom and other issues in the output.   


```r
modelUnder = 'LV =~ x1 + x2'
modelJust = 'LV =~ x1 + x2 + x3'
underModel = cfa(modelUnder, data=cbind(x1,x2,x3))
```

<img src="index_files/figure-html/identification-1.png" title="" alt="" style="display: block; margin: auto;" />

```r
summary(underModel)
```

```
lavaan (0.5-20) converged normally after  10 iterations

  Number of observations                           100

  Estimator                                         ML
  Minimum Function Test Statistic                   NA
  Degrees of freedom                                -1

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)
  LV =~                                               
    x1                1.000                           
    x2                0.677       NA                  

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    x1                0.409       NA                  
    x2                0.740       NA                  
    LV                0.614       NA                  
```

Now if we had a third variable, we now have six pieces of information to estimate and still seven unknowns. Again though, we usually fix the first loading to 1, so it would be estimated. An alternative approach would be to fix the factor variance to some value (typically 1 to create a standardized latent variable). This will allow us to estimate a unique value for each path.

Even so, this is the *just identified* situation, and so the model runs, but we won't have any fit measures because we can perfectly reproduce the observed correlation matrix.


```r
justModel = cfa(modelJust, data=cbind(x1,x2,x3))
```

<img src="index_files/figure-html/justID-1.png" title="" alt="" style="display: block; margin: auto;" />

```r
summary(justModel, fit=T)
```

```
lavaan (0.5-20) converged normally after  21 iterations

  Number of observations                           100

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               90.742
  Degrees of freedom                                 3
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -388.626
  Loglikelihood unrestricted model (H1)       -388.626

  Number of free parameters                          6
  Akaike (AIC)                                 789.251
  Bayesian (BIC)                               804.882
  Sample-size adjusted Bayesian (BIC)          785.933

Root Mean Square Error of Approximation:

  RMSEA                                          0.000
  90 Percent Confidence Interval          0.000  0.000
  P-value RMSEA <= 0.05                          1.000

Standardized Root Mean Square Residual:

  SRMR                                           0.000

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)
  LV =~                                               
    x1                1.000                           
    x2                1.412    0.281    5.021    0.000
    x3                1.767    0.384    4.605    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    x1                0.728    0.113    6.427    0.000
    x2                0.434    0.113    3.858    0.000
    x3                0.214    0.151    1.422    0.155
    LV                0.294    0.112    2.627    0.009
```

Note that in the full alienation model, we have 6*7/2 = 21 variances and covariances, which provides enough to estimate the parameters of the model.


Determining identification is difficult for any complex model. Necessary conditions include there being model degrees of freedom $\geq 0$, and scaling all latent variables, but they are not sufficient. In general though, it is enough to know conceptually what the issue is and how the information you have relates to what you can estimate.

### Fit
There are many, many measures of model fit for SEM, and none of them will give you a definitive answer as to how your model is doing.  Your assessment, if you use them, is to take a holistic approach to get a global sense of how your model is doing.  Let's look again at the alienation results.


```r
fitMeasures(alienation, c('chisq', 'df', 'pvalue', 'cfi', 'rmsea', 'srmr', 'AIC'))
```

```
    chisq        df    pvalue       cfi     rmsea      srmr       aic 
    4.735     4.000     0.316     1.000     0.014     0.007 30460.548 
```


#### Chi-square test
Conceptually the chi-square test measures the discrepancy between the observed correlations and those implied by the model.  In the [graphical model section](#path-analysis), we actually gave an example of reproducing a correlation from a path analysis. In general, the model goal is to reproduce them as closely as we can.  It compares the fitted model with a (saturated) model that does not have any degrees of freedom. The degrees of freedom for this test are equal to the data (variances + covariances) minus the number of parameters estimated.  A non-significant $\chi^2$ suggests our predictions are not statistically different from those we observe, so yay!


```
  Estimator                                         ML
  Minimum Function Test Statistic                4.735
  Degrees of freedom                                 4
  P-value (Chi-square)                           0.316
```


**Or not**.  Those familiar with null-hypothesis testing know that one cannot accept a null hypothesis, and attempting to do so is fundamentally illogical.    Other things that affect this measure specifically include multivariate non-normality, the size of the correlations (larger ones are typically related to larger predicted vs. observed discrepancies), unreliable measures (can actually make this test fail to reject), and sample size (same as with any other model scenario and statistical significance).

So if it worries you that a core measure of model fit in SEM is fundamentally problematic, good. As has been said before, no single measure will be good enough on its own, so gather as much info as you can.  Some suggest to pay more attention to the $\chi^2$ result, but to me, the flawed logic is something that can't really be overcome.  If you use it with appropriate null hypothesis testing logic, a significant $\chi^2$ test can tell you that something is potentially wrong with the model.


- Note that lavaan also provides a Chi-square test which compares the current model to a model in which all paths are zero, and is essentially akin to the likelihood ratio test we might use in standard model settings (e.g. comparing against an intercept only model).  For that test, we want a statistically significant result.  However, one can specify a prior model conducted with lavaan to test against specifically (i.e. to compare nested models).

#### CFI etc.
The comparative fit index compares the fitted model to a null model that assumes there is no relationship among the measured items. CFI values larger than .9 or especially .95 are desired. Others include the Tucker-Lewis Fit Index, which is provided in standard lavaan output, but there are more <span class="emph">incremental fit indices</span> where those come from.


```
User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       0.999
```


#### RMSEA

The root mean squared error of approximation is a measure that also centers on the model-implied vs. sample covariance matrix, and, all else being equal, is lower for simpler models and larger sample sizes. Look for values less than .05.  Lavaan also provides a one-sided test that the RMSE is $\leq .05$, which ideally would be high, but the confidence interval is enough for reporting purposes.


```
Root Mean Square Error of Approximation:

  RMSEA                                          0.014
  90 Percent Confidence Interval          0.000  0.053
  P-value RMSEA <= 0.05                          0.930

Standardized Root Mean Square Residual:

  SRMR                                           0.007
```


#### SRMR
The standardized root mean squared residual is the mean absolute correlation residual, i.e. the difference between the observed and model-implied correlations. Historical suggestions are to also look for values less than .05, but it is better to simply inspect the residuals and note where there are large discrepancies.


```r
residuals(alienation, type='cor')$cor
```

```
            eductn sei    anom67 pwrl67 anom71 pwrl71
education    0.000                                   
sei          0.000  0.000                            
anomia67     0.007 -0.020  0.000                     
powerless67 -0.006  0.018  0.000  0.000              
anomia71     0.007 -0.017  0.000  0.001  0.000       
powerless71 -0.001  0.001 -0.001  0.000  0.000  0.000
```


#### Fit Summarized

A brief summary of these and other old/typical measures of fit are described [here](https://en.wikipedia.org/wiki/Confirmatory_factor_analysis#Evaluating_model_fit).  However they all have issues, and one should *never* use cutoffs as a basis for your ultimate thinking about model performance.  Studies have been done and all the fit indices have issues in various scenarios, and the cutoffs do not hold up under scrutiny.  While they can provide some assistance in the process, they are not meant to overcome a global assessment of theory-result compatibility.

### Model Comparison

All of the above, while rooted in model comparison approaches, are by themselves only providing information about the fit or lack thereof regarding the current model.  In any modeling situation, SEM or otherwise, a model comparison approach is to be preferred.  Even when we don't have the greatest model, being able to choose among viable options can help science progress.

#### AIC

AIC is a good way to compare models in SEM just as it is elsewhere, where a penalty is imposed on the likelihood based on the number of parameters estimated, i.e. model complexity.  The value by itself is not useful, but the 'better' model will have a lower value. A natural question arises as to how low is low enough to prefer one model over another, but this is impossible to answer because the value of AIC varies greatly with the data and model in question. However, this frees you to know which is 'better', at least in terms of AIC, while still allowing you to consider the merits of the model even so.  If the lower AIC is associated with the simpler model, you'd be hard-pressed to justify not taking it.  

#### BIC

One can probably ignore the BIC in this context. This isn't actually Bayesian, and if you are using a Bayesian approach, WAIC or DIC would be appropriate.  If you aren't using a Bayesian approach, then AIC would likely be preferable in most circumstances.  The BIC has a different penalty than AIC, and is not a measure based on predictive performance, which is what we typically want in model selection.

#### Example

Let's compare the previous model to one without the indirect effect and in which the SES and Alienation contributions are independent (i.e. just made the previous code change to `alien67 ~ 0*ses`).  We'll use the semTools package for easy side by side comparison.





```r
library(semTools)
## compareFit(alienation, alienationNoInd)
```

```
################### Nested Model Comparison #########################
                                chi df      p delta.cfi
alienation - alienationNoInd 200.28  1  <.001    0.0941
```


--------------------------------------------------------------------------------------------
       &nbsp;          chisq   df   pvalue   cfi   tli     aic        bic      rmsea   srmr 
--------------------- ------- ---- -------- ----- ----- ---------- ---------- ------- ------
   **alienation**      4.735   4    .316   .000 .999 30460.548 30542.783  .014  .007 

 **alienationNoInd**  205.017  5     .000   .906  .717  30658.830  30736.227   .207    .173 
--------------------------------------------------------------------------------------------

The first result is a likelihood ratio test. The model with no path is nested within the model with a path and so this is a viable option.  It tells us essentially that adding the indirect path results in a statistically significantly better model. In terms of fit indices, the model including the indirect effect is better.  So now we can say that not only does our model appear to fit the data well, but is better than a plausible competitor.


### Prediction
While the fitted correlation matrix is nice to be able to obtain, it has always struck me a bit odd that one can't even predict the actual data.  Part of this is due to the fact that the models regard the covariance matrix as opposed to the raw data, and that is the focus in many SEM situations. But in path analysis, measurement models, and SEM where mean structures are of focus (e.g. growth curves), it stands to reason that one would like to get predicted values and/or be able to test a model on new data. Even in more complex models, predictions can be made by fixing parameters at estimated values and supplying new data.

Lavaan at least does do this for you, and its <span class="func">lavPredict</span> function allows one to get predicted values for both latent and observed variables, for the current or new data.  There is also a fit index, obtainable through the <span class="func">fitMeasures</span> function, called Expected Value of Cross-Validation Index (or ECVI), also speaks to this notion.  In addition, the <span class="pack">semTools</span> package is a great resource for comparing models, comparing models across groups, simulation and so forth.

### Observed covariates
Just to be clear, SEM doesn't only have to be about structural relations among latent variables.  At any point observed covariates can be introduced to the structural model as well, and this is common practice.  As an example, the alienation model is fundamentally wrong, as it doesn't include many background or other characteristics we'd commonly collect on individuals and which might influence feelings of alienation.


### Interactions
Interactions among both observed and latent variables can be included in SEM, and have the same interpretation as they would in any regression model.  A common term for this in SEM is <span class="emph">moderation</span>.  While, many depictions in SEM suggest that one variable *moderates* another, just like with standard interactions it is arbitrary whether one says A interacts with/moderates B or vice versa, and this fact doesn't change just because we are doing SEM.  For latent variables, one can think of adding a latent variable whose indicator variables consists of product terms of the indicators for the latent variables we want to have an interaction. See <span class="func">indProd</span> and <span class="func">probe2WayMC</span> in the <span class="pack">semTools</span> package.



### Estimation
In everything demonstrated thus far, we have been using standard maximum likelihood to estimate the parameters.  This often may not be the best choice. The following list comes from the Mplus manual, and most of these are available in lavaan.

- **ML**: maximum likelihood parameter estimates with conventional standard errors and chi-square test statistic
- **MLM**: maximum likelihood parameter estimates with standard errors and a mean-adjusted chi-square test statistic that are robust to non-normality. The chi-square test statistic is also referred to as the Satorra-Bentler chi-square.
- **MLMV**: maximum likelihood parameter estimates with standard errors and a mean- and variance-adjusted chi-square test statistic that are robust to non-normality
- **MLR**: maximum likelihood parameter estimates with standard errors and a chi-square test statistic (when applicable) that are robust to non-normality and non-independence of observations when used with TYPE=COMPLEX. The MLR standard errors are computed using a sandwich estimator. The MLR chi-square test statistic is asymptotically equivalent to the Yuan-Bentler T2* test statistic.
- **MLF**: maximum likelihood parameter estimates with standard errors approximated by first-order derivatives and a conventional chi-square test statistic
- **MUML**: Muthén’s limited information parameter estimates, standard errors, and chi-square test statistic
- **WLS**: weighted least square parameter estimates with conventional standard errors and chi-square test statistic that use a full weight matrix. The WLS chi-square test statistic is also referred to as ADF when all outcome variables are continuous.
- **WLSM**: weighted least square parameter estimates using a diagonal weight matrix with standard errors and mean-adjusted chi-square test statistic that use a full weight matrix
- **WLSMV**: weighted least square parameter estimates using a diagonal weight matrix with standard errors and mean- and variance-adjusted chi-square test statistic that use a full weight matrix
- **ULS**: unweighted least squares parameter estimates
- **ULSMV**: unweighted least squares parameter estimates with standard errors and a mean- and variance-adjusted chi-square test statistic that use a full weight matrix
- **GLS**: generalized least square parameter estimates with conventional standard errors and chi-square test statistic that use a normal-theory based weight matrix
- **Bayes**: Bayesian posterior parameter estimates with credibility intervals and posterior predictive checking[^bayesEstimator]


### Missing data

A lot of data of interest in applications of SEM have missing values.  Two common approaches to dealing with this are <span class="emph">Full Information Maximum Likelihood</span> (FIML) and <span class="emph">Multiple Imputation</span> (MI), and both are generally available in SEM packages.  This is far too detailed an issue to treat adequately here, though we can take a moment to describe the approach generally.  FIML uses the available information in the data (think pairwise correlations). MI uses a process to estimate the raw data values, and to adequately account for the uncertainty in those guesses, it creates multiple versions of complete data sets, each with different estimates of the missing values.  The SEM model is run on all of them and estimates combined across all models (e.g. the mean path parameter).  The imputation models, i.e. those used to estimate the missing values, can be any sort of regression model, including using variables not in the SEM model.

In addition, Bayesian approaches can estimate the missing values as additional parameters in the model (in fact, MI is essentially steeped within a Bayesian perspective).  Also there may additional concerns when data is missing over time, i.e. longitudinal dropout.  Using the lavaan package is nice because it comes with FIML, and the semTools package adds MI.

### Other SEM approaches

SEM is very flexible and applicable to a wide variety of modeling situations.  Some of these will be covered in their own module (e.g. mixture models, growth curve modeling).


## How to fool yourself with SEM

Kline's third edition text listed over 50(!) ways in which one could fool themselves with SEM, which speaks to the difficulty  in running SEM and dealing with all of its issues.  I will note a handful of some of them to keep in mind in particular.

### Sample size

If you don't have at least a thousand observations, you will probably only be able to conduct (possibly unrealistically) simple SEM models, or just the measurement models for scale development, or only structural models with only observed variables (path analysis).  Even with simpler modeling situations, one should have several hundred observations.  In the simple alienation model above, we already are dealing with 17 parameters, and it doesn't include any background covariates of the individuals, which is unrealistic.  Furthermore, because it's a mediation model, adding such variables might require additional direct and indirect paths, time-varying covariates that would have effects at both years, etc., and the number of parameters could balloon quite quickly.

One will see many articles of published research with low sample sizes using SEM.  This doesn't make it correct to do so, and one should be highly suspicious of the results suggested in those papers as they are overfit or not including relevant information.

### Poor data

If the correlations among the data are low, one isn't going to magically have strong effects by using SEM.  I have seen many clients running these models and who are surprised that they don't turn out well, when a quick glance at the correlation matrix would have suggested that there wasn't much to work with in the first place. 

### Naming a latent variable doesn't mean it exists

While everything may turn out well for one's measurement model, and the results in keeping with theory, that doesn't make it so.  This is especially so with less reliable measures. Latent constructs require operational definitions and other considerations in order to be useful, and rule out that one isn't simply measuring something else, or that it makes sense that such a construct has real (physical ties).

As an example, many diagnoses in the Diagnostic and Statistical Manual of Mental Disorders have not even been shown to exist via a statistical approach like SEM[^dsm], while others are simply assumed to exist, and even presumably (subsequently) supported by measurement models (often with low N), only to be shown to have no ties to any underlying physiology.

### Ignoring diagnostics

Ignoring residuals, warning messages, etc. is a sure path to trying to interpret nonsensical results.  Look at your residuals, fitted values etc. If your SEM software of choice is giving you messages, find out what they mean, because it may be very important.

### Ignoring performance

As in our previous path analysis example, one can write a paper on a good fitting model with statistically significant results, and not explain any of the target variables. Check things like R-square (and accuracy if binary outputs) when running your models.

## Summary

SEM is a powerful modeling approach that generalizes many other techniques, but it simply cannot be used lightly. Strong theory, strong data, and a lot of data can potentially result in quite interesting models that have a lot to say about the underlying constructs of interest.  Go into it with competing ideas, and realize that your theory is wrong from the outset, even if there is evidence that it isn't way off.


## R packages used
- lavaan
- semTools
- semPlots







# Latent Growth Curves
<span class="emph">Latent growth curve (LGC)</span> models are in a sense, just a different form of the very commonly used mixed model framework.  In some ways they are more flexible, mostly in the standard structural equation modeling framework that allows for indirect, and other complex covariate relationships.  In other ways, they are less flexible (e.g. requiring balanced data, estimating nonlinear relationships, data with many time points, dealing with time-varying covariates).  With appropriate tools there is little one can't do with the normal mixed model approach relative to the SEM approach, and one would likely have easier interpretation.  As such I'd recommend sticking with the standard mixed model framework unless you really need to.

That said, growth curve models are a very popular SEM technique, so it makes sense to become familiar with them. To best understand a growth curve model, I still think it's instructive to see it from the mixed model perspective, where things are mostly interpretable from what you know from a SLiM.


## Random effects
Often data is clustered, e.g. students within schools or observations for individuals over time.  The standard linear model assumes *independent* observations, and in these situations we definitely do not have that.

One very popular way to deal with these are a class of models called <span class="emph">mixed effects models</span>, or simply mixed models.  They are mixed, because there is a mixture of <span class="emph">fixed effects</span> and <span class="emph">random effects</span>.  The fixed effects are the regression coefficients one has in standard modeling approaches.

The *random effects* allow each cluster to have its own unique effect in addition to the overall fixed effect.  This is simply a random deviation, almost always normally distributed in practice, from the overall intercept and slopes.  Mixed models are a balanced approach between ignoring these unique contributions, and over-contextualizing by running separate regressions for every cluster.


## Random Effects in SEM
As we've seen with other models, the latent variables are assumed normally distributed, usually with zero mean, and some estimated variance.  Well so are the random effects in mixed models, and it's through this that we can maybe start to get a sense of random effects as latent variables (or vice versa).  Indeed, mixed models have ties to many other kinds of models (e.g. spatial, additive), because they too add a 'random' component to the model in some fashion.


## Simulating Random Effects
Through simulation we can demonstrate conceptual understanding, and will be well on our way toward better understanding LGC models.  We'll have balanced data with four time-points for 500 individuals (subjects).


```r
set.seed(1234)
n = 500
timepoints = 4
time = rep(0:3, times=n)
subject = rep(1:n, each=4)
```


We'll have 'fixed' effects, i.e. our standard regression intercept and slope, set at .5 and .25 respectively.  We'll allow their associated subject-specific effects to have a slight correlation (.2), and as such we'll draw them from a multivariate normal distribution (variance of 1 for both effects).


```r
intercept = .5
slope = .25
randomEffectsCorr = matrix(c(1,.2,.2,1), ncol=2) 
randomEffects = MASS::mvrnorm(n, mu=c(0,0), Sigma = randomEffectsCorr, empirical=T) %>% 
  data.frame()
colnames(randomEffects) = c('Int', 'Slope')
```

Let's take a look at the data thus far. Note how I'm using subject as a row index.  This will spread out the n random effects to n*timepoints total, while being constant within a subject.


```r
data.frame(Subject=subject, time=time, randomEffects[subject,]) %>% 
  head(20)
```

```
    Subject time        Int      Slope
1         1    0 -1.4774750  0.4536349
1.1       1    1 -1.4774750  0.4536349
1.2       1    2 -1.4774750  0.4536349
1.3       1    3 -1.4774750  0.4536349
2         2    0  0.6390051 -0.9525007
2.1       2    1  0.6390051 -0.9525007
2.2       2    2  0.6390051 -0.9525007
2.3       2    3  0.6390051 -0.9525007
3         3    0  0.7736171  1.1377251
3.1       3    1  0.7736171  1.1377251
3.2       3    2  0.7736171  1.1377251
3.3       3    3  0.7736171  1.1377251
4         4    0 -2.1972780 -1.0066772
4.1       4    1 -2.1972780 -1.0066772
4.2       4    2 -2.1972780 -1.0066772
4.3       4    3 -2.1972780 -1.0066772
5         5    0 -0.1922775  1.8472234
5.1       5    1 -0.1922775  1.8472234
5.2       5    2 -0.1922775  1.8472234
5.3       5    3 -0.1922775  1.8472234
```

Now, to get a target variable, we simply add the random effects for the intercept to the overall intercept, and likewise for the slopes. We'll throw in some noise at the end.


```r
sigma = .5
y1 = (intercept + randomEffects$Int[subject]) + (slope + randomEffects$Slope[subject])*time + rnorm(n*timepoints, mean=0, sd=sigma)

d = data.frame(subject, time, y1)
head(d)
```

```
  subject time         y1
1       1    0 -1.5801417
2       1    1 -0.1231067
3       1    2 -0.3397778
4       1    3  1.4511151
5       2    0  1.4904810
6       2    1 -0.5164371
```

Let's estimate this as a mixed model first[^reml]. See if you can match the parameters from our simulated data to the output.


```r
library(lme4)
mixedModel = lmer(y1 ~ time + (1 + time|subject), data=d)  # 1 represents the intercept
## summary(mixedModel)
```

```
Linear mixed model fit by REML ['lmerMod']
Formula: y1 ~ time + (1 + time | subject)
   Data: d

REML criterion at convergence: 5833.3

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.36211 -0.48276  0.02046  0.47515  2.84524 

Random effects:
 Groups   Name        Variance Std.Dev. Corr
 subject  (Intercept) 0.9999   0.9999       
          time        0.9898   0.9949   0.21
 Residual             0.2382   0.4881       
Number of obs: 2000, groups:  subject, 500

Fixed effects:
            Estimate Std. Error t value
(Intercept)  0.48986    0.04830  10.141
time         0.26400    0.04555   5.796
```

Our fixed effects are the values we set for the overall intercept and slope.  The estimated random effects variances are at 1, the correlation near .2, and finally, our residual standard deviation is near the .5 value we set.

## Running a Growth Curve Model
As before, we'll use lavaan, but now the syntax will look a bit strange compared to what we're used to, because we have to fix the factor loadings to specific values in order to make it work.  This also leads to non-standard output, as there is nothing to estimate for the many fixed parameters.  Furthermore, our data needs to be in wide format, as opposed to the long format we used in the previous mixed model.


```r
head(d)
```

```
  subject time         y1
1       1    0 -1.5801417
2       1    1 -0.1231067
3       1    2 -0.3397778
4       1    3  1.4511151
5       2    0  1.4904810
6       2    1 -0.5164371
```

```r
library(tidyr)
dWide = d %>%  
  spread(time, y1)

# change the names, as usually things don't work well if they start with a number
colnames(dWide)[-1] = paste0('y', 0:3)

model = "
    # intercept and slope with fixed coefficients
    i =~ 1*y0 + 1*y1 + 1*y2 + 1*y3
    s =~ 0*y0 + 1*y1 + 2*y2 + 3*y3
"

growthCurveModel = growth(model, data=dWide)
summary(growthCurveModel)
```

```
lavaan (0.5-20) converged normally after  42 iterations

  Number of observations                           500

  Estimator                                         ML
  Minimum Function Test Statistic               10.616
  Degrees of freedom                                 5
  P-value (Chi-square)                           0.060

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)
  i =~                                                
    y0                1.000                           
    y1                1.000                           
    y2                1.000                           
    y3                1.000                           
  s =~                                                
    y0                0.000                           
    y1                1.000                           
    y2                2.000                           
    y3                3.000                           

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  i ~~                                                
    s                 0.226    0.050    4.512    0.000

Intercepts:
                   Estimate  Std.Err  Z-value  P(>|z|)
    y0                0.000                           
    y1                0.000                           
    y2                0.000                           
    y3                0.000                           
    i                 0.487    0.048   10.072    0.000
    s                 0.267    0.045    5.884    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    y0                0.287    0.041    6.924    0.000
    y1                0.219    0.021   10.501    0.000
    y2                0.185    0.027    6.748    0.000
    y3                0.357    0.065    5.485    0.000
    i                 0.977    0.076   12.882    0.000
    s                 0.969    0.065   14.841    0.000
```

Most of the output is blank, which is needless clutter.  There are only the same five value we are interested in though.

Start with the intercepts:

```{}
Intercepts:
                   Estimate  Std.Err  Z-value  P(>|z|)
                       
    i                 0.487    0.048   10.072    0.000
    s                 0.267    0.045    5.884    0.000
```

It might be odd to call your fixed effects 'intercepts', but it make sense if we are thinking of it as a multilevel model as depicted previously, where we actually broke out the random effects as a separate model. The estimates here are pretty much spot on with our mixed model estimates, which are identical to just the standard regression estimates.


```r
fixef(mixedModel)
```

```
(Intercept)        time 
  0.4898598   0.2640034 
```

```r
lm(y1 ~ time, data=d)
```

```

Call:
lm(formula = y1 ~ time, data = d)

Coefficients:
(Intercept)         time  
     0.4899       0.2640  
```

Now let's look at the variance estimates.  The estimation of residual variance for each y in the LGC distinguishes the two approaches, but not necessarily so.  We could fix them to zero here or allow them to be estimated in the mixed model framework.  Just know that's why the results are not identical (to go along with their respective estimation approaches, which are also different by default).  Again though, the variances are near one, and the correlation between the intercepts and slopes is around the .2 value.

```{}
Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  i ~~                                                
    s                 0.226    0.050    4.512    0.000
Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    y0                0.287    0.041    6.924    0.000
    y1                0.219    0.021   10.501    0.000
    y2                0.185    0.027    6.748    0.000
    y3                0.357    0.065    5.485    0.000
    i                 0.977    0.076   12.882    0.000
    s                 0.969    0.065   14.841    0.000
```


```r
VarCorr(mixedModel)
```

```
 Groups   Name        Std.Dev. Corr 
 subject  (Intercept) 0.99994       
          time        0.99488  0.208
 Residual             0.48806       
```


The differences provide some insight.  LGC by default assumes heterogeneous variance for each time point. Mixed models by default assume the same $\sigma^2$ for each time point, but can allow them to be estimated separately in most modeling packages.

As an example, if we fix the variances to be equal, the models are now identical. 


```r
model = "
    # intercept and slope with fixed coefficients
    i =~ 1*y0 + 1*y1 + 1*y2 + 1*y3
    s =~ 0*y0 + 1*y1 + 2*y2 + 3*y3

    y0 ~~ resvar*y0    
    y1 ~~ resvar*y1
    y2 ~~ resvar*y2
    y3 ~~ resvar*y3
"

growthCurveModel = growth(model, data=dWide)
summary(growthCurveModel)
summary(mixedModel, corr=F)
```

```
lavaan (0.5-20) converged normally after  27 iterations

  Number of observations                           500

  Estimator                                         ML
  Minimum Function Test Statistic               17.105
  Degrees of freedom                                 8
  P-value (Chi-square)                           0.029

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)
  i =~                                                
    y0                1.000                           
    y1                1.000                           
    y2                1.000                           
    y3                1.000                           
  s =~                                                
    y0                0.000                           
    y1                1.000                           
    y2                2.000                           
    y3                3.000                           

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)
  i ~~                                                
    s                 0.207    0.050    4.170    0.000

Intercepts:
                   Estimate  Std.Err  Z-value  P(>|z|)
    y0                0.000                           
    y1                0.000                           
    y2                0.000                           
    y3                0.000                           
    i                 0.490    0.048   10.151    0.000
    s                 0.264    0.046    5.802    0.000

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)
    y0      (rsvr)    0.238    0.011   22.361    0.000
    y1      (rsvr)    0.238    0.011   22.361    0.000
    y2      (rsvr)    0.238    0.011   22.361    0.000
    y3      (rsvr)    0.238    0.011   22.361    0.000
    i                 0.998    0.074   13.478    0.000
    s                 0.988    0.066   15.076    0.000

Linear mixed model fit by REML ['lmerMod']
Formula: y1 ~ time + (1 + time | subject)
   Data: d

REML criterion at convergence: 5833.3

Scaled residuals: 
     Min       1Q   Median       3Q      Max 
-2.36211 -0.48276  0.02046  0.47515  2.84524 

Random effects:
 Groups   Name        Variance Std.Dev. Corr
 subject  (Intercept) 0.9999   0.9999       
          time        0.9898   0.9949   0.21
 Residual             0.2382   0.4881       
Number of obs: 2000, groups:  subject, 500

Fixed effects:
            Estimate Std. Error t value
(Intercept)  0.48986    0.04830  10.141
time         0.26400    0.04555   5.796
```

In addition, the random coefficients estimates from the mixed model perfectly correlate with those of the latent variables.


```r
ranefLatent = data.frame(coef(mixedModel)[[1]], lavPredict(growthCurveModel))
ranefLatent %>% round(2) %>% head
```

```
  X.Intercept.  time     i     s
1        -1.12  0.72 -1.12  0.72
2         0.90 -0.61  0.90 -0.61
3         1.08  1.72  1.08  1.72
4        -1.86 -0.68 -1.86 -0.68
5         0.06  1.94  0.06  1.94
6         0.87  0.24  0.87  0.24
```

```r
ranefLatent %>% cor %>% round(2)
```

```
             X.Intercept. time    i    s
X.Intercept.         1.00 0.29 1.00 0.29
time                 0.29 1.00 0.29 1.00
i                    1.00 0.29 1.00 0.29
s                    0.29 1.00 0.29 1.00
```


Both approaches allow those residuals to covary, though it gets tedious in SEM syntax, while it is a natural extension in the mixed model framework. Here is the syntax for letting each time point covary with the next.


```r
model = "
    # intercept and slope with fixed coefficients
    i =~ 1*y0 + 1*y1 + 1*y2 + 1*y3
    s =~ 0*y0 + 1*y1 + 2*y2 + 3*y3

    # all of the following is needed for what are essentially only two parameters 
    # to estimate- resvar and correlation (the latter defined explicitly here)
    y0 ~~ resvar*y0
    y1 ~~ resvar*y1
    y2 ~~ resvar*y2
    y3 ~~ resvar*y3

    # timepoints 1 step apart
    y0 ~~ a*y1
    y1 ~~ a*y2
    y2 ~~ a*y3
    
    # two steps apart
    y0 ~~ b*y2
    y1 ~~ b*y3
    
    # three steps apart
    y0 ~~ c*y3
    
    # fix parameters according to ar1
    b == a^2
    c == a^3
"
```

```
lavaan (0.5-20) converged normally after 287 iterations

  Number of observations                           500

  Estimator                                         ML
  Minimum Function Test Statistic               14.881
  Degrees of freedom                                 7
  P-value (Chi-square)                           0.038

Parameter Estimates:

  Information                                 Expected
  Standard Errors                             Standard

Latent Variables:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
  i =~                                                                  
    y0                1.000                               0.980    0.884
    y1                1.000                               0.980    0.603
    y2                1.000                               0.980    0.399
    y3                1.000                               0.980    0.291
  s =~                                                                  
    y0                0.000                               0.000    0.000
    y1                1.000                               0.991    0.610
    y2                2.000                               1.983    0.808
    y3                3.000                               2.974    0.882

Covariances:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
  y0 ~~                                                                 
    y1         (a)    0.029    0.021    1.397    0.162    0.029    0.110
  y1 ~~                                                                 
    y2         (a)    0.029    0.021    1.397    0.162    0.029    0.110
  y2 ~~                                                                 
    y3         (a)    0.029    0.021    1.397    0.162    0.029    0.110
  y0 ~~                                                                 
    y2         (b)    0.001    0.001    0.698    0.485    0.001    0.003
  y1 ~~                                                                 
    y3         (b)    0.001    0.001    0.698    0.485    0.001    0.003
  y0 ~~                                                                 
    y3         (c)    0.000    0.000    0.466    0.642    0.000    0.000
  i ~~                                                                  
    s                 0.217    0.051    4.293    0.000    0.223    0.223

Intercepts:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
    y0                0.000                               0.000    0.000
    y1                0.000                               0.000    0.000
    y2                0.000                               0.000    0.000
    y3                0.000                               0.000    0.000
    i                 0.492    0.048   10.195    0.000    0.502    0.502
    s                 0.263    0.046    5.765    0.000    0.265    0.265

Variances:
                   Estimate  Std.Err  Z-value  P(>|z|)   Std.lv  Std.all
    y0      (rsvr)    0.267    0.025   10.714    0.000    0.267    0.218
    y1      (rsvr)    0.267    0.025   10.714    0.000    0.267    0.101
    y2      (rsvr)    0.267    0.025   10.714    0.000    0.267    0.044
    y3      (rsvr)    0.267    0.025   10.714    0.000    0.267    0.024
    i                 0.960    0.079   12.155    0.000    1.000    1.000
    s                 0.983    0.066   14.883    0.000    1.000    1.000

Constraints:
                                               |Slack|
    b - (a^2)                                    0.000
    c - (a^3)                                    0.000
```

```
Linear mixed-effects model fit by maximum likelihood
 Data: d 
       AIC      BIC    logLik
  5836.589 5875.795 -2911.295

Random effects:
 Formula: ~1 + time | subject
 Structure: General positive-definite, Log-Cholesky parametrization
            StdDev    Corr  
(Intercept) 0.9768961 (Intr)
time        0.9907609 0.225 
Residual    0.5215351       

Correlation Structure: AR(1)
 Formula: ~time | subject 
 Parameter estimate(s):
      Phi 
0.1235872 
Fixed effects: y1 ~ time 
                Value  Std.Error   DF   t-value p-value
(Intercept) 0.4918555 0.04827394 1499 10.188841       0
time        0.2628092 0.04559937 1499  5.763439       0
 Correlation: 
     (Intr)
time 0.121 

Standardized Within-Group Residuals:
        Min          Q1         Med          Q3         Max 
-2.29559946 -0.45932855  0.01075219  0.45334542  2.76051403 

Number of Observations: 2000
Number of Groups: 500 
```



## Thinking more generally about regression

In fact, your standard regression is already equipped to handle heterogeneous variances and a specific correlation structure for the residuals. In reality the linear model is the following model:

$$y \sim N(X\beta, \Sigma)$$

$X\beta$ represents the linear predictor, i.e. the linear combination of your predictors, and a big, N by N covariance matrix $\Sigma$.  Thus the target variable $y$ is multivariate normal with mean vector $X\beta$ and covariance $\Sigma$.

SLiMs assume that the covariance matrix is constant diagonal.  A single value on the diagonal, $\sigma^2$, and zeros on the off-diagonals.  Mixed models, however, can allow the covariance structure to be specified in myriad ways, and it ties them to still other models, which in the end produces a very flexible modeling framework.



## More on LGC
### LGC are non-standard SEM
In no other SEM situation do you fix so many parameters or think about your latent variables in this manner.  This can make for difficult interpretations relative to the mixed model (unless you are aware of the parallels).

### Residual correlations
Typical models that would be investigated via the LGC have correlated residuals as depicted above.

### Nonlinear time effect
A nonlinear time effect can be estimated if we don't fix all the parameters for the slope factor. As an example, the following would actually estimate the loadings for times in between the first and last point.


```r
    s =~ 0*y0 + y1 + y2 + 1*y3
```

It may be difficult to assess nonlinear relationships unless one has many time points[^nonlinearfewtimepts], and even then, one might get more with an additive mixed model approach.

### Growth Mixture Models

Adding a latent categorical variable would allow for different trajectories across the latent groups.  Most clients that I've seen typically did not have enough data to support it, as one essentially can be estimating a whole growth model for each group. Some might restrict certain parameters for certain groups, but given that the classes are a latent construct to be discovered, there would not be a theoretical justification to do so, and it would only complicate interpretation at best.  Researchers rarely if ever predict test data, nor provide evidence that the clusters hold up with alternate data.  In addition, it seems that typical interpretation of the classes takes on an ordered structure (e.g. low, medium, and high), which means they just have a coarsely measured continuous latent variable.  Had they started under the assumption of a continuous latent variable, it might have made things easier to interpret and estimate.

As of this writing, Mplus is perhaps the only SEM software used for this, and it requires yet another syntax style, and, depending on the model you run, some of the most confusing output you'll ever see in SEM.  Alternatives in R include <span class="pack">flexmix</span> (demonstrated in the Mixture Models Module) for standard mixture modeling (including mixed effects models), as well as the R package <span class="pack">OpenMx</span>.


### Other covariates

#### Cluster level

To add a cluster level covariate, for a mixed model, it looks something like this:

*standard random intercept*
$$y = b0_c + b1*time + e $$
$$b0_c = b0 + u_c$$   

Plugging in becomes:
$$y = b0 + b1*time + u_c + e $$

*subject level covariate added*
$$b0_c = b0 + sex + u_c$$ 

But if we plug that into our level 1 model, it just becomes:
$$y = b0 + sex + b1*time + u_c + e$$

In our previous modeling syntax it would look like this:

```r
mixedModel = lmer(y1 ~ sex + time + (time|subject), data=d)
```

We'd have a fixed effect for sex and interpret it just like in the standard setting. Similarly, if we had a time-varying covariate, say socioeconomic status, it'd look like the following:

```r
mixedModel = lmer(y1 ~ time + ses + (time|subject), data=d)
```

Though we could have a random slope for SES if we wanted.  You get the picture. Most of the model is still standard regression interpretation.


With LGC, there is a tendency to interpret the model as an SEM, and certainly one can.  But adding additional covariates typically causes confusion for those not familiar with mixed models.  We literally do have to regress the intercept and slope latent variables on cluster level covariates as follows.


```r
model.syntax <- '
  # intercept and slope with fixed coefficients
    i =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
    s =~ 0*y1 + 1*y2 + 2*y3 + 3*y4

  # regressions
    i ~ x1 + x2
    s ~ x1 + x2
'
```

Applied researchers commonly have difficulty on interpreting the model due to past experience with SEM.  While these are latent variables, they aren't *just* latent variables or underlying constructs.  It doesn't help that the output can be confusing, because now one has an 'intercept for your intercepts' and an 'intercept for your slopes'. In the multilevel context it makes sense, but there you know 'intercept' is just 'fixed effect'.



#### Time-varying covariates
With time varying covariates, the syntax starts to get tedious.


```r
model.syntax <- '
  # intercept and slope with fixed coefficients
    i =~ 1*y1 + 1*y2 + 1*y3 + 1*y4
    s =~ 0*y1 + 1*y2 + 2*y3 + 3*y4

  # regressions
    i ~ x1 + x2
    s ~ x1 + x2

  # time-varying covariates
    y1 ~ c1
    y2 ~ c2
    y3 ~ c3
    y4 ~ c4
'
fit <- growth(model.syntax, data=Demo.growth)
summary(fit)
```

Now imagine having just a few of those kinds of variables. In the mixed model framework one would add them in as any covariate in a regression model. In the LGC framework, one has to regress each time point for the target variable on its corresponding predictor time point.  It might take a few paragraphs to explain the coefficients for just a handful of covariates.



## Some Differences between Mixed Models and Growth Curves



### Random slopes

One difference seen in comparing LGC models vs. mixed models is that in the former, random slopes are always assumed, whereas in the latter, one would typically see if it's worth adding random slopes in the first place, or simply not assume them.

### Wide vs. long

The SEM framework is inherently multivariate, and your data will need to be in wide format.  This isn't too big of a deal until you have many time-varying covariates, then the model syntax is tedious and you end up having the number of parameters to estimate climb rapidly. God help you if you want to investigate interactions based on time-varying covariates.

### Sample size

As we have noted before, SEM is inherently a large sample technique.  The mixed model does not require as much for standard approaches, but may require a lot more depending on the model one tries to estimate.

### Number of time points

Mixed models can run even if some clusters have a single value. SEM requires balanced data and so one will always have to estimate missing values or drop them.  Whether this missingness can be ignored in the standard mixed model framework is a matter of some debate in certain circles.

### Time points

Numbering your time from zero makes sense in both worlds.  This leads to the natural interpretation that the intercept is the mean for your first timepoint.


## Other stuff

Here is an example of a parallel process in which we posit two growth curves at the same time, with possible correlations among them. This could be accomplished quite easily with a standard mixed model in the Bayesian framework, with a multivariate response, though I'll have to come back to that later.



```r
# parallel process --------------------------------------------------------

# let's simulate data with a negative slope average and positive correlation among intercepts and other process slopes
set.seed(1234)
n = 500
timepoints = 4
time = rep(0:3, times=n)
subject = rep(1:n, each=4)

# first we'll draw intercepts with overall mean .5 and -.5 for the two
# processes, and let them have a slight correlation. Their variance is 1.
intCorr = matrix(c(1,.2,.2,1), ncol=2) 
colnames(intCorr) = rownames(intCorr) = c('i1', 'i2')
intCorr

interceptP1 = .5
interceptP2 = -.5

ranInts = MASS::mvrnorm(n, mu=c(0,0), Sigma = intCorr, empirical=T)
ranInts = data.frame(ranInts)
head(ranInts)
cor(ranInts)
colMeans(ranInts)

# now create slopes with intercept/mean .4, -.4, but the same positive
# relationship with their respective intercept. Their variances are also 1.
slopeP1 = .4
slopeP2 = -.4

s1 = .3*ranInts$i2  + rnorm(n)
s2 = .3*ranInts$i1  + rnorm(n)

ranef = data.frame(ranInts, s1, s2)
head(ranef)


# so we have slight positive correlations among all random intercepts and slopes
y1 = (interceptP1 + ranef$i1[subject]) + (slopeP1+ranef$s1[subject])*time + rnorm(n*timepoints, sd=.5)
d1 = data.frame(Subject=subject, time=time, y1)
head(d1)

library(ggplot2)
ggplot(aes(x=time, y=y1), data=d1) + 
  geom_line(aes(group=Subject), alpha=.1) + 
  geom_smooth(method='lm',color='red') +
  lazerhawk::theme_trueMinimal()


y2 = (interceptP2 + ranef$i2[subject]) + (slopeP2+ranef$s2[subject])*time + rnorm(n*timepoints, sd=.5)
d2 = data.frame(Subject=subject, time=time, y2)

# process 2 shows the downward overall trend as expected
ggplot(aes(x=time, y=y2), data=d2) + 
  geom_line(aes(group=Subject), alpha=.1) + 
  geom_smooth(method='lm',color='red') +
  lazerhawk::theme_trueMinimal()

# Widen from long form for lavaan
library(tidyr)
negslopepospath1 = d1 %>% spread(time, y1)
colnames(negslopepospath1) = c('Subject', paste0('y1', 1:4))
head(negslopepospath1)

negslopepospath2 = d2 %>% spread(time, y2)
colnames(negslopepospath2) = c('Subject', paste0('y2', 1:4))

# combine
dparallel = dplyr::left_join(negslopepospath1, negslopepospath2)
head(dparallel)

mainModel = "
i1 =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
s1 =~ 0*y11 + 1*y12 + 2*y13 + 3*y14


i2 =~ 1*y21 + 1*y22 + 1*y23 + 1*y24
s2 =~ 0*y21 + 1*y22 + 2*y23 + 3*y24

s1 ~ i2
s2 ~ i1
"

library(lavaan)
mainRes  = growth(mainModel, data=dparallel)
summary(mainRes)
fscores = lavPredict(mainRes)
broom::tidy(data.frame(fscores))
lm(s2~., fscores)

lazerhawk::corrheat(cor(fscores))
qplot(s1, i2, data=data.frame(fscores)) + geom_smooth(method='lm', se=F)
fv = lavPredict(mainRes, 'ov')
summary(mainRes, stdv)
d3heatmap::d3heatmap(cor(fv, fscores))
d3heatmap::d3heatmap(cor(select(dparallel, -Subject), ranef), Rowv = F, Colv = F)


process1Model = "
i1 =~ 1*y11 + 1*y12 + 1*y13 + 1*y14
s1 =~ 0*y11 + 1*y12 + 2*y13 + 3*y14
"
p1Res = growth(process1Model, data=dparallel)
fscoresP1 = lavPredict(p1Res)

process2Model = "
i2 =~ 1*y21 + 1*y22 + 1*y23 + 1*y24
s2 =~ 0*y21 + 1*y22 + 2*y23 + 3*y24
"
p2Res = growth(process2Model, data=dparallel)
fscoresP2 = lavPredict(p2Res)

fscoresSeparate = data.frame(fscoresP1, fscoresP2)

pathMod = "
s1 ~ i2
s2 ~ i1

i1~~i2
"

pathModRes = sem(pathMod, data=fscoresSeparate, fixed.x = F)
summary(pathModRes)  # you'd have come to the same conclusions
summary(mainRes)
```


## Summary

Growth curve modeling is an alternate way to do what is very commonly accomplished through mixed models, and allow for more complex models than typically seen for standard mixed models.  One's default should probably be to use the more common, and probably more flexible (in most situations), mixed modeling tools. However, the latent variable approach may provide what you need, and at the very least gives you a fresh take on the standard mixed model perspective.






# Mixture Models

Thus far we have understood latent variables as possessing an underlying continuum, i.e. normally distributed with a mean of zero and some variance.  This does not have to be the case, and instead we can posit a categorical variable.  Some approaches you may in fact be already familiar with, as any modeling process under the heading of 'cluster analysis' could be said to deal with latent categorical variables.  The issue is that we may feel that there is some underlying structure to the data that is described as discrete, and based on perhaps multiple variables.  

We will approach this in the way that has been done from statistical and related motivations, rather than the SEM/psychometric approach.  This will make clearer what it is we're dealing with as well as not get bogged down in terminology.  Furthermore, mixture models are typically poorly implemented within SEM, as many of the typical issues can often be magnified.  The goal here as before is clarity of thought over 'being able to run it'.  

A common question in such analysis is *how many clusters*?  There are many, many techniques for answering this question, and not a single one of them even remotely definitive.  On the plus side, the good news is that we already know the answer, because the answer is always 1.  However, that won't stop us from trying to discover more than that, so here we go.


## A Motivating Example
Take a look at the following data. It regards the waiting time between eruptions and the duration of the eruption (both in minutes) for the Old Faithful geyser in Yellowstone National Park, Wyoming, USA.


```r
library(ggplot2)
data("faithful")
```

<img src="index_files/figure-html/unnamed-chunk-15-1.png" title="" alt="" style="display: block; margin: auto;" />

Take a good look.  This is probably the cleanest separation of clustered data you will likely ever see, and even so there are still data points that might fall into either cluster.

## Create Clustered Data
To get a sense of mixture models, let's actually create some data that might look like the Old Faithful data above. In the following we create something that will look like the eruptions variable in the faithful data. To do so, we draw one random sample from a normal distribution with a mean of 2, and the other with a mean of 4.5, and both get a standard deviation of .25.  The first plot is based on the code below, the second on the actual data.


```r
library(ggplot2)
set.seed(1234)
erupt1 = rnorm(150, mean=2, sd=.25)
erupt2 = rnorm(150, mean=4.5, sd=.25)
erupt = sample(c(erupt1, erupt2))
```

<img src="index_files/figure-html/simFaithful-1.png" title="" alt="" style="display: block; margin: auto;" /><img src="index_files/figure-html/simFaithful-2.png" title="" alt="" style="display: block; margin: auto;" />

What do we have and what do we see?  The data is a *mixture* of two normals, but we can think of the observations as belonging to a latent class, and each class has its own mean and standard deviation (and is based on a normal, but doesn't have to be).  Each observation has some likelihood, however great or small, of coming from either cluster, and had we really wanted to do more appropriate simulation, we would incorporate that information.

A basic approach for categorical latent variable analysis from a model based perspective[^cluster]:

1. Posit the number of clusters you believe there to be
2. For each observation, estimate those probability of coming from either cluster
3. Assign observations to the most likely class (i.e. the one with the highest probability).

More advanced approaches might include:

- Predicting the latent classes in a manner akin to logistic regression
- Allow your model coefficients to vary based on cluster membership
    - For example, have separate regression models for each class


## Mixture modeling with Old Faithful
The following uses the <span class="pack">flexmix</span>  package and function to estimate a regression model per class.  In this case, our model includes only an intercept, and so is equivalent to estimating the mean and variance of each group.  We posit `k=2` groups.

We can see from the summary about 2/3 are classified to one group. We also get the estimated means and standard deviations for each group.  Note that the group labels are completely arbitrary.


```r
library(flexmix)
mod = flexmix(eruptions~1,  data=faithful, k = 2)
summary(mod)
```

```

Call:
flexmix(formula = eruptions ~ 1, data = faithful, k = 2)

       prior size post>0 ratio
Comp.1 0.652  177    190 0.932
Comp.2 0.348   95     98 0.969

'log Lik.' -276.3611 (df=5)
AIC: 562.7222   BIC: 580.7512 
```

```r
head(mod@posterior$scaled, 10) %>% round(4)  # show some estimated probabilities
```

```
        [,1]   [,2]
 [1,] 1.0000 0.0000
 [2,] 0.0000 1.0000
 [3,] 1.0000 0.0000
 [4,] 0.0001 0.9999
 [5,] 1.0000 0.0000
 [6,] 0.8384 0.1616
 [7,] 1.0000 0.0000
 [8,] 1.0000 0.0000
 [9,] 0.0000 1.0000
[10,] 1.0000 0.0000
```

```r
parameters(mod)    #means and std dev for each group
```

```
                    Comp.1    Comp.2
coef.(Intercept) 4.2735128 2.0187913
sigma            0.4376169 0.2363539
```


The first plot shows the estimated probabilities for each observation for one of the clusters (with some jitter), which in this case are all around 0 or 1.  Again, you will probably never see anything like this, but clarity is useful here.  The second plot shows the original data with their classification and contours of the density for each group.

<img src="index_files/figure-html/unnamed-chunk-16-1.png" title="" alt="" style="display: block; margin: auto;" /><img src="index_files/figure-html/unnamed-chunk-16-2.png" title="" alt="" style="display: block; margin: auto;" />



## SEM and Latent Categorical Variables

Dealing with categorical latent variables can be somewhat problematic. Interpreting one SEM model might be difficult enough, but then one might be allowing parts of it to change depending on which latent class observations belong to, while having to assess the latent class measurement model as well.  It can be difficult to find a clarity of understanding from this process, as one is discovering classes then immediately assuming key differences among these classes they didn't know existed beforehand[^latclass].  In addition, one will need even more data than standard SEM to deal with all the additional parameters that are allowed to vary across the classes.  

Researchers also tend to find classes that represent 'hi-lo' or 'hi-med-lo' groups, which may suggest they should have left the latent construct as a continuous variable. When given the choice to discretize continuous variables in normal settings, it is rare in which the answer is anything but a resounding *no*.  As such, one should think hard about the ultimate goals of such a model.  

### Terminology in SEM

<span class="emph">Latent Class Analysis</span> refers to dealing with categorical latent variables in the context of multivariate categorical data.  For example one might have a series of yes/no questions on a survey, and want to discover categories of responses.

<span class="emph">Latent Profile Analysis</span> refers to dealing with categorical latent variables in the context of multivariate numerical data. 

### Latent Categories vs. Multigroup Analysis

The primary difference between the two is that one grouping structure actually exists in the data, for example, sex, race etc. In that case, a <span class="emph">multigroup analysis</span> would allow for separate SEM models per group.  In the latent categorical variable situation, one must first discover the latent groups. In multigroup analysis, a common goal is to test <span class="emph">measurement invariance</span>, a concept which has several definitions itself.  An example would be to see if the latent structure holds for an American vs. foreign sample, with the same items for the scale provided in the respective languages. This makes a lot of sense from a measurement model perspective and has some obvious use.

If one wants to see a similar situation for a less practically driven model, e.g. to see if an SEM model is the same for males vs. females, this is equivalent to having an interaction with the sex variable for every path in the model.  The same holds for 'subgroup analysis' in typical settings, where you won't find any more than you would by including the interactions of interest with the whole sample, though you will certainly have less data to work with.  In any case, we need a lot of data to compare separate models where parameters are allowed to vary by group vs. a model in which they are fixed, and many simply do not have enough data for this.

### Latent Trajectories

As noted in the growth curve modeling section, these are growth curve models in which intercepts and slopes are allowed to vary across latent groups as well as the clusters.  The flexmix package used previously would allow one to estimate such models from the mixed model perspective, and might be preferred.

### Estimation

If you would like to see the conceptual innards of estimating mixture models using <span class="emph">EM Algorithm</span>, see [this link](https://github.com/mclark--/Miscellaneous-R-Code/tree/master/ModelFitting/EM%20Examples) on my github page.


## R packages used
- <span class="pack">flexmix</span>
    


# Other

## Other topics that may be covered in varying detail in the future. With packages noted.

- IRT
    - ltm or lavaan
- Multiple group analysis
    - lavaan
- Multilevel SEM
- Collaborative filtering
    - recommenderlab
- HMM, Linear Dynamical Systems
    - HMM, HiddenMarkov depmixS4
- Others





# Excercises
## Path Analysis
### Part 1

This exercise investigates satisfaction in high school seniors using the 1993 Monitoring the Future dataset (mtfdata.dta). Perform a path analysis on the four measured variables: self-esteem (esteem), overall life satisfaction (overall), locus of control (locus), and loneliness (lonely). Estimate the following model using lavaan (note that the dashed line is an 'unanalyzed' correlation and doesn't need to be explicit in the model).

<br>



<img src="index_files/figure-html/pa1-1.png" title="" alt="" style="display: block; margin: auto;" />



```r
mtf = read.csv('data/monitorfuture.csv')
satistifaction_ModelCode = ''
satistifaction_ModelResults = sem(satistifaction_ModelCode, data=mtf)
summary(satistifaction_ModelResults, rsquare=T)

# to visualize
library(semPlot)
semPaths(satistifaction_ModelResults, whatLabels='est', style='lisrel', rotation=2)

# or color based on direction, fade with size, using standardized estimates
semPaths(satistifaction_ModelResults, what='std', style='lisrel', rotation=2)
```


<br>

Questions:

1. What are the positive effects in this model?

2. What are the negative effects in this model?

3. What is your initial impression about model performance?

4. What specifically are the R^2^ values for the endogenous variables?


### Part 2

Rerun with the following model (click to show).

<br>


```r
satistifaction_ModelCode = '
  overall ~ c*esteem + lonely
  esteem ~ a*locus + b*lonely

  # Indirect effects
  locusOverall := a*c
  lonelyOverall := b*c
'
```

<br>

Regarding this mediation model... 

  - A. Is the indirect effect loneliness statistically significant? 
  - B. How about locus of control?
  - C. Do you think loneliness causes self-esteem (more lonely, less self-esteem), or vice versa, or perhaps they are simply correlated?



<br><br><br>

## Factor Analysis

### Part 1

Data: National Longitudinal Survey of Youth (1997, NLSY97), which investigates the transition from youth to adulthood. For this example, a series of questions asked to the participants in 2006 pertaining to the government’s role in promoting well-being will be investigated. Questions regarded the government's responsibility for following issues: provide jobs for everyone, keep prices under control, provide health care, provide for elderly, help industry, provide for unemployed, reduce income differences, provide college financial aid, provide decent housing, protect environment.  They have four values 1:4, which range from 'definitely should be' to 'definitely should not be'(note[^backward]).


1. Run a factor analysis using the 'nlsy97_governmentNumeric' dataset.  Your first model will have all items (sans ID) loading on a single factor.  With <span class="pack">lavaan</span>, use the <span class="func">cfa</span> function.  Recall that you give it the model code (as a <span class="objclass">string</span>) and a `data = ` argument like `cfa(mod, data=mydata)`.


```r
govtInvolvement = read.csv('data/nlsy97_governmentNumeric.csv')
govtInvolvement_ModelCode = ''
govtInvolvement_Results = sem(govtInvolvement_ModelCode, sample.cov=marshCov, sample.nobs=385)
summary(govtInvolvement_Results, standardized=T, fit=T)
```


2. Note the standardized loadings, are the items 'hanging together' well?  Do you see any that might be we somewhat weak?

### Part 2

3. Now specify a two factor structure of your choosing. As an example, some of these are maybe more economic in nature, while others might fit in some other category.  Whatever makes sense to you, or just randomly split it.

4. Does this seem any more interpretable?  Were the latent variables notably correlated? Which model would you say is better based on internal performance, in terms of comparison (e.g. lower AIC = preferred model), and in terms of interpretability?


Click to show example (after you've tried yourself).
<br>


```r
library(lavaan)
govtInvolvement = read.csv('data/nlsy97_governmentNumeric.csv')

govtInvolvement_ModelCode1 = "
  moregovt =~ ProvideJobs + Prices + HealthCare + Elderly + Industry + Unemployed + IncInequal + College + Housing + Environment
"
model1 = cfa(govtInvolvement_ModelCode1, data=govtInvolvement) 
summary(model1, fit=T, standardized=T)

govtInvolvement_ModelCode2 = '
  econ =~ ProvideJobs + Industry + Unemployed + IncInequal + Housing + Prices
  services =~ HealthCare + Elderly + College + Environment
'
model2 = cfa(govtInvolvement_ModelCode2, data=govtInvolvement) 
summary(model2, fit=T, standardized=T)

# Compare the two († means the better result)
semTools::compareFit(model1, model2, nested=F)
```


<br><br><br>

## SEM

You get the choice of doing exercise 1 or 2.

### Exercise 1
The data for this exercise comes from a paper published by Marsh and Hocevar in 1985. The data regards information on 385 fourth and fifth grade students who filled out a ‘Self-Description Questionnaire.’ The questionnaire has 16 items, four of which measure physical ability, four measure physical appearance, four measure relations with peers and the final four measure relations with parents. The data is saved in the file ‘Marsh85.dta’ as summary data with means, standard deviations and correlations.  However you will just use 'Marsh85_SEMExercise.csv', which is the covariance matrix.

We are interested in determining how a student’s physical appearance and physical ability might predict relationships with their peers. The diagram for the model of interest is shown below.

<br><br><br>

<img src="index_files/figure-html/sem1-1.png" title="" alt="" style="display: block; margin: auto;" />

<br><br><br>

The following will get you started. All you need to do is fill in the model code. Rather than raw data, we will be using the sample covariance matrix with sample size equal to 385. Note how you can detect the structure visually.  Physical ability hangs together well and is positively correlated with the other factors, which are more strongly correlated with each other.  This is extremely important in factor analysis and SEM, as they deal with the correlation matrix, you should often be able to see the structure before modeling even begins.

<br><br><br>

<img src="index_files/figure-html/corplot-1.png" title="" alt="" style="display: block; margin: auto;" />

<br><br><br>


```r
marsh85 = read.csv('data/Marsh85_SEMExercise.csv', row.names = 1)
marsh85 = as.matrix(marsh85)
peerRel_ModelCode = ''
peerRel_Results = sem(peerRel_ModelCode, sample.cov=marsh85, sample.nobs=385)
summary(peerRel_Results, standardized=T, fit=T, rsquare=T)
```

<br><br>

> Write a brief summary in terms of an assessment of the measurement components of the model, overall impression of model fit, and specifics of the structural relations (i.e. the paths among the latent variables) and model performance in terms of R^2^.

### Exercise 2
In this second example, we will use the classic Political Democracy dataset used by Bollen in his seminal 1989 book on structural equation modeling. This data set includes four measures of democracy at two points in time, 1960 and 1965, and three measures of industrialization in 1960, for 75 developing countries.

- FoPress60: freedom of the press, 1960
- FoPopp60: freedom of political opposition, 1960
- FairElect60: fairness of elections, 1960
- EffectiveLeg60: effectiveness of elected legislature, 1960
- FoPress65: freedom of the press, 1965
- FoPopp65: freedom of political opposition, 1965
- FairElect65: fairness of elections, 1965
- EffectiveLeg65: effectiveness of elected legislature, 1965
- GNP60: GNP per capita, 1960
- EnConsump60: energy consumption per capita, 1960
- PercLaborForce60: percentage of labor force in industry, 1960

The model we wish to estimate is in according to the following diagram.

<br><br>

<img src="index_files/figure-html/sem2-1.png" title="" alt="" style="display: block; margin: auto;" />

<br><br><br>



<br><br>

Here is some starter code. All you need to do is fill in the model code.

<br><br>


```r
poldem = read.csv('data/PoliticalDemocracy.csv')
poldem_ModelCode = ''
poldem_Results = sem(poldem_ModelCode, data=poldem)
summary(poldem_Results, standardized=T, fit=T, rsquare=T)
```


<br><br>

> Write a brief summary in terms of an assessment of the measurement components of the model, overall impression of model fit, and specifics of the structural relations (i.e. the paths among the latent variables) and model performance in terms of R^2^.


## Growth Curve/Mixed Model

Forthcoming.
 



# Appendix

## Data set descriptions

### McClelland 

#### Description

- McClelland et al. (2013) abstract 
> This study examined relations between children's attention span-persistence in preschool and later school achievement and college completion. Children were drawn from the Colorado Adoption Project using adopted and non-adopted children (N = 430). Results of structural equation modeling indicated that children's age 4 attention span-persistence significantly predicted math and reading achievement at age 21 after controlling for achievement levels at age 7, adopted status, child vocabulary skills, gender, and maternal education level. Relations between attention span-persistence and later achievement were not fully mediated by age 7 achievement levels. Logistic regressions also revealed that age 4 attention span-persistence skills significantly predicted the odds of completing college by age 25. The majority of this relationship was direct and was not significantly mediated by math or reading skills at age 7 or age 21. Specifically, children who were rated one standard deviation higher on attention span-persistence at age 4 had 48.7% greater odds of completing college by age 25. Discussion focuses on the importance of children's early attention span-persistence for later school achievement and educational attainment.

#### Reference

McClelland, Acock, Piccinin, Rheac, Stallings. (2013). Relations between preschool attention span-persistence and age 25 educational outcomes. [link](http://www.sciencedirect.com/science/article/pii/S0885200612000762)



### National Longitudinal Survey of Youth (1997, NLSY97)

#### Description

NLSY97 consists of a nationally representative sample of approximately 9,000 youths who were 12 to 16 years old as of December 31, 1996. Round 1 of the survey took place in 1997. In that round, both the eligible youth and one of that youth's parents received hour-long personal interviews. In addition, during the screening process, an extensive two-part questionnaire was administered that listed and gathered demographic information on members of the youth's household and on his or her immediate family members living elsewhere. Youths are interviewed on an annual basis. 

The NLSY97 is designed to document the transition from school to work and into adulthood. It collects extensive information about youths' labor market behavior and educational experiences over time. Employment information focuses on two types of jobs, "employee" jobs where youths work for a particular employer, and "freelance" jobs such as lawn mowing and babysitting. These distinctions will enable researchers to study effects of very early employment among youths. Employment data include start and stop dates of jobs, occupation, industry, hours, earnings, job search, and benefits. Measures of work experience, tenure with an employer, and employer transitions can also be obtained. Educational data include youths' schooling history, performance on standardized tests, course of study, the timing and types of degrees, and a detailed account of progression through post-secondary schooling.

#### Reference

[Bureau of Labor Statistics](http://www.bls.gov/nls/nlsy97.htm)


### Wheaton 1977 data 

#### Description

> Longitudinal data to develop a model of the stability of alienation from 1967 to 1971, accounting for socioeconomic status as a covariate. Each of the three factors have two indicator variables, SES in 1966 is measured by education and occupational status in 1966 and alienation in both years is measured by powerlessness and anomia.

#### Reference

Wheaton, B., Muthen B., Alwin, D., & Summers, G., 1977, "Assessing reliability and stability in panel models", in D. R. Heise (Ed.), _Sociological Methodology 1977_ (pp. 84-136), San Francisco: Jossey-Bass, Inc. 


### Old Faithful

#### From the R helpfile

Waiting time between eruptions and the duration of the eruption for the Old Faithful geyser in Yellowstone National Park, Wyoming, USA. A closer look at faithful$eruptions reveals that these are heavily rounded times originally in seconds, where multiples of 5 are more frequent than expected under non-human measurement. For a better version of the eruption times, see the example below.

There are many versions of this dataset around: Azzalini and Bowman (1990) use a more complete version.

### Harman 1974

#### Description

A correlation matrix of 24 psychological tests given to 145 seventh and eight-grade children in a Chicago suburb by Holzinger and Swineford.

#### Reference

Harman, H. H. (1976) Modern Factor Analysis, Third Edition Revised, University of Chicago Press, Table 7.4.




## Terminology in SEM

SEM as it is known has been widely used in psychology and education for decades, while other disciplines have developed and advanced techniques that are related, but would not typically call them SEM.  The following will be expanded over time.

**Exploratory vs. Confirmatory**: This distinction is problematic.  Science and data analysis is inherently exploratory, and most who use SEM do some model exploration as they would with any other model.  Some SEM models have more constraints than others, but that does not require a separate name or way of thinking about the model.

**Mediation** and moderation:  These mean different things, both straightforward except in the SEM literature.

- Mediation: an indirect effect, e.g. A->B->C, A has an indirect effect on C. A can have a direct on C too. 
- Moderation:outside of SEM calls this refers to an interaction (the same ones utilized in a standard regression modeling)

**Fit**: Model fit is something very difficult to ascertain in SEM, and notoriously problematic in this setting, where all proposed cutoffs for a good fit are ultimately arbitrary.  Even if one had most fit indices suggesting a 'good' fit, there's little indication the model has predictive capability.

**Endo/Exogenous**: Endogenous variables are determined by other variables, exogenous variables have no analyzed causes.

**Disturbance**: residual variance. Includes measurement error and unknown causes.

**Mixture Models**: models using categorical latent variables.

## Resources

This list serves only as a starting point, though may be added to over time.

### Graphical Models
[UseR Series](http://link.springer.com/bookseries/6991): Contains texts on graphical models, Bayesian networks, and network analysis.

### Measurement Models
[Personality Project](http://personality-project.org/index.html): William Revelle's website and text on psychometric theory.

### SEM
Kline, Rex. *Principles and Practice of Structural Equation Modeling*. A very applied introduction.
Beaujean, A. A. (2014). [Latent variable modeling using R: A step by step guide](http://blogs.baylor.edu/rlatentvariable/). New York, NY: Routledge/Taylor and Francis. Lavaan based guide to SEM

### lavaan
[lavaan website](http://lavaan.ugent.be/)
[Tutorial](http://lavaan.ugent.be/tutorial/tutorial.pdf) 
[Bayesian estimation with lavaan](https://cran.r-project.org/package=blavaan)
[Complex surveys with lavaan](https://cran.r-project.org/package=lavaan.survey)
[Interactive lavaan](https://github.com/kylehamilton/lavaan.shiny)

### Other SEM
[semTools]: Excellent set of tools for reliability assessment, measurement invariance, fit, simulation etc.
[semPlot]: Visualize your lavaan models.
    
[^pathOld]: Sewall Wright first used path analysis almost 100 years ago.
[^backward]: For your own sake, if you develop a questionnaire, make values correspond to higher values meaning 'more of' something, rather than in this backward fashion.
[^factpca]: One version of factor analysis is nearly identical to PCA in terms of mechanics, save for what are on the diagonals of the correlation matrix (1s vs. 'communalities').
[^oldMediation]: In the past people would run separate regressions to estimate mediation models, particularly for the most simple, three variable case. One paper that for whatever reason will not stop being cited is Baron & Kenny 1986.  *It was 1986*.  Please do not do mediation models like this.  You will always have more than three variables, and always have access to software that can estimate the model simultaneously.  While I think it is very helpful to estimate your models in piecemeal fashion for debugging purposes and to facilitate your understanding, use appropriate tools for the model you wish to estimate.
[^mccnodescript]: There is a statement "All results controlled for background covariates of vocabulary at age 4, gender, adoption status, and maternal education level." and a picture of only the three-variable mediation part.
[^medvsdirectModcomp]: I suspect this is likely the case for the majority of modeling scenarios.
[^nonrecursiveName]: No, 'non'-recursive as a name for these models makes no sense to me either.
[^pcafacormat]: Principal components, standard factor analysis and sem can work on covariance/correlation matrices even without the raw data, this will be perhaps demonstrated in a later version of this doc.
[^rotation]: I don't think it necessary to get into rotation here, though will likely add a bit in the future. If you're doing PCA, you're likely not really concerned about interpretation of loadings, as you are going to use the components for other means.  It might help with standard factor analysis, but this workshop will spend time on more focused approaches where one would have some idea of the underlying structure rather than looking to uncover the structure.
[^residualModel]: Note that this is actually done for all disturbance/residual terms, as there is an underlying latent variable there which represents measurement error and the effect of unexplained causes.  The path of that latent variable is fixed to 1, and its variance is the residual variance in the SEM output.
[^bayesEstimator]: See the <span class="pack">blavaan</span> package.
[^dsm]: Despite the name, there is nothing inherently 'statistical' about the DSM.
[^reml]: One can set REML=F so as to use standard maximum likelihood and make the results directly comparable to lavaan.
[^nonlinearfewtimepts]: I personally cannot *see* bends with only four time points, at such that I couldn't just as easily posit a linear trend.
[^cluster]: Note that k-means and other common cluster analysis techniques are not model based as in this example.  In model-based approaches we assume some probabilistic data generating process (e.g. normal distribution) rather than some heuristic.
[^latclass]: By contrast, continuous latent variables are typically clearly theoretically motivated in typical SEM practice.  Data set sizes would usually limit the number of groups to three at most, yet there is no reason to believe there would only be three distinct latent classes in any reasonable amount of data.
