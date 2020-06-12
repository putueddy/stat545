#' ---
#' title: "Introduction to character"
#' author: "I Putu Eddy Irawan"
#' date: "12/06/2020"
#' output: github_document
#' always_allow_html: true
#' ---

#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' # Character vectors
#' In real life we will spent a lot of time working with nasty data.
#' Here we discuss common remedial tasks for cleaning and transforming character 
#' data, also known as “strings”.
#' 
#' ### Manipulating character vectors
#' * **stringr** package
#'   * A core package in the `tidyverse`.
#'   * Main functions start with `str_`.
#' * **tidyr** package
#' * Base functions: `nchar()`, `strsplit()`, `substr()`, `paste()`, `paste0()`.
#' * The glue package is fantastic for string interpolation. If 
#' `stringr::str_interp()` doesn’t get your job done, check out 
#' the glue package.
#' 
library(tidyverse)

#' ### Regex-free string manipulation with stringr and tidyr
#' Basic string manipulation tasks:
#' * Study a single character vector
#' * Operate on a single character vector
#' * Operate on two or more character vectors
#' `fruit`, `words`, and `sentences` are character vectors that ship with 
#' stringr for practicing.
#' 
#' ### Detect or filter on a target string
#' Determine presence/absence of a literal string with `str_detect()`.
#' Which fruits actually use the word “fruit”?
str_detect(fruit, pattern = "fruit")

#' Use `str_subset()` to keep only the matching elements. Note we are storing 
#' this new vector `my_fruit` to use in later examples!
(my_fruit <- str_subset(fruit, pattern = "fruit"))

#' ### String splitting by delimiter
#' Use `stringr::str_split()` to split strings on a delimiter. Some of our fruits 
#' are compound words, like “grapefruit”, but some have two words, like 
#' “ugli fruit”.
str_split(my_fruit, pattern = " ")

#' In full generality, split strings must return list, because who knows how 
#' many pieces there will be?  
#' 
#' If you are willing to commit to the number of pieces, you can use 
#' `str_split_fixed()` and get a character matrix. You’re welcome!
str_split_fixed(my_fruit, pattern = " ", n = 2)

#' If the to-be-split variable lives in a data frame, `tidyr::separate()` will 
#' split it into 2 or more variables.
my_fruit_df <- tibble(my_fruit)
my_fruit_df %>%
  separate(my_fruit, into = c("pre", "post"), sep = " ")

#' ### Substring extraction (and replacement) by position
#' Count characters in your strings with `str_length()`. Note this is different 
#' from the length of the character vector itself.
length(my_fruit)
str_length(my_fruit)

#' You can snip out substrings based on character position with `str_sub()`.
head(fruit) %>%
  str_sub(1, 3)

#' The `start` and `end` arguments are vectorised. **Example**: a sliding 
#' 3-character window.
tibble(fruit) %>%
  head() %>%
  mutate(snip = str_sub(fruit, 1:6, 3:8))

#' Finally, `str_sub()` also works for assignment, i.e. on the left hand side 
#' of `<-`.
(x <- head(fruit, 3))
str_sub(x, 1, 3) <- "PUT"
x

#' ### Collapse a vector
#' You can collapse a character vector of `length` n > 1 to a single string 
#' with `str_c()`
head(fruit) %>%
  str_c(collapse = ", ")

#' If you have two or more character vectors of the same length, you can glue 
#' them together element-wise, to get a new vector of that length. Here are 
#' some … awful smoothie flavors?
str_c(fruit[1:4], fruit[5:8], sep = " & ")

#' Element-wise catenation can be combined with collapsing.
str_c(fruit[1:4], fruit[5:8], sep = " & ", collapse = ", ")

#' If the to-be-combined vectors are variables in a data frame, you can use 
#' `tidyr::unite()` to make a single new variable from them.
fruit_df <- tibble(
  fruit1 = fruit[1:4],
  fruit2 = fruit[5:8]
)
fruit_df %>%
  unite("flavor_combo", fruit1, fruit2, sep = " & ")

#' ### Substring replacement
#' You can replace a pattern with `str_replace()`. Here we use an explicit 
#' string-to-replace, but later we revisit with a regular expression.
str_replace(my_fruit, pattern = "fruit", replacement = "JUICE")

#' A special case that comes up a lot is replacing `NA`, for which there 
#' is `str_replace_na()`.
melons <- str_subset(fruit, pattern = "melon")
melons[2] <- NA
melons
str_replace_na(melons, "UNKNOWN MELON")

#' If the `NA`-afflicted variable lives in a data frame, you can use 
#' `tidyr::replace_na()`.
tibble(melons) %>%
  replace_na(replace = list(melons = "UNKNOWN MELON"))

#' # Regular expressions with stringr
#' Load it now and store the 142 unique country names to the object `countries`.
library(gapminder)
countries <- levels(gapminder$country)

#' Frequently your string tasks cannot be expressed in terms of a fixed string, 
#' but can be described in terms of a **pattern**.  
#' 
#' The regex `a.b` will match all countries that have an `a`, followed by any 
#' single character, followed by `b`.  
#' Yes, regexes are case sensitive.
str_subset(countries, pattern = "i.a")

#' Notice that `i.a` matches “ina”, “ica”, “ita”, and more.  
#' 
#' **Anchors** can be included to express where the expression must occur within 
#' the string. The `^` indicates the beginning of string and `$` indicates the end.  
#' 
#' Note how the regex `i.a$` matches many fewer countries than `i.a `alone. 
#' Likewise, more elements of `my_fruit` match d than `^d`, which requires “d” 
#' at string start.
str_subset(countries, pattern = "i.a$")
str_subset(fruit, pattern = "d")
str_subset(fruit, pattern = "^d")

#' The metacharacter `\b` indicates a word **boundary** and `\B` indicates NOT 
#' a word boundary.
str_subset(fruit, pattern = "melon")
str_subset(fruit, pattern = "\\bmelon")
str_subset(fruit, pattern = "\\Bmelon")
