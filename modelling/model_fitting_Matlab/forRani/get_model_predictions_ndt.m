function convolved_model_predictions = get_model_predictions_ndt(true_thetas, believed_thetas, gamma, ndt, T)
    % true thetas: [p(1|absent), p(1|present)]
    % believed thetas: participants' beliefs about the true thetas
    % gamma: the temporal discount factor (but before applying a sigmoid
    % function)
    % ndt: non-decision time, in seconds (assuming 20 time points per second)
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
    
    ndt_points = floor(ndt * 20); % Convert NDT from seconds to time points
    ndt_resid = ndt*20-ndt_points;

    model_predictions = zeros(2, 2, T + ndt_points);
    % Run simulations for both target absence and presence
    for target_presence = 0:1
        prob = zeros(T+1,T+1);
        prob(1,1) = 1;
        for t = 0:T-1
            for state = 0:t
                if prob(t+1, state+1) > 0
                    if ~isnan(A(t+1, state+1))
                        decision = A(t+1, state+1);
                        model_predictions(target_presence+1, decision+1, t+ndt_points+1) = prob(t+1, state+1);
                    else
                        prob(t+2, state+1) = prob(t+2, state+1) + prob(t+1, state+1) * (1 - true_thetas(target_presence+1));
                        prob(t+2, state+2) = prob(t+2, state+2) + prob(t+1, state+1) * true_thetas(target_presence+1);
                    end
                end
            end
        end
    end
    
    model_predictions = model_predictions(:,:,1:T); 
    shifted_model_predictions = (1-ndt_resid)*model_predictions;
    shifted_model_predictions(:,:,2:end) =shifted_model_predictions(:,:,2:end)+ndt_resid*model_predictions(:,:,1:end-1);
    
    % Convolve with normal distribution
    
    convolved_model_predictions = smoothdata(shifted_model_predictions,3,'gaussian',10)+0.00000001;

    
    % Normalize convolved predictions
    for present = 1:2
        convolved_model_predictions(present, :, :) = ...
            convolved_model_predictions(present, :, :) / sum(sum(convolved_model_predictions(present, :, :)));
    end
    
    return
