## Test different theme options on index
## Creates html to output-folder
themes <- c("default", "cerulean", "journal", "flatly", "darkly", "readable", "spacelab", "united", "cosmo", "lumen", "paper", "sandstone", "simplex", "yeti")
for(t in themes){
  index <- readr::read_file("index.Rmd") # read template
  index <- stringr::str_replace_all(string = index, 
                                       pattern = "xxx-theme-xxx",
                                       replacement = t)
  writeLines(index, paste0("temp/index-", t, ".rmd"))
  rmarkdown::render(paste0("temp/index-", t, ".rmd"), output_dir = "output/")
}
