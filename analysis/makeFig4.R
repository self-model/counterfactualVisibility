detection_colors = c('#377eb8', '#e41a1c');
labels = c('Present','Absent')

### panel B ###
upper_threshold_08 = 1.60
lower_threshold_08 = -1.7918
LLR1_08 = 1.3863;
LLR0_08 = -0.1335;

evacc08_df <- data.frame(percept=c(0,-1,-1,-1,-1,-1,-1,-1,1 ,-1,-1,-1,-1,-1,1 ,-1,-1,-1,-1,-1),t=seq(1,20)) %>%
  mutate(percept = ifelse(percept==1, LLR1_08,ifelse(percept==-1, LLR0_08,0)),
         accum=cumsum(percept))

upper_threshold_06 = 1.30
lower_threshold_06 = -1.51
LLR1_06 = 1.3863;
LLR0_06 = -0.0974;

evacc06_df <- data.frame(percept=c(0,-1,-1,-1,-1,-1,-1,-1,1 ,-1,-1,-1,-1,-1,1 ),t=seq(1,15)) %>%
  mutate(percept = ifelse(percept==1, LLR1_06,ifelse(percept==-1, LLR0_06,0)),
         accum=cumsum(percept))

evacc08_df %>% ggplot(aes(x=t,y=accum)) +
  geom_abline(slope=0,intercept=lower_threshold_06,color='grey') +
  geom_abline(slope=0,intercept=upper_threshold_06,color='grey') +
  geom_abline(slope=0,intercept=lower_threshold_08,color='black') +
  geom_abline(slope=0,intercept=upper_threshold_08,color='black') +
  geom_point(color='grey', data=evacc06_df) +
  geom_line(color='grey', data=evacc06_df)+
  geom_point(color='black') +
  geom_line(color='black') +
  
  scale_y_continuous(limits=c(-2.1,2.1), name='LLR') +
  theme_classic()+
  scale_x_continuous(breaks=c(),name='time')

ggsave('../docs/figures/Fig4/panelB/tc_assym_occ.png', height=1.2,width=4)

upper_threshold_07 = 1.53
lower_threshold_07 = -1.62
LLR1_07 = 1.3863;
LLR0_07 = -0.1152;

evacc07_df <- data.frame(percept=c(0,-1,-1,-1,-1,-1,-1,-1,1 ,-1,-1,-1,-1,-1,1 ),t=seq(1,15)) %>%
  mutate(percept = ifelse(percept==1, LLR1_07,ifelse(percept==-1, LLR0_07,0)),
         accum=cumsum(percept))

evacc08_df %>% ggplot(aes(x=t,y=accum)) +
  geom_abline(slope=0,intercept=lower_threshold_07,color='#171717') +
  geom_abline(slope=0,intercept=upper_threshold_07,color='#171717') +
  geom_point(color='#171717') +
  geom_line(color='#171717') +
  
  scale_y_continuous(limits=c(-2.1,2.1), name='LLR') +
  theme_classic()+
  scale_x_continuous(breaks=c(),name='time')

ggsave('../docs/figures/Fig4/panelB/tc_assym_occ_ignore.png', height=1.2,width=4)


### panel C ###

sim.occlusion <- read_csv('../modelling/simulated_data/accum_bernoulli_occlusion.csv') %>%
  mutate(correct = ifelse(decision==present,1,0))

sim.occlusion_f1 <- read_csv('../modelling/simulated_data/accum_bernoulli_occlusion_fault1.csv') %>%
  mutate(correct = ifelse(decision==present,1,0))

RT_A<- sim.occlusion %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(RT=mean(RT)) %>%
  ggplot(aes(x=occluded_rows,y=RT,fill=present, color=present,shape=present)) +
  scale_shape_manual(values=c(4,16))+
  scale_fill_manual(values=detection_colors) +
  scale_color_manual(values=detection_colors) +
  scale_y_continuous(limits=c(10,25))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='time points',x='') 

ggsave('../docs/figures/Fig4/panelC/RT_A.png',RT_A, width=1.6,height=1.6)

RT_B<- sim.occlusion_f1 %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(RT=mean(RT)) %>%
  ggplot(aes(x=occluded_rows,y=RT,fill=present, color=present,shape=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_color_manual(values=detection_colors) +
  scale_shape_manual(values=c(4,16))+
  scale_y_continuous(limits=c(10,25))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='time points',x='') 

ggsave('../docs/figures/Fig4/panelC/RT_B.png',RT_B, width=1.6,height=1.6)

conf_A<- sim.occlusion %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(confidence=mean(confidence)) %>%
  ggplot(aes(x=occluded_rows,y=confidence,fill=present, color=present,shape=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_color_manual(values=detection_colors) +
  scale_shape_manual(values=c(4,16))+
  scale_y_continuous(limits=c(0.8,1), breaks=seq(0.8,1,0.05))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='Bayes p(correct)',x='') 

ggsave('../docs/figures/Fig4/panelC/conf_A.png',conf_A, width=1.6,height=1.6)

conf_B<- sim.occlusion_f1 %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(confidence=mean(confidence)) %>%
  ggplot(aes(x=occluded_rows,y=confidence,fill=present, color=present,shape=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(4,16))+
  scale_color_manual(values=detection_colors) +
  scale_y_continuous(limits=c(0.8,1), breaks=seq(0.8,1,0.05))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='Bayes p(correct)',x='') 

ggsave('../docs/figures/Fig4/panelC/conf_B.png',conf_B, width=1.6,height=1.6)

acc_A<- sim.occlusion %>% 
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(errors=1-mean(correct)) %>%
  ggplot(aes(x=occluded_rows,y=errors,fill=present, color=present, shape=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_color_manual(values=detection_colors) +
  scale_shape_manual(values=c(4,16))+
  scale_y_continuous(limits=c(0,0.3), breaks=seq(0,0.35,0.05))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='error rate',x='') 

ggsave('../docs/figures/Fig4/panelC/acc_A.png',acc_A, width=1.6,height=1.6)

acc_B<- sim.occlusion_f1 %>% 
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent'))) %>%
  group_by(present, occluded_rows)%>%summarise(errors=1-mean(correct)) %>%
  ggplot(aes(x=occluded_rows,y=errors,fill=present, color=present, shape=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_color_manual(values=detection_colors) +
  scale_shape_manual(values=c(4,16))+
  scale_y_continuous(limits=c(0,0.3), breaks=seq(0,0.35,0.05))+
  geom_line()+
  geom_point(size=2) +
  theme_classic() +
  theme(legend.pos='na') +
  scale_x_continuous(limits=c(0,8),breaks=c(2,6),labels=c('easy','hard'))+
  labs(y='error rate',x='') 

ggsave('../docs/figures/Fig4/panelC/acc_B.png',acc_B, width=1.6,height=1.6)
