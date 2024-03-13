function simulated_data = simulate_data(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, dt, T, ntrials)
    % true thetas: [p(1|absent), p(1|present)]
    % believed thetas: participants' beliefs about the true thetas
    % gamma: the temporal discount factor (but before applying a sigmoid
    % function)
    % minimal_ndt: the minimum non-decision time, in seconds (assuming 20 time points per second)
    % ndt_range: maxmimal ndt minus minimal_ndt
    % dt: s per time point
    % ntrials: number of trials to simulate in each cell
    
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

    simulated_data = zeros(2, 2, T);
    % Run simulations for both target absence and presence
    for target_presence = 0:1
        for trial=1:ntrials
            t=0;
            state=0;
            p1 = true_thetas(target_presence+1);
            while isnan(A(t+1,state+1))
                t=t+1;
                state=state+binornd(1,p1);
            end
            RT=t+round(unifrnd(minimal_ndt/dt,(minimal_ndt+ndt_range)/dt));
            decision=A(t+1,state+1);
            if RT<=T
                simulated_data(target_presence+1,decision+1,RT)=simulated_data(target_presence+1,decision+1,RT)+1;
            end
        end
    end

    return
