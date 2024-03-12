clear all;
close all;

T=10;
gamma=.99;
theta = [.2 .05];
[V,A,PP]=deal(nan(T+1., T+1));
lower_bound = nan(T+1,1);
upper_bound = nan(T+1,1);
for t=T:-1:0
    states= 0:t; % number of 1's
    LLR= states*(log(theta(1))- log(theta(2))) + (t-states)*(log(1-theta(1))- log(1-theta(2)));
    P_present= 1./(1+exp(-LLR));
    V_choose_now= max(P_present,1-P_present);
    P(t+1,states+1)= LLR;
    if t==T
        V(t+1, 1+states)= V_choose_now;
        A(t+1,1+states)= 2*(LLR>0)-1;
    else
        %% calculate value if waiting
        prob1= P_present*theta(1)+ (1-P_present)*theta(2);
        V_wait= gamma*(prob1.*V(t+2,states+1+1)+ (1-prob1).*V(t+2,states+1));
        [V(t+1, 1+states), dum]= max([V_choose_now;V_wait],[],1);
        A(t+1,1+states)= (2-dum).*(2*(LLR>0)-1);
    end
    ind1= find(A(t+1,:)==1);
    plot(t*ones(length(ind1),1), P(t+1,ind1), 'gx');
    ind1= find(A(t+1,:)==0);
    plot(t*ones(length(ind1),1), P(t+1,ind1), 'ro');
end