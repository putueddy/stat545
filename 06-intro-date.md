Introduction to date
================
I Putu Eddy Irawan
13/06/2020

# Dates and times

Install the nycflights13 for practice data from CRAN

``` r
install.packages("nycflights13")
```

Use base `Sys.Date()` or lubridate’s `today()` to get today’s date,
without any time.

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
library(lubridate)
## 
## Attaching package: 'lubridate'
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
library(nycflights13)

Sys.Date()
## [1] "2020-06-13"
today()
## [1] "2020-06-13"
```

They both give you something of class Date.

``` r
str(Sys.Date())
##  Date[1:1], format: "2020-06-13"
class(Sys.Date())
## [1] "Date"
str(today())
##  Date[1:1], format: "2020-06-13"
class(today())
## [1] "Date"
```

Use base `Sys.time()` or lubridate’s `now()` to get RIGHT NOW, meaning
the date and the time.

``` r
Sys.time()
## [1] "2020-06-13 01:20:58 WIB"
now()
## [1] "2020-06-13 01:20:58 WIB"
```

They both give you something of class POSIXct in R jargon.

``` r
str(Sys.time())
##  POSIXct[1:1], format: "2020-06-13 01:20:58"
class(Sys.time())
## [1] "POSIXct" "POSIXt"
str(now())
##  POSIXct[1:1], format: "2020-06-13 01:20:58"
class(now())
## [1] "POSIXct" "POSIXt"
```

Get date or date-time from character

``` r
ymd("2020-06-14")
## [1] "2020-06-14"
mdy("June 14th, 2020")
## [1] "2020-06-14"
dmy("14-06-2020")
## [1] "2020-06-14"
```

Build date or date-time from parts Instead of a single string, sometimes
you’ll have the individual components of the date-time spread across
multiple columns. This is what we have in the flights data:

``` r
flights %>%
  select(year, month, day, hour, minute)
## # A tibble: 336,776 x 5
##     year month   day  hour minute
##    <int> <int> <int> <dbl>  <dbl>
##  1  2013     1     1     5     15
##  2  2013     1     1     5     29
##  3  2013     1     1     5     40
##  4  2013     1     1     5     45
##  5  2013     1     1     6      0
##  6  2013     1     1     5     58
##  7  2013     1     1     6      0
##  8  2013     1     1     6      0
##  9  2013     1     1     6      0
## 10  2013     1     1     6      0
## # … with 336,766 more rows
```

To create a date/time from this sort of input, use `make_date()` for
dates, or `make_datetime()` for date-times:

``` r
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))
## # A tibble: 336,776 x 6
##     year month   day  hour minute departure          
##    <int> <int> <int> <dbl>  <dbl> <dttm>             
##  1  2013     1     1     5     15 2013-01-01 05:15:00
##  2  2013     1     1     5     29 2013-01-01 05:29:00
##  3  2013     1     1     5     40 2013-01-01 05:40:00
##  4  2013     1     1     5     45 2013-01-01 05:45:00
##  5  2013     1     1     6      0 2013-01-01 06:00:00
##  6  2013     1     1     5     58 2013-01-01 05:58:00
##  7  2013     1     1     6      0 2013-01-01 06:00:00
##  8  2013     1     1     6      0 2013-01-01 06:00:00
##  9  2013     1     1     6      0 2013-01-01 06:00:00
## 10  2013     1     1     6      0 2013-01-01 06:00:00
## # … with 336,766 more rows
```

Get parts from date or date-time

``` r
datetime <- now()

year(datetime)
## [1] 2020
month(datetime)
## [1] 6
mday(datetime) #day of the month
## [1] 13

yday(datetime) #day of the year
## [1] 165
wday(datetime) #day of the week
## [1] 7
```
