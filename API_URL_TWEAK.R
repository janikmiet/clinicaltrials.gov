

# Maksimimäärä hakuehtoja condition 169 kpl. Mutta toimivaksi havaittu 150.  
conditions <- readr::read_csv2("./doc/conditions.csv")
conditions <- head(unique(conditions$Condition), 150)
# conditions <- unique(conditions$Condition)
cond <- paste0("(AREA[Condition]",conditions,")", collapse = "%20OR%20")
base_url <- paste0("https://clinicaltrials.gov/api/query/full_studies?expr=(Finland) AND (SEARCH[Study]",cond,") AND SEARCH[Location](AREA[LocationCountry]Finland) AND SEARCH[Study](AREA[OverallStatus]Recruiting)")
writeLines(URLencode(base_url), con = "url.txt")

base_url <- readLines("url.txt")
url <- paste0(base_url, "&min_rnk=", min_rnk,"&max_rnk=", max_rnk,"&fmt=json")

# # Test it
# r <- GET(url = url)
# http_status(r)

res <- fromJSON(content(GET(url)))
df <- as_tibble(res$FullStudiesResponse$FullStudies)

