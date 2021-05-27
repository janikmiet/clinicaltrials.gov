## Help function to recode NA values
check_na <- function(x) {
  ifelse(is.na(x), "", x)
}
## Help function to check null lists
check_null <- function(x) {
  ifelse(is.null(x[[1]]), "Not Available from clinicaltrials.gov", x)
}
## replace " to '
check_text <- function(x) {
  stringr::str_replace_all(x, "\"", "'")
}
