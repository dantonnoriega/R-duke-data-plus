date()
sessionInfo()
library(data.table)

# IMPORT DATA -------------------------
## import the file 'becr_ssb_upc_data+.csv' and assign it to a data table `dt`
main_dir <- file.path("~/Dropbox/Data+")
dt <- fread(file.path(main_dir, "becr_ssb_upc_data+.csv"))

# CLEANING DATA -----------------------
## drop variable `department` from data.table `dt`
dt[, c("department") := NULL]

## investigate column `nfp_serv_units` using function `table()`
table(dt[, .(nfp_serv_units)])

## convert ALL serving sizes UNITS to "oz".
dt[nfp_serv_units == "mL", nfp_serv_units := "oz"]

## update any NA values of `volume` to be equal to `nfp_serv_size_us`
dt[is.na(volume), volume := nfp_serv_size_us]

## update any NA values of `count` to be equal to 1 (one)
dt[is.na(count), count := 1]

# CREATE NEW VARS ------------------------
## CREATE two new variables: `tot_sugars` and `tot_sodium`.
## that is, how much total sugar/sodium is contained in `tot_volume` by
##  using `nfp_serv_size_us` to convert.
dt[, c("tot_sugars", "tot_sodium") := list(tot_volume/nfp_serv_size_us*nfp_sugars, tot_volume/nfp_serv_size_us*nfp_sodium)]

## consider that anything with `count` > 1 is a "pack".
## CREATE a new variable `pack` equal to 0 if a pack, else equal to 1
dt[, pack := 0 + (count > 1)]


# EXTRACT DATA ---------------------------
## CREATE a new data.table named `product_count` that counts total products/upc by product.
## the table should contain only two variables: `product` and `count`
## hint: use 'by' and the special variable '.N'
product_count <- dt[, list(count = .N), by = .(product)]

## set the keys to `count`, `product` so that it sorts by count then product
setkey(product_count, count, product)

# AGGREGATED BY VARIABLES ----------------
## create a new data.table `dt_avg` that contains the average total sugar and sodium,
##  `avg_tot_sugars` and `avg_tot_sodium`, by product and pack.
## HINT 1: if you use the function `mean()`, make sure you use the option `na.rm` --- see ?mean
## HINT 2: it's easier to rename the variables of average values AFTER they've been computed.
dt_avg <- dt[, lapply(.SD, mean, na.rm = T), by = .(product, pack), .SDcol = c("tot_sugars", "tot_sodium")]
setnames(dt_avg, c("tot_sugars", "tot_sodium"), c("avg_tot_sugars", "avg_tot_sodium"))

# MERGE -----------------------
## merge data tables `product_count` and `dt_avg` and name the new data table `dt_m`
dt_m <- merge(dt_avg, product_count, by = "product")

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
vars <- list(dt[["product"]], dt[["aisle"]])
hists <- lapply(vars, function(x) qplot(x))

## ADVANCED
##  dataset:            dt_m
##  variables:          "product", c("avg_tot_sugars", "avg_tot_sodium")
##  plotting function:  qplot
##  options used:
##      - geom = "bar"
##      - position = "dodge"
##      - fill = factor(dt_m[["pack"]])
##      - stat = "identity"

vars <- c("avg_tot_sugars", "avg_tot_sodium")
bar_charts <- lapply(vars, function(x) {
    qplot(dt_m[["product"]], dt_m[[x]], geom = "bar", fill = factor(dt_m[["pack"]]), position = "dodge", stat = "identity")
})
