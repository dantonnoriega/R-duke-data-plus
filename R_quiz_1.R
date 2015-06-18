
date()
sessionInfo()
library(data.table)

# IMPORT DATA -------------------------
## import the file 'becr_ssb_upc_data+.csv' and assign it to a data table `dt`





# CLEANING DATA -----------------------
## drop variable `department` from data table `dt`


## investigate column `nfp_serv_units` using function `table()`.


## convert ALL serving sizes UNITS to "oz".


## replace NA values of `volume` with corresponding values of `nfp_serv_size_us`


## replace NA values of `count` with 1 (one)





# CREATE NEW VARS ------------------------
## CREATE two new variables: `tot_sugars` and `tot_sodium`.
##  that is, how much total sugar/sodium is contained in `tot_volume` by
##  using `nfp_serv_size_us` to convert.


## consider that anything with `count` > 1 is a "pack". CREATE a new variable `pack`
##  equal to 0 if a pack, else equal to 1





# EXTRACT DATA ---------------------------
## CREATE a new data.table named `product_count` that counts total products/upc by product.
##  the table should contain only two variables: `product` and `count`
##  HINT: use 'by' and the special variable '.N'


## set the keys to `count`, `product` so that it sorts by count then product





# AGGREGATED BY VARIABLES ----------------
## create a new data.table `dt_avg` that contains the average total sugar and sodium,
##  `avg_tot_sugars` and `avg_tot_sodium`, by product and pack.
## HINT 1: if you use the function `mean()`, make sure you use the option `na.rm` --- see ?mean
## HINT 2: it's easier to rename the variables of average values AFTER they've been computed.





# MERGE -----------------------
## merge data tables `product_count` and `dt_avg` and name the new data table `dt_m`





################################

# PLOTTING -------------------------------------
library(ggplot2)
library(lattice)
## create the provided HISTOGRAMS using loops and package ggplot2
## HINT: loop through a list of vectors with `lapply` and
##      a function that can plot e.g. function(x) qplot(x)
## BASIC HISTOGRAM
##  dataset:            dt_m
##  variables:          "product", "aisle"
##  plotting function:  qplot



## ADVANCED
##  dataset:    dt_m
##  variables:  "product", c("avg_tot_sugars", "avg_tot_sodium")
##  function:   qplot
##  options used:
##      - geom = "bar"
##      - position = "dodge"
##      - fill = factor(dt_m[["pack"]])
##      - stat = "identity"


