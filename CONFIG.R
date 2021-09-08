# BASE_URL.txt -----
# Search definition is created from 'doc/conditions.csv' (search condition keywords, check for example)
# Write search criteria base_url.txt (URL without min and max rank and fmt)
library(httr)
library(tidyverse)
conditions <- readr::read_csv2("./doc/conditions.csv")
# conditions <- conditions[order(conditions$Studies, decreasing = T),]
# conditions <- unique(conditions$Condition)
# conditions <- head(unique(conditions$Condition), 160)
# conditions <- head(unique(conditions$Conditions), 170)
cond <- paste0("(AREA[Condition]",conditions$Conditions,")", collapse = "%20OR%20")
base_url <- paste0("https://clinicaltrials.gov/api/query/full_studies?expr=(Finland)%20AND%20(SEARCH[Study]",cond,")%20AND%20SEARCH[Location](AREA[LocationCountry]Finland)%20AND%20SEARCH[Study](AREA[OverallStatus]Recruiting)")
base_url <- gsub(pattern = " ", replacement = "%20", x = base_url)
writeLines(URLencode(base_url), con = "base_url.txt")
rm(list = c("cond", "conditions", "base_url"))

### Test if URL gives results ----
r <- GET(url = readLines("base_url.txt"))
http_status(r)

# ## Download example set (first 100 results)
# library(jsonlite)
# base_url <- readLines("base_url.txt")
# url <- URLencode(paste0(base_url, "&min_rnk=1&max_rnk=100&fmt=json"))
# res <- fromJSON(content(GET(url)))
# df <- as_tibble(res$FullStudiesResponse$FullStudies)

