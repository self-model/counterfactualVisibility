close all;
clear all;
clc;
rng(1)

%parameter order: [theta0, theta1, believed theta0,
%believed theta1, gamma, minimal ndt (in seconds), ndt range (in seconds),
%alpha, believed alpha, softmax temperature
lb = [-0.4 -0.4 -0.4 -0.4 0.45,0.2,0.1,-0.4,-0.4, -0.5];
ub = [-0.1 -0.1 -0.1 -0.1 0.8,0.5,0.5,0,0,-0.1];

parameters_to_recover = [];

recovered_parameters = [];

T=100; % number of time points to simulate

dt=0.05; % the duration of each time point, in seconds

ntrials=5000; % number of trials to simulate, per cell

while size(parameters_to_recover,1)<10

    params=lb+rand(1,10).*(ub-lb);

    simulated_data = simulate_data_by_occlusion_softmax(params,dt,T,ntrials);

    accuracy = (sum(sum(simulated_data(:,1,1,:)))+sum(sum(simulated_data(:,2,2,:))))/sum(simulated_data(:))

    if accuracy<0.6
        continue
    end
    
    params
    parameters_to_recover = [parameters_to_recover; params];

    initialParams = mean([lb;ub]); 

    A = []; b = []; Aeq = []; beq = [];
    nonlcon = [];

    objective = @(params) get_neg_likelihood_softmax(params, simulated_data,dt,T);
    %likelihood for the true parameters (should be the lowest)
    get_neg_likelihood_softmax(params, simulated_data,dt,T)
    plot_by_condition_softmax(params,simulated_data,dt,T)
    % SIMULATED ANNEALING
    options = optimoptions('simulannealbnd','InitialTemperature',5*10^2,...
        'TemperatureFcn','temperatureboltz',...
              'PlotFcns',{@saplotbestx,@saplotbestf,@saplotx,@saplotf});
    options.Display = 'iter';
% 'TemperatureFcn','temperatureboltz',
    [optimizedParams, fval] = simulannealbnd(objective, initialParams, lb, ub, options)

    %UNCOMMENT TO RUN FMINCON
    % Optimization options, for example, to display iteration output
    % options = optimoptions('fmincon', 'Display', 'iter-detailed', 'OutputFcn',...
    %     @outfun, 'Algorithm', 'interior-point', 'ScaleProblem',true);
    % 
    % % Call fmincon
    % [optimizedParams, fval] = fmincon(objective, initialParams, A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    recovered_parameters=[recovered_parameters;optimizedParams];
    figure;
    plot_by_condition_softmax(optimizedParams,simulated_data,dt,T)
end