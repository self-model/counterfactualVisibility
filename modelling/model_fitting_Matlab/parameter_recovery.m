parameters_to_recover =  [0.05, 0.15, 0.05, 0.15, 0.5, 1.2, 0.2, -0.5, 0;
    0.05, 0.25, 0.05, 0.15, 0.4, 0.8, 0.55, 0, 0;
    0.35, 0.45, 0.35, 0.45, 0.4, 0.8, 0.05, -0.5, -0.5;
    0.1, 0.2, 0.1, 0.2, 0.7, 2, 2, -0.1, -0.5];

recovered_parameters = [];
T=500;
dt=20;
ntrials=2500;

for i = 1:size(parameters_to_recover,1)
    params=parameters_to_recover(i,:);
    simulated_data = simulate_data_by_occlusion(params,dt,T,ntrials);

    initialParams = [0.25, 0.35, 0.25, 0.35, 0.5, 1.2, 0.5, 0, 0]; % Example values, adjust as necessary
    
    % Define bounds for the parameters (if necessary)
    lb = [0.001, 0.001, 0.001, 0.001, 0, 0, 0, -2, -2]; % Lower bounds
    ub = [0.6, 0.6, 0.6, 0.6, 1, 2, 1, 0, 0]; % Upper bounds
    
    objective = @(params) get_neg_likelihood(params, simulated_data,dt,T);

    % Optimization options, for example, to display iteration output
    options = optimoptions('simulannealbnd','InitialTemperature',500, 'TemperatureFcn','temperatureboltz','PlotFcns',...
              {@saplotbestx,@saplotbestf,@saplotx,@saplotf});

    % Call fmincon
    [optimizedParams, fval] = simulannealbnd(objective, initialParams, lb, ub, options)

    % % Optimization options, for example, to display iteration output
    % options = optimoptions('fmincon', 'Display', 'iter-detailed', 'OutputFcn',...
    %     @outfun, 'Algorithm', 'interior-point', 'ScaleProblem',true,...
    %     'OptimalityTolerance', 1e-2, 'FunctionTolerance', 1e-6);
    % 
    % %Call fmincon
    % [optimizedParams, fval] = fmincon(objective, initialParams, A, b, Aeq, beq, lb, ub, nonlcon, options);
    
    recovered_parameters=[recovered_parameters;optimizedParams];
end