rng(1)
lb = [-0.4 -0.4 -0.4 -0.4 0.45,0.2,0.1,-0.4,-0.4];
ub = [-0.1 -0.1 -0.1 -0.1 0.8,0.5,0.5,0,0];
parameters_to_recover = rand(10,9) .* ...
    repmat(ub-lb,10,1) + ...
    repmat(lb,10,1);

recovered_parameters = [];
T=500;
dt=0.01;
ntrials=2500;

for i = 1:size(parameters_to_recover,1)
    params=parameters_to_recover(i,:)
    simulated_data = simulate_data_by_occlusion(params,dt,T,ntrials);

    initialParams = [-0.4, -0.4, -0.4, -0.4, 0.4, 0.2, 0.2, -0.1, -0.1]; % Example values, adjust as necessary
    
    objective = @(params) get_neg_likelihood(params, simulated_data,dt,T);
    get_neg_likelihood(params, simulated_data,dt,T)
    % SIMULATED ANNEALING
    options = optimoptions('simulannealbnd','InitialTemperature',10^4,...
        'TemperatureFcn','temperatureboltz',...
              'PlotFcns',{@saplotbestx,@saplotbestf,@saplotx,@saplotf});
    options.Display = 'iter';
% 'TemperatureFcn','temperatureboltz',
    [optimizedParams, fval] = simulannealbnd(objective, initialParams, lb, ub, options)

    %UNCOMMENT TO RUN FMINCON
    % % Optimization options, for example, to display iteration output
    % options = optimoptions('fmincon', 'Display', 'iter-detailed', 'OutputFcn',...
    %     @outfun, 'Algorithm', 'interior-point', 'ScaleProblem',true);

    %Call fmincon
    % [optimizedParams, fval] = fmincon(objective, initialParams, A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    recovered_parameters=[recovered_parameters;optimizedParams];
    plot_by_condition(optimizedParams,simulated_data,dt,T)
end