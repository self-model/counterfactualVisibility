T = 1000;
df = readtable('data/E2a.csv');
df.present(df.present==-1) =0;
df.decision = double((df.correct == 1 & df.present == 1) | (df.correct == 0 & df.present == 0));
df.rt = round(df.rt / 0.05);

for s = 1:10
    df_filtered = df(df.subj_id == s, :);
    subj_data = zeros(2,2,2,T);
    numRows = height(df_filtered);
    for i = 1:numRows
        occlusion_index = df_filtered.occlusion_is_low(i)+1;
        present_index = df_filtered.present(i)+1;
        decision_index = df_filtered.decision(i)+1;
        rt_index = df_filtered.rt(i)+1;
        subj_data(occlusion_index,present_index,decision_index,rt_index)=...
        subj_data(occlusion_index,present_index,decision_index,rt_index)+1;
    end

    % Define the objective function
    % Assuming get_neg_likelihood takes a parameters vector and a data matrix, and returns a scalar
    objective = @(params) get_neg_likelihood(params, subj_data,T);

% Initial guess for the parameters
initialParams = [0.05, 0.15, 0.05, 0.15, 0.5, 1.2, -0.5, -0.5]; % Example values, adjust as necessary

% Define bounds for the parameters (if necessary)
lb = [0.001, 0.001, 0.001, 0.001, 0, 0, -2, -2]; % Lower bounds
ub = [0.6, 0.6, 0.6, 0.6, 1, 2, 0, 0]; % Upper bounds
% Adjust these bounds based on your knowledge of the parameters

% Linear inequality and equality constraints (A*x ≤ b, Aeq*x = beq)
% If you don't have any, set these to empty matrices
A = []; b = []; Aeq = []; beq = [];

% Nonlinear constraints (if you have any)
nonlcon = [];

% Optimization options, for example, to display iteration output
options = optimoptions('simulannealbnd','Display', 'iter', 'InitialTemperature',500, 'TemperatureFcn','temperatureboltz','PlotFcns',...
          {@saplotbestx,@saplotbestf,@saplotx,@saplotf});

% Call fmincon
[optimizedParams, fval] = simulannealbnd(objective, initialParams, lb, ub, options)

end