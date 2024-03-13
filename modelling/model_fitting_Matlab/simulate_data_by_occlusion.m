function simulated_data = simulate_data_by_occlusion(params, dt, T, ntrials)
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

% simulate_data(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, dt, T, ntrials)

data_high_occlusion = simulate_data(params(1:2).*exp(params(8)), params(3:4).*exp(params(9)), params(5), params(6), params(7), dt, T,ntrials);
data_low_occlusion = simulate_data(params(1:2), params(3:4), params(5), params(6), params(7), dt, T,ntrials);
simulated_data = cat(4,data_high_occlusion,data_low_occlusion);
simulated_data=permute(simulated_data,[4,1,2,3]);

end