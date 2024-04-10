clear all; close all; clc;
dt=0.05;
T=100;
ntrials=1000;
rng(1);

load('E2a_fit.mat')

[~, idx] = min(LL, [], 2);
E2_best_parameters = nan(10,10);

for i=1:size(E2_best_parameters,1)
    E2_best_parameters(i,:) = fitted_parameters(i,:,idx(i));
end

E2_best_parameters(:,9) = 0;
E2_simulated_data = [];
for i=1:size(E2_best_parameters,1)
    subj_simulated_data = simulate_data_by_occlusion_softmax_csv(E2_best_parameters(i,:), dt,T,ntrials);
    E2_simulated_data = [E2_simulated_data; [i*ones(size(subj_simulated_data,1),1) subj_simulated_data]];
end

E2_simulated_data = array2table(E2_simulated_data);
E2_simulated_data.Properties.VariableNames(1:6) = {'subj_id','present','rt','correct','confidence','occlusion_is_low'};
writetable(E2_simulated_data,'simulated_E2a_varB.csv','Delimiter',',')

load('E3a_fit.mat')

[~, idx] = min(LL, [], 2);
E3_best_parameters = nan(10,10);

for i=1:size(E3_best_parameters,1)
    E3_best_parameters(i,:) = fitted_parameters(i,:,idx(i));
end
E3_best_parameters(:,9) = 0;

E3_simulated_data = [];
for i=1:size(E3_best_parameters,1)
    subj_simulated_data = simulate_data_by_occlusion_softmax_csv(E3_best_parameters(i,:), dt,T,ntrials);
    E3_simulated_data = [E3_simulated_data; [i*ones(size(subj_simulated_data,1),1) subj_simulated_data]];
end

E3_simulated_data = array2table(E3_simulated_data);
E3_simulated_data.Properties.VariableNames(1:6) = {'subj_id','present','rt','correct','confidence','occlusion_is_low'};
writetable(E3_simulated_data,'simulated_E3a_varB.csv','Delimiter',',')


