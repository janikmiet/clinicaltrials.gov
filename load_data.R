# Download dataset and wrangle
library(httr)
library(jsonlite)
library(tibble)

## Download & save ----
if(TRUE){
  url <- "https://clinicaltrials.gov/api/query/full_studies?expr=finland&min_rnk=1&max_rnk=100&fmt=json"
  res <- fromJSON(content(GET(url)))
  df <- as_tibble(res$FullStudiesResponse$FullStudies)
  ## Modify list to dataframe
  trials <- dplyr::tibble(
    # = BASIC INFOS
    NCTId = df$Study$ProtocolSection$IdentificationModule$NCTId, ## id
    BriefTitle = df$Study$ProtocolSection$IdentificationModule$BriefTitle, ## title
    OfficialTitle = df$Study$ProtocolSection$IdentificationModule$OfficialTitle,
    Acronym = df$Study$ProtocolSection$IdentificationModule$Acronym,
    OrgFullName = df$Study$ProtocolSection$IdentificationModule$Organization$OrgFullName,
    OrgClass = df$Study$ProtocolSection$IdentificationModule$Organization$OrgClass,
    # = DATES
    StartDate=df$Study$ProtocolSection$StatusModule$StartDateStruct$StartDate,
    StartDateType=df$Study$ProtocolSection$StatusModule$StartDateStruct$StartDateType,
    PrimaryCompletionDate=df$Study$ProtocolSection$StatusModule$PrimaryCompletionDateStruct$PrimaryCompletionDate,
    PrimaryCompletionDateType=df$Study$ProtocolSection$StatusModule$PrimaryCompletionDateStruct$PrimaryCompletionDateType,
    # = STATUS
    OverallStatus=df$Study$ProtocolSection$StatusModule$OverallStatus,
    LastKnownStatus=df$Study$ProtocolSection$StatusModule$LastKnownStatus,
    WhyStopped=df$Study$ProtocolSection$StatusModule$WhyStopped,
    # = RESPONSIBILITIES
    ResponsiblePartyType=df$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyType,
    ResponsiblePartyInvestigatorFullName=df$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorFullName,
    ResponsiblePartyInvestigatorTitle=df$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorTitle,
    ResponsiblePartyInvestigatorAffiliation=df$Study$ProtocolSection$SponsorCollaboratorsModule$ResponsibleParty$ResponsiblePartyInvestigatorAffiliation,
    # = SPONSOR
    LeadSponsorName=df$Study$ProtocolSection$SponsorCollaboratorsModule$LeadSponsor$LeadSponsorName,
    LeadSponsorClass=df$Study$ProtocolSection$SponsorCollaboratorsModule$LeadSponsor$LeadSponsorClass,
    # = COLLABORATORS
    Collaborators=df$Study$ProtocolSection$SponsorCollaboratorsModule$CollaboratorList$Collaborator, # df
    # = DESCRIPTION AND SUMMARY
    BriefSummary=df$Study$ProtocolSection$DescriptionModule$BriefSummary,
    DetailedDescription=df$Study$ProtocolSection$DescriptionModule$DetailedDescription,
    DesignPrimaryPurpose=df$Study$ProtocolSection$DesignModule$DesignInfo$DesignPrimaryPurpose,
    DesignInterventionModelDescription=df$Study$ProtocolSection$DesignModule$DesignInfo$DesignInterventionModelDescription,
    # =
    Condition=df$Study$ProtocolSection$ConditionsModule$ConditionList$Condition, #df
    Keyword=df$Study$ProtocolSection$ConditionsModule$KeywordList$Keyword,   # df
    # =
    StudyType=df$Study$ProtocolSection$DesignModule$StudyType,
    Phase=df$Study$ProtocolSection$DesignModule$PhaseList$Phase,
    # =
    EligibilityCriteria=df$Study$ProtocolSection$EligibilityModule$EligibilityCriteria,
    HealthyVolunteers=df$Study$ProtocolSection$EligibilityModule$HealthyVolunteers,
    Gender=df$Study$ProtocolSection$EligibilityModule$Gender,
    MinimumAge=df$Study$ProtocolSection$EligibilityModule$MinimumAge,
    MaximumAge=df$Study$ProtocolSection$EligibilityModule$MaximumAge,
    StudyPopulation=df$Study$ProtocolSection$EligibilityModule$StudyPopulation,
    SamplingMethod=df$Study$ProtocolSection$EligibilityModule$SamplingMethod,
    GenderBased=df$Study$ProtocolSection$EligibilityModule$GenderBased,
    GenderDescription=df$Study$ProtocolSection$EligibilityModule$GenderDescription,
    
    # =
    OverallOfficial=df$Study$ProtocolSection$ContactsLocationsModule$OverallOfficialList$OverallOfficial,
    Location=df$Study$ProtocolSection$ContactsLocationsModule$LocationList$Location,
    CentralContact=df$Study$ProtocolSection$ContactsLocationsModule$CentralContactList$CentralContact,
    # =
    Reference=df$Study$ProtocolSection$ReferencesModule$ReferenceList$Reference,
    SeeAlsoLink=df$Study$ProtocolSection$ReferencesModule$SeeAlsoLinkList$SeeAlsoLink
  )
  ## Create URL link
  trials$url <- paste0("trials/", trials$NCTId, ".html")
  trials$Link <- paste0("<a href='",trials$url,"'>",trials$url,"</a>")
  
  ## Save dataset
  # readr::write_csv2(trials, file = paste0("./data/",Sys.Date(), "_trials.csv"))
  saveRDS(trials, file = paste0("./data/",Sys.Date(), "_trials.rds"))
}


## Load  -----
if(TRUE){
  ## Read the latest file
  fils <- list.files("data/")
  latest <- fils[order(format(as.Date(substr(fils, 1, 10), format = "%Y-%m-%d")), decreasing = T)[1]]
  d <- readRDS(paste0("data/", latest))
}
