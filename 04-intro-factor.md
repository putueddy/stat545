Introduction to factor
================
I Putu Eddy Irawan
11/06/2020

### Factors inspection

Factors are the variable type that useRs love to hate. It is how we
store truly categorical information in R. The values a factor can take
on are called the levels.

Load forcats and gapminder

``` r
library(gapminder)
library(tidyverse)
<<<<<<< HEAD
<<<<<<< HEAD
## ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
=======
## ── Attaching packages ───────────────────────────────────────── tidyverse 1.3.0 ──
>>>>>>> 77f7b9cdd340c8f63823df96d549906b48d45acb
=======
## ── Attaching packages ───────────────────────────────────────── tidyverse 1.3.0 ──
>>>>>>> 77f7b9cdd340c8f63823df96d549906b48d45acb
## ✓ ggplot2 3.3.1     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   1.0.0
## ✓ tidyr   1.1.0     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
<<<<<<< HEAD
<<<<<<< HEAD
## ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
=======
## ── Conflicts ──────────────────────────────────────────── tidyverse_conflicts() ──
>>>>>>> 77f7b9cdd340c8f63823df96d549906b48d45acb
=======
## ── Conflicts ──────────────────────────────────────────── tidyverse_conflicts() ──
>>>>>>> 77f7b9cdd340c8f63823df96d549906b48d45acb
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

Get to know your factor before you start touching it\! It’s polite.
Let’s use `gapminder$continent` as our example.

``` r
str(gapminder$continent)
##  Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
levels(gapminder$continent)
## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
nlevels(gapminder$continent)
## [1] 5
class(gapminder$continent)
## [1] "factor"
```

To get a frequency table as a tibble, from a tibble, use
`dplyr::count()`. To get similar from a free-range factor, use
`forcats::fct_count()`

``` r
gapminder %>%
  count(continent)
## # A tibble: 5 x 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
fct_count(gapminder$continent)
## # A tibble: 5 x 2
##   f            n
##   <fct>    <int>
## 1 Africa     624
## 2 Americas   300
## 3 Asia       396
## 4 Europe     360
## 5 Oceania     24
```

### Dropping unused factor

Watch what happens to the levels of `country` (= nothing) when we filter
Gapminder to a handful of countries.

``` r
nlevels(gapminder$country)
## [1] 142
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries)
nlevels(h_gap$country)
## [1] 142
```

Even though `h_gap` only has data for a handful of countries, we are
still schlepping around all 142 levels from the original `gapminder`
tibble.

How can you get rid of them? The base function `droplevels()` operates
on all the factors in a data frame or on a single factor. The function
`forcats::fct_drop()` operates on a factor.

``` r
h_gap_dropped <- h_gap %>%
  droplevels()
nlevels(h_gap_dropped$country)
## [1] 5

# use forcats::fct_drop() on a free-range factor
h_gap$country %>%
  fct_drop() %>%
  levels()
## [1] "Egypt"     "Haiti"     "Romania"   "Thailand"  "Venezuela"
```

Change order of the levels, principled By default, factor levels are
ordered alphabetically.  
It is preferable to order the levels according to some principle:

  - Frequency. Make the most common level the first and so on.  
  - Another variable. **Example**: order Gapminder countries by life
    expectancy.

First, let’s order continent by frequency, forwards and backwards. This
is often a great idea for tables and figures, esp. frequency barplots.

``` r
# default order is alphabetical
gapminder$continent %>%
  levels()
## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"

# order by frequency
gapminder$continent %>%
  fct_infreq() %>%
  levels()
## [1] "Africa"   "Asia"     "Europe"   "Americas" "Oceania"

# backward!
gapminder$continent %>%
  fct_infreq() %>%
  fct_rev() %>%
  levels()
## [1] "Oceania"  "Americas" "Europe"   "Asia"     "Africa"
```

These two barcharts of frequency by continent differ only in the order
of the continents. Which do you prefer?

<img src="04-intro-factor_files/figure-gfm/r barplot-1.png" width="50%" /><img src="04-intro-factor_files/figure-gfm/r barplot-2.png" width="50%" />

Now we order country by another variable, forwards and backwards.  
The factor is the grouping variable and the default summarizing function
is `median()` but you can specify something else.

``` r
# order countries by median life expectancy
fct_reorder(gapminder$country, gapminder$lifeExp) %>%
  levels() %>% 
  head()
## [1] "Sierra Leone"  "Guinea-Bissau" "Afghanistan"   "Angola"       
## [5] "Somalia"       "Guinea"

# order accoring to minimum life expectancy instead of median
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>%
  levels() %>% 
  head()
## [1] "Rwanda"       "Afghanistan"  "Gambia"       "Angola"       "Sierra Leone"
## [6] "Cambodia"

# backward!
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>%
  levels() %>% 
  head()
## [1] "Iceland"     "Japan"       "Sweden"      "Switzerland" "Netherlands"
## [6] "Norway"
```

Example of why we reorder factor levels: often makes plots much better\!
Compare the interpretability of these two plots of life expectancy in
Asian countries in 2007. The only difference is the order of the
`country` factor. Which one do you find easier to learn from?

``` r
gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = country)) + geom_point()

gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = fct_reorder(country, lifeExp))) + geom_point()
```

<img src="04-intro-factor_files/figure-gfm/r plotreorder-1.png" width="50%" /><img src="04-intro-factor_files/figure-gfm/r plotreorder-2.png" width="50%" />

Use `fct_reorder2()` when you have a line chart of a quantitative x
against another quantitative y and your factor provides the color. This
way the legend appears in some order as the data\!

``` r
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries) %>%
  droplevels()
```

``` r
h_gap %>%
  ggplot(aes(x = year, y = lifeExp, color = country)) +
  geom_line()

h_gap %>%
  ggplot(aes(x = year, y = lifeExp, 
             color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")
```

<img src="04-intro-factor_files/figure-gfm/r reorderplot2-1.png" width="50%" /><img src="04-intro-factor_files/figure-gfm/r reorderplot2-2.png" width="50%" />

Sometimes you just want to hoist one or more levels to the front. Why?
Because I said so.

``` r
h_gap$country %>% levels()
## [1] "Egypt"     "Haiti"     "Romania"   "Thailand"  "Venezuela"
h_gap$country %>% fct_relevel("Romania", "Haiti") %>% levels()
## [1] "Romania"   "Haiti"     "Egypt"     "Thailand"  "Venezuela"
```

This might be useful if you are preparing a report for, say, the
Romanian government. The reason for always putting Romania first has
nothing to do with the data, it is important for external reasons and
you need a way to express this.

Sometimes you have better ideas about what certain levels should be.
This is called recoding.

``` r
i_gap <- gapminder %>%
  filter(country %in% c("United States", "Sweden", "Australia")) %>%
  droplevels()
i_gap$country %>% levels()
## [1] "Australia"     "Sweden"        "United States"
i_gap$country %>%
  fct_recode("USA" = "United States", "Oz" = "Australia") %>%
  levels()
## [1] "Oz"     "Sweden" "USA"
```

### Grow a factor

Let’s create two data frames, each with data from two countries,
dropping unused factor levels.

``` r
df1 <- gapminder %>%
  filter(country %in% c("Indonesia", "Japan"), year > 2000) %>%
  droplevels()
df2 <- gapminder %>%
  filter(country %in% c("Haiti", "Germany"), year > 2000) %>%
  droplevels()
```

The `country` factors in `df1` and `df2` have different levels

``` r
levels(df1$country)
## [1] "Indonesia" "Japan"
levels(df2$country)
## [1] "Germany" "Haiti"
```

Can you just combine them?

``` r
c(df1$country, df2$country)
## [1] 1 1 2 2 1 1 2 2
```

Umm, no. That is wrong on many levels\! Use `fct_c()` to do this.

``` r
fct_c(df1$country, df2$country)
## [1] Indonesia Indonesia Japan     Japan     Germany   Germany   Haiti    
## [8] Haiti    
## Levels: Indonesia Japan Germany Haiti
```

**Exercise**: Explore how different forms of row binding work behave
here, in terms of the country variable in the result.

``` r
bind_rows(df1, df2)
## # A tibble: 8 x 6
##   country   continent  year lifeExp       pop gdpPercap
##   <fct>     <fct>     <int>   <dbl>     <int>     <dbl>
## 1 Indonesia Asia       2002    68.6 211060000     2874.
## 2 Indonesia Asia       2007    70.6 223547000     3541.
## 3 Japan     Asia       2002    82   127065841    28605.
## 4 Japan     Asia       2007    82.6 127467972    31656.
## 5 Germany   Europe     2002    78.7  82350671    30036.
## 6 Germany   Europe     2007    79.4  82400996    32170.
## 7 Haiti     Americas   2002    58.1   7607651     1270.
## 8 Haiti     Americas   2007    60.9   8502814     1202.
rbind(df1, df2)
## # A tibble: 8 x 6
##   country   continent  year lifeExp       pop gdpPercap
##   <fct>     <fct>     <int>   <dbl>     <int>     <dbl>
## 1 Indonesia Asia       2002    68.6 211060000     2874.
## 2 Indonesia Asia       2007    70.6 223547000     3541.
## 3 Japan     Asia       2002    82   127065841    28605.
## 4 Japan     Asia       2007    82.6 127467972    31656.
## 5 Germany   Europe     2002    78.7  82350671    30036.
## 6 Germany   Europe     2007    79.4  82400996    32170.
## 7 Haiti     Americas   2002    58.1   7607651     1270.
## 8 Haiti     Americas   2007    60.9   8502814     1202.
```
