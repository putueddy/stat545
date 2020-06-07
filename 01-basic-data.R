#' ---
#' title: "Basic care and feeding of data in R"
#' author: "I Putu Eddy Irawan"
#' date: "07/06/2020"
#' output: github_document
#' ---

#' ### 1. Meet the `gapminder` data frame or "tibble" 
#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' Install the Gapminder data from CRAN
#+ r install, eval=FALSE
install.packages("gapminder")
#' Now load the package:
#+ r library
library(gapminder)

#' Get an overview of the Gapminder data structure 
#+ r str
str(gapminder)

#' The tidyverse offers a special case of R’s default data frame: the “tibble”, 
#' which is a nod to the actual class of these objects, `tbl_df`.
#'
#' If you have not already done so, install the tidyverse meta-package now
#+ r install2, eval=FALSE
install.packages("tidyverse")

#' Now load it:
#+ r tidyverse
library(tidyverse)

#' Prints the names of classes
#+ r class
class(gapminder)

#' Now we can print the gapminder to screen. It is a tibble (and also a regular 
#' data frame) 
#+ r gapminder
gapminder

#' Since we are dealing with plain vanilla data frames, we can rein in data 
#' frame printing explicity with `head()` and `tail()`. Or turn it into a 
#' tibble with `as_tibble()`
#+ r head
head(gapminder)
tail(gapminder)
as_tibble(iris)

#' More ways to query basic info on a data frame
#+ r query
names(gapminder)
ncol(gapminder)
length(gapminder)
dim(gapminder)
nrow(gapminder)

#' A statistical overview can be obtained with `summary()`
#+ r summary
summary(gapminder)

#'  Here we use only base R graphics, which are very basic.
#+ r plot
plot(lifeExp ~ year, gapminder)
plot(lifeExp ~ gdpPercap, gapminder)
plot(lifeExp ~ log(gdpPercap), gapminder)

#' ### 2. Look at the variables inside a data frame
#' To specify a single variable from a data frame, use the dollar sign `$`.
#' Let's explore the numeric variable of life expectancy.
#+ r lifeExp
head(gapminder$lifeExp)
summary(gapminder$lifeExp)
hist(gapminder$lifeExp)

#' The year variable is an integer variable, but since there are so few unique 
#' values it also functions a bit like a categorical variable.
#+ r year
summary(gapminder$year)
table(gapminder$year)

#' The variables for country and continent hold truly categorical information, 
#' which is stored as a factor in R.
#+ r continent
class(gapminder$continent)
summary(gapminder$continent)
levels(gapminder$continent)
nlevels(gapminder$continent)

#' The **levels** of the factor `continent` in R is stored as integer codes 
#' 1, 2, 3, etc. 
#+ r levelcontinent
str(gapminder$continent)

#' Here we count how many observations are associated with each continent and, 
#' as usual, try to portray that info visually.
#+ r tablecontinent
table(gapminder$continent)
barplot(table(gapminder$continent))

#' In the figures below, we see how factors can be put to work in figures. 
#' The continent factor is easily mapped into “facets” or colors and a legend 
#' by the ggplot2 package.
## we exploit the fact that ggplot2 was installed and loaded via tidyverse
#+ r ggplotcontinent
p <- ggplot(filter(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # initialize
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
p + geom_point(aes(color = continent)) # map continent color
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE) # geom_smooth() using method = 'gam' and formula 'y ~ s(x, bs = "cs)'
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) + 
  geom_smooth(lwd = 1.5, se = FALSE) # geom_smooth() using method = 'loess' and formula 'y ~ x'
