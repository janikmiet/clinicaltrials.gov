## Help function to recode NA values
check_na <- function(x) {
  ifelse(is.na(x), "", x)
}
## Help function to check null lists
check_null <- function(x) {
  ifelse(is.null(x[[1]]), "NA", x)
}
