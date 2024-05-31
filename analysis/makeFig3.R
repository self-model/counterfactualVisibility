detection_colors = c('#377eb8', '#e41a1c');
labels = c('Present','Absent')

### panel B ###
upper_threshold_07 = 1.53
lower_threshold_07 = -1.62
LLR1_07 = 1.3863;
LLR0_07 = -0.1152;

evacc07_df <- data.frame(percept=c(0,-1,-1,-1,-1,-1,-1,-1,1 ,-1,-1,-1,-1,-1,1,-1,-1,-1,-1,-1 ),t=seq(1,20)) %>%
  mutate(percept = ifelse(percept==1, LLR1_07,ifelse(percept==-1, LLR0_07,0)),
         accum=cumsum(percept))

evacc07_df %>% ggplot(aes(x=t,y=accum)) +
  geom_abline(slope=0,intercept=lower_threshold_07,color='black') +
  geom_abline(slope=0,intercept=upper_threshold_07,color='black') +
  geom_point(color='black') +
  geom_line(color='black') +
  scale_y_continuous(limits=c(-2.1,2.1), name='LLR') +
  theme_classic()+
  scale_x_continuous(breaks=c(),name='time')

ggsave('../docs/figures/Fig3/panelB/tc_assym.png', height=1.2,width=4)


### panel C ###

sim.asym <- read_csv('../modelling/model_fitting_Matlab/simulate_data_from_parameters/simulated_data/illustration/asym.csv') %>%
  rename(RT=rt) %>%
  mutate(decision = ifelse(present==1,correct,1-correct))

pRT_collapsed <- sim.asym %>%
  filter(correct==1)%>%
  mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')))%>%
  group_by(present)%>%summarise(RT=mean(RT)) %>%
  ggplot(aes(x=present,y=RT,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(10,22))+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='number of time points',title='Reaction time',x='') 

ggsave('../docs/figures/Fig3/panelC/RT_collapsed_square.png',pRT_collapsed, width=2,height=2)

pconfidence_collapsed <- sim.asym %>% 
  filter(correct==1 ) %>%
  mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')))%>%
  group_by(present)%>%
  summarise(confidence=mean(confidence)) %>%
  ggplot(aes(x=present,y=confidence,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(0.85,0.95))+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='Bayesian p(correct)',title='Confidence',x='') 

ggsave('../docs/figures/Fig3/panelC/confidence_collapsed_square.png',pconfidence_collapsed, width=2,height=2)

# pBias_collapsed <- sim.asym %>% 
#   mutate(bias=mean(decision))%>%
#   # group_by(present, occluded_rows)%>%summarise(RT=mean(RT)) %>%
#   ggplot(aes(y=bias)) +
#   # scale_fill_manual(values=detection_colors) +
#   # scale_shape_manual(values=c(21,22))+
#   # scale_y_continuous(limits=c(0.475,0.525))+
#   scale_x_continuous(limits=c(0.45,0.55),breaks=c(0.5),labels=c('all trials'))+
#   geom_point(size=3, shape=21,x=0.5,fill='black') +
#   theme_classic() +
#   theme(legend.pos='na') +
#   labs(y='propotion "present"',title='Bias',x='') 
# 
# ggsave('../docs/figures/model/Bias_collapsed_square.png',pBias_collapsed, width=1,height=2)

# sim.RC <- read_csv('../modelling/model_fitting_Matlab/simulate_data_from_parameters/simulated_data/illustration/RC_highthreshold_ByT.csv') %>%
#   rename(RT=rt) %>%
#   rowwise() %>%
#   mutate(RT=RT+rnorm(1,0,2),
#          confidence=confidence+rnorm(1,0,0.01),
#          decision = ifelse(present==1,correct,1-correct));

# RT_RC <- sim.RC %>%
#   filter(correct==1 & frame<8 & RT>12)%>%
#   mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')))%>%
#   group_by(present,frame)%>%summarise(RT=cor(RT,evidence)) %>%
#   ggplot(aes(x=frame,y=RT,color=present,fill=present)) +
#   scale_color_manual(values=detection_colors) +
#   scale_y_continuous(limits=c(10,22))+
#   geom_point(size=3) +
#   geom_line(size=1)+
#   theme_classic() +
#   theme(legend.pos='na') +
#   geom_abline(slope=0,intercept=0)+
#   labs(y='correlation',x='') 
# 
# ggsave('../docs/figures/model/RTRC_collapsed_square.png',RT_RC, width=2,height=1.8)
# 
# confidence_RC <- sim.RC %>%
#   filter(correct==1 & frame<8 & RT>7)%>%
#   mutate(present=factor(present,levels=c(1,-1),labels=c('present','absent')))%>%
#   group_by(present,frame)%>%summarise(confidence=cor(confidence,evidence)) %>%
#   ggplot(aes(x=frame,y=confidence,color=present,fill=present)) +
#   scale_color_manual(values=detection_colors) +
#   # scale_y_continuous(limits=c(10,22))+
#   geom_point(size=3) +
#   geom_line(size=1)+
#   theme_classic() +
#   theme(legend.pos='na') +
#   geom_abline(slope=0,intercept=0)+
#   labs(y='correlation',x='') 
# 
# ggsave('../docs/figures/model/confRC_collapsed_square.png',confidence_RC, width=2,height=1.8)

# 
# conf_discrete_counts <- sim.asym %>%
#   mutate(confidence = round(confidence*100)/100)%>%
#   group_by(decision, correct, confidence, .drop=FALSE) %>%
#   tally() %>%
#   spread(correct, n, sep='',fill=0) %>%
#   arrange(desc(confidence), by_group=TRUE) %>%
#   group_by(decision)%>%
#   mutate(cs_correct=cumsum(correct1)/sum(correct1),
#          cs_incorrect=cumsum(correct0)/sum(correct0))
# 
# additional_lines = conf_discrete_counts %>%
#   group_by(decision) %>%
#   reframe(confidence=c(0,1),cs_incorrect = c(0,1),cs_correct=c(0,1))
# 
# conf_discrete_counts = rbind(conf_discrete_counts,additional_lines)
# 
# labels=c('present','absent')
# 
# p<- ggplot(data=conf_discrete_counts%>%mutate(response=ifelse(decision==1,labels[1],labels[2])%>%factor(levels=labels)),
#            aes(x=cs_incorrect, y=cs_correct, color=response)) +
#   geom_line(size=1.3) +
#   # geom_point(aes(shape = response))+
#   geom_abline(slope=1)+
#   theme_bw() + coord_fixed() +
#   labs(x='p(conf | incorrect)', y='p(conf | correct)')+ 
#   scale_color_manual(values=detection_colors)+
#   scale_fill_manual(values=detection_colors) +
#   scale_x_continuous(breaks=c())+
#   scale_y_continuous(breaks=c())+
#   geom_rect(aes(xmin=0,xmax=1,ymin=0,ymax=1),size=0.5,color='black',alpha=0)+
#   theme_classic()+
#   theme(legend.position='none')+
#   labs(title='mc sensitivity')
# 
# ggsave('../docs/figures/model/AUC_square.png',p,width=2,height=2)

