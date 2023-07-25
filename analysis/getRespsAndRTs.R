library('groundhog')
groundhog.library(
  c(
    'tidyverse',
    'dplyr',
    'jsonlite'
  ), "2022-12-01"
)

source("../analysis/loadAndPreprocessData.R")

makeJson <- function(df,filename) {
  
  df_grouped <- df %>%
    group_by(subject_identifier) %>%
    summarise(
      RT = list(RT),
      response = list(response),
      .groups = "drop"  # drop the grouping
    )
  
  list_df <- split(df_grouped[setdiff(names(df_grouped), "subject_identifier")], df_grouped$subject_identifier)
  
  named_list <- setNames(lapply(list_df, function(x) {
    list(RT = unlist(x$RT), response = unlist(x$response))
  }), unique(df_grouped$subject_identifier))
  
  json_output <- toJSON(named_list, auto_unbox = TRUE)
  
  write(json_output, filename)
  
}
  
  
