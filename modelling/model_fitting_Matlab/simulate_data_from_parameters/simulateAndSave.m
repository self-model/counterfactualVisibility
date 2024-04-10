function [] = simulateAndSave(best_parameters,dt,T,ntrials,filename)

    simulated_data = [];
    for i_subj=1:size(best_parameters,1)
        best_parameters(i_subj,:)
        subj_simulated_data = simulate_data_by_occlusion_softmax_csv(best_parameters(i_subj,:), dt,T,ntrials);
        simulated_data = [simulated_data; [i_subj*ones(size(subj_simulated_data,1),1) subj_simulated_data]];
    end
    
    simulated_data = array2table(simulated_data);
    simulated_data.Properties.VariableNames(1:6) = {'subj_id','present','rt','correct','confidence','occlusion_is_low'};
    writetable(simulated_data,fullfile('simulated_data',[filename,'.csv']),'Delimiter',',')
    
end