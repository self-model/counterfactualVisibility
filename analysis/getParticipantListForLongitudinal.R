library('groundhog')
groundhog.library(
  c(
    'tidyverse',
    'dplyr',
    'jsonlite'
  ), "2022-12-01"
)

E2.raw_df <- read_csv('../experiments/Exp2rows/data/jatos_resultfiles_batch1/all_data.csv') %>%
  # filter(frame_index==0)%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key) 

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

E2.participants_to_invite <- E2.df %>% 
  group_by(subj_id) %>% 
  summarise(acc=min(mean(correct[test_part=='test1'], na.rm=T),
                    mean(correct[test_part=='test2'], na.rm=T)), 
            comprehension_visits = comprehension_visits[1], 
            presence_key = presence_key[1]) %>% 
  filter(comprehension_visits=='1' & acc>0.70)

E2.keys_list <- as.list(setNames(E2.participants_to_invite$presence_key, E2.participants_to_invite$subj_id))
E2.json <- toJSON(E2.keys_list)
writeLines(E2.json, con = "../experiments/Exp2rowsLong/keys.json")

paste(E2.participants_to_invite$subj_id,collapse='\n') %>%
  writeLines(con="../experiments/Exp2rowsLong/subjects.txt")


E3.raw_df <- read_csv('../experiments/Exp3reference/data/jatos_results_data_batch1.txt') %>%
  # filter(frame_index==0)%>%
  mutate(subj_id=PROLIFIC_PID,
         correct = as.numeric(correct=='true'),
         RT = as.numeric(RT),
         present=as.numeric(present),
         resp = response==presence_key, 
         hide_proportion=as.numeric(hide_proportion)) 

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
  filter(!(subj_id %in% E3.to_exclude))%>%
  mutate(hide_proportion = ifelse(abs(hide_proportion-0.35)<0.0001,'high',
                                  ifelse(abs(hide_proportion-0.10)<0.0001,'low',NA)))  %>%
  filter(test_part %in% c('test1','test2'));

E3.participants_to_invite <- E3.df %>% 
  group_by(subj_id) %>% 
  summarise(acc=min(mean(correct[test_part=='test1']),
                    mean(correct[test_part=='test2'])), 
            comprehension_visits = comprehension_visits[1], 
            presence_key = presence_key[1]) %>% 
  filter(comprehension_visits=='1' & acc>0.70)

E3.keys_list <- as.list(setNames(E3.participants_to_invite$presence_key, E3.participants_to_invite$subj_id))
E3.json <- toJSON(E3.keys_list)
writeLines(E3.json, con = "../experiments/Exp3referenceLong/keys.json")

paste(E3.participants_to_invite$subj_id,collapse='\n') %>%
  writeLines(con="../experiments/Exp3referenceLong/subjects.txt")

