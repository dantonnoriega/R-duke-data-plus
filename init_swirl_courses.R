## init_swirl_courses.R
##  -- run this script to install all the beginner, intermediate, and advanced courses for swirl

install.packages("swirl", dep = T)

library(swirl)

# create vector of courses
courses <- c("Data_Analysis", "Exploratory_Data_Analysis", "Getting_and_Cleaning_Data", "Mathematical_Biostatistics_Boot_Camp",
    "Open_Intro", "R_Programming_Alt", "Regression_Models", "Statistical_Inference")

# install courses
invisible(lapply(courses, install_from_swirl))

# run swirl
# recommended that one do the "R_Programming_Alt" class
swirl()