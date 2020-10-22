## clinicaltrials.gov

### Workflow

1. hae ensin montako triali löytyy (ja niiden id:t)

2. hae sitten 100 tulosta kerralla trialin full infot

3. hae sitten trialien descriptionit

4. joinaa tulokset


## solve the problems

- get right results / api call
- nested tibble to data frame or refering right way
- 


```
library(httr)
library(jsonlite)
library(tibble)

url <- "https://clinicaltrials.gov/api/query/full_studies?expr=finland%26field%3Dlocation&min_rnk=1&max_rnk=20&fmt=json"
res <- fromJSON(content(GET(url)))
df <- as_tibble(res$FullStudiesResponse$FullStudies)

```