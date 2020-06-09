Introduction to tidyr
================
I Putu Eddy Irawan
09/06/2020

### Overview

It is often said that 80% of data analysis is spent on the cleaning and
preparing data. The principles of tidy data provide a standard way to
organise data values within a dataset.

The goal of tidyr is to help you create **tidy data**. Tidy data is data
where:  
1\. Every column is variable.  
2\. Every row is an observation.  
3\. Every cell is a single value.

If you ensure that your data is tidy, you’ll spend less time fighting
with the tools and more time working on your analysis.

### Defining tidy data

Like families, tidy datasets are all alike but every messy dataset is
messy in its own way. Tidy datasets provide a standardized way to link
the structure of a dataset (its physical layout) with its semantics (its
meaning).

### Data structure

Most statistical datasets are data frames made up of **rows** and
**columns**. The columns are almost always labeled and the rows are
sometimes labeled. The following code provides some data about an
imaginary classroom in a format commonly seen in the wild. The table has
three columns and four rows, and both rows and columns are labeled.

``` r
classroom <- read.csv("data/classroom.csv", stringsAsFactors = FALSE)
classroom
##     name quiz1 quiz2 test1
## 1  Billy  <NA>     D     C
## 2   Suzy     F  <NA>  <NA>
## 3 Lionel     B     C     B
## 4  Jenny     A     A     B
```

There are many ways to structure the same underlying data. The following
table shows the same data as above, but the rows and columns have been
transposed.

``` r
read.csv("data/classroom2.csv", stringsAsFactors = FALSE)
##   assessment Billy Suzy Lionel Jenny
## 1      quiz1  <NA>    F      B     A
## 2      quiz2     D <NA>      C     A
## 3      test1     C <NA>      B     B
```

The data is the same, but the layout is different. Our vocabulary of
rows and columns is simply not rich enough to describe why the two
tables represent the same data. In addition to appearance, we need a way
to describe the underlying semantics, or meaning, of the values
displayed in the table. \#\#\# Installation

``` r
# The easiest way to get tidyr is to install the whole tidyverse:
install.packages("tidyverse")

# Alternatively, install just tidyr:
install.packages("tidyr")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("tidyverse/tidyr")
```

### Data tidying

A tidy version of the classroom data looks like this: (you’ll learn how
the functions work a little later)

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

classroom
##     name quiz1 quiz2 test1
## 1  Billy  <NA>     D     C
## 2   Suzy     F  <NA>  <NA>
## 3 Lionel     B     C     B
## 4  Jenny     A     A     B
```

This dataset contains three variables:  
\* `name`, stored in the rows,  
\* `assessment` spread across the columns names, and  
\* `grade` stored in the cell values

#### Longer

`pivot_longer()` makes datasets longer by increasing the number of rows
and decreasing the number of columns.

``` r
classroom2 <- classroom %>%
  pivot_longer(quiz1:test1, names_to = "assessment", values_to = "grade") %>%
  arrange(name, assessment)
classroom2
## # A tibble: 12 x 3
##    name   assessment grade
##    <chr>  <chr>      <chr>
##  1 Billy  quiz1      <NA> 
##  2 Billy  quiz2      D    
##  3 Billy  test1      C    
##  4 Jenny  quiz1      A    
##  5 Jenny  quiz2      A    
##  6 Jenny  test1      B    
##  7 Lionel quiz1      B    
##  8 Lionel quiz2      C    
##  9 Lionel test1      B    
## 10 Suzy   quiz1      F    
## 11 Suzy   quiz2      <NA> 
## 12 Suzy   test1      <NA>
```

  - The first argument is the dataset to reshape, `classroom`  
  - The second argument describes which columns need to be reshaped. In
    this case, it’s every column apart from `name`.  
  - The `names_to` gives the name of the variable that will be created
    from the data stored in the column names, i.e. `assessment`.
  - The `values_to` gives the name of the variable that will be created
    from the data stored in the cell value, i.e. `grade`.

This makes the values, variables, and observations more clear. The
dataset contains 36 values representing three variables and 12
observations. The variables are:  
1\. `name`, with four possible values (Billy, Suzy, Lionel, and
Jenny).  
2\. `assessment`, with three possible values (quiz1, quiz2, and
test1).  
3\. `grade`, with five or six values depending on how you think of the
missing value (A, B, C, D, F, NA).

#### Wider

`pivot_wider()` is the opposite of `pivot_longer()`: it makes a dataset
wider by increasing the number of columns and decreasing the number of
rows.

``` r
# Creating summary tables similar to data structure from file: classroom2.csv
classroom2 %>%
  pivot_wider(names_from = name, values_from = grade)
## # A tibble: 3 x 5
##   assessment Billy Jenny Lionel Suzy 
##   <chr>      <chr> <chr> <chr>  <chr>
## 1 quiz1      <NA>  A     B      F    
## 2 quiz2      D     A     C      <NA> 
## 3 test1      C     B     B      <NA>
```

### Lord of the Rings example

-----

We have untidy data per movie. In each table, we have the total number
of words spoken, by characters of different races and genders.

| Race   | Female | Male |
| :----- | -----: | ---: |
| Elf    |   1229 |  971 |
| Hobbit |     14 | 3644 |
| Man    |      0 | 1995 |

The Fellowship Of The Ring

| Race   | Female | Male |
| :----- | -----: | ---: |
| Elf    |    331 |  513 |
| Hobbit |      0 | 2463 |
| Man    |    401 | 3589 |

The Two Towers

| Race   | Female | Male |
| :----- | -----: | ---: |
| Elf    |    183 |  510 |
| Hobbit |      2 | 2673 |
| Man    |    268 | 2459 |

The Return Of The King

This data has been formatted for consumption by *human*. The format
makes it easy for a *human* to look up the number of words spoken by
female elves in The Two Towers. But this format actually makes it pretty
hard for a *computer* to pull out such counts and, more importantly, to
compute on them or graph them.

#### Collect untidy Lord Of The Rings data into a single data frame

We now have one data frame per film, each with a common set of 4
variables. Step one in tidying this data is to glue them together into
one data frame, stacking them up row wise. This is called row binding
and we use `dplyr::bind_rows()`.

``` r
lotr_untidy <- bind_rows(The_Fellowship_Of_The_Ring, 
                       The_Two_Towers, 
                       The_Return_Of_The_King)
str(lotr_untidy)
## 'data.frame':    9 obs. of  4 variables:
##  $ Film  : chr  "The Fellowship Of The Ring" "The Fellowship Of The Ring" "The Fellowship Of The Ring" "The Two Towers" ...
##  $ Race  : chr  "Elf" "Hobbit" "Man" "Elf" ...
##  $ Female: int  1229 14 0 331 0 401 183 2 268
##  $ Male  : int  971 3644 1995 513 2463 3589 510 2673 2459
lotr_untidy
##                         Film   Race Female Male
## 1 The Fellowship Of The Ring    Elf   1229  971
## 2 The Fellowship Of The Ring Hobbit     14 3644
## 3 The Fellowship Of The Ring    Man      0 1995
## 4             The Two Towers    Elf    331  513
## 5             The Two Towers Hobbit      0 2463
## 6             The Two Towers    Man    401 3589
## 7     The Return Of The King    Elf    183  510
## 8     The Return Of The King Hobbit      2 2673
## 9     The Return Of The King    Man    268 2459
```

#### Tidy the untidy Lord Of The Rings data

We need to gather up the word counts into a single variable and create a
new variable, `Gender`, to track whether each count refers to females or
males. We use the `gather()` function from the tidyr package to do this.

``` r
lotr_tidy <- 
  gather(lotr_untidy, key = "Gender", value = "Words", Female, Male)
lotr_tidy
##                          Film   Race Gender Words
## 1  The Fellowship Of The Ring    Elf Female  1229
## 2  The Fellowship Of The Ring Hobbit Female    14
## 3  The Fellowship Of The Ring    Man Female     0
## 4              The Two Towers    Elf Female   331
## 5              The Two Towers Hobbit Female     0
## 6              The Two Towers    Man Female   401
## 7      The Return Of The King    Elf Female   183
## 8      The Return Of The King Hobbit Female     2
## 9      The Return Of The King    Man Female   268
## 10 The Fellowship Of The Ring    Elf   Male   971
## 11 The Fellowship Of The Ring Hobbit   Male  3644
## 12 The Fellowship Of The Ring    Man   Male  1995
## 13             The Two Towers    Elf   Male   513
## 14             The Two Towers Hobbit   Male  2463
## 15             The Two Towers    Man   Male  3589
## 16     The Return Of The King    Elf   Male   510
## 17     The Return Of The King Hobbit   Male  2673
## 18     The Return Of The King    Man   Male  2459
```

Tidy data … mission accomplished\!

#### Exercises

Look at the tables above and answer these questions:  
\* What’s the total number of words spoken by male hobbits?  
\* Does a certain Race dominate a movie? Does the dominant Race differ
across the movies?

Here’s how the same data looks in tidy form:

| Film                       | Race   | Gender | Words |
| :------------------------- | :----- | :----- | ----: |
| The Fellowship Of The Ring | Elf    | Female |  1229 |
| The Fellowship Of The Ring | Elf    | Male   |   971 |
| The Fellowship Of The Ring | Hobbit | Female |    14 |
| The Fellowship Of The Ring | Hobbit | Male   |  3644 |
| The Fellowship Of The Ring | Man    | Female |     0 |
| The Fellowship Of The Ring | Man    | Male   |  1995 |
| The Two Towers             | Elf    | Female |   331 |
| The Two Towers             | Elf    | Male   |   513 |
| The Two Towers             | Hobbit | Female |     0 |
| The Two Towers             | Hobbit | Male   |  2463 |
| The Two Towers             | Man    | Female |   401 |
| The Two Towers             | Man    | Male   |  3589 |
| The Return Of The King     | Elf    | Female |   183 |
| The Return Of The King     | Elf    | Male   |   510 |
| The Return Of The King     | Hobbit | Female |     2 |
| The Return Of The King     | Hobbit | Male   |  2673 |
| The Return Of The King     | Man    | Female |   268 |
| The Return Of The King     | Man    | Male   |  2459 |

With the data in tidy form, it’s natural to get a computer to do further
summarization or to make a figure. Let’s answer the questions posed
above.

##### What’s the total number of words spoken by male hobbits?

``` r
lotr_tidy %>%
  count(Race, Gender, wt = Words)
## # A tibble: 6 x 3
##   Race   Gender     n
##   <chr>  <chr>  <int>
## 1 Elf    Female  1743
## 2 Elf    Male    1994
## 3 Hobbit Female    16
## 4 Hobbit Male    8780
## 5 Man    Female   669
## 6 Man    Male    8043
```

The total number of words spoken by male hobbits is 8780. It was
important here to have all word counts in a single variable, within a
data frame that also included a variables for gender and race.

##### Does a certain race dominate a movie? Does the dominant race differ across the movies?

First, we sum across gender, to obtain word counts for the different
races by movie.

``` r
lotr_tidy %>%
  group_by(Film, Race) %>%
  summarize(Words = sum(Words))
## `summarise()` regrouping output by 'Film' (override with `.groups` argument)
## # A tibble: 9 x 3
## # Groups:   Film [3]
##   Film                       Race   Words
##   <chr>                      <chr>  <int>
## 1 The Fellowship Of The Ring Elf     2200
## 2 The Fellowship Of The Ring Hobbit  3658
## 3 The Fellowship Of The Ring Man     1995
## 4 The Return Of The King     Elf      693
## 5 The Return Of The King     Hobbit  2675
## 6 The Return Of The King     Man     2727
## 7 The Two Towers             Elf      844
## 8 The Two Towers             Hobbit  2463
## 9 The Two Towers             Man     3990
```

#### Spread

Practicing with `spread()`: let’s get one variable per Race

``` r
lotr_tidy %>%
  spread(key = Race, value = Words)
## # A tibble: 6 x 5
##   Film                       Gender   Elf Hobbit   Man
##   <chr>                      <chr>  <int>  <int> <int>
## 1 The Fellowship Of The Ring Female  1229     14     0
## 2 The Fellowship Of The Ring Male     971   3644  1995
## 3 The Return Of The King     Female   183      2   268
## 4 The Return Of The King     Male     510   2673  2459
## 5 The Two Towers             Female   331      0   401
## 6 The Two Towers             Male     513   2463  3589
```
