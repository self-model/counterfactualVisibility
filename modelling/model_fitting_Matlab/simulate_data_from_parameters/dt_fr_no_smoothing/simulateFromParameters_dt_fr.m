clear all; close all; clc;
dt=1/15;
T=200;
ntrials=1000;
rng(1);

load('E2a_fit_dt_fr_no_smoothing.mat')

E2_best_parameters = nan(10,10);
E2_best_parameters(:,1:6)=best_parameters(:,1:6);
E2_best_parameters(:,7)=0;
E2_best_parameters(:,8:10)=best_parameters(:,7:9);



E2_simulated_data = [];
for i=1:10
    subj_simulated_data = simulate_data_by_occlusion_softmax_csv(E2_best_parameters(i,:), dt,T,ntrials);
    E2_simulated_data = [E2_simulated_data; [i*ones(size(subj_simulated_data,1),1) subj_simulated_data]];
end

E2_simulated_data = array2table(E2_simulated_data);
E2_simulated_data.Properties.VariableNames(1:6) = {'subj_id','present','rt','correct','confidence','occlusion_is_low'};
writetable(E2_simulated_data,'simulated_E2a_dt_fr_no_smoothing.csv','Delimiter',',')
