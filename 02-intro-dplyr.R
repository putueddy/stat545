#' ---
#' title: "Introduction to dplyr"
#' author: "I Putu Eddy Irawan"
#' date: "07/06/2020"
#' output: github_document
#' ---

#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' ### 1. Load dpylr and gapminder
#' I choose to load tidyverse, which will load dplyr among other packages we 
#'  use incidentally below
#+ r tidyverse
library(tidyverse)

#' Also load gapminder.
#+ r gapminder
library(gapminder)

#' Say hello to the `gapminder` tibble
#+ r printgapminder
gapminder

#' Note how gapminder’s `class()` includes `tbl_df`; the “tibble” terminology 
#' is a nod to this.
#+ r classgapminder
class(gapminder)

#' Go type `iris` in the R Console or print a data frame to screen that 
#' has lots of columns. Too crowded isn't it?
#' To turn any data frame into a tibble use `as_tibble()`:
#+ r astibble
as_tibble(iris)

#' ### 2. Data aggregation techniques
#' > Do you want to create mini datasets for each level of some factor 
#' (or unique combination of several factors) … in order to compute or 
#' graph something?
#'
#' * Use `filter()` to subset data row-wise.
#+ r filter
filter(gapminder, lifeExp < 29)
filter(gapminder, country == "Indonesia", year > 1979)
filter(gapminder, country %in% c("Indonesia", "Rwanda"))

#' * Meet the new pipe operator.
#+ r pipe
gapminder %>% head()
#' This is equivalent to head(gapminder). The pipe operator takes the thing on 
#' the left-hand-side and pipes it into the function call on the right-hand-side.
#' 
#' You can still specify other arguments to this function! 
#' To see the first 3 rows of `gapminder`, we could say `head(gapminder, 3)` 
#' or this:
#+ r pipeargs
gapminder %>% head(3)

#' * Use `select()` to subset the data on variables or columns.
#+ r selectdplyr
select(gapminder, year, lifeExp)

#' And here’s the same operation, but written with the pipe operator and 
#' piped through `head()`:
#+ r pipeselect
gapminder %>% 
  select(year, lifeExp) %>%
  head(4)

#' The data is **always** the very first argument of the verb functions.
#' 
#' * Use `mutate()` to add new variables  
#' First, we're going to create copy of gapminder, to eliminate any fear that
#' you're damaging the data for our experiments.
#+ r copygapminder
(my_gap <- gapminder)

#' 
#+ r mygap, eval = FALSE, collapse = TRUE
## let print output to screen, but do not store
my_gap %>% filter(country == "Indonesia")

#' when we assign the output to an object, possibly overwriting an existing 
#' object.
my_country <- my_gap %>% filter(country == "Indonesia")

#' `mutate()` is a function that defines and inserts new variables into a 
#' tibble. Let’s multiply population and GDP per capita.
my_gap %>%
  mutate(gdp = pop * gdpPercap)

#' This is how to achieve a new variable that is `gdpPercap` divided by Indonesia
#' `gdpPercap`:
#' 1. Filter down to rows for Indonesia.
#' 2. Create a new temporary variable in `my_gap`:
#'   i. Extract the `gdpPercap` variable from Indonesian data.
#'   ii. Replicate it once per country in the dataset, so it has the right length.
#' 3. Divide raw `gdpPercap` by this Indonesian figure.
#' 4. Discard the temporary variable of replicated Indonesia `gdpPercap`.
indo <- my_gap %>%
  filter(country == "Indonesia")
my_gap <- my_gap %>%
  mutate(tmp = rep(indo$gdpPercap, nlevels(country)),
         gdpPercapRel = gdpPercap / tmp,
         tmp = NULL)

#' Sanity check that Indonesian value for `gdpPercapRel` all be 1.
my_gap %>%
  filter(country == "Indonesia") %>%
  select(country, year, gdpPercapRel)

#' I perceive Indonesia to be a "high GDP" country, so I predict that the
#' distribution of gdpPercapRel is below 1. Check your intuition!
summary(my_gap$gdpPercapRel)

#' Oops... we see that most of the countries covered by this dataset have higher 
#' GDP per capita, relative to Indonesia, across the entire time period.  
#' 
#' Remember: Trust No One. Including yourself. Always try to find a way to check
#' that yo've done what meant to.
#' 
#' * Use `arrange()` to row-order data in a principled way 
#' `arrange()` reorders the rows in a data frame. Imagine you wanted this data 
#' ordered by year then country, as opposed to by country then year.
my_gap %>%
  arrange(year, country)

#' Or maybe you want just the data from 2007, sorted on life expectancy in 
#' descending order? Then use `desc()`.
my_gap %>%
  filter(year == 2007) %>%
  arrange(desc(lifeExp))

#' * Use `rename()` to rename variables
#' 
my_gap %>%
  rename(life_exp = lifeExp,
         gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)

#' * `select()` can rename and reposition variables
#' 
#' You’ve seen simple use of `select()`. There are two tricks you might enjoy:  
#' 1. `select()` can rename the variables you request to keep.  
#' 2. `select()` can be used with `everything()` to hoist a variable up the 
#' front of the tibble
my_gap %>%
  filter(country == "Canada", year > 1996) %>%
  select(yr = year, lifeExp, gdpPercap) %>%
  select(gdpPercap, everything())

#' * `group_by()` is mighty weapon
#' 
#' “which country experienced the sharpest 5-year drop in life expectancy?”  
#' In fact, that is a totally natural question to ask. But if you are using 
#' a language that doesn’t know about data, it’s an incredibly annoying
#' question to answer.  
#'
#' dplyr offers powerful tools to solve this class of problem:  
#' 1. `group_by()` adds extra structure to your dataset – grouping information.  
#' 2. `summarize()` takes a dataset with `n` observations, computes requested 
#' summaries, and returns a dataset with 1 observation.  
#' 3. Window functions take a dataset with `n` observations and return a 
#' dataset with `n` observations.  
#' 4. `mutate()` and `summarize()` will honor groups.  
#' 5. You can also do very general computations on your groups with `do()`.  
#' 
#' Combined with the verbs you already know, these new tools allow you to solve 
#' an extremely diverse set of problems with relative ease.
#' 
my_gap %>%
  group_by(continent) %>%
  summarise(n = n())

#' Let us pause here to think about the tidyverse. You could get these same 
#' frequencies using `table()` from base R.
table(gapminder$continent)
str(table(gapminder$continent))

#' The `tally()` function is a convenience function that knows to count rows. 
#' It honors groups.
my_gap %>%
  group_by(continent) %>%
  tally()

#' The `count()` function is an even more convenient function that does both 
#' grouping and counting.
my_gap %>%
  count(continent)

#' What if we wanted to add the number of unique countries for each continent? 
#' You can compute multiple summaries inside `summarize()`. Use the 
#' `n_distinct()` function to count the number of distinct countries within 
#' each continent.
my_gap %>%
  group_by(continent) %>%
  summarize(n = n(),
            n_countries = n_distinct(country))

#' * General summarization
#' The functions you’ll apply within summarize() include classical statistical
#' summaries, like `mean()`, `median()`, `var()`, `sd()`, `mad()`, `IQR()`, 
#' `min()`, and `max()`. Remember they are functions that take n inputs and 
#' distill them down into 1 output.
my_gap %>%
  group_by(continent) %>%
  summarise(avg_life_exp = mean(lifeExp))

#' `summarize_at()` applies the same summary function(s) to multiple variables. 
#' Let’s compute average and median life expectancy and GDP per capita by 
#' continent by year…but only for 1952 and 2007.
my_gap %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarize_at(vars(lifeExp, gdpPercap), list(~mean(.), ~median(.)))

#' Let’s focus just on Asia. What are the minimum and maximum life expectancies 
#' seen by year?
my_gap %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))

#' * Computing with group-wise summaries
#' 
#' Let’s make a new variable that is the years of life expectancy gained (lost) 
#' relative to 1952, for each individual country. We group by country and use 
#' `mutate()` to make a new variable. The `first()` function extracts the 
#' first value from a vector.
my_gap %>%
  group_by(country) %>%
  select(country, year, lifeExp) %>%
  mutate(lifeExp_gain = lifeExp - first(lifeExp)) %>%
  filter(year < 1963)

#' * Windows functions
#' 
#' Window functions take `n` inputs and give back `n` outputs. Furthermore, 
#' the output depends on all the values. So `rank() `is a window function but 
#' `log()` is not.
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>%
  arrange(year)

#' If we had wanted just the min OR the max, an alternative approach using 
#' `top_n()` would have worked.
my_gap %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  top_n(1, wt = desc(lifeExp))

#' So let’s answer that “simple” question: which country experienced the 
#' sharpest 5-year drop in life expectancy?
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
