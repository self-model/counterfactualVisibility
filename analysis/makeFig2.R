detection_colors = c('#377eb8', '#e41a1c');


N_perm <- 1000;
bootstrap_error <- function(x, N_perm) {
  N <- length(x)
  medians = c();
  for (i in 1:N_perm) {
    medians = c(medians,sample(x,replace=TRUE,size=N)%>%median())
  };
  return(sd(medians))
}

### panel A ###

E1.pRT_collapsed <- E1.df %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent')))%>%
  group_by(present, subj_id) %>%
  summarise(RT=median(RT)) %>%
  group_by(present) %>%
  summarise(sem=bootstrap_error(RT,N_perm),
            RT=median(RT))%>%
  ggplot(aes(x=present,y=RT,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(1200,2500))+
  geom_errorbar(aes(ymin=RT-sem,ymax=RT+sem),width=0.2)+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='reaction time (ms)',x='') 

ggsave('../docs/figures/Fig2/panelA/E1_RT_asymmetry.png',E1.pRT_collapsed, width=2,height=2)

E2.pRT_collapsed <- E2.df %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent')))%>%
  group_by(present, subj_id) %>%
  summarise(RT=median(RT)) %>%
  group_by(present) %>%
  summarise(sem=bootstrap_error(RT,N_perm),
            RT=median(RT))%>%
  ggplot(aes(x=present,y=RT,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(1200,2500))+
  geom_errorbar(aes(ymin=RT-sem,ymax=RT+sem),width=0.2)+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='reaction time (ms)',x='') 

ggsave('../docs/figures/Fig2/panelA/E2_RT_asymmetry.png',E2.pRT_collapsed, width=2,height=2)

E3.pRT_collapsed <- E3.df %>% 
  filter(correct==1) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent')))%>%
  group_by(present, subj_id) %>%
  summarise(RT=median(RT)) %>%
  group_by(present) %>%
  summarise(sem=bootstrap_error(RT,N_perm),
            RT=median(RT))%>%
  ggplot(aes(x=present,y=RT,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(1200,2500))+
  geom_errorbar(aes(ymin=RT-sem,ymax=RT+sem),width=0.2)+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='reaction time (ms)',x='') 

ggsave('../docs/figures/Fig2/panelA/E3_RT_asymmetry.png',E3.pRT_collapsed, width=2,height=2)

### panel B ###

p<- E1.frames_df %>%
  mutate(time=frame_index*1000/15,
         present=factor(as.numeric(present),levels=c(1,0)))%>%
  filter(time<500 & correct)%>%
  group_by(subj_id,present,occlusion,time) %>%
  summarise(RT=cor(correlation_with_target_letter_corrected,RT,method='spearman')) %>%
  group_by(subj_id,present,time)%>%
  summarise(RT=mean(RT))%>%
  group_by(present,time)%>%
  summarise(se=se(RT),
            RT=mean(RT, na.rm=T))%>%
  ggplot(aes(x=time,y=RT,color=present,fill=present))+
  geom_segment(aes(x=0,y=0,xend=300,yend=0),size=2, color='black')+
  geom_line(size=1)+
  geom_ribbon(aes(ymin=RT-se,ymax=RT+se),alpha=0.3)+
  geom_point(size=2)+
  scale_color_manual(values=detection_colors)+
  scale_fill_manual(values=detection_colors) +
  labs(x="time (ms)", y="Spearman correlation", title="RT, Exp. 1") +
  theme_minimal() +
  theme(legend.pos='na')

ggsave("../docs/figures/Fig2/panelB/E1RT.png",p,width=4,height=3,dpi=600)


p<- E2.frames_df %>%
  mutate(time=frame_index*1000/15-533.33,
         present=factor(as.numeric(present),levels=c(1,0)))%>%
  filter(time>0 & time<500 & correct)%>%
  group_by(subj_id,present,occlusion,time) %>%
  summarise(RT=cor(correlation_with_target_letter_corrected,RT,method='spearman')) %>%
  group_by(subj_id,present,time)%>%
  summarise(RT=mean(RT))%>%
  group_by(present,time)%>%
  summarise(se=se(RT),
            RT=mean(RT, na.rm=T))%>%
  ggplot(aes(x=time,y=RT,color=present,fill=present))+
  geom_segment(aes(x=0,y=0,xend=300,yend=0),size=2, color='black')+
  geom_line(size=1)+
  geom_ribbon(aes(ymin=RT-se,ymax=RT+se),alpha=0.3)+
  geom_point(size=2)+
  scale_color_manual(values=detection_colors)+
  scale_fill_manual(values=detection_colors) +
  labs(x="time (ms)", y="Spearman correlation", title="RT, Exp. 2") +
  theme_minimal() +
  theme(legend.pos='na')

ggsave("../docs/figures/Fig2/panelB/E2RT.png",p,width=4,height=3,dpi=600)
p<- E3.frames_df %>%
  mutate(time=frame_index*1000/15-533.33,
         present=factor(as.numeric(present),levels=c(1,0)))%>%
  filter(time>=0 & time<500 & correct)%>%
  group_by(subj_id,present,occlusion,time) %>%
  summarise(RT=cor(correlation_with_target_letter_corrected,RT,method='spearman')) %>%
  group_by(subj_id,present,time)%>%
  summarise(RT=mean(RT))%>%
  group_by(present,time)%>%
  summarise(se=se(RT),
            RT=mean(RT, na.rm=T))%>%
  ggplot(aes(x=time,y=RT,color=present,fill=present))+
  geom_segment(aes(x=0,y=0,xend=300,yend=0),size=2, color='black')+
  geom_line(size=1)+
  geom_ribbon(aes(ymin=RT-se,ymax=RT+se),alpha=0.3)+
  geom_point(size=2)+
  scale_color_manual(values=detection_colors)+
  scale_fill_manual(values=detection_colors) +
  labs(x="time (ms)", y="Spearman correlation", title="RT, Exp. 3") +
  theme_minimal() +
  theme(legend.pos='na')

ggsave("../docs/figures/Fig2/panelB/E3RT.png",p,width=4,height=3,dpi=600)


### panel D ###

E2.pconfidence_collapsed <- E2.df %>% 
  filter(correct==1 & !is.na(confidence)) %>%
  mutate(present=factor(present,levels=c(1,0),labels=c('present','absent')))%>%
  group_by(present, subj_id) %>%
  summarise(confidence=mean(confidence)) %>%
  group_by(present) %>%
  summarise(se=se(confidence),
            confidence=mean(confidence))%>%
  ggplot(aes(x=present,y=confidence,fill=present)) +
  scale_fill_manual(values=detection_colors) +
  scale_shape_manual(values=c(21,22))+
  scale_y_continuous(limits=c(0.8,0.9))+
  geom_errorbar(aes(ymin=confidence-se,ymax=confidence+se),width=0.2)+
  geom_point(size=3, shape=21) +
  theme_classic() +
  theme(legend.pos='na') +
  labs(y='confidence ratings',x='') 

ggsave('../docs/figures/Fig2/panelD/E2_confidence_asymmetry.png',E2.pconfidence_collapsed, width=2,height=2)

### panel E ###

p<- E2.frames_df %>%
  mutate(time=frame_index*1000/15-533.33,
         present=factor(present,levels=c(1,0),labels=c('present','absent')))%>%
  filter(time>=0 & time<500 & correct & !is.na(confidence))%>%
  group_by(subj_id,present,occlusion,time) %>%
  summarise(confidence=cor(correlation_with_target_letter_corrected,confidence,method='spearman')) %>%
  group_by(subj_id,present,time)%>%
  summarise(confidence=mean(confidence))%>%
  group_by(present,time)%>%
  summarise(se=se(confidence),
            confidence=mean(confidence, na.rm=T))%>%
  ggplot(aes(x=time,y=confidence,color=present,fill=present))+
  geom_segment(aes(x=0,y=0,xend=300,yend=0),size=2, color='black')+
  geom_line(size=1)+
  geom_ribbon(aes(ymin=confidence-se,ymax=confidence+se),alpha=0.3)+
  geom_point(size=2)+
  scale_color_manual(values=detection_colors)+
  scale_fill_manual(values=detection_colors) +
  labs(x="time (ms)", y="Spearman correlation", title="Confidence, Exp. 2") +
  theme_minimal() +
  theme(legend.pos='na')

ggsave("../docs/figures/Fig2/panelE/E2confidence.png",p,width=4,height=3,dpi=600)