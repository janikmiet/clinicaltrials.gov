## CLINICAL TRIALS WEBPAGE/DATABASE

library(tidyverse)
clean_folders <- TRUE # This cleans ./temp and ./output folders before rendering files



# Load global.R and download datasets ----
source("global.R")
source("download_data.R")


## Load latest data set -----
if(TRUE){
  ## Read the latest file
  fils <- list.files("data/")
  latest <- fils[order(format(as.Date(substr(fils, 1, 10), format = "%Y-%m-%d")), decreasing = T)[1]]
  df <- readRDS(paste0("data/", latest))
  ## Create URL link
  df$url <- paste0("trials/", df$Study$ProtocolSection$IdentificationModule$NCTId, ".html")
  df$Link <- paste0("<a href='",df$url,"'>Description</a>")
}


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
for (i in 1:nrow(df)) {
  d <- df[i,]
  template <- readr::read_file("template.Rmd") # read template
  # replace keywords and description
  template <- stringr::str_replace_all(string = template, 
                                       pattern = "xxx-Trial-Identifier-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$IdentificationModule$NCTId))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$IdentificationModule$BriefTitle))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Title2-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$IdentificationModule$OfficialTitle))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Description-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$DescriptionModule$BriefSummary))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-DetailedDescription-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$DescriptionModule$DetailedDescription))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Keywords-xxx",
                                       replacement = paste0(unlist(check_null(d$Study$ProtocolSection$ConditionsModule$KeywordList$Keyword)), collapse = ", "))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-LastKnownStatus-xxx",
                                       replacement = as.character(check_null(d$Study$ProtocolSection$StatusModule$LastKnownStatus)))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-OverallStatus-xxx",
                                       replacement = as.character(check_na(d$Study$ProtocolSection$StatusModule$OverallStatus)))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Trial-Phase-xxx",
                                       replacement = paste(unlist(check_null(d$Study$ProtocolSection$DesignModule$PhaseList$Phase)), collapse = ",")) ### check this
  ## Study design
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-StudyType-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$DesignModule$StudyType))
  ## Subjects
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Minimum-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$EligibilityModule$MinimumAge))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Age-Maximum-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$EligibilityModule$MaximumAge))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Gender-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$EligibilityModule$Gender))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Healthy-Subject-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$EligibilityModule$HealthyVolunteers))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Participants-Criteria-Inclusion-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$EligibilityModule$EligibilityCriteria))
  ### Contacts etc
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-ResponsibleParty-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyType))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-ResponsibleInvestigator-xxx",
                                       replacement = paste0(check_na(d$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorFullName), 
                                                            ", ", check_na(d$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorTitle),
                                                            ", ", check_na(d$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorAffiliation)) )
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Sponsor-Name-xxx",
                                       replacement = check_na(d$Study$ProtocolSection$SponsorCollaboratorsModule$LeadSponsor$LeadSponsorName))
  template <- stringr::str_replace_all(string = template,
                                       pattern = "xxx-Collaborators-xxx",
                                       replacement = paste0(unlist(check_null(d$Study$ProtocolSection$SponsorCollaboratorsModule$CollaboratorList$Collaborator)), collapse = ", ")) #DF
  # Save as new file
  writeLines(template, paste0("./temp/trials/", d$Study$ProtocolSection$IdentificationModule$NCTId,".Rmd"))
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


