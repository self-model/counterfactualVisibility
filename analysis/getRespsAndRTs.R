library('groundhog')
groundhog.library(
  c(
    'tidyverse',
    'dplyr',
    'jsonlite'
  ), "2022-12-01"
)

E2.df_for_json <- read_csv('../experiments/Exp2rows/data/jatos_resultfiles_batch1/all_data.csv') %>%
  group_by(subject_identifier,trial_index) %>%
  filter(trial_type=='noisyLetter' & frame_index==max(frame_index))%>%
  mutate(RT = as.numeric(RT),
         nframes=frame_index)  %>%
  dplyr::select(subject_identifier, RT, nframes, response)

E3.df_for_json <- read_csv('../experiments/Exp3reference/data/jatos_results_files_batch1/all_data.csv') %>%

  group_by(subject_identifier,trial_index) %>%
  filter(trial_type=='noisyLetter' & frame_index==max(frame_index))%>%
  mutate(RT = as.numeric(RT),
         nframes=frame_index)  %>%
  dplyr::select(subject_identifier, RT, nframes, response)

makeJson <- function(df,filename) {
  
  df_grouped <- df %>%
    group_by(subject_identifier) %>%
    summarise(
      RT = list(RT),
      response = list(response),
      nframes = list(nframes),
      .groups = "drop"  # drop the grouping
    )
  
  list_df <- split(df_grouped[setdiff(names(df_grouped), "subject_identifier")], df_grouped$subject_identifier)
  
  named_list <- setNames(lapply(list_df, function(x) {
    list(RT = unlist(x$RT), response = unlist(x$response), nframes = unlist(x$nframes))
  }), unique(df_grouped$subject_identifier))
  
  json_output <- toJSON(named_list, auto_unbox = TRUE)
  
  write(json_output, filename)
  
}

makeJson(E2.df_for_json,'../experiments/Exp2rows/data/responses.json')
  
  
