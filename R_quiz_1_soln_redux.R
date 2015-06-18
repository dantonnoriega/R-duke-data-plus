date()
sessionInfo()
library(data.table)

# IMPORT DATA -------------------------
main_dir <- file.path("~/Dropbox/Data+")
dt <- fread(file.path(main_dir, "becr_ssb_upc_data+.csv"))

# CLEANING DATA -----------------------
dt[, c("department") := NULL]
table(dt[, .(nfp_serv_units)])
dt[nfp_serv_units == "mL", nfp_serv_units := "oz"]
dt[is.na(volume), volume := nfp_serv_size_us]
dt[is.na(count), count := 1]

# CREATE NEW VARS ------------------------
dt[, c("tot_sugars", "tot_sodium") := list(tot_volume/nfp_serv_size_us*nfp_sugars, tot_volume/nfp_serv_size_us*nfp_sodium)]
dt[, pack := 0 + (count > 1)]


# EXTRACT DATA ---------------------------
product_count <- dt[, list(count = .N), by = .(product)]
setkey(product_count, count, product)

# AGGREGATED BY VARIABLES ----------------
dt_avg <- dt[, lapply(.SD, mean, na.rm = T), by = .(product, pack), .SDcol = c("tot_sugars", "tot_sodium")]
setnames(dt_avg, c("tot_sugars", "tot_sodium"), c("avg_tot_sugars", "avg_tot_sodium"))

# MERGE -----------------------
dt_m <- merge(dt_avg, product_count, by = "product")

# PLOTTING -------------------------------------
library(ggplot2)
library(lattice)

# BASIC PLOT
vars <- list(dt[["product"]], dt[["aisle"]])
hists <- lapply(vars, function(x) qplot(x))

# ADVANCED PLOT
vars <- c("avg_tot_sugars", "avg_tot_sodium")
bar_charts <- lapply(vars, function(x) {
    qplot(dt_m[["product"]], dt_m[[x]], geom = "bar", fill = factor(dt_m[["pack"]]), position = "dodge", stat = "identity")
})
