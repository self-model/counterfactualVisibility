
E2a_ddm <- read.csv(
  file='../modelling/data/E2a.csv') %>%
  mutate(exp=2) %>%
  arrange(subj_id)

E3a_ddm <- read.csv(
  file='../modelling/data/E3a.csv') %>%
  mutate(exp=3) %>%
  arrange(subj_id)

E2a_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/best_parameters_E2a.csv', header=FALSE, sep=',') %>%
  rename(gamma=V5, alpha=V8, belalpha=V9) %>% 
  mutate(alpha=exp(alpha),
         belalpha=exp(belalpha),
         gamma = 1/(1+exp(-10*gamma)),
         offsetalpha = (belalpha-alpha)/(1-alpha))

E2a_measures <- E2a_ddm %>%
  group_by(subj_id) %>%
  summarise(present_RT_t = t.test(rt[present==1 & correct==1 & rt<5 & occlusion_is_low==0],
                                  rt[present==1 & correct==1 & rt<5 & occlusion_is_low==1])$statistic,
            absent_RT_t = t.test(rt[present==-1 & correct==1 & rt<5 & occlusion_is_low==0],
                                 rt[present==-1 & correct==1 & rt<5 & occlusion_is_low==1])$statistic,
            FA = mean(correct[present==-1 & occlusion_is_low==1])-mean(correct[present==-1 & occlusion_is_low==0]),
            hits = mean(correct[present==1 & occlusion_is_low==1])-mean(correct[present==1 & occlusion_is_low==0]))

E3a_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/best_parameters_E3a.csv', header=FALSE, sep=',') %>%
  rename(gamma=V5, alpha=V8, belalpha=V9) %>% 
  mutate(alpha=exp(alpha),
         belalpha=exp(belalpha),
         gamma = 1/(1+exp(-10*gamma)),
         offsetalpha = (belalpha-alpha)/(1-alpha))

E3a_measures <- E3a_ddm %>%
  group_by(subj_id) %>%
  summarise(present_RT_t = t.test(rt[present==1 & correct==1 & rt<5 & occlusion_is_low==0],
                                  rt[present==1 & correct==1 & rt<5 & occlusion_is_low==1])$statistic,
            absent_RT_t = t.test(rt[present==-1 & correct==1 & rt<5 & occlusion_is_low==0],
                                 rt[present==-1 & correct==1 & rt<5 & occlusion_is_low==1])$statistic,
            FA = mean(correct[present==-1 & occlusion_is_low==1])-mean(correct[present==-1 & occlusion_is_low==0]),
            hits = mean(correct[present==1 & occlusion_is_low==1])-mean(correct[present==1 & occlusion_is_low==0]))

