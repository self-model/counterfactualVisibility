## parameters

E1_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/basicModel/best_parameters_from_E1_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         offsetalpha = belalpha-alpha,
         theta0 = V1/alpha,
         theta1 = (V1+V2)/alpha,
         beltheta0 = V3/belalpha,
         beltheta1 = V3+V4/belalpha)

E2_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/basicModel/best_parameters_from_E2_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         offsetalpha = belalpha-alpha,
         theta0 = V1/alpha,
         theta1 = (V1+V2)/alpha,
         beltheta0 = V3/belalpha,
         beltheta1 = V3+V4/belalpha)

E3_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/basicModel/best_parameters_from_E3_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         offsetalpha = belalpha-alpha,
         theta0 = V1/alpha,
         theta1 = (V1+V2)/alpha,
         beltheta0 = V3/belalpha,
         beltheta1 = V3+V4/belalpha)


E2a_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/basicModel/best_parameters_from_E2a_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         offsetalpha = belalpha-alpha,
         theta0 = V1/alpha,
         theta1 = (V1+V2)/alpha,
         beltheta0 = V3/belalpha,
         beltheta1 = V3+V4/belalpha)

E3a_parameters <- read.table('../modelling/model_fitting_matlab/best_parameters/basicModel/best_parameters_from_E3a_fit.csv', header=FALSE, sep=',') %>%
  mutate(alpha=V8**2,
         belalpha=V9**2,
         gamma = V5,
         offsetalpha = belalpha-alpha,
         theta0 = V1/alpha,
         theta1 = (V1+V2)/alpha,
         beltheta0 = V3/belalpha,
         beltheta1 = V3+V4/belalpha)

## simulated data

E1.sim.df <- read_csv('../modelling/model_fitting_matlab/simulate_data_from_parameters/simulated_data/basicModel/E1.csv') %>%
  mutate(exp='1',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.05,0.15));

E2.sim.df <- read_csv('../modelling/model_fitting_matlab/simulate_data_from_parameters/simulated_data/basicModel/E2.csv') %>%
  mutate(exp='2',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));

E3.sim.df <- read_csv('../modelling/model_fitting_matlab/simulate_data_from_parameters/simulated_data/basicModel/E3.csv') %>%
  mutate(exp='3',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));


E2a.sim.df <- read_csv('../modelling/model_fitting_matlab/simulate_data_from_parameters/simulated_data/basicModel/E2a.csv') %>%
  mutate(exp='2a',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));


E3a.sim.df <- read_csv('../modelling/model_fitting_matlab/simulate_data_from_parameters/simulated_data/basicModel/E3a.csv') %>%
  mutate(exp='3a',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));

sim.df <- rbind(E1.sim.df, E2.sim.df,E3.sim.df,E2a.sim.df,E3a.sim.df)

## human data in condensed format


E1.minimal_df <- read_csv('../modelling/data/E1.csv') %>% 
  mutate(exp='1',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.05,0.15));

E2.minimal_df <- read_csv('../modelling/data/E2_wconf.csv') %>% 
  mutate(exp='2',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));

E3.minimal_df <- read_csv('../modelling/data/E3.csv') %>% 
  mutate(exp='3',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));

E2a.minimal_df <- read_csv('../modelling/data/E2a.csv') %>% 
  mutate(exp='2a',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35));

E3a.minimal_df <- read_csv('../modelling/data/E3a.csv') %>% 
  mutate(exp='3a',
         present=factor(present,levels=c(1,-1),labels=c('present','absent')),
         occluded_rows=factor(ifelse(occlusion_is_low==0,6,2)),
         hide_proportion = ifelse(occlusion_is_low,0.1,0.35))

human.df <- rbind(E1.minimal_df, E2.minimal_df%>%dplyr::select(-confidence),E3.minimal_df,E2a.minimal_df,E3a.minimal_df)
