> NB: This post was revisited when updating the website early 2025, and some changes were required. Attempts to keep things consistent were made, but if you feel you’ve found an issue, please post it at [GitHub](http://github.com/m-clark/m-clark.github.io/issues).

## Introduction

Oftentimes I’m looking to gain speed/memory advantages, or maybe just exploring how to do the same thing differently in case it becomes useful later on. I thought I’d start posting them, but then I don’t get around to it. Here are a few that have come up over the past year (or two 😞), and even as I wrote this, more examples kept coming up, so I may come back to add more in the future.

## Quick summary

Data processing efficiency really depends on context. Faster doesn’t mean memory efficient, and what may be the best in a standard setting can be notably worse in others. Some approaches won’t show their value until the data is very large, or there are many groups to deal with, while others will get notably worse. Also, you may not want an additional package dependency beyond what you’re using, and may need a base R approach. The good news is you’ll always have options!

One caveat: I’m not saying that the following timed approaches are necessarily the best/fastest, I mostly stuck to ones I’d try first. You may find even better for your situation! A great resource to keep in mind is the [fastverse](https://github.com/fastverse), which is a collection of packages with speed and efficiency in mind, and includes a couple that are demonstrated here.

## Setup and orientation

Required packages.

``` r
library(dplyr)
library(tidyr)
library(dtplyr)
library(tidyfast)
library(data.table)
library(collapse)
library(vctrs)
library(bench)   # for timings
```

Also, in the following bench marks I turn off checking if the results are equivalent (i.e. `check = FALSE`) because even if the resulting data is the same, the objects may be different classes, or some objects may even be of the same class, but have different attributes. You are welcome to double check that you would get the same thing as I did. Also, you might want to look at the `autoplot` of the bench mark summaries, as many results have some variability that isn’t captured by just looking at median/best times.

## Fill in missing values

We’ll start with the problem of filling in missing values by group. I’ve created a realistic example where the missingness is seen randomly across multiple columns, and differently across groups. I’ve chosen to compare tidyr, tidyfast, the underlying approach of tidyr via vctrs, and data.table.

Note that only data.table is not last observation carried forward by default (‘down’ in tidyr parlance), so that argument is made explicit. All of these objects will have different attributes or classes. tidyfast for some reason renames the grouping variable to ‘by’. If you wrap all of these in `data.frame`, that will remove the attributes and give them all the same class, so you can verify they return the same result.

``` r
set.seed(1234)

N = 1e5
Ng = 5000

create_missing <- function(x) {
  x[sample(1:length(x), 5)] = NA
  x
}


df_missing = tibble(grp = rep(1:Ng, e = N / Ng)) %>%
  arrange(grp) %>%
  group_by(grp) %>%
  mutate(
    x = 1:n(),
    y = rpois(n(), 5),
    z = rnorm(n(), 5),
    across(x:z, create_missing)
  ) %>% 
  ungroup()

df_missing %>% head(5)

dt_missing = as.data.table(df_missing) %>% setkey(grp)
tf_missing = copy(dt_missing)

bm_fill <-
  bench::mark(
    %!in%
    tidyr    = fill(group_by(df_missing, grp), x:z),  
    tidyfast = dt_fill(tf_missing, x, y, z, id = grp),
    vctrs    = df_missing %>% group_by(grp) %>% mutate(across(x:z, vec_fill_missing)),
    dt = dt_missing[
      ,
      .(x = nafill(x, type = 'locf'),
        y = nafill(y, type = 'locf'),
        z = nafill(z, type = 'locf')),
      by = grp
    ],
    check = FALSE,
    iterations = 10
  )
```

This is a great example of where there is a notable speed/memory trade-off. Very surprising how much memory data.table uses[^1], while not giving much speed advantage relative to the tidyr. Perhaps there is something I’m missing (😏)? Also note that we can get an even ‘tidier’ advantage by using vctrs directly, rather than wrapping it via tidyr, and seeing how easy it is to use, it’s probably the best option.

| expression | min     | median  | mem_alloc | median_relative | mem_relative |
|------------|---------|---------|-----------|-----------------|--------------|
| tidyfast   | 18.3ms  | 24.5ms  | 39.87MB   | 1               | 6.06         |
| vctrs      | 27ms    | 28.5ms  | 6.58MB    | 1.16            | 1            |
| dt         | 111.7ms | 117.8ms | 237.08MB  | 4.81            | 36.04        |
| tidyr      | 132.3ms | 147.2ms | 6.59MB    | 6.01            | 1            |

## Antijoins

Sometimes you just don’t want that! In the following we have a situation where we want to filter values based on the negation of some condition. Think of a case where certain person IDs are not viable for consideration for analysis. Many times, a natural approach would be to use something like a filter where instead of using `vals %in% values_desired`, we just negate that with a bang (`!`) operator. However, another approach is to create a data frame of the undesired values and use an `anti_join`. When using joins in general, you get a relative advantage by explicitly noting the variables you’re joining on, so I compare that as well for demonstration. Finally, in this particular example we could use data.table’s built-in character match, `chin`.

``` r
set.seed(123)

df1 = tibble(
  id = sample(letters, 10000, replace = TRUE)
)

df2 = tibble(
  id = sample(letters[1:10], 10000, replace = TRUE)
)

df1_lazy = lazy_dt(df1)
df2_lazy = lazy_dt(df2)

df1_dt = data.table(df1)
df2_dt = data.table(df2)

suppressMessages({
  bm_antijoin = bench::mark(
    in_     = filter(df1, !id %in% letters[1:10]),
    in_dtp  = collect(filter(df1_lazy, !id %in% letters[1:10])),     # not usable until collected/as_tibbled
    chin    = filter(df1, !id %chin% letters[1:10]),                 # chin for char vector only, from data.table
    chin_dt = df1_dt[!df1_dt$id %chin% letters[1:10],],              
    coll    = fsubset(df1, id %!in% letters[1:10]),                  # can work with dt or tidyverse
    aj      = anti_join(df1, df2, by = 'id'),
    aj_noby = anti_join(df1, df2),

    iterations = 100,
    check      = FALSE
  )
})
```

In this case, the fully data.table approach is best in speed and memory, but collapse is not close behind[^2]. In addition, if you are in the tidyverse, the `anti_join` function is a very good option. Hopefully the lesson about explicitly setting the `by` argument is made clear.

| expression | min    | median   | mem_alloc | median_relative | mem_relative |
|------------|--------|----------|-----------|-----------------|--------------|
| chin_dt    | 152µs  | 160µs    | 206KB     | 1               | 1            |
| coll       | 167µs  | 185µs    | 268KB     | 1.16            | 1.3          |
| aj         | 529µs  | 559µs    | 293KB     | 3.5             | 1.42         |
| chin       | 626µs  | 662µs    | 270KB     | 4.15            | 1.31         |
| in\_       | 716µs  | 804µs    | 387KB     | 5.04            | 1.88         |
| in_dtp     | 923µs  | 988µs    | 479KB     | 6.2             | 2.33         |
| aj_noby    | 9.95ms | 10.962ms | 323KB     | 68.72           | 1.57         |

## Lag/lead/differences

Here we are interested in getting the difference in the current value of some feature from it’s last (or next) value, typically called a lag (lead). Note that it doesn’t have to be the last value, but that is most common. In the tidyverse we have `lag`/`lead` functions, or with data.table, we have the generic `shift` function that can do both. In the following I look at using that function in the fully data.table situation or within a tibble.

``` r
set.seed(1234)

N = 1e5
Ng = 5000

df  = tibble(
  x = rpois(N, 10),
  grp = rep(1:Ng, e = N / Ng)
)

dt = as.data.table(df)

bm_lag = bench::mark(
  dplyr_lag  = mutate(df, x_diff = x - lag(x)),
  dplyr_lead = mutate(df, x_diff = x - lead(x)),
  dt_lag     = dt[, x_diff := x - shift(x)],
  dt_lead    = dt[, x_diff := x - shift(x, n = -1)],
  dt_dp_lag  = mutate(df, x_diff = x - shift(x)),
  dt_dp_lead = mutate(df, x_diff = x - shift(x, n = -1)),
  coll_lag   = ftransform(df, x_diff = x - flag(x)),
  coll_lead  = ftransform(df, x_diff = x - flag(x, n = -1)),
  iterations = 100,
  check      = FALSE
)
```

In this case, collapse is best, with data.table not far behind, but using the `shift` function within the tidy approach is a very solid gain. Oddly, `lag` and `lead` seem somewhat different in terms of speed and memory.

| expression | min     | median  | mem_alloc | median_relative | mem_relative |
|------------|---------|---------|-----------|-----------------|--------------|
| coll_lag   | 226µs   | 260µs   | 783.84KB  | 1               | 1            |
| coll_lead  | 250µs   | 309µs   | 783.84KB  | 1.18            | 1            |
| dt_lag     | 316µs   | 354µs   | 813.87KB  | 1.36            | 1.04         |
| dt_lead    | 319µs   | 355µs   | 813.87KB  | 1.36            | 1.04         |
| dt_dp_lag  | 792µs   | 818µs   | 782.91KB  | 3.14            | 1            |
| dt_dp_lead | 797µs   | 892µs   | 782.91KB  | 3.42            | 1            |
| dplyr_lead | 994µs   | 1.115ms | 1.53MB    | 4.28            | 2            |
| dplyr_lag  | 1.044ms | 1.2ms   | 1.15MB    | 4.61            | 1.5          |

What about a grouped scenario? To keep it simple we’ll just look at using lagged values.

``` r
bm_lag_grp = bench::mark(
  dt_lag    = dt[, x_diff := x - shift(x), by = grp],
  dt_dp_lag = mutate(group_by(df, grp), x_diff = x - shift(x)),
  dplyr_lag = mutate(group_by(df, grp), x_diff = x - lag(x)),
  coll_lag  = fmutate(fgroup_by(df, grp), x_diff = x - flag(x)),
  
  iterations = 10,
  check      = FALSE
)
```

In the grouped situation, using a collapse isn’t best for memory, but the speed gain is ridiculous!!

| expression | min      | median   | mem_alloc | median_relative | mem_relative |
|------------|----------|----------|-----------|-----------------|--------------|
| coll_lag   | 484µs    | 548µs    | 1.59MB    | 1               | 3.52         |
| dt_lag     | 25.692ms | 28.067ms | 462.32KB  | 51.2            | 1            |
| dt_dp_lag  | 30.843ms | 32.969ms | 2.61MB    | 60.15           | 5.77         |
| dplyr_lag  | 77.156ms | 78.771ms | 5.19MB    | 143.7           | 11.49        |

## First/Last

In this demo, we want to take the first (last) value of each group. Surprisingly, for the same functionality, it turns out that the number of groups matter when doing groupwise operations. For the following I’ll even use a base R approach (though within dplyr’s mutate) to demonstrate some differences.

``` r
set.seed(1234)

N = 100000

df = tibble(
  x  = rpois(N, 10),
  id = sample(1:100, N, replace = TRUE)
)

dt = as.data.table(df)

bm_first = bench::mark(
  base_first  = summarize(group_by(df, id), x = x[1]),
  base_last   = summarize(group_by(df, id), x = x[length(x)]),
  dplyr_first = summarize(group_by(df, id), x = dplyr::first(x)),
  dplyr_last  = summarize(group_by(df, id), x = dplyr::last(x)),
  dt_first    = dt[, .(x = data.table::first(x)), by = id],
  dt_last     = dt[, .(x = data.table::last(x)),  by = id],
  coll_first  = ffirst(fgroup_by(df, id)),
  coll_last   = flast(fgroup_by(df, id)),
  
  iterations  = 100,
  check       = FALSE
)
```

The first result is actually not too surprising, in that the fully dt approaches are fast and memory efficient, though collapse is notably faster. Somewhat interesting is that the base last is a bit faster than dplyr’s `last` (technically `nth`) approach.

| expression  | min     | median  | mem_alloc | median_relative | mem_relative |
|-------------|---------|---------|-----------|-----------------|--------------|
| coll_last   | 307µs   | 341µs   | 783.53KB  | 1               | 1.72         |
| coll_first  | 299µs   | 345µs   | 783.53KB  | 1.01            | 1.72         |
| dt_last     | 698µs   | 876µs   | 454.62KB  | 2.57            | 1            |
| dt_first    | 689µs   | 895µs   | 454.62KB  | 2.62            | 1            |
| base_last   | 1.944ms | 2.036ms | 2.06MB    | 5.97            | 4.64         |
| dplyr_first | 2.026ms | 2.127ms | 2.06MB    | 6.24            | 4.64         |
| base_first  | 1.984ms | 2.165ms | 2.06MB    | 6.35            | 4.64         |
| dplyr_last  | 2.111ms | 2.553ms | 2.06MB    | 7.49            | 4.64         |

In the following, the only thing that changes is the number of groups.

``` r
set.seed(1234)

N = 100000

df = tibble(
  x = rpois(N, 10),
  id = sample(1:(N/10), N, replace = TRUE) # <--- change is here
)

dt = as.data.table(df)

bm_first_more_groups = bench::mark(
  base_first  = summarize(group_by(df, id), x = x[1]),
  base_last   = summarize(group_by(df, id), x = x[length(x)]),
  dplyr_first = summarize(group_by(df, id), x = dplyr::first(x)),
  dplyr_last  = summarize(group_by(df, id), x = dplyr::last(x)),
  dt_first    = dt[, .(x = data.table::first(x)), by = id],
  dt_last     = dt[, .(x = data.table::last(x)),  by = id],
  coll_first  = ffirst(group_by(df, id)),
  coll_last   = flast(group_by(df, id)),
  iterations  = 100,
  check       = FALSE
)
```

Now what the heck is going on here? The base R approach is way faster than even data.table, while not using any more memory than what dplyr is doing (because of the group-by-summarize). More to the point is that collapse is notably faster than the other options, but still a bit heavy memory-wise relative to data.table.

| expression  | min      | median   | mem_alloc | median_relative | mem_relative |
|-------------|----------|----------|-----------|-----------------|--------------|
| coll_last   | 2.813ms  | 3.006ms  | 2.79MB    | 1               | 3.8          |
| coll_first  | 2.838ms  | 3.128ms  | 2.79MB    | 1.04            | 3.8          |
| base_first  | 10.596ms | 11.4ms   | 3.06MB    | 3.79            | 4.17         |
| base_last   | 12.551ms | 13.151ms | 3.06MB    | 4.37            | 4.17         |
| dt_last     | 17.588ms | 18.318ms | 752.15KB  | 6.09            | 1            |
| dt_first    | 17.671ms | 18.379ms | 752.15KB  | 6.11            | 1            |
| dplyr_first | 20.066ms | 20.943ms | 3.06MB    | 6.97            | 4.17         |
| dplyr_last  | 20.916ms | 21.357ms | 3.16MB    | 7.1             | 4.31         |

## Coalesce/ifelse

It’s very often we want to change a single value based on some condition, often starting with `ifelse`. This is similar to our previous fill situation for missing values, but applies a constant as opposed to last/next value. `Coalesce` is similar to tidyr’s `fill`, and is often used in cases where we might otherwise use an `ifelse` style approach . In the following, we want to change NA values to zero, and there are many ways we might go about it.

``` r
set.seed(1234)
x = rnorm(1000)
x[x > 2] = NA


bm_coalesce = bench::mark(
  base      = {x[is.na(x)] <- 0; x},
  ifelse    = ifelse(is.na(x), 0, x),
  if_else   = if_else(is.na(x), 0, x),
  vctrs     = vec_assign(x, is.na(x), 0),
  tidyr     = replace_na(x, 0),
  fifelse   = fifelse(is.na(x), 0, x),
  coalesce  = coalesce(x, 0),
  fcoalesce = fcoalesce(x, 0),
  nafill    = nafill(x, fill = 0),
  coll      = replace_NA(x)   # default is 0
)
```

The key result here to me is just how much memory the dplyr `if_else` approach is using, as well as how fast and memory efficient the base R approach is even with a second step. While providing type safety, `if_else` is both slow and a memory hog, so probably anything else is better. tidyr itself would be a good option here, and while it makes up for the memory issue, it’s relatively slow compared to other approaches, including the function it’s a wrapper for (`vec_assign`), which is also demonstrated. Interestingly, `fcoalesce` and `fifelse` would both be better options than data.table’s other approach that is explicitly for this task.

| expression | min  | median | mem_alloc | median_relative | mem_relative |
|------------|------|--------|-----------|-----------------|--------------|
| fcoalesce  | 1µs  | 1µs    | 7.86KB    | 1               | 1            |
| coll       | 1µs  | 1µs    | 7.86KB    | 1.03            | 1            |
| base       | 2µs  | 3µs    | 7.91KB    | 2.17            | 1.01         |
| fifelse    | 3µs  | 4µs    | 11.81KB   | 2.6             | 1.5          |
| vctrs      | 4µs  | 4µs    | 11.81KB   | 3.09            | 1.5          |
| nafill     | 5µs  | 6µs    | 23.95KB   | 4.14            | 3.05         |
| tidyr      | 9µs  | 10µs   | 11.81KB   | 7.09            | 1.5          |
| coalesce   | 15µs | 17µs   | 20.19KB   | 11.71           | 2.57         |
| ifelse     | 15µs | 17µs   | 47.31KB   | 12.11           | 6.02         |
| if_else    | 21µs | 25µs   | 71.06KB   | 17.54           | 9.04         |

## Conditional Slide

I recently had a problem where I wanted to do a apply a certain function that required taking the difference between the current and last value as we did in the lag demo. The problem was that ‘last’ depended on a specific condition being met. The basic idea is that we want to take x - lag(x) but where the condition is `FALSE`, we need to basically ignore that value for consideration as the last value, and only use the previous value for which the condition is `TRUE`. In the following, for the first two values where the condition is met, this is straightforward (6 minus 10). But for the fourth row, 4 should subtract 6, rather than 5, because the condition is `FALSE`.

``` r
set.seed(1234)

df = tibble(
  x = sample(1:10),
  cond = c(TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE),
  group = rep(c('a', 'b'), e = 5)
)

df 
```

    # A tibble: 10 × 3
           x cond  group
       <int> <lgl> <chr>
     1    10 TRUE  a    
     2     6 TRUE  a    
     3     5 FALSE a    
     4     4 TRUE  a    
     5     1 FALSE a    
     6     8 TRUE  b    
     7     2 FALSE b    
     8     7 FALSE b    
     9     9 TRUE  b    
    10     3 FALSE b    

While somewhat simple in concept, it doesn’t really work with simple lags, as the answer would be wrong, or sliding functions, because the window is adaptive. I wrote the following function to deal with this. By default, it basically takes our vector under consideration, `x`, makes it `NA` where the condition doesn’t hold, then fills in the NA values with the last value using the `vec_fill_missing` (or a supplied constant/single value). However there is flexibility beyond that type of fill. In addition, the function applied is generic, and could be applied to the newly created variable (`.x`), or use both the original (`x`) and the newly created variable.

``` r
conditional_slide <-
  function(x,
           condition,
           fun,
           direction  = c("down"),
           fill_value = NA,
           na_value   = NA,
           ...) {
    
    if (!direction %in% c("constant", "down", "up", "downup", "updown"))
      rlang::abort('direction must be one of "constant", "down", "up", "downup", "updown"')
    
    if (length(x) != length(condition))
      rlang::abort('condition and x must be the same length')
    
    # can't use dplyr/dt ifelse since we won't know class type of fill_value
    conditional_val <- ifelse(direction == 'constant', fill_value, NA)    
    .x <- ifelse(condition, x, conditional_val)
    
    if (direction != 'constant')
      .x <- vctrs::vec_fill_missing(.x, direction = direction)
    
    class(.x) <- class(x)
    
    result <- fun(x, .x, ...)
    
    if (!is.na(na_value))
      result[is.na(result)] <- na_value
    
    result
  }
```

The first example applies the function, `x - lag(x)`, to our dataset, and which in my case, I also wanted to apply within groups, which caused further problems for some of the available functions I thought would otherwise be applicable. I also show it for another type of problem, taking the cumulative sum, as well as just conditionally changing the values to zero.

``` r
df %>%
 group_by(group) %>%
 mutate(
   # demo first difference
   simple_diff = x - dplyr::lag(x),
   cond_diff = conditional_slide(x, cond, fun = \(x, .x) x - lag(.x), na_value = 0),
   
   # demo cumulative sum
   simple_cumsum = cumsum(x),
   cond_cumsum   = conditional_slide(
     x,
     cond,
     fun = \(x, .x) cumsum(.x),
     direction = 'constant',
     fill = 0
   ),
   
   # demo fill last
   simple_fill_last = vec_fill_missing(x),
   cond_fill_last = conditional_slide(
     x,
     cond,
     fun = \(x, .x) .x,
     direction = 'down'
   )
 )
```

    # A tibble: 10 × 9
    # Groups:   group [2]
           x cond  group simple_diff cond_diff simple_cumsum cond_cumsum
       <int> <lgl> <chr>       <int>     <dbl>         <int>       <int>
     1    10 TRUE  a              NA         0            10          10
     2     6 TRUE  a              -4        -4            16          16
     3     5 FALSE a              -1        -1            21          16
     4     4 TRUE  a              -1        -2            25          20
     5     1 FALSE a              -3        -3            26          20
     6     8 TRUE  b              NA         0             8           8
     7     2 FALSE b              -6        -6            10           8
     8     7 FALSE b               5        -1            17           8
     9     9 TRUE  b               2         1            26          17
    10     3 FALSE b              -6        -6            29          17
    # ℹ 2 more variables: simple_fill_last <int>, cond_fill_last <int>

This is one of those things that comes up from time to time where trying to apply a standard tool likely won’t cut it. You may find similar situations where you need to modify what’s available and create some functionality tailored to your needs.

## Take the first TRUE

Sometimes we want the first instance of a condition. For example, we might want the position or value of the first number \> than some value. We’ve already investigated using dplyr or data.table’s `first`, and I won’t do so again here except to say they are both notably slower and worse on memory here. We have a few approaches we might take in base R. Using `which` would be common, but there is also `which.max`, that, when applied to logical vectors, gives the position of the first `TRUE` (`which.min` gives the position of the first `FALSE`). In addition, there is the `Position` function, which I didn’t even know about until messing with this problem.

``` r
set.seed(123)

x = sort(rnorm(10000))

marker = 2

bm_first_true_1 = bench::mark(
  which     = which(x > marker)[1],
  which_max = which.max(x > marker),
  pos       = Position(\(x) x > marker, x)
)


# make it slightly more challenging
x = sort(rnorm(1e6))

marker = 4 

bm_first_true_2 = bench::mark(
  which     = which(x > marker)[1],
  which_max = which.max(x > marker),
  pos       = Position(\(x) x > marker, x)
)
```

Interestingly `Position` provides the best memory performance, but is prohibitively slower. `which.max` is probably your best bet.

| expression | min     | median  | mem_alloc | median_relative | mem_relative |
|------------|---------|---------|-----------|-----------------|--------------|
| which      | 15µs    | 20µs    | 79.14KB   | 1               | 14.19        |
| which_max  | 18µs    | 20µs    | 39.11KB   | 1.01            | 7.01         |
| pos        | 1.986ms | 2.158ms | 5.58KB    | 109.67          | 1            |

| expression | min      | median   | mem_alloc | median_relative | mem_relative |
|------------|----------|----------|-----------|-----------------|--------------|
| which      | 1.44ms   | 1.69ms   | 7.63MB    | 1               | 1400.58      |
| which_max  | 1.79ms   | 2ms      | 3.81MB    | 1.18            | 700.29       |
| pos        | 213.55ms | 219.13ms | 5.58KB    | 129.4           | 1            |

But not so fast? The following makes the first case come very quickly, where `Position` blows the other options out of the water! I guess if you knew this was going to be the case you could take serious advantage.

``` r
set.seed(123)

x = sort(rnorm(100000), decreasing = TRUE)

x[1:30] = 4


bm_first_true_3 = bench::mark(
  which     = which(x < marker)[1],
  which_max = which.max(x < marker),
  pos       = Position(\(x) x < marker, x) 
)
```

| expression    | min   | median | mem_alloc | median_relative | mem_relative |
|---------------|-------|--------|-----------|-----------------|--------------|
| pos_rev       | 10µs  | 10µs   | 5.58KB    | 1               | 1            |
| which_max_rev | 110µs | 130µs  | 390.67KB  | 13.04           | 70.04        |
| which_rev     | 160µs | 220µs  | 1.14MB    | 22.55           | 210.09       |

## Group by filtering/slicing

The previous situation was the basis for this next demo where we utilize `which.max`. Here we want to filter in one scenario, such that if all values are zero, we drop them, and in the second, we want to only retain certain values based on a condition. In this latter case, the condition is that at least one non-zero has occurred, in which case we want to keep all of those values from that point on (even if they are zero).

To make things more clear, for the example data that follows, we want to drop group 1 entirely, the initial part of group 2, and retain all of group 3.

``` r
library(tidyverse)

set.seed(12345)

df = tibble(
  group = rep(1:3, e = 10),
  value = c(
    rep(0, 10),
    c(rep(0, 3), sample(0:5, 7, replace = TRUE)), 
    sample(0:10, 10, replace = TRUE)
  )
)


df %>% 
  group_by(group) %>% 
  filter(!all(value == 0)) %>% 
  slice(which.max(value > 0):n())
```

    # A tibble: 17 × 2
    # Groups:   group [2]
       group value
       <int> <dbl>
     1     2     5
     2     2     2
     3     2     1
     4     2     3
     5     2     1
     6     2     4
     7     2     2
     8     3     7
     9     3     1
    10     3     5
    11     3    10
    12     3     5
    13     3     6
    14     3     9
    15     3     0
    16     3     7
    17     3     6

In the above scenario, we take two steps to illustrate our desired outcome conceptually. Ideally though, we’d like one step, because it is just a general filtering. You might think maybe to change `which.max` to `which` and just slice, but this would remove all zeros, when we want to retain zeros after the point where at least some values are greater than zero. Using `row_number` was a way I thought to get around things.

``` r
df %>% 
  group_by(group) %>% 
  filter(!all(value == 0) & row_number() >= which.max(value > 0))


bm_filter_slice = bench::mark(
  orig = df %>% 
    group_by(group) %>% 
    filter(!all(value == 0)) %>% 
    slice(which.max(value > 0):n()),
  
  new = df %>% 
    group_by(group) %>% 
    filter(!all(value == 0) & row_number() >= which.max(value > 0))
)
```

| expression | min   | median | mem_alloc | median_relative | mem_relative |
|------------|-------|--------|-----------|-----------------|--------------|
| orig       | 2ms   | 2.2ms  | 10.25KB   | 1               | 1.11         |
| new        | 6.1ms | 7.1ms  | 9.21KB    | 3.28            | 1            |

Well we got it to one operation, but now it takes longer and has no memory advantage. Are we on the wrong track? Let’s try with a realistically sized data set with a lot of groups.

``` r
set.seed(1234)

N = 100000
g = 1:(N/4)

df = tibble(
  group = rep(g, e = 4),
  value = sample(0:5, size = N, replace = TRUE)
)

bm_filter_slice2 = bench::mark(
  orig = df %>% 
    group_by(group) %>% 
    filter(!all(value == 0)) %>% 
    slice(which.max(value > 0):n()),
  
  new = df %>% 
    group_by(group) %>% 
    filter(!all(value == 0) & row_number() >= which.max(value > 0))
)
```

Now we have the reverse scenario. The single filter is notably faster and more memory efficient.

| expression | min     | median  | mem_alloc | median_relative | mem_relative |
|------------|---------|---------|-----------|-----------------|--------------|
| new        | 208.6ms | 209.9ms | 12.9MB    | 1               | 1            |
| orig       | 949.8ms | 949.8ms | 28.3MB    | 4.53            | 2.19         |

## Tidy timings

### Overview

> This tidy timings section comes from a notably old exploration I rediscovered (I think it was originally Jan 2020), but it looks like tidyfast still has some functionality beyond dtplyr, and it doesn’t hurt to revisit. I added a result for collapse. My original timings were on a nicely suped up pc, but the following are on a year and a half old macbook with an M1 processer, and were almost 2x faster.

Here I take a look at some timings for data processing tasks. My reason for doing so is that dtplyr has recently arisen from the dead, and tidyfast has come on the scene, so I wanted a quick reference for myself and others to see how things stack up against data.table.

So we have the following:

- *Base R*: Just kidding. If you’re using base R approaches for this `aggregate` you will always be slower. Functions like `aggregate`, `tapply` and similar could be used in these demos, but I leave that as an exercise to the reader. I’ve done them, and it isn’t pretty.
- *dplyr*: standard data wrangling workhorse package
- *tidyr*: has some specific functionality not included in dplyr
- *data.table*: another commonly used data processing package that purports to be faster and more memory efficient (usually but not always)
- *tidyfast*: can only do a few things, but does them quickly.
- *collapse*: many replacements for base R functions.

### Standard grouped operation

The following demonstrates some timings from [this post on stackoverflow](http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega/34167477#34167477). I reproduced it on my own machine based on 50 million observations. The grouped operations that are applied are just a sum and length on a vector. As this takes several seconds to do even once, I only do it one time.

``` r
set.seed(123)
n = 5e7
k = 5e5
x = runif(n)
grp = sample(k, n, TRUE)

timing_group_by_big = list()


# dplyr
timing_group_by_big[["dplyr"]] = system.time({
    df = tibble(x, grp)
    r.dplyr = summarise(group_by(df, grp), sum(x), n())
})

# dtplyr
timing_group_by_big[["dtplyr"]] = system.time({
    df = lazy_dt(tibble(x, grp))
    r.dtplyr = df %>% group_by(grp) %>% summarise(sum(x), n()) %>% collect()
})

# tidyfast
timing_group_by_big[["tidyfast"]] = system.time({
    dt = setnames(setDT(list(x, grp)), c("x","grp"))
    r.tidyfast = dt_count(dt, grp)
})

# data.table
timing_group_by_big[["data.table"]] = system.time({
    dt = setnames(setDT(list(x, grp)), c("x","grp"))
    r.data.table = dt[, .(sum(x), .N), grp]
})

# collapse
timing_group_by_big[["collapse"]] = system.time({
     df = tibble(x, grp)
    r.data.table = fsummarise(fgroup_by(df, grp), x = fsum(x),  n = fnobs(x))
})

timing_group_by_big = timing_group_by_big %>% 
  do.call(rbind, .) %>% 
  data.frame() %>% 
  rownames_to_column('package')
```

| package    | elapsed |
|------------|---------|
| dplyr      | 7.03    |
| dtplyr     | 1.30    |
| collapse   | 1.02    |
| data.table | 0.67    |
| tidyfast   | 0.47    |

We can see that all options are notable improvements on dplyr. tidyfast is a little optimistic, as it can count but does not appear to do a summary operation like means or sums.

### Count

To make things more evenly matched, we’ll just do a simple grouped count. In the following, I add a different option for dplyr if all we want are group sizes. In addition, you have to ‘collect’ the data for a dtplyr object, otherwise the resulting object is not actually a usable tibble, and we don’t want to count the timing until it actually performs the operation. You can do this with the `collect` function or `as_tibble`.

``` r
data(flights, package = 'nycflights13')
head(flights)

flights_dtp = lazy_dt(flights)

flights_dt = data.table(flights)

bm_count_flights = bench::mark(
  dplyr_base = count(flights, arr_time),
  dtplyr     = collect(count(flights_dt, arr_time)),
  tidyfast   = dt_count(flights_dt, arr_time),
  data.table = flights_dt[, .(n = .N), by = arr_time],
  iterations = 100,
  check = FALSE
)
```

Here are the results. It’s important to note the memory as well as the time. The faster functions here are taking a bit more memory to do it. If dealing with very large data this could be more important if operations timings aren’t too different.

| expression | min   | median | mem_alloc | median_relative | mem_relative |
|------------|-------|--------|-----------|-----------------|--------------|
| data.table | 2ms   | 2.4ms  | 9.07MB    | 1               | 1.5          |
| tidyfast   | 2ms   | 3.3ms  | 9.05MB    | 1.38            | 1.49         |
| dplyr_gs   | 3.7ms | 4ms    | 6.06MB    | 1.65            | 1            |
| dtplyr     | 3.5ms | 4.2ms  | 9.06MB    | 1.73            | 1.5          |
| dplyr_base | 9.3ms | 10.5ms | 6.12MB    | 4.31            | 1.01         |

Just for giggles I did the same in Python with a pandas `DataFrame`, and depending on how you go about it you could be notably slower than all these methods, or less than half the standard dplyr approach. Unfortunately I can’t reproduce it here[^3], but I did run it on the same machine using a `df.groupby().size()` approach to create the same type of data frame. Things get worse as you move to something not as simple, like summarizing with a custom function, even if that custom function is still simple arithmetic.

A lot of folks that use Python primarily still think R is slow, but that is mostly just a sign that they don’t know how to effectively program with R for data science. I know folks who use Python more, but also use tidyverse, and I use R more but also use pandas quite a bit. It’s not really a debate - tidyverse is easier, less verbose, and generally faster relative to pandas, especially for more complicated operations. If you start using tools like data.table, then there is really no comparison for speed and efficiency. You can run the following for comparison.

``` python
import pandas as pd


# flights = r.flights
flights = pd.read_parquet('data/flights.parquet')

flights.groupby("arr_time", as_index=False).size()
```

          arr_time  size
    0          1.0   201
    1          2.0   164
    2          3.0   174
    3          4.0   173
    4          5.0   206
    ...        ...   ...
    1406    2356.0   202
    1407    2357.0   207
    1408    2358.0   189
    1409    2359.0   222
    1410    2400.0   150

    [1411 rows x 2 columns]

``` python
def test(): 
  flights.groupby("arr_time", as_index=False).arr_time.count()
 
test()


import timeit

timeit.timeit() # see documentation
```

    0.004073165997397155

``` python
test_result = timeit.timeit(stmt="test()", setup="from __main__ import test", number = 100)

# default result is in seconds for the total number of 100 runs
test_result/100*1000  # ms per run 
```

    3.1555674999253824

## Summary

Programming is a challenge, and programming in a computationally efficient manner is even harder. Depending on your situation, you may need to switch tools or just write your own to come up with the best solution.

## Footnotes

## Reuse

[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

## Citation

BibTeX citation:

``` quarto-appendix-bibtex
@online{clark2022,
  author = {Clark, Michael},
  title = {Programming {Odds} \& {Ends}},
  date = {2022-07-25},
  url = {https://m-clark.github.io/posts/2022-07-25-programming/},
  langid = {en}
}
```

For attribution, please cite this work as:

Clark, Michael. 2022. “Programming Odds & Ends.” July 25. <https://m-clark.github.io/posts/2022-07-25-programming/>.

[^1]: data.table modifies in place, so it technically it doesn’t have anything to fill after the first run. As a comparison, I created new columns as the filled in values, and this made almost no speed/memory difference. I also tried `copy(dt_missing)[...]`, which had a minor speed hit. I also tried using `setkey` first but that made no difference. Note also that data.table has `setnafill`, but this apparently has no grouping argument, so is not demonstrated.

[^2]: As of this writing, I’m new to the collapse package, and so might be missing other uses that might be more efficient.

[^3]: This is because [reticulate still has issues with M1 out of the box](https://github.com/rstudio/reticulate/issues/1019), and even then getting it to work can be a pain.
