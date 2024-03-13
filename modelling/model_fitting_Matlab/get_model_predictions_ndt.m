function model_predictions = get_model_predictions_ndt(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, dt, T)
    % true thetas: [p(1|absent), p(1|present)]
    % believed thetas: participants' beliefs about the true thetas
    % gamma: the temporal discount factor (but before applying a sigmoid
    % function)
    % minimal_ndt: the minimum non-decision time, in seconds (assuming 20 time points per second)
    % ndt_range: maxmimal ndt minus minimal_ndt
    % dt: s per time point
    % T: number of time points to simulate
    
    gamma = 1/(1+exp(-10*gamma));

    % 1. FIND POLICY
    V = nan(T*2+1, T*2+1); % Value
    A = nan(T*2+1, T*2+1); % Action
    LLR = nan(T*2+1, T*2+1); % Log likelihood ratio

    % Backward induction
    for t = T*2:-1:0
        states = 0:t; % State is the number of 1's observed so far
        LLR_at_t = states .* (log(believed_thetas(2)) - log(believed_thetas(1))) + ...
                   (t-states) .* (log(1-believed_thetas(2)) - log(1-believed_thetas(1)));
                   
        LLR(t+1,states+1) = LLR_at_t;
        
        % To avoid overflow errors later
        clipped_LLR_at_t = min(max(LLR_at_t, -500), 500);

        P_present = exp(clipped_LLR_at_t) ./ (1 + exp(clipped_LLR_at_t));
        
        % The expected value if I make a decision now is the probability of being correct
        V_choose_now = max(P_present, 1-P_present);
        
        if t == T*2
            V(t+1, states+1) = V_choose_now;
            A(t+1, states+1) = double(LLR_at_t > 0);
        else
            % Calculate value if waiting
            prob1 = P_present .* believed_thetas(2) + (1-P_present) .* believed_thetas(1);
            V_wait = gamma * (prob1 .* V(t+2, states+2) + (1-prob1) .* V(t+2, states+1));
            
            % The expected value is the maximum between the expected value if I wait or if I make a decision.
            V(t+1, states+1) = max(V_choose_now, V_wait);
            
            A(t+1, states+1) = double(LLR_at_t > 0); % the action is 1 if deciding 'present', 0 if deciding 'absent'

            A(t+1, V_choose_now <= V_wait) = nan; % the action is nan if not making a decision.

        end
    end
    
    % 2. RUN SIMULATION FORWARD
    
    ndt_indices = floor(minimal_ndt/dt):ceil((minimal_ndt+ndt_range)/dt); % Convert NDT from seconds to time points
    ndt_weights = [mod(minimal_ndt/dt,1), ones(1, length(ndt_indices)-2),mod((minimal_ndt+ndt_range)/dt,1)];
    ndt_weights = ndt_weights/sum(ndt_weights);
    ndt_weights = reshape(ndt_weights,[1,1,length(ndt_weights)]);

    model_predictions = zeros(2, 2, T + max(ndt_indices));
    % Run simulations for both target absence and presence
    for target_presence = 0:1
        prob = zeros(T+1,T+1);
        prob(1,1) = 1;
        for t = 0:T-1
            states = 0:t;
            yes_indices = states(A(t+1,states+1)==1);
            no_indices = states(A(t+1,states+1)==0);
            update_indices = states(isnan(A(t+1,states+1)));
            model_predictions(target_presence+1,1,t+ndt_indices+1)=model_predictions(target_presence+1,1,t+ndt_indices+1)+sum(prob(t+1,no_indices+1)).*ndt_weights;
            model_predictions(target_presence+1,2,t+ndt_indices+1)=model_predictions(target_presence+1,2,t+ndt_indices+1)+sum(prob(t+1,yes_indices+1))*ndt_weights;
            prob(t+2, update_indices+1) = prob(t+2, update_indices+1) + ...
                prob(t+1, update_indices+1)*(1 - true_thetas(target_presence+1));
            prob(t+2, update_indices+2) = prob(t+2, update_indices+2) + ...
                prob(t+1, update_indices+1)*true_thetas(target_presence+1);            
        end
    end
    
    model_predictions = model_predictions(:,:,1:T)+0.00001; 
    
    % Normalize predictions
    for present = 1:2
        model_predictions(present, :, :) = ...
            model_predictions(present, :, :) / sum(sum(model_predictions(present, :, :)));
    end
    
    return
