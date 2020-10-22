# Read dataset and wrangle


## SIMPLE ------

## Read the latest file
fils <- list.files("data/")
latest <- fils[order(format(as.Date(substr(fils, 1, 10), format = "%Y-%m-%d")), decreasing = T)[1]]
d <- readr::read_csv2(paste0("data/", latest))
# d <- readr::read_csv2("./data/simple/2020-10-05_clinical_trials.csv") ## manual file read
