detection_colors = c('#377eb8', '#e41a1c');
labels = c('Present','Absent')

### panel B: histograms ###
E2.RT_by_occlusion_in_absence_correct_only <- E2.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & !resp & correct) %>%
  group_by(subj_id,hide_proportion) %>%
  summarise(RT=median(RT))%>%
  spread(hide_proportion,RT,sep='')%>%
  mutate(diff=hide_proportion0.1-hide_proportion0.35);

E2.RT_by_occlusion_in_presence_correct_only <- E2.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & resp & correct) %>%
  group_by(subj_id,hide_proportion) %>%
  summarise(RT=median(RT))%>%
  spread(hide_proportion,RT,sep='')%>%
  mutate(diff=hide_proportion0.1-hide_proportion0.35);

E2.RT_by_occlusion_and_response_correct_only <- merge(
  E2.RT_by_occlusion_in_presence_correct_only,
  E2.RT_by_occlusion_in_absence_correct_only,
  by= 'subj_id',
  suffixes = c('presence','absence')) %>%
  mutate(interaction = diffpresence-diffabsence);

E2a.subjects <- E2a.df$subj_id%>%unique()

E2.random_subset_df <- E2.RT_by_occlusion_and_response_correct_only %>% 
  mutate(sampled=factor(ifelse(subj_id %in% c(E2a.subjects),1,0),levels=c(0,1))) %>% 
  gather(key='condition',value='effect',diffpresence,diffabsence) %>%
  mutate(condition=factor(ifelse(condition=='diffabsence','absent','present'),
                          levels=c('present','absent')),
         effect=-effect)

E2.random_subset_df %>%
  ggplot(aes(x=effect)) +
  geom_histogram(bins=100, fill='grey') +
  facet_grid(rows=vars(condition)) +
  scale_fill_manual(values=c('grey','black')) +
  scale_x_continuous(breaks=c(0), limits=c(-2400,2400))+
  scale_y_continuous(breaks=c())+
  labs(x='RT difference: 2 minus 6 rows (ms)', y='')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14)) +
  geom_vline(data = E2.random_subset_df %>% filter(sampled==1),
             aes(xintercept=effect))

ggsave('../docs/figures/Fig6/panelB/E2a_subjects_histogram.png', width = 6, height = 2, units = "in", dpi = 300)


E3.RT_by_occlusion_in_absence_correct_only <- E3.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & !resp & correct) %>%
  group_by(subj_id,hide_proportion) %>%
  summarise(RT=median(RT))%>%
  spread(hide_proportion,RT,sep='')%>%
  mutate(diff=hide_proportion0.1-hide_proportion0.35);

E3.RT_by_occlusion_in_presence_correct_only <- E3.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & resp & correct) %>%
  group_by(subj_id,hide_proportion) %>%
  summarise(RT=median(RT))%>%
  spread(hide_proportion,RT,sep='')%>%
  mutate(diff=hide_proportion0.1-hide_proportion0.35);

E3.RT_by_occlusion_and_response_correct_only <- merge(
  E3.RT_by_occlusion_in_presence_correct_only,
  E3.RT_by_occlusion_in_absence_correct_only,
  by= 'subj_id',
  suffixes = c('presence','absence')) %>%
  mutate(interaction = diffpresence-diffabsence);

E3a.subjects <- E3a.df$subj_id%>%unique()

E3.random_subset_df <- E3.RT_by_occlusion_and_response_correct_only %>% 
  mutate(sampled=factor(ifelse(subj_id %in% c(E3a.subjects),1,0),levels=c(0,1))) %>% 
  gather(key='condition',value='effect',diffpresence,diffabsence) %>%
  mutate(condition=factor(ifelse(condition=='diffabsence','absent','present'),
                          levels=c('present','absent')),
         effect=-effect)

E3.random_subset_df %>%
  ggplot(aes(x=effect)) +
  geom_histogram(bins=100, fill='grey') +
  facet_grid(rows=vars(condition)) +
  scale_fill_manual(values=c('grey','black')) +
  scale_x_continuous(breaks=c(0), limits=c(-2400,2400))+
  scale_y_continuous(breaks=c())+
  labs(x='RT difference: 2 minus 6 rows (ms)', y='')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14)) +
  geom_vline(data = E3.random_subset_df %>% filter(sampled==1),
             aes(xintercept=effect))

ggsave('../docs/figures/Fig6/panelB/E3a_subjects_histogram.png', width = 6, height = 2, units = "in", dpi = 300)


### panel C: sign-consistency, occluded rows

N_perm <- 1000;
bootstrap_error <- function(x, N_perm) {
  N <- length(x)
  medians = c();
  for (i in 1:N_perm) {
    medians = c(medians,sample(x,replace=TRUE,size=N)%>%median())
  };
  return(sd(medians))
}

E2a.RT <- E2a.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & RT<5000 & correct) %>%
  mutate(occluded_rows=factor(ifelse(hide_proportion>0.2,6,2)))%>%
  group_by(subj_id,resp, occluded_rows) %>%
  summarise(
    median_RT=median(RT),
    sem_RT=bootstrap_error(RT,N_perm)
  ) %>%
  mutate(resp=factor(resp,levels=c(TRUE,FALSE),labels=c('present','absent'))) 

E2a.RT_sc <- E2a.tp.sign_consistency$consistency_per_id %>%
  mutate(resp='present') %>%
  rbind(E2a.ta.sign_consistency$consistency_per_id %>%
          mutate(resp='absent'))

min_sc = E2a.RT_sc$score%>%min()
max_sc = E2a.RT_sc$score%>%max()
E2a.RT <- E2a.RT %>%
  merge(E2a.RT_sc, by=c('subj_id','resp'))

E2a.rt_present_plot<- E2a.RT %>% 
  filter(resp=='present') %>%
  mutate(subj_id=factor(subj_id,
                        levels=E2a.RT %>%
                          group_by(subj_id) %>%
                          summarise(score=mean(score)) %>%
                          arrange(score) %>%
                          pull(subj_id))) %>%
  ggplot(aes(x=occluded_rows, 
             y=median_RT, 
             color=score,
             group=subj_id)) +
  geom_line(size=1.5)+
  geom_errorbar(aes(ymin=median_RT-sem_RT,ymax=median_RT+sem_RT),width=0.1)+
  scale_color_gradient(low = 'gray', 
                       high = "#377eb8", limits=c(0,1))+
  scale_size_continuous(range=c(0,3))+
  scale_y_continuous(limits=c(1000,4600))+
  facet_grid(~resp)+
  labs(x='occluded rows',
       y='RT')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14))


ggsave('../docs/figures/Fig6/panelC/E2aRT_present.png',E2a.rt_present_plot,width=2.2,height=3.5);


E2a.rt_absent_plot<- E2a.RT %>% 
  filter(resp=='absent') %>%
  mutate(subj_id=factor(subj_id,
                        levels=E2a.RT %>%
                          group_by(subj_id) %>%
                          summarise(score=mean(score)) %>%
                          arrange(score) %>%
                          pull(subj_id))) %>%
  ggplot(aes(x=occluded_rows, 
             y=median_RT, 
             color=score,
             group=subj_id)) +
  geom_line(size=1.5)+
  geom_errorbar(aes(ymin=median_RT-sem_RT,ymax=median_RT+sem_RT),width=0.1)+
  scale_color_gradient(low = 'gray', 
                       high = "#E41a1c", limits=c(0,1))+
  scale_size_continuous(range=c(0,3))+
  scale_y_continuous(limits=c(1000,4600))+
  facet_grid(~resp)+
  labs(x='occluded rows',
       y='RT')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14))


ggsave('../docs/figures/Fig6/panelC/E2aRT_absent.png',E2a.rt_absent_plot,width=2.2,height=3.5);

plot_sign_consistency <- function(sc_results,color,file_path) {
  
  # calculate density
  dens <- density(sc_results$null)
  
  # rescale the x values of the density to match the width of the rectangle
  dens$x <- (dens$x - min(dens$x)) / diff(range(dens$x))
  
  # rescale the y values of the density to match the height of the rectangle
  dens$y <- (dens$y / max(dens$y)) * 0.1 + 0.45
  
  # create a data frame for the density
  df_density <- data.frame(x = dens$x, y = dens$y)
  
  # Create a data frame for the points
  df_points <- data.frame(x = sc_results$consistency_per_id$score, 
                          y = rep(0.472, length(sc_results$consistency_per_id)))
  
  # Number of steps in the gradient
  n <- 500
  
  # Create a data frame for the gradient
  df_rect <- data.frame(x = seq(0, 1, length.out = n), 
                        alpha = seq(0, 1, length.out = n))%>% 
    mutate(height=ifelse(abs(x-sc_results$statistic)<0.01,0.1,0.02),
           y = ifelse(abs(x-sc_results$statistic)<0.01,0.50,0.46))
  
  print(df_points)
  
  # Create the plot
  p <- ggplot() +
    # Draw the rectangle
    geom_tile(data = df_rect, aes(x = x, y = y, fill = alpha, height=height), width = 1/n) +
    scale_fill_gradient(low = 'gray', 
                        high = color) +
    scale_color_gradient(low = 'gray', 
                         high = color)+
    # Draw the density plot
    geom_line(data = df_density, aes(x = x, y = y), color = "black") +
    # Draw the points
    geom_jitter(data = df_points, aes(x = x, y = y,fill=x), size = 4, shape=21,color = "black",width=0,height=0.01) +
    # geom_point(data = df_points, aes(x = x, y = y), size = 4, shape=21,color = "black") +
    # geom_vline(xintercept=sc_results$statistic, size=1, color=color, alpha=sc_results$statistic) +
    geom_text(data=df_density, aes(x=sc_results$statistic+0.05, y=0.51, label = sprintf("%.2f", sc_results$statistic), color=x), alpha=sc_results$statistic, size=6) +
    coord_fixed(ratio = 3) +
    theme_void() +
    theme(axis.text.y = element_text(margin = margin(t = 1000)),
          axis.ticks.y = element_line(),
          plot.margin = margin(0, 0, 0, 0)) +
    scale_x_continuous(breaks = seq(0, 1, by = 0.2), limits = c(0, 1)) +
    theme(legend.pos='na', text = element_text(size = 14)) +
    coord_flip()
  
  ggsave(file_path, plot = p, width = 1.2, height = 4, units = "in", dpi = 300)
  
  p
}


plot_sign_consistency(E2a.ta.sign_consistency,"#e41a1c",'../docs/figures/Fig6/panelC/E2a_SC_RT_ta.png')
plot_sign_consistency(E2a.tp.sign_consistency,"#377eb8",'../docs/figures/Fig6/panelC/E2a_SC_RT_tp.png')

### panel D: sign consistency, rows + reference

E3a.RT <- E3a.df %>%
  filter((test_part=='test1' | test_part=='test2') & RT>100 & RT<5000 & correct) %>%
  mutate(occluded_rows=factor(ifelse(hide_proportion>0.2,6,2)))%>%
  group_by(subj_id,resp, occluded_rows) %>%
  summarise(
    median_RT=median(RT),
    sem_RT=bootstrap_error(RT,N_perm)
  ) %>%
  mutate(resp=factor(resp,levels=c(TRUE,FALSE),labels=c('present','absent'))) 

E3a.RT_sc <- E3a.tp.sign_consistency$consistency_per_id %>%
  mutate(resp='present') %>%
  rbind(E3a.ta.sign_consistency$consistency_per_id %>%
          mutate(resp='absent'))

min_sc = E3a.RT_sc$score%>%min()
max_sc = E3a.RT_sc$score%>%max()
E3a.RT <- E3a.RT %>%
  merge(E3a.RT_sc, by=c('subj_id','resp'))

E3a.rt_present_plot<- E3a.RT %>% 
  filter(resp=='present') %>%
  mutate(subj_id=factor(subj_id,
                        levels=E3a.RT %>%
                          group_by(subj_id) %>%
                          summarise(score=mean(score)) %>%
                          arrange(score) %>%
                          pull(subj_id))) %>%
  ggplot(aes(x=occluded_rows, 
             y=median_RT, 
             color=score,
             group=interaction(subj_id,resp))) +
  geom_line(size=1.5)+
  geom_errorbar(aes(ymin=median_RT-sem_RT,ymax=median_RT+sem_RT),width=0.1)+
  scale_color_gradient(low = 'gray', 
                       high = "#377eb8", limits=c(0,1))+
  scale_size_continuous(range=c(0,3))+
  scale_y_continuous(limits=c(1000,4600))+
  facet_grid(~resp)+
  labs(x='occluded rows',
       y='RT')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14))


ggsave('../docs/figures/Fig6/panelD/E3aRT_present.png',E3a.rt_present_plot,width=2.2,height=3.5);


E3a.rt_absent_plot<- E3a.RT %>% 
  filter(resp=='absent') %>%
  mutate(subj_id=factor(subj_id,
                        levels=E3a.RT %>%
                          group_by(subj_id) %>%
                          summarise(score=mean(score)) %>%
                          arrange(score) %>%
                          pull(subj_id))) %>%
  ggplot(aes(x=occluded_rows, 
             y=median_RT, 
             color=score,
             group=interaction(subj_id,resp))) +
  geom_line(size=1.5)+
  geom_errorbar(aes(ymin=median_RT-sem_RT,ymax=median_RT+sem_RT),width=0.1)+
  scale_color_gradient(low = 'gray', 
                       high = "#E41a1c", limits=c(0,1))+
  scale_size_continuous(range=c(0,3))+
  scale_y_continuous(limits=c(1000,4600))+
  facet_grid(~resp)+
  labs(x='occluded rows',
       y='RT')+
  theme_bw() +
  theme(legend.pos='na', text = element_text(size = 14))


ggsave('../docs/figures/Fig6/panelD/E3aRT_absent.png',E3a.rt_absent_plot,width=2.2,height=3.5);

plot_sign_consistency(E3a.ta.sign_consistency,"#e41a1c",'../docs/figures/Fig6/panelD/E3a_SC_RT_ta.png')
plot_sign_consistency(E3a.tp.sign_consistency,"#377eb8",'../docs/figures/Fig6/panelD/E3a_SC_RT_tp.png')
