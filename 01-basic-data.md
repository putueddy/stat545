Basic care and feeding of data in R
================
I Putu Eddy Irawan
07/06/2020

### 1\. Meet the `gapminder` data frame or “tibble”

Install the Gapminder data from CRAN

``` r
install.packages("gapminder")
```

Now load the package:

``` r
library(gapminder)
```

Get an overview of the Gapminder data structure

``` r
str(gapminder)
## tibble [1,704 × 6] (S3: tbl_df/tbl/data.frame)
##  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ year     : int [1:1704] 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ lifeExp  : num [1:1704] 28.8 30.3 32 34 36.1 ...
##  $ pop      : int [1:1704] 8425333 9240934 10267083 11537966 13079460 14880372 12881816 13867957 16317921 22227415 ...
##  $ gdpPercap: num [1:1704] 779 821 853 836 740 ...
```

The tidyverse offers a special case of R’s default data frame: the
“tibble”, which is a nod to the actual class of these objects,
`tbl_df`.

If you have not already done so, install the tidyverse meta-package now

``` r
install.packages("tidyverse")
```

Now load it:

``` r
library(tidyverse)
## ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.3.1     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   1.0.0
## ✓ tidyr   1.1.0     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
## ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

Prints the names of classes

``` r
class(gapminder)
## [1] "tbl_df"     "tbl"        "data.frame"
```

Now we can print the gapminder to screen. It is a tibble (and also a
regular data frame)

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

Since we are dealing with plain vanilla data frames, we can rein in data
frame printing explicity with `head()` and `tail()`. Or turn it into a
tibble with `as_tibble()`

``` r
head(gapminder)
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333      779.
## 2 Afghanistan Asia       1957    30.3  9240934      821.
## 3 Afghanistan Asia       1962    32.0 10267083      853.
## 4 Afghanistan Asia       1967    34.0 11537966      836.
## 5 Afghanistan Asia       1972    36.1 13079460      740.
## 6 Afghanistan Asia       1977    38.4 14880372      786.
tail(gapminder)
## # A tibble: 6 x 6
##   country  continent  year lifeExp      pop gdpPercap
##   <fct>    <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Zimbabwe Africa     1982    60.4  7636524      789.
## 2 Zimbabwe Africa     1987    62.4  9216418      706.
## 3 Zimbabwe Africa     1992    60.4 10704340      693.
## 4 Zimbabwe Africa     1997    46.8 11404948      792.
## 5 Zimbabwe Africa     2002    40.0 11926563      672.
## 6 Zimbabwe Africa     2007    43.5 12311143      470.
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

More ways to query basic info on a data frame

``` r
names(gapminder)
## [1] "country"   "continent" "year"      "lifeExp"   "pop"       "gdpPercap"
ncol(gapminder)
## [1] 6
length(gapminder)
## [1] 6
dim(gapminder)
## [1] 1704    6
nrow(gapminder)
## [1] 1704
```

A statistical overview can be obtained with `summary()`

``` r
summary(gapminder)
##         country        continent        year         lifeExp     
##  Afghanistan:  12   Africa  :624   Min.   :1952   Min.   :23.60  
##  Albania    :  12   Americas:300   1st Qu.:1966   1st Qu.:48.20  
##  Algeria    :  12   Asia    :396   Median :1980   Median :60.71  
##  Angola     :  12   Europe  :360   Mean   :1980   Mean   :59.47  
##  Argentina  :  12   Oceania : 24   3rd Qu.:1993   3rd Qu.:70.85  
##  Australia  :  12                  Max.   :2007   Max.   :82.60  
##  (Other)    :1632                                                
##       pop              gdpPercap       
##  Min.   :6.001e+04   Min.   :   241.2  
##  1st Qu.:2.794e+06   1st Qu.:  1202.1  
##  Median :7.024e+06   Median :  3531.8  
##  Mean   :2.960e+07   Mean   :  7215.3  
##  3rd Qu.:1.959e+07   3rd Qu.:  9325.5  
##  Max.   :1.319e+09   Max.   :113523.1  
## 
```

Here we use only base R graphics, which are very basic.

``` r
plot(lifeExp ~ year, gapminder)
```

![](01-basic-data_files/figure-gfm/r%20plot-1.png)<!-- -->

``` r
plot(lifeExp ~ gdpPercap, gapminder)
```

![](01-basic-data_files/figure-gfm/r%20plot-2.png)<!-- -->

``` r
plot(lifeExp ~ log(gdpPercap), gapminder)
```

![](01-basic-data_files/figure-gfm/r%20plot-3.png)<!-- -->

### 2\. Look at the variables inside a data frame

To specify a single variable from a data frame, use the dollar sign `$`.
Let’s explore the numeric variable of life expectancy.

``` r
head(gapminder$lifeExp)
## [1] 28.801 30.332 31.997 34.020 36.088 38.438
summary(gapminder$lifeExp)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   23.60   48.20   60.71   59.47   70.85   82.60
hist(gapminder$lifeExp)
```

![](01-basic-data_files/figure-gfm/r%20lifeExp-1.png)<!-- -->

The year variable is an integer variable, but since there are so few
unique values it also functions a bit like a categorical variable.

``` r
summary(gapminder$year)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1952    1966    1980    1980    1993    2007
table(gapminder$year)
## 
## 1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 2002 2007 
##  142  142  142  142  142  142  142  142  142  142  142  142
```

The variables for country and continent hold truly categorical
information, which is stored as a factor in R.

``` r
class(gapminder$continent)
## [1] "factor"
summary(gapminder$continent)
##   Africa Americas     Asia   Europe  Oceania 
##      624      300      396      360       24
levels(gapminder$continent)
## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
nlevels(gapminder$continent)
## [1] 5
```

The **levels** of the factor `continent` in R is stored as integer codes
1, 2, 3, etc.

``` r
str(gapminder$continent)
##  Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
```

Here we count how many observations are associated with each continent
and, as usual, try to portray that info visually.

``` r
table(gapminder$continent)
## 
##   Africa Americas     Asia   Europe  Oceania 
##      624      300      396      360       24
barplot(table(gapminder$continent))
```

![](01-basic-data_files/figure-gfm/r%20tablecontinent-1.png)<!-- -->

In the figures below, we see how factors can be put to work in figures.
The continent factor is easily mapped into “facets” or colors and a
legend by the ggplot2 package.

``` r
## we exploit the fact that ggplot2 was installed and loaded via tidyverse
```

``` r
p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # initialize
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
```

![](01-basic-data_files/figure-gfm/r%20ggplotcontinent-1.png)<!-- -->

``` r
p + geom_point(aes(color = continent)) # map continent color
```

![](01-basic-data_files/figure-gfm/r%20ggplotcontinent-2.png)<!-- -->

``` r
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE) # geom_smooth() using method = 'gam' and formula 'y ~ s(x, bs = "cs)'
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

![](01-basic-data_files/figure-gfm/r%20ggplotcontinent-3.png)<!-- -->

``` r
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) + 
  geom_smooth(lwd = 1.5, se = FALSE) # geom_smooth() using method = 'loess' and formula 'y ~ x'
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

![](01-basic-data_files/figure-gfm/r%20ggplotcontinent-4.png)<!-- -->
