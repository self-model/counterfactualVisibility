function log_likelihood = get_neg_likelihood(params, data, T)
% params are in the order:
% true_theta0, [1]
% true_theta1, [2]
% believed theta0, [3]
% believed theta1, [4]
% gamma for temporal discounting, [5]
% non-decision time, [6]
% log alpha, [7]
% believed log alpha, [8]

    % High occlusion
    predictions = get_model_predictions_ndt(params(1:2).*exp(params(7)), params(3:4).*exp(params(7)), params(5), params(6), T);
    log_p = log(predictions);

    log_likelihood = -nansum(nansum(nansum(squeeze(data(1,:,:,:)).*log_p)));
    
    % Low occlusion
    predictions = get_model_predictions_ndt(params(1:2), params(3:4), params(5), params(6), T);
    log_p = log(predictions);
    
    log_likelihood = log_likelihood - sum(sum(sum(squeeze(data(2,:,:,:)).*log_p)));
    
end