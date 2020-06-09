#' ---
#' title: "Introduction to tidyr"
#' author: "I Putu Eddy Irawan"
#' date: "09/06/2020"
#' output: github_document
#' always_allow_html: true
#' ---

#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' ### Overview
#' It is often said that 80% of data analysis is spent on the cleaning and 
#' preparing data. The principles of tidy data provide a standard way to 
#' organise data values within a dataset.
#' 
#' The goal of tidyr is to help you create **tidy data**. Tidy data is data where:  
#' 1. Every column is variable.  
#' 2. Every row is an observation.  
#' 3. Every cell is a single value.
#' 
#' If you ensure that your data is tidy, you’ll spend less time fighting with 
#' the tools and more time working on your analysis.  
#' 
#' ### Defining tidy data
#' Like families, tidy datasets are all alike but every messy dataset is messy 
#' in its own way. Tidy datasets provide a standardized way to link the 
#' structure of a dataset (its physical layout) with its semantics (its meaning).
#' 
#' ### Data structure
#' Most statistical datasets are data frames made up of **rows** and **columns**. 
#' The columns are almost always labeled and the rows are sometimes labeled. 
#' The following code provides some data about an imaginary classroom in a 
#' format commonly seen in the wild. The table has three columns and four rows, 
#' and both rows and columns are labeled.
classroom <- read.csv("data/classroom.csv", stringsAsFactors = FALSE)
classroom

#' There are many ways to structure the same underlying data. The following table
#' shows the same data as above, but the rows and columns have been transposed.
read.csv("data/classroom2.csv", stringsAsFactors = FALSE)

#' The data is the same, but the layout is different. Our vocabulary of rows and 
#' columns is simply not rich enough to describe why the two tables represent 
#' the same data. In addition to appearance, we need a way to describe the 
#' underlying semantics, or meaning, of the values displayed in the table.

#' ### Installation
#+ r installtidyverse, eval = FALSE, collapse = TRUE
# The easiest way to get tidyr is to install the whole tidyverse:
install.packages("tidyverse")

# Alternatively, install just tidyr:
install.packages("tidyr")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("tidyverse/tidyr")

#' ### Data tidying
#' A tidy version of the classroom data looks like this: (you’ll learn how the 
#' functions work a little later)
#+ r library
library(tidyverse)

classroom
#' This dataset contains three variables:  
#' * `name`, stored in the rows,  
#' * `assessment` spread across the columns names, and  
#' * `grade` stored in the cell values  
#' 
#' #### Longer
#' `pivot_longer()` makes datasets longer by increasing the number of rows and 
#' decreasing the number of columns.
#'
classroom2 <- classroom %>%
  pivot_longer(quiz1:test1, names_to = "assessment", values_to = "grade") %>%
  arrange(name, assessment)
classroom2
#' * The first argument is the dataset to reshape, `classroom`  
#' * The second argument describes which columns need to be reshaped. In this 
#' case, it’s every column apart from `name`.  
#' * The `names_to` gives the name of the variable that will be created from the 
#' data stored in the column names, i.e. `assessment`.
#' * The `values_to` gives the name of the variable that will be created from 
#' the data stored in the cell value, i.e. `grade`.  
#' 
#' This makes the values, variables, and observations more clear. The dataset 
#' contains 36 values representing three variables and 12 observations. 
#' The variables are:  
#' 1. `name`, with four possible values (Billy, Suzy, Lionel, and Jenny).  
#' 2. `assessment`, with three possible values (quiz1, quiz2, and test1).  
#' 3. `grade`, with five or six values depending on how you think of the missing 
#' value (A, B, C, D, F, NA).  
#' 
#' #### Wider
#' `pivot_wider()` is the opposite of `pivot_longer()`: it makes a dataset wider 
#' by increasing the number of columns and decreasing the number of rows.
# Creating summary tables similar to data structure from file: classroom2.csv
classroom2 %>%
  pivot_wider(names_from = name, values_from = grade)

#' ### Lord of the Rings example
#' ***
#' We have untidy data per movie. In each table, we have the total number of words spoken, 
#' by characters of different races and genders.  
#' 
#+ r The_Fellowship_Of_The_Ring, echo = FALSE, result = 'asis'
The_Fellowship_Of_The_Ring <- read.table("data/The_Fellowship_Of_The_Ring.csv", header = TRUE, sep = ",")
knitr::kable(The_Fellowship_Of_The_Ring %>% select(-Film), caption = "The Fellowship Of The Ring")

The_Two_Towers <- read.table("data/The_Two_Towers.csv", header = TRUE, sep = ",")
knitr::kable(The_Two_Towers %>% select(-Film), caption = "The Two Towers")

The_Return_Of_The_King <- read.table("data/The_Return_Of_The_King.csv", header = TRUE, sep = ",")
knitr::kable(The_Return_Of_The_King %>% select(-Film), caption = "The Return Of The King")

#' This data has been formatted for consumption by *human*. The format makes it 
#' easy for a *human* to look up the number of words spoken by female elves in 
#' The Two Towers. But this format actually makes it pretty hard for a *computer* 
#' to pull out such counts and, more importantly, to compute on them or graph them.
#' 
#' #### Collect untidy Lord Of The Rings data into a single data frame
#' We now have one data frame per film, each with a common set of 4 variables. 
#' Step one in tidying this data is to glue them together into one data frame, 
#' stacking them up row wise. This is called row binding and we use `dplyr::bind_rows()`.
lotr_untidy <- bind_rows(The_Fellowship_Of_The_Ring, 
                       The_Two_Towers, 
                       The_Return_Of_The_King)
str(lotr_untidy)
lotr_untidy

#' #### Tidy the untidy Lord Of The Rings data
#' We need to gather up the word counts into a single variable and create a new 
#' variable, `Gender`, to track whether each count refers to females or males. 
#' We use the `gather()` function from the tidyr package to do this.
lotr_tidy <- 
  gather(lotr_untidy, key = "Gender", value = "Words", Female, Male)
lotr_tidy

#' Tidy data … mission accomplished!  
#' 
#' #### Exercises
#' Look at the tables above and answer these questions:  
#' * What’s the total number of words spoken by male hobbits?  
#' * Does a certain Race dominate a movie? Does the dominant Race differ across 
#' the movies?  
#' 
#' Here’s how the same data looks in tidy form:
#+ r lotrtidy, echo = FALSE, result = 'asis'
lotr_tidy <- lotr_untidy %>%
  pivot_longer(Female:Male, names_to = "Gender", values_to = "Words")
knitr::kable(lotr_tidy)

#' With the data in tidy form, it’s natural to get a computer to do further 
#' summarization or to make a figure. Let’s answer the questions posed above.  
#' 
#' ##### What’s the total number of words spoken by male hobbits?
lotr_tidy %>%
  count(Race, Gender, wt = Words)

#' The total number of words spoken by male hobbits is 8780. It was important 
#' here to have all word counts in a single variable, within a data frame that 
#' also included a variables for gender and race.  
#'  
#' ##### Does a certain race dominate a movie? Does the dominant race differ across the movies?
#' 
#' First, we sum across gender, to obtain word counts for the different races 
#' by movie.
lotr_tidy %>%
  group_by(Film, Race) %>%
  summarize(Words = sum(Words))

#' #### Spread
#' Practicing with `spread()`: let's get one variable per Race
lotr_tidy %>%
  spread(key = Race, value = Words)
