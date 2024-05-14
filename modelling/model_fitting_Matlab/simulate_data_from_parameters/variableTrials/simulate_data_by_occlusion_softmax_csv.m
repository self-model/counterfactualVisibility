function simulated_data = simulate_data_by_occlusion_softmax_csv(params, dt, T, ntrials)
% params are in the order:
% true_theta0, [1]
% true_theta1-true_theta0, [2]
% believed_theta0, [3]
% believed_theta1 - believed_theta0, [4]
% gamma for temporal discounting, [5]
% minimum non-decision time, [6]
% non-decision time range, [7]
% log alpha, [8]
% believed log alpha, [9]
% softmax temperature [10]

data_high_occlusion = simulate_data_softmax_csv([params(1), params(2)+params(1)]*params(8), [params(3), params(4)+params(3)]*params(9), params(5), params(6), params(7), params(10), dt, T,ntrials);
data_low_occlusion = simulate_data_softmax_csv([params(1), params(2)+params(1)]/params(8), [params(3), params(4)+params(3)]/params(9), params(5), params(6), params(7), params(10), dt, T,ntrials);
occlusion_is_low = [zeros(ntrials*2,1); ones(ntrials*2,1)];
simulated_data = [[data_high_occlusion;data_low_occlusion] occlusion_is_low];

end