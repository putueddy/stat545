#' ---
#' title: "Introduction to date"
#' author: "I Putu Eddy Irawan"
#' date: "13/06/2020"
#' output: github_document
#' always_allow_html: true
#' ---

#+ r setup, include=FALSE
knitr::opts_chunk$set(echo = TRUE, collapse = TRUE)

#' # Dates and times
#' Install the nycflights13 for practice data from CRAN
#+ r install, eval=FALSE
install.packages("nycflights13")

#' Use base `Sys.Date()` or lubridate’s `today()` to get today’s date, without 
#' any time.
library(tidyverse)
library(lubridate)
library(nycflights13)

Sys.Date()
today()

#' They both give you something of class Date.
str(Sys.Date())
class(Sys.Date())
str(today())
class(today())

#' Use base `Sys.time()` or lubridate’s `now()` to get RIGHT NOW, meaning the 
#' date and the time.
Sys.time()
now()

#' They both give you something of class POSIXct in R jargon.
str(Sys.time())
class(Sys.time())
str(now())
class(now())

#' Get date or date-time from character
ymd("2020-06-14")
mdy("June 14th, 2020")
dmy("14-06-2020")

#' Build date or date-time from parts
#' Instead of a single string, sometimes you’ll have the individual components 
#' of the date-time spread across multiple columns. This is what we have in the 
#' flights data:
flights %>%
  select(year, month, day, hour, minute)

#' To create a date/time from this sort of input, use `make_date()` for dates, or 
#' `make_datetime()` for date-times:
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

#' Get parts from date or date-time
datetime <- now()

year(datetime)
month(datetime)
mday(datetime) #day of the month

yday(datetime) #day of the year
wday(datetime) #day of the week
