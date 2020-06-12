Introduction to character
================
I Putu Eddy Irawan
12/06/2020

# Character vectors

In real life we will spent a lot of time working with nasty data. Here
we discuss common remedial tasks for cleaning and transforming character
data, also known as “strings”.

### Manipulating character vectors

  - **stringr** package
      - A core package in the `tidyverse`.
      - Main functions start with `str_`.
  - **tidyr** package
  - Base functions: `nchar()`, `strsplit()`, `substr()`, `paste()`,
    `paste0()`.
  - The glue package is fantastic for string interpolation. If
    `stringr::str_interp()` doesn’t get your job done, check out the
    glue package.

<!-- end list -->

``` r
library(tidyverse)
## ── Attaching packages ───────────────────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.3.1     ✓ purrr   0.3.4
## ✓ tibble  3.0.1     ✓ dplyr   1.0.0
## ✓ tidyr   1.1.0     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
## ── Conflicts ──────────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

### Regex-free string manipulation with stringr and tidyr

Basic string manipulation tasks: \* Study a single character vector \*
Operate on a single character vector \* Operate on two or more character
vectors `fruit`, `words`, and `sentences` are character vectors that
ship with stringr for practicing.

### Detect or filter on a target string

Determine presence/absence of a literal string with `str_detect()`.
Which fruits actually use the word “fruit”?

``` r
str_detect(fruit, pattern = "fruit")
##  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
## [13] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [25] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE
## [37] FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
## [49] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE
## [61] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [73] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE
```

Use `str_subset()` to keep only the matching elements. Note we are
storing this new vector `my_fruit` to use in later examples\!

``` r
(my_fruit <- str_subset(fruit, pattern = "fruit"))
## [1] "breadfruit"   "dragonfruit"  "grapefruit"   "jackfruit"    "kiwi fruit"  
## [6] "passionfruit" "star fruit"   "ugli fruit"
```

### String splitting by delimiter

Use `stringr::str_split()` to split strings on a delimiter. Some of our
fruits are compound words, like “grapefruit”, but some have two words,
like “ugli fruit”.

``` r
str_split(my_fruit, pattern = " ")
## [[1]]
## [1] "breadfruit"
## 
## [[2]]
## [1] "dragonfruit"
## 
## [[3]]
## [1] "grapefruit"
## 
## [[4]]
## [1] "jackfruit"
## 
## [[5]]
## [1] "kiwi"  "fruit"
## 
## [[6]]
## [1] "passionfruit"
## 
## [[7]]
## [1] "star"  "fruit"
## 
## [[8]]
## [1] "ugli"  "fruit"
```

In full generality, split strings must return list, because who knows
how many pieces there will be?

If you are willing to commit to the number of pieces, you can use
`str_split_fixed()` and get a character matrix. You’re welcome\!

``` r
str_split_fixed(my_fruit, pattern = " ", n = 2)
##      [,1]           [,2]   
## [1,] "breadfruit"   ""     
## [2,] "dragonfruit"  ""     
## [3,] "grapefruit"   ""     
## [4,] "jackfruit"    ""     
## [5,] "kiwi"         "fruit"
## [6,] "passionfruit" ""     
## [7,] "star"         "fruit"
## [8,] "ugli"         "fruit"
```

If the to-be-split variable lives in a data frame, `tidyr::separate()`
will split it into 2 or more variables.

``` r
my_fruit_df <- tibble(my_fruit)
my_fruit_df %>%
  separate(my_fruit, into = c("pre", "post"), sep = " ")
## Warning: Expected 2 pieces. Missing pieces filled with `NA` in 5 rows [1, 2, 3,
## 4, 6].
## # A tibble: 8 x 2
##   pre          post 
##   <chr>        <chr>
## 1 breadfruit   <NA> 
## 2 dragonfruit  <NA> 
## 3 grapefruit   <NA> 
## 4 jackfruit    <NA> 
## 5 kiwi         fruit
## 6 passionfruit <NA> 
## 7 star         fruit
## 8 ugli         fruit
```

### Substring extraction (and replacement) by position

Count characters in your strings with `str_length()`. Note this is
different from the length of the character vector itself.

``` r
length(my_fruit)
## [1] 8
str_length(my_fruit)
## [1] 10 11 10  9 10 12 10 10
```

You can snip out substrings based on character position with
`str_sub()`.

``` r
head(fruit) %>%
  str_sub(1, 3)
## [1] "app" "apr" "avo" "ban" "bel" "bil"
```

The `start` and `end` arguments are vectorised. **Example**: a sliding
3-character window.

``` r
tibble(fruit) %>%
  head() %>%
  mutate(snip = str_sub(fruit, 1:6, 3:8))
## # A tibble: 6 x 2
##   fruit       snip 
##   <chr>       <chr>
## 1 apple       "app"
## 2 apricot     "pri"
## 3 avocado     "oca"
## 4 banana      "ana"
## 5 bell pepper " pe"
## 6 bilberry    "rry"
```

Finally, `str_sub()` also works for assignment, i.e. on the left hand
side of `<-`.

``` r
(x <- head(fruit, 3))
## [1] "apple"   "apricot" "avocado"
str_sub(x, 1, 3) <- "PUT"
x
## [1] "PUTle"   "PUTicot" "PUTcado"
```

### Collapse a vector

You can collapse a character vector of `length` n \> 1 to a single
string with `str_c()`

``` r
head(fruit) %>%
  str_c(collapse = ", ")
## [1] "apple, apricot, avocado, banana, bell pepper, bilberry"
```

If you have two or more character vectors of the same length, you can
glue them together element-wise, to get a new vector of that length.
Here are some … awful smoothie flavors?

``` r
str_c(fruit[1:4], fruit[5:8], sep = " & ")
## [1] "apple & bell pepper"   "apricot & bilberry"    "avocado & blackberry" 
## [4] "banana & blackcurrant"
```

Element-wise catenation can be combined with collapsing.

``` r
str_c(fruit[1:4], fruit[5:8], sep = " & ", collapse = ", ")
## [1] "apple & bell pepper, apricot & bilberry, avocado & blackberry, banana & blackcurrant"
```

If the to-be-combined vectors are variables in a data frame, you can use
`tidyr::unite()` to make a single new variable from them.

``` r
fruit_df <- tibble(
  fruit1 = fruit[1:4],
  fruit2 = fruit[5:8]
)
fruit_df %>%
  unite("flavor_combo", fruit1, fruit2, sep = " & ")
## # A tibble: 4 x 1
##   flavor_combo         
##   <chr>                
## 1 apple & bell pepper  
## 2 apricot & bilberry   
## 3 avocado & blackberry 
## 4 banana & blackcurrant
```

### Substring replacement

You can replace a pattern with `str_replace()`. Here we use an explicit
string-to-replace, but later we revisit with a regular expression.

``` r
str_replace(my_fruit, pattern = "fruit", replacement = "JUICE")
## [1] "breadJUICE"   "dragonJUICE"  "grapeJUICE"   "jackJUICE"    "kiwi JUICE"  
## [6] "passionJUICE" "star JUICE"   "ugli JUICE"
```

A special case that comes up a lot is replacing `NA`, for which there is
`str_replace_na()`.

``` r
melons <- str_subset(fruit, pattern = "melon")
melons[2] <- NA
melons
## [1] "canary melon" NA             "watermelon"
str_replace_na(melons, "UNKNOWN MELON")
## [1] "canary melon"  "UNKNOWN MELON" "watermelon"
```

If the `NA`-afflicted variable lives in a data frame, you can use
`tidyr::replace_na()`.

``` r
tibble(melons) %>%
  replace_na(replace = list(melons = "UNKNOWN MELON"))
## # A tibble: 3 x 1
##   melons       
##   <chr>        
## 1 canary melon 
## 2 UNKNOWN MELON
## 3 watermelon
```

# Regular expressions with stringr

Load it now and store the 142 unique country names to the object
`countries`.

``` r
library(gapminder)
countries <- levels(gapminder$country)
```

Frequently your string tasks cannot be expressed in terms of a fixed
string, but can be described in terms of a **pattern**.

The regex `a.b` will match all countries that have an `a`, followed by
any single character, followed by `b`.  
Yes, regexes are case sensitive.

``` r
str_subset(countries, pattern = "i.a")
##  [1] "Argentina"                "Bosnia and Herzegovina"  
##  [3] "Burkina Faso"             "Central African Republic"
##  [5] "China"                    "Costa Rica"              
##  [7] "Dominican Republic"       "Hong Kong, China"        
##  [9] "Jamaica"                  "Mauritania"              
## [11] "Nicaragua"                "South Africa"            
## [13] "Swaziland"                "Taiwan"                  
## [15] "Thailand"                 "Trinidad and Tobago"
```

Notice that `i.a` matches “ina”, “ica”, “ita”, and more.

**Anchors** can be included to express where the expression must occur
within the string. The `^` indicates the beginning of string and `$`
indicates the end.

Note how the regex `i.a$` matches many fewer countries than `i.a`alone.
Likewise, more elements of `my_fruit` match d than `^d`, which requires
“d” at string start.

``` r
str_subset(countries, pattern = "i.a$")
## [1] "Argentina"              "Bosnia and Herzegovina" "China"                 
## [4] "Costa Rica"             "Hong Kong, China"       "Jamaica"               
## [7] "South Africa"
str_subset(fruit, pattern = "d")
##  [1] "avocado"      "blood orange" "breadfruit"   "cloudberry"   "damson"      
##  [6] "date"         "dragonfruit"  "durian"       "elderberry"   "honeydew"    
## [11] "mandarine"    "redcurrant"
str_subset(fruit, pattern = "^d")
## [1] "damson"      "date"        "dragonfruit" "durian"
```

The metacharacter `\b` indicates a word **boundary** and `\B` indicates
NOT a word boundary.

``` r
str_subset(fruit, pattern = "melon")
## [1] "canary melon" "rock melon"   "watermelon"
str_subset(fruit, pattern = "\\bmelon")
## [1] "canary melon" "rock melon"
str_subset(fruit, pattern = "\\Bmelon")
## [1] "watermelon"
```
