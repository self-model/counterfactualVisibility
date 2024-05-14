function [] = simulateAndSaveSimpleSym(parameters,T,ntrials,filename)

rng(1);

nsubjects = size(parameters,1);

simulated_data= simulate_data_simple_sym_csv(parameters, T, ntrials);

simulated_data = array2table(simulated_data);
simulated_data.Properties.VariableNames(1:4) = {'present','rt','correct','confidence'};
writetable(simulated_data,fullfile('simulated_data',[filename,'.csv']),'Delimiter',',')
