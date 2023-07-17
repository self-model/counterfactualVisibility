library(signcon)
library(magrittr)

#E1

E1.sign_consistency_presence <- E1.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E1.sign_consistency_absence <- E1.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E1.directional_effect_presence <- E1.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E1.directional_effect_absence <- E1.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='cong', summary_function=median)

#E2

E2.sign_consistency_presence <- E2.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E2.sign_consistency_absence <- E2.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E2.directional_effect_presence <- E2.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='cong', summary_function=median)

E2.directional_effect_absence <- E2.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  mutate(cong=context==target) %>%
  dplyr::select(subj_id,cong,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='cong', summary_function=median)

#E3

E3.sign_consistency_presence <- E3.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E3.sign_consistency_presence_control <- E3.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  mutate(subj_id=as.numeric(as.factor(subj_id))) %>%
  mutate(RT=ifelse(hide_proportion==0.15, RT+1000*(subj_id%%2), RT+1000*(1-subj_id%%2)))%>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median, null_dist_samples=1000)

E3.sign_consistency_absence <- E3.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E3.directional_effect_presence <- E3.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E3.directional_effect_absence <- E3.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

#E4

E4.sign_consistency_presence <- E4.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E4.sign_consistency_absence <- E4.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_sign_consistency(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E4.directional_effect_presence <- E4.df %>% 
  filter(test_part %in% c('test1','test2') & correct & present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)

E4.directional_effect_absence <- E4.df %>% 
  filter(test_part %in% c('test1','test2') & correct & !present) %>% 
  dplyr::select(subj_id,hide_proportion,RT) %>%
  signcon::test_directional_effect(idv="subj_id", dv='RT', iv='hide_proportion', summary_function=median)
