function [] = simulateAndSave(parameters,dt,T,ntrials,filename)

rng(1);

nsubjects = size(parameters,1);

simulated_data=[];

for i=1:nsubjects
    i
    parameters_i = parameters(i,:);
    subj_simulated_data = simulate_data_by_occlusion_softmax_csv(parameters_i, dt, T, ntrials);
    simulated_data = [simulated_data; [i*ones(size(subj_simulated_data,1),1) subj_simulated_data]];
end

simulated_data = array2table(simulated_data);
simulated_data.Properties.VariableNames(1:6) = {'subj_id','present','rt','correct','confidence','occlusion_is_low'};
writetable(simulated_data,fullfile('simulated_data',[filename,'.csv']),'Delimiter',',')
