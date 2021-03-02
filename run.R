## CLINICAL TRIALS WEBPAGE/DATABASE

library(tidyverse)
clean_folders <- TRUE # This cleans ./temp and ./output folders before rendering files



# Load global.R and dataset ----
source("global.R")
source("load_data.R")



# Create and clean directories -----
if(!dir.exists("temp/")) dir.create("temp/")
if(!dir.exists("temp/trials")) dir.create("temp/trials")
if(!dir.exists("output/")) dir.create("output/")
if(!dir.exists("output/trials")) dir.create("output/trials")

## Remove all files from ./temp
if(clean_folders){
  fils <- list.files("temp/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}

## Remove all files from ./output
if(clean_folders){
  fils <- list.files("output/", full.names = T, recursive = T)
  for (fil in fils) {
    file.remove(fil)
  }
}



# Create RMD-pages -----
# This creates rmd-pages to ./temp/ 
for (i in 1:nrow(d)) {
  d1 <- d[i,]
  # d1 <- d[d$NCTId == "NCT00342992",] #TODO problem occurs!!!
  
  # read template
  template <- readr::read_file("template.Rmd")
  # replace keywords and description
  template <- stringr::str_replace_all(string = template, 
                                       pattern = "xxx-Trial-Identifier-xxx",
                                       replacement = check_na(d1$NCTId))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title-xxx",
                                       replacement = check_na(d1$BriefTitle))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title2-xxx",
                                       replacement = check_na(d1$OfficialTitle))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Description-xxx",
                                       replacement = check_na(d1$BriefSummary))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-DetailedDescription-xxx",
                                       replacement = check_na(d1$DetailedDescription))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Keywords-xxx",
                                       replacement = paste0(unlist(check_null(d1$Keyword)), collapse = ", "))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-LastKnownStatus-xxx",
                                       replacement = as.character(check_na(d1$LastKnownStatus)))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-OverallStatus-xxx",
                                       replacement = as.character(check_na(d1$OverallStatus)))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Phase-xxx",
                                       replacement = paste(unlist(check_null(d1$Phase)), collapse = ",")) ### check this
  ## Study design
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-StudyType-xxx",
                                       replacement = check_na(d1$StudyType))
  # template <- stringr::str_replace_all(string = template,
  #                                      pattern = "xxx-Study-Design-xxx",
  #                                      replacement = check_na(d1$StudyType))
  ## Subjects
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Minimum-xxx",
                                       replacement = check_na(d1$MinimumAge))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Maximum-xxx",
                                       replacement = check_na(d1$MaximumAge))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Gender-xxx",
                                       replacement = check_na(d1$Gender))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Healthy-Subject-xxx",
                                       replacement = check_na(d1$HealthyVolunteers))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Participants-Criteria-Inclusion-xxx",
                                       replacement = check_na(d1$EligibilityCriteria))
  ### Contacts etc
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-ResponsibleParty-xxx",
                                       replacement = check_na(d1$ResponsiblePartyType))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-ResponsibleInvestigator-xxx",
                                       replacement = paste0(check_na(d1$ResponsiblePartyInvestigatorFullName), 
                                                            ", ", check_na(d1$ResponsiblePartyInvestigatorTitle),
                                                            ", ", check_na(d1$ResponsiblePartyInvestigatorAffiliation)) )
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Sponsor-Name-xxx",
                                       replacement = check_na(d1$LeadSponsorName))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Collaborators-xxx",
                                       replacement = paste0(unlist(check_null(d1$Collaborators)), collapse = ", ")) #DF

  
  # save as new file
  writeLines(template, paste0("./temp/trials/", d1$NCTId,".Rmd"))
}



# Render webpages  ----
## This renders rmd pages to ./output
pages <- list.files("temp/trials/", full.names = T)
for(page in pages){
  rmarkdown::render(page, output_dir = "output/trials/")
}
## Create index
rmarkdown::render("index.Rmd", output_dir = "output/")




# Upload to web ----

# move files to kapsi
# system("scp -r ./output/* neurocenterfinland@neurocenterfinland.fi-h.seravo.com:/home/neurocenterfinland/wordpress/htdocs/kliiniset-tutkimukset")

