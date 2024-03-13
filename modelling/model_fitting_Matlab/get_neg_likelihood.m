function log_likelihood = get_neg_likelihood(params, data, dt, T)
% params are in the order:
% true_theta0, [1]
% true_theta1, [2]
% believed theta0, [3]
% believed theta1, [4]
% gamma for temporal discounting, [5]
% minimum non-decision time, [6]
% non-decision time range, [7]
% log alpha, [8]
% believed log alpha, [9]

    % High occlusion
    predictions = get_model_predictions_ndt(params(1:2).*exp(params(8)), params(3:4).*exp(params(9)), params(5), params(6), params(7), dt, T);
    log_p = log(predictions);

    log_likelihood = -nansum(nansum(nansum(squeeze(data(1,:,:,:)).*log_p)));
    
    % Low occlusion
    predictions = get_model_predictions_ndt(params(1:2), params(3:4), params(5), params(6), params(7), dt, T);
    log_p = log(predictions);
    
    log_likelihood = log_likelihood - sum(sum(sum(squeeze(data(2,:,:,:)).*log_p)));
    
end