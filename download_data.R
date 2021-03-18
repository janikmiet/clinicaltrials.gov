# Download dataset and wrangle
library(httr)
library(jsonlite)
library(tibble)
library(dplyr)

if(TRUE){
  min_rnk=1
  max_rnk=100
  i=1
  more_studies=TRUE
  base_url <- readLines("base_url.txt")
  trials_final <- dplyr::tibble()
  ## Start data gathering
  while (more_studies) {
    ## Get data
    message(paste0("Downloading dataset ",i, " // ", Sys.time()))
    # url <- paste0("https://clinicaltrials.gov/api/query/full_studies?expr=(Brain%20OR%20head)%20and%20SEARCH[Location](AREA[LocationCountry]Finland)%20and%20SEARCH[Study](AREA[OverallStatus]Recruiting)&min_rnk=",min_rnk,"&max_rnk=",max_rnk,"&fmt=json")
    url <- paste0(base_url, "&min_rnk=", min_rnk,"&max_rnk=", max_rnk,"&fmt=json")
    res <- fromJSON(content(GET(url)))
    df <- as_tibble(res$FullStudiesResponse$FullStudies)
    ## Get more studies
    if(nrow(df) == 100){
      min_rnk = min_rnk + 100
      max_rnk = max_rnk + 100
      i = i + 1
    }else{
      more_studies <- FALSE
    }
    ## Join data
    if(nrow(trials_final) <= 0){
      trials_final <- df
    }else{
      trials_final <- trials_final %>% 
        bind_rows(df)
    }
  }
  ## Save dataset
  rm(list = c("df", "res", "url", "min_rnk", "max_rnk","more_studies", "i"))
  message(paste0("Saving full dataset. Found ", nrow(trials_final), " trials // ", Sys.time()))
  saveRDS(trials_final, file = paste0("./data/",Sys.Date(), "_trials.rds"))
} 
