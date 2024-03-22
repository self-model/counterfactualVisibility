function simulated_data = simulate_data_by_occlusion_softmax(params, dt, T, ntrials)
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

%apply the sigmoid function to the thetas and gamma
params(1:5) = 1./(1+exp(-10.*params(1:5)));

%multiply temp by 10
params(10) = params(10)*10;

%apply the exponent to alpha and temp
params(8:10) =exp(params(8:10));

data_high_occlusion = simulate_data_softmax([params(1), params(2)+params(1)]*params(8), [params(3), params(4)+params(3)]*params(9), params(5), params(6), params(7), params(10), dt, T,ntrials);
data_low_occlusion = simulate_data_softmax([params(1), params(2)+params(1)]/params(8), [params(3), params(4)+params(3)]/params(9), params(5), params(6), params(7), params(10), dt, T,ntrials);
simulated_data = cat(4,data_high_occlusion,data_low_occlusion);
simulated_data=permute(simulated_data,[4,1,2,3]);

end