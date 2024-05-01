function [] = getBestParameters(fit_path,target_path,apply_transformations)

    load(fit_path)

    nparams = size(fitted_parameters,2);
    
    [~, idx] = min(LL, [], 2);
    best_parameters = nan(size(idx,1),nparams);
    
    for i=1:size(best_parameters,1)
        best_parameters(i,:) = fitted_parameters(i,:,idx(i));
    end
    
    %% APPLY TRANFORMATIONS %%
    if apply_transformations==1
        %apply the sigmoid function to the thetas and gamma
        best_parameters(:,1:5) = 1./(1+exp(-10.*best_parameters(:,1:5)));
    
        %multiply temp by 10
        best_parameters(:,10) = best_parameters(:,10)*10;
        
        %apply the exponent to alpha and softmax temp
        best_parameters(:,8:10) =exp(best_parameters(:,8:10));
    end

    writematrix(best_parameters,target_path,'Delimiter',',');

end