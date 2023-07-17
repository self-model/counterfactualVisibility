df <- read_csv('RC_kernels/E2_means.csv') %>%
  mutate(exp=2) %>%
  bind_rows(
    read_csv('RC_kernels/E3_means.csv') %>%
      mutate(exp=3)
  )

S_RC <- df %>%
  dplyr::select(S_RT_present,S_RT_absent, S_conf_present,S_conf_absent, S_hit,S_fa,exp) %>%
  rename(RT_present=S_RT_present,
         RT_absent=S_RT_absent,
         conf_present=S_conf_present,
         conf_absent=S_conf_absent,
         hit=S_hit,
         fa=S_fa)%>%
  group_by(exp)%>%
  mutate(letter='S',
         row=seq(n()))

A_RC <- df %>%
  dplyr::select(A_RT_present,A_RT_absent, A_hit,A_conf_present,A_conf_absent,A_fa,exp) %>%
  rename(RT_present=A_RT_present,
         RT_absent=A_RT_absent,
         conf_present=A_conf_present,
         conf_absent=A_conf_absent,
         hit=A_hit,
         fa=A_fa)%>%
  group_by(exp)%>%
  mutate(letter='A',
         row=seq(n()))

RC <- S_RC %>%
  rbind(A_RC)

RC %>% 
  ggplot(aes(x=hit,y=fa,color=letter,group=letter, fill=letter, label=row)) +
  facet_wrap(~exp) +
  geom_smooth(method='lm') +
  geom_point(size=2)

RC %>% 
  ggplot(aes(x=conf_present,y=conf_absent,color=letter,group=letter, fill=letter, label=row)) +
  geom_smooth(method='lm') +
  geom_point(size=2)