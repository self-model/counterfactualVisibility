function [] = getBestParameters(filename)

    load([filename,'.mat'])

    [~, idx] = min(LL, [], 2);
    best_parameters = nan(size(idx,1),10);
    
    for i=1:size(best_parameters,1)
        best_parameters(i,:) = fitted_parameters(i,:,idx(i));
    end
    
    writematrix(best_parameters,['best_parameters_from_',filename,'.csv'],'Delimiter',',');

end