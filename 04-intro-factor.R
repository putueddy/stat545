#' ---
#' title: "Introduction to factor"
#' author: "I Putu Eddy Irawan"
#' date: "11/06/2020"
#' output: github_document
#' always_allow_html: true
#' ---

#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' ### Factors inspection
#' Factors are the variable type that useRs love to hate. It is how we store 
#' truly categorical information in R. The values a factor can take on are 
#' called the levels.  
#' 
#' Load forcats and gapminder
library(gapminder)
library(tidyverse)

#' Get to know your factor before you start touching it! It’s polite. Let’s 
#' use `gapminder$continent` as our example.
str(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)
class(gapminder$continent)

#' To get a frequency table as a tibble, from a tibble, use `dplyr::count()`. 
#' To get similar from a free-range factor, use `forcats::fct_count()`
gapminder %>%
  count(continent)
fct_count(gapminder$continent)

#' ### Dropping unused factor
#' Watch what happens to the levels of `country` (= nothing) when we filter 
#' Gapminder to a handful of countries.
nlevels(gapminder$country)
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries)
nlevels(h_gap$country)

#' Even though `h_gap` only has data for a handful of countries, we are still 
#' schlepping around all 142 levels from the original `gapminder` tibble.  
#' 
#' How can you get rid of them? The base function `droplevels()` operates on 
#' all the factors in a data frame or on a single factor. The function 
#' `forcats::fct_drop()` operates on a factor.
h_gap_dropped <- h_gap %>%
  droplevels()
nlevels(h_gap_dropped$country)

# use forcats::fct_drop() on a free-range factor
h_gap$country %>%
  fct_drop() %>%
  levels()

#' Change order of the levels, principled
#' By default, factor levels are ordered alphabetically.  
#' It is preferable to order the levels according to some principle:  
#' 
#' * Frequency. Make the most common level the first and so on.  
#' * Another variable. **Example**: order Gapminder countries by life expectancy.  
#' 
#' First, let’s order continent by frequency, forwards and backwards. This is 
#' often a great idea for tables and figures, esp. frequency barplots.

# default order is alphabetical
gapminder$continent %>%
  levels()

# order by frequency
gapminder$continent %>%
  fct_infreq() %>%
  levels()

# backward!
gapminder$continent %>%
  fct_infreq() %>%
  fct_rev() %>%
  levels()

#' These two barcharts of frequency by continent differ only in the order of the 
#' continents. Which do you prefer?
#+ r barplot, echo = FALSE, out.width = '50%'
gapminder$continent %>% 
  as.data.frame() %>% 
  ggplot(aes(y = .)) + geom_bar() 

gapminder$continent %>% 
  fct_infreq() %>%
  fct_rev() %>%
  as.data.frame() %>% 
  ggplot(aes(y = .)) + geom_bar() 

#' Now we order country by another variable, forwards and backwards.  
#' The factor is the grouping variable and the default summarizing function is 
#' `median()` but you can specify something else.
# order countries by median life expectancy
fct_reorder(gapminder$country, gapminder$lifeExp) %>%
  levels() %>% 
  head()

# order accoring to minimum life expectancy instead of median
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>%
  levels() %>% 
  head()

# backward!
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>%
  levels() %>% 
  head()

#' Example of why we reorder factor levels: often makes plots much better!
#' Compare the interpretability of these two plots of life expectancy in Asian 
#' countries in 2007. The only difference is the order of the `country` factor. 
#' Which one do you find easier to learn from?
#+ r reorderplot, eval = FALSE
gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = country)) + geom_point()

gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = fct_reorder(country, lifeExp))) + geom_point()

#+ r plotreorder, echo = FALSE, out.width = '50%'
gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = country)) + geom_point()
gapminder %>%
  filter(year == 2007,continent == "Asia") %>%
  ggplot(aes(x = lifeExp, y = fct_reorder(country, lifeExp))) + geom_point()
#' Use `fct_reorder2()` when you have a line chart of a quantitative x against 
#' another quantitative y and your factor provides the color. This way the 
#' legend appears in some order as the data!
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
h_gap <- gapminder %>%
  filter(country %in% h_countries) %>%
  droplevels()
#+ r reorder2plot, eval = FALSE
h_gap %>%
  ggplot(aes(x = year, y = lifeExp, color = country)) +
  geom_line()

h_gap %>%
  ggplot(aes(x = year, y = lifeExp, 
             color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")

#+ r reorderplot2, echo = FALSE, out.width = '50%'
h_gap %>%
  ggplot(aes(x = year, y = lifeExp, color = country)) +
  geom_line()
h_gap %>%
  ggplot(aes(x = year, y = lifeExp, 
             color = fct_reorder2(country, year, lifeExp))) +
  geom_line() +
  labs(color = "country")

#' Sometimes you just want to hoist one or more levels to the front. Why? 
#' Because I said so.
h_gap$country %>% levels()
h_gap$country %>% fct_relevel("Romania", "Haiti") %>% levels()

#' This might be useful if you are preparing a report for, say, the Romanian 
#' government. The reason for always putting Romania first has nothing to do 
#' with the data, it is important for external reasons and you need a way to 
#' express this.  
#' 
#' Sometimes you have better ideas about what certain levels should be. This is 
#' called recoding.
i_gap <- gapminder %>%
  filter(country %in% c("United States", "Sweden", "Australia")) %>%
  droplevels()
i_gap$country %>% levels()
i_gap$country %>%
  fct_recode("USA" = "United States", "Oz" = "Australia") %>%
  levels()

#' ### Grow a factor
#' Let’s create two data frames, each with data from two countries, dropping 
#' unused factor levels.
df1 <- gapminder %>%
  filter(country %in% c("Indonesia", "Japan"), year > 2000) %>%
  droplevels()
df2 <- gapminder %>%
  filter(country %in% c("Haiti", "Germany"), year > 2000) %>%
  droplevels()

#' The `country` factors in `df1` and `df2` have different levels
levels(df1$country)
levels(df2$country)

#' Can you just combine them?
c(df1$country, df2$country)

#' Umm, no. That is wrong on many levels! Use `fct_c()` to do this.
fct_c(df1$country, df2$country)

#' **Exercise**: Explore how different forms of row binding work behave here, in 
#' terms of the country variable in the result.

bind_rows(df1, df2)
rbind(df1, df2)
