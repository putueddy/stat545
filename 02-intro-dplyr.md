Introduction to dplyr
================
I Putu Eddy Irawan
07/06/2020

### 1\. Load dpylr and gapminder

I choose to load tidyverse, which will load dplyr among other packages
we use incidentally below

``` r
library(tidyverse)
## ── Attaching packages ───────────────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.3.1     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   1.0.0
## ✓ tidyr   1.1.0     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
## ── Conflicts ──────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

Also load gapminder.

``` r
library(gapminder)
```

Say hello to the `gapminder` tibble

``` r
gapminder
## # A tibble: 1,704 x 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.
##  2 Afghanistan Asia       1957    30.3  9240934      821.
##  3 Afghanistan Asia       1962    32.0 10267083      853.
##  4 Afghanistan Asia       1967    34.0 11537966      836.
##  5 Afghanistan Asia       1972    36.1 13079460      740.
##  6 Afghanistan Asia       1977    38.4 14880372      786.
##  7 Afghanistan Asia       1982    39.9 12881816      978.
##  8 Afghanistan Asia       1987    40.8 13867957      852.
##  9 Afghanistan Asia       1992    41.7 16317921      649.
## 10 Afghanistan Asia       1997    41.8 22227415      635.
## # … with 1,694 more rows
```

Note how gapminder’s `class()` includes `tbl_df`; the “tibble”
terminology is a nod to this.

``` r
class(gapminder)
## [1] "tbl_df"     "tbl"        "data.frame"
```

Go type `iris` in the R Console or print a data frame to screen that has
lots of columns. Too crowded isn’t it? To turn any data frame into a
tibble use `as_tibble()`:

``` r
as_tibble(iris)
## # A tibble: 150 x 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           <dbl>       <dbl>        <dbl>       <dbl> <fct>  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # … with 140 more rows
```

### 2\. Data aggregation techniques

> Do you want to create mini datasets for each level of some factor (or
> unique combination of several factors) … in order to compute or graph
> something?

  - Use `filter()` to subset data row-wise.

<!-- end list -->

``` r
filter(gapminder, lifeExp < 29)
## # A tibble: 2 x 6
##   country     continent  year lifeExp     pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>   <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8 8425333      779.
## 2 Rwanda      Africa     1992    23.6 7290203      737.
filter(gapminder, country == "Indonesia", year > 1979)
## # A tibble: 6 x 6
##   country   continent  year lifeExp       pop gdpPercap
##   <fct>     <fct>     <int>   <dbl>     <int>     <dbl>
## 1 Indonesia Asia       1982    56.2 153343000     1517.
## 2 Indonesia Asia       1987    60.1 169276000     1748.
## 3 Indonesia Asia       1992    62.7 184816000     2383.
## 4 Indonesia Asia       1997    66.0 199278000     3119.
## 5 Indonesia Asia       2002    68.6 211060000     2874.
## 6 Indonesia Asia       2007    70.6 223547000     3541.
filter(gapminder, country %in% c("Indonesia", "Rwanda"))
## # A tibble: 24 x 6
##    country   continent  year lifeExp       pop gdpPercap
##    <fct>     <fct>     <int>   <dbl>     <int>     <dbl>
##  1 Indonesia Asia       1952    37.5  82052000      750.
##  2 Indonesia Asia       1957    39.9  90124000      859.
##  3 Indonesia Asia       1962    42.5  99028000      849.
##  4 Indonesia Asia       1967    46.0 109343000      762.
##  5 Indonesia Asia       1972    49.2 121282000     1111.
##  6 Indonesia Asia       1977    52.7 136725000     1383.
##  7 Indonesia Asia       1982    56.2 153343000     1517.
##  8 Indonesia Asia       1987    60.1 169276000     1748.
##  9 Indonesia Asia       1992    62.7 184816000     2383.
## 10 Indonesia Asia       1997    66.0 199278000     3119.
## # … with 14 more rows
```

  - Meet the new pipe operator.

<!-- end list -->

``` r
gapminder %>% head()
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
## 4 Afghanistan Asia       1967    34.0 11537966      836.
## 5 Afghanistan Asia       1972    36.1 13079460      740.
## 6 Afghanistan Asia       1977    38.4 14880372      786.
```

This is equivalent to head(gapminder). The pipe operator takes the thing
on the left-hand-side and pipes it into the function call on the
right-hand-side.

You can still specify other arguments to this function\! To see the
first 3 rows of `gapminder`, we could say `head(gapminder, 3)` or this:

``` r
gapminder %>% head(3)
## # A tibble: 3 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
```

  - Use `select()` to subset the data on variables or columns.

<!-- end list -->

``` r
select(gapminder, year, lifeExp)
## # A tibble: 1,704 x 2
##     year lifeExp
##    <int>   <dbl>
##  1  1952    28.8
##  2  1957    30.3
##  3  1962    32.0
##  4  1967    34.0
##  5  1972    36.1
##  6  1977    38.4
##  7  1982    39.9
##  8  1987    40.8
##  9  1992    41.7
## 10  1997    41.8
## # … with 1,694 more rows
```

And here’s the same operation, but written with the pipe operator and
piped through `head()`:

``` r
gapminder %>% 
  select(year, lifeExp) %>%
  head(4)
## # A tibble: 4 x 2
##    year lifeExp
##   <int>   <dbl>
## 1  1952    28.8
## 2  1957    30.3
## 3  1962    32.0
## 4  1967    34.0
```

The data is **always** the very first argument of the verb functions.

  - Use `mutate()` to add new variables  
    First, we’re going to create copy of gapminder, to eliminate any
    fear that you’re damaging the data for our experiments.

<!-- end list -->

``` r
(my_gap <- gapminder)
## # A tibble: 1,704 x 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.
##  2 Afghanistan Asia       1957    30.3  9240934      821.
##  3 Afghanistan Asia       1962    32.0 10267083      853.
##  4 Afghanistan Asia       1967    34.0 11537966      836.
##  5 Afghanistan Asia       1972    36.1 13079460      740.
##  6 Afghanistan Asia       1977    38.4 14880372      786.
##  7 Afghanistan Asia       1982    39.9 12881816      978.
##  8 Afghanistan Asia       1987    40.8 13867957      852.
##  9 Afghanistan Asia       1992    41.7 16317921      649.
## 10 Afghanistan Asia       1997    41.8 22227415      635.
## # … with 1,694 more rows
```

``` r
## let print output to screen, but do not store
my_gap %>% filter(country == "Indonesia")
```

when we assign the output to an object, possibly overwriting an existing
object.

``` r
my_country <- my_gap %>% filter(country == "Indonesia")
```

`mutate()` is a function that defines and inserts new variables into a
tibble. Let’s multiply population and GDP per capita.

``` r
my_gap %>%
  mutate(gdp = pop * gdpPercap)
## # A tibble: 1,704 x 7
##    country     continent  year lifeExp      pop gdpPercap          gdp
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.  6567086330.
##  2 Afghanistan Asia       1957    30.3  9240934      821.  7585448670.
##  3 Afghanistan Asia       1962    32.0 10267083      853.  8758855797.
##  4 Afghanistan Asia       1967    34.0 11537966      836.  9648014150.
##  5 Afghanistan Asia       1972    36.1 13079460      740.  9678553274.
##  6 Afghanistan Asia       1977    38.4 14880372      786. 11697659231.
##  7 Afghanistan Asia       1982    39.9 12881816      978. 12598563401.
##  8 Afghanistan Asia       1987    40.8 13867957      852. 11820990309.
##  9 Afghanistan Asia       1992    41.7 16317921      649. 10595901589.
## 10 Afghanistan Asia       1997    41.8 22227415      635. 14121995875.
## # … with 1,694 more rows
```

This is how to achieve a new variable that is `gdpPercap` divided by
Indonesia `gdpPercap`: 1. Filter down to rows for Indonesia. 2. Create a
new temporary variable in `my_gap`: i. Extract the `gdpPercap` variable
from Indonesian data. ii. Replicate it once per country in the dataset,
so it has the right length. 3. Divide raw `gdpPercap` by this Indonesian
figure. 4. Discard the temporary variable of replicated Indonesia
`gdpPercap`.

``` r
indo <- my_gap %>%
  filter(country == "Indonesia")
my_gap <- my_gap %>%
  mutate(tmp = rep(indo$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)
```

Sanity check that Indonesian value for `gdpPercapRel` all be 1.

``` r
my_gap %>%
  filter(country == "Indonesia") %>%
  select(country, year, gdpPercapRel)
## # A tibble: 12 x 3
##    country    year gdpPercapRel
##    <fct>     <int>        <dbl>
##  1 Indonesia  1952            1
##  2 Indonesia  1957            1
##  3 Indonesia  1962            1
##  4 Indonesia  1967            1
##  5 Indonesia  1972            1
##  6 Indonesia  1977            1
##  7 Indonesia  1982            1
##  8 Indonesia  1987            1
##  9 Indonesia  1992            1
## 10 Indonesia  1997            1
## 11 Indonesia  2002            1
## 12 Indonesia  2007            1
```

I perceive Indonesia to be a “high GDP” country, so I predict that the
distribution of gdpPercapRel is below 1. Check your intuition\!

``` r
summary(my_gap$gdpPercapRel)
##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
##   0.07839   0.90210   2.45773   4.72309   6.71510 144.57117
```

Oops… we see that most of the countries covered by this dataset have
higher GDP per capita, relative to Indonesia, across the entire time
period.

Remember: Trust No One. Including yourself. Always try to find a way to
check that yo’ve done what meant to.

  - Use `arrange()` to row-order data in a principled way `arrange()`
    reorders the rows in a data frame. Imagine you wanted this data
    ordered by year then country, as opposed to by country then year.

<!-- end list -->

``` r
my_gap %>%
  arrange(year, country)
## # A tibble: 1,704 x 7
##    country     continent  year lifeExp      pop gdpPercap gdpPercapRel
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>        <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333      779.        1.04 
##  2 Albania     Europe     1952    55.2  1282697     1601.        2.14 
##  3 Algeria     Africa     1952    43.1  9279525     2449.        3.27 
##  4 Angola      Africa     1952    30.0  4232095     3521.        4.70 
##  5 Argentina   Americas   1952    62.5 17876956     5911.        7.89 
##  6 Australia   Oceania    1952    69.1  8691212    10040.       13.4  
##  7 Austria     Europe     1952    66.8  6927772     6137.        8.19 
##  8 Bahrain     Asia       1952    50.9   120447     9867.       13.2  
##  9 Bangladesh  Asia       1952    37.5 46886859      684.        0.913
## 10 Belgium     Europe     1952    68    8730405     8343.       11.1  
## # … with 1,694 more rows
```

Or maybe you want just the data from 2007, sorted on life expectancy in
descending order? Then use `desc()`.

``` r
my_gap %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))
## # A tibble: 142 x 7
##    country          continent  year lifeExp       pop gdpPercap gdpPercapRel
##    <fct>            <fct>     <int>   <dbl>     <int>     <dbl>        <dbl>
##  1 Japan            Asia       2007    82.6 127467972    31656.         8.94
##  2 Hong Kong, China Asia       2007    82.2   6980412    39725.        11.2 
##  3 Iceland          Europe     2007    81.8    301931    36181.        10.2 
##  4 Switzerland      Europe     2007    81.7   7554661    37506.        10.6 
##  5 Australia        Oceania    2007    81.2  20434176    34435.         9.73
##  6 Spain            Europe     2007    80.9  40448191    28821.         8.14
##  7 Sweden           Europe     2007    80.9   9031088    33860.         9.56
##  8 Israel           Asia       2007    80.7   6426679    25523.         7.21
##  9 France           Europe     2007    80.7  61083916    30470.         8.61
## 10 Canada           Americas   2007    80.7  33390141    36319.        10.3 
## # … with 132 more rows
```

  - Use `rename()` to rename variables

<!-- end list -->

``` r
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)
## # A tibble: 1,704 x 7
##    country     continent  year life_exp      pop gdp_percap gdp_percap_rel
##    <fct>       <fct>     <int>    <dbl>    <int>      <dbl>          <dbl>
##  1 Afghanistan Asia       1952     28.8  8425333       779.          1.04 
##  2 Afghanistan Asia       1957     30.3  9240934       821.          0.956
##  3 Afghanistan Asia       1962     32.0 10267083       853.          1.00 
##  4 Afghanistan Asia       1967     34.0 11537966       836.          1.10 
##  5 Afghanistan Asia       1972     36.1 13079460       740.          0.666
##  6 Afghanistan Asia       1977     38.4 14880372       786.          0.569
##  7 Afghanistan Asia       1982     39.9 12881816       978.          0.645
##  8 Afghanistan Asia       1987     40.8 13867957       852.          0.488
##  9 Afghanistan Asia       1992     41.7 16317921       649.          0.272
## 10 Afghanistan Asia       1997     41.8 22227415       635.          0.204
## # … with 1,694 more rows
```

  - `select()` can rename and reposition variables

You’ve seen simple use of `select()`. There are two tricks you might
enjoy:  
1\. `select()` can rename the variables you request to keep.  
2\. `select()` can be used with `everything()` to hoist a variable up
the front of the tibble

``` r
my_gap %>%
  filter(country == "Canada", year > 1996) %>%
  select(yr = year, lifeExp, gdpPercap) %>%
  select(gdpPercap, everything())
## # A tibble: 3 x 3
##   gdpPercap    yr lifeExp
##       <dbl> <int>   <dbl>
## 1    28955.  1997    78.6
## 2    33329.  2002    79.8
## 3    36319.  2007    80.7
```

  - `group_by()` is mighty weapon

“which country experienced the sharpest 5-year drop in life
expectancy?”  
In fact, that is a totally natural question to ask. But if you are using
a language that doesn’t know about data, it’s an incredibly annoying
question to answer.

dplyr offers powerful tools to solve this class of problem:  
1\. `group_by()` adds extra structure to your dataset – grouping
information.  
2\. `summarize()` takes a dataset with `n` observations, computes
requested summaries, and returns a dataset with 1 observation.  
3\. Window functions take a dataset with `n` observations and return a
dataset with `n` observations.  
4\. `mutate()` and `summarize()` will honor groups.  
5\. You can also do very general computations on your groups with
`do()`.

Combined with the verbs you already know, these new tools allow you to
solve an extremely diverse set of problems with relative ease.

``` r
my_gap %>%
  group_by(continent) %>%
  summarise(n = n())
## `summarise()` ungrouping output (override with `.groups` argument)
## # A tibble: 5 x 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

Let us pause here to think about the tidyverse. You could get these same
frequencies using `table()` from base R.

``` r
table(gapminder$continent)
## 
##   Africa Americas     Asia   Europe  Oceania 
##      624      300      396      360       24
str(table(gapminder$continent))
##  'table' int [1:5(1d)] 624 300 396 360 24
##  - attr(*, "dimnames")=List of 1
##   ..$ : chr [1:5] "Africa" "Americas" "Asia" "Europe" ...
```

The `tally()` function is a convenience function that knows to count
rows. It honors groups.

``` r
my_gap %>%
  group_by(continent) %>%
  tally()
## # A tibble: 5 x 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

The `count()` function is an even more convenient function that does
both grouping and counting.

``` r
my_gap %>%
  count(continent)
## # A tibble: 5 x 2
##   continent     n
##   <fct>     <int>
## 1 Africa      624
## 2 Americas    300
## 3 Asia        396
## 4 Europe      360
## 5 Oceania      24
```

What if we wanted to add the number of unique countries for each
continent? You can compute multiple summaries inside `summarize()`. Use
the `n_distinct()` function to count the number of distinct countries
within each continent.

``` r
my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))
## `summarise()` ungrouping output (override with `.groups` argument)
## # A tibble: 5 x 3
##   continent     n n_countries
##   <fct>     <int>       <int>
## 1 Africa      624          52
## 2 Americas    300          25
## 3 Asia        396          33
## 4 Europe      360          30
## 5 Oceania      24           2
```

  - General summarization The functions you’ll apply within summarize()
    include classical statistical summaries, like `mean()`, `median()`,
    `var()`, `sd()`, `mad()`, `IQR()`, `min()`, and `max()`. Remember
    they are functions that take n inputs and distill them down into 1
    output.

<!-- end list -->

``` r
my_gap %>%
  group_by(continent) %>%
  summarise(avg_life_exp = mean(lifeExp))
## `summarise()` ungrouping output (override with `.groups` argument)
## # A tibble: 5 x 2
##   continent avg_life_exp
##   <fct>            <dbl>
## 1 Africa            48.9
## 2 Americas          64.7
## 3 Asia              60.1
## 4 Europe            71.9
## 5 Oceania           74.3
```

`summarize_at()` applies the same summary function(s) to multiple
variables. Let’s compute average and median life expectancy and GDP per
capita by continent by year…but only for 1952 and 2007.

``` r
my_gap %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarize_at(vars(lifeExp, gdpPercap), list(~mean(.), ~median(.)))
## # A tibble: 10 x 6
## # Groups:   continent [5]
##    continent  year lifeExp_mean gdpPercap_mean lifeExp_median gdpPercap_median
##    <fct>     <int>        <dbl>          <dbl>          <dbl>            <dbl>
##  1 Africa     1952         39.1          1253.           38.8             987.
##  2 Africa     2007         54.8          3089.           52.9            1452.
##  3 Americas   1952         53.3          4079.           54.7            3048.
##  4 Americas   2007         73.6         11003.           72.9            8948.
##  5 Asia       1952         46.3          5195.           44.9            1207.
##  6 Asia       2007         70.7         12473.           72.4            4471.
##  7 Europe     1952         64.4          5661.           65.9            5142.
##  8 Europe     2007         77.6         25054.           78.6           28054.
##  9 Oceania    1952         69.3         10298.           69.3           10298.
## 10 Oceania    2007         80.7         29810.           80.7           29810.
```

Let’s focus just on Asia. What are the minimum and maximum life
expectancies seen by year?

``` r
my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))
## `summarise()` ungrouping output (override with `.groups` argument)
## # A tibble: 12 x 3
##     year min_lifeExp max_lifeExp
##    <int>       <dbl>       <dbl>
##  1  1952        28.8        65.4
##  2  1957        30.3        67.8
##  3  1962        32.0        69.4
##  4  1967        34.0        71.4
##  5  1972        36.1        73.4
##  6  1977        31.2        75.4
##  7  1982        39.9        77.1
##  8  1987        40.8        78.7
##  9  1992        41.7        79.4
## 10  1997        41.8        80.7
## 11  2002        42.1        82  
## 12  2007        43.8        82.6
```

  - Computing with group-wise summaries

Let’s make a new variable that is the years of life expectancy gained
(lost) relative to 1952, for each individual country. We group by
country and use `mutate()` to make a new variable. The `first()`
function extracts the first value from a vector.

``` r
my_gap %>%
  group_by(country) %>%
  select(country, year, lifeExp) %>%
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>%
  filter(year < 1963)
## # A tibble: 426 x 4
## # Groups:   country [142]
##    country      year lifeExp lifeExp_gain
##    <fct>       <int>   <dbl>        <dbl>
##  1 Afghanistan  1952    28.8         0   
##  2 Afghanistan  1957    30.3         1.53
##  3 Afghanistan  1962    32.0         3.20
##  4 Albania      1952    55.2         0   
##  5 Albania      1957    59.3         4.05
##  6 Albania      1962    64.8         9.59
##  7 Algeria      1952    43.1         0   
##  8 Algeria      1957    45.7         2.61
##  9 Algeria      1962    48.3         5.23
## 10 Angola       1952    30.0         0   
## # … with 416 more rows
```

  - Windows functions

Window functions take `n` inputs and give back `n` outputs. Furthermore,
the output depends on all the values. So `rank()`is a window function
but `log()` is not.

``` r
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>%
  arrange(year)
## # A tibble: 24 x 3
## # Groups:   year [12]
##     year country     lifeExp
##    <int> <fct>         <dbl>
##  1  1952 Afghanistan    28.8
##  2  1952 Israel         65.4
##  3  1957 Afghanistan    30.3
##  4  1957 Israel         67.8
##  5  1962 Afghanistan    32.0
##  6  1962 Israel         69.4
##  7  1967 Afghanistan    34.0
##  8  1967 Japan          71.4
##  9  1972 Afghanistan    36.1
## 10  1972 Japan          73.4
## # … with 14 more rows
```

If we had wanted just the min OR the max, an alternative approach using
`top_n()` would have worked.

``` r
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  top_n(1, wt = desc(lifeExp))
## # A tibble: 12 x 3
## # Groups:   year [12]
##     year country     lifeExp
##    <int> <fct>         <dbl>
##  1  1952 Afghanistan    28.8
##  2  1957 Afghanistan    30.3
##  3  1962 Afghanistan    32.0
##  4  1967 Afghanistan    34.0
##  5  1972 Afghanistan    36.1
##  6  1977 Cambodia       31.2
##  7  1982 Afghanistan    39.9
##  8  1987 Afghanistan    40.8
##  9  1992 Afghanistan    41.7
## 10  1997 Afghanistan    41.8
## 11  2002 Afghanistan    42.1
## 12  2007 Afghanistan    43.8
```

So let’s answer that “simple” question: which country experienced the
sharpest 5-year drop in life expectancy?

``` r
my_gap %>%
  select(country, year, continent, lifeExp) %>%
  group_by(continent, country) %>%
  # within country, take (lifeExp in year i) - (lifeExp in year i - 1)
  # positive means lifeExp went up, negative means it went down
  mutate(le_delta = lifeExp - lag(lifeExp)) %>%
  # within country, retain the worst lifeExp change = smallest or most negative
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>%
  # within continent, retain the row with the lowest worsr_le_delta
  top_n(-1, wt = worst_le_delta)
## `summarise()` regrouping output by 'continent' (override with `.groups` argument)
## # A tibble: 5 x 3
## # Groups:   continent [5]
##   continent country     worst_le_delta
##   <fct>     <fct>                <dbl>
## 1 Africa    Rwanda             -20.4  
## 2 Americas  El Salvador         -1.51 
## 3 Asia      Cambodia            -9.10 
## 4 Europe    Montenegro          -1.46 
## 5 Oceania   Australia            0.170
```
