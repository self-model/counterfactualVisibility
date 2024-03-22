function log_likelihood = get_neg_likelihood_softmax(params, data, dt, T)
% params are in the order:
% true_theta0, [1] ! before sigmoid
% true_theta1-true_theta0, [2] ! before sigmoid
% believed_theta0, [3] ! before sigmoid
% believed_theta1-believed_theta0, [4] ! before sigmoid
% gamma for temporal discounting, [5] ! before sigmoid
% minimum non-decision time, [6]
% non-decision time range, [7]
% alpha, [8] !before sigmoid
% believed alpha, [9] !before sigmoid


%apply the sigmoid function to the thetas and gamma
params(1:5) = 1./(1+exp(-10.*params(1:5)));

%multiply temp by 10
params(10) = params(10)*10;

%apply the exponent to alpha and softmax temp
params(8:10) =exp(params(8:10));

    % High occlusion
    predictions = get_model_predictions_softmax([params(1), params(2)+params(1)]*params(8), ...
        [params(3), params(4)+params(3)]*params(9), params(5), params(6), params(7), params(10), dt, T);
    log_p = log(predictions);

    log_likelihood = -sum(sum(sum(squeeze(data(1,:,:,:)).*log_p)));
    
    % Low occlusion
    predictions = get_model_predictions_softmax([params(1), params(2)+params(1)]/params(8), ...
        [params(3), params(4)+params(3)]/params(9), params(5), params(6), params(7), params(10), dt, T);
    log_p = log(predictions);
    
    log_likelihood = log_likelihood - sum(sum(sum(squeeze(data(2,:,:,:)).*log_p)));
    
end