# Recursive function to read 'data.txt' files from directory and its subdirectories
read_concat_data <- function(dir) {
  
  # List files in directory
  files <- list.files(dir, recursive = TRUE)
  
  # Filter to keep only 'data.txt' files
  data_files <- files[grepl("data.txt$", files)]
  
  # Add directory path to file names
  data_files <- file.path(dir, data_files)
  
  # Read all 'data.txt' files, replacing missing columns with NA
  data_list <- map(data_files, ~ read_csv(.x, col_types = cols(.default = "c")) %>% replace_na(list(NA)))
  
  # Bind all data frames together
  all_data <- bind_rows(data_list)
  
  return(all_data)
}

E1.raw_df <- read_csv('../experiments/Exp1pixels/version2/data/jatos_resultfiles_batch1/all_data.csv') %>%
  filter(frame_index==0)%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key) 

E2.raw_df <- read_csv('../experiments/Exp2rows/data/jatos_resultfiles_batch1/all_data.csv') %>%
  filter(frame_index==0)%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key) 

E3.raw_df <- read_csv('../experiments/Exp3reference/data/jatos_results_data_batch1.txt') %>%
  # filter(frame_index==0)%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct=='true'),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key) 

E2a.raw_df <- read_concat_data('../experiments/Exp2rowsLong/data/jatos_results_data_session1') %>% 
  mutate(session=1) %>%
  bind_rows(read_concat_data('../experiments/Exp2rowsLong/data/jatos_results_data_session2') %>%
              mutate(session=2))%>%
  bind_rows(read_concat_data('../experiments/Exp2rowsLong/data/jatos_results_data_session3') %>%
              mutate(session=3))%>%
  bind_rows(read_concat_data('../experiments/Exp2rowsLong/data/jatos_results_data_session4') %>%
              mutate(session=4))%>%
  bind_rows(read_concat_data('../experiments/Exp2rowsLong/data/jatos_results_data_session5') %>%
              mutate(session=5))%>%
  filter(!(PROLIFIC_PID%in%c('PROLIFIC_PID','first_target','S')))%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct=='true'),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key) %>%
  group_by(subj_id) %>%
  filter(length(unique(session))>3) %>%
  ungroup()

E3a.raw_df <- read_concat_data('../experiments/Exp3referenceLong/data/jatos_results_data_session1') %>% 
  mutate(session=1) %>%
  rbind(read_concat_data('../experiments/Exp3referenceLong/data/jatos_results_data_session2') %>%
          mutate(session=2))%>%
  rbind(read_concat_data('../experiments/Exp3referenceLong/data/jatos_results_data_session3') %>%
          mutate(session=3))%>%
  rbind(read_concat_data('../experiments/Exp3referenceLong/data/jatos_results_data_session4') %>%
          mutate(session=4))%>%
  rbind(read_concat_data('../experiments/Exp3referenceLong/data/jatos_results_data_session5') %>%
          mutate(session=5))%>%
  filter(!(PROLIFIC_PID%in%c('PROLIFIC_PID','first_target','S')))%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct=='true'),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key)

E1.low_accuracy <- E1.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

E1.too_slow <- E1.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>5000) %>%
  pull(subj_id)

E1.too_fast <- E1.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

E1.to_exclude <- c(
  E1.low_accuracy,
  E1.too_slow,
  E1.too_fast
) %>% unique()

E1.df <- E1.raw_df %>%
  filter(!(subj_id %in% E1.to_exclude)) %>%
  mutate(correlation_with_mask=as.numeric(correlation_with_mask));


E2.low_accuracy <- E2.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

E2.too_slow <- E2.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>5000) %>%
  pull(subj_id)

E2.too_slow <- E2.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>5000) %>%
  pull(subj_id)

E2.too_fast <- E2.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

E2.to_exclude <- c(
  E2.low_accuracy,
  E2.too_slow,
  E2.too_fast
) %>% unique()

E2.df <- E2.raw_df %>%
  filter(!(subj_id %in% E2.to_exclude));

E3.low_accuracy <- E3.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

E3.too_slow <- E3.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>7000) %>%
  pull(subj_id)

E3.too_fast <- E3.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

E3.to_exclude <- c(
  E3.low_accuracy,
  E3.too_slow,
  E3.too_fast
) %>% unique()

E3.df <- E3.raw_df %>%
  filter(!(subj_id %in% E3.to_exclude));

E2a.low_accuracy <- E2a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

E2a.too_slow <- E2a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>7000) %>%
  pull(subj_id)

E2a.too_fast <- E2a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

E2a.to_exclude <- c(
  E2a.low_accuracy,
  E2a.too_slow,
  E2a.too_fast
) %>% unique()

E2a.df <- E2a.raw_df %>%
  filter(!(subj_id %in% E2a.to_exclude));

E3a.low_accuracy <- E3a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    accuracy = mean(correct)) %>%
  filter(accuracy<0.5) %>%
  pull(subj_id)

E3a.too_slow <- E3a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    third_quartile_RT = quantile(RT,0.75)) %>%
  filter(third_quartile_RT>7000) %>%
  pull(subj_id)

E3a.too_fast <- E3a.raw_df %>%
  filter(test_part=='test1' | test_part=='test2') %>%
  group_by(subj_id) %>%
  summarise(
    first_quartile_RT = quantile(RT,0.25)) %>%
  filter(first_quartile_RT<100) %>%
  pull(subj_id)

E3a.to_exclude <- c(
  E3a.low_accuracy,
  E3a.too_slow,
  E3a.too_fast
) %>% unique()

E3a.df <- E3a.raw_df %>%
  filter(!(subj_id %in% E3a.to_exclude))



occlusion.df <- E1.df %>%
  dplyr::select(subj_id,hide_proportion,present,correct,RT,test_part,target) %>%
  mutate(exp=1,
         hide_proportion = ifelse(hide_proportion>0.10,'high','low')) %>%
  filter(test_part %in% c('test1','test2')) %>%
  rbind(E2.df  %>%
          dplyr::select(subj_id,hide_proportion,present,correct,RT,test_part,target)%>%
          mutate(exp=2,
            hide_proportion = ifelse(hide_proportion>0.10,'high','low'))) %>%
  rbind(E3.df %>%
          dplyr::select(subj_id,hide_proportion,present,correct,RT,test_part,target) %>%
          mutate(exp=3,
                 hide_proportion = ifelse(hide_proportion>0.10,'high','low')))
)
