function simulated_data = simulate_data_softmax(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, softmax_temp, dt, T, ntrials)
    % true thetas: [p(1|absent), p(1|present)]
    % believed thetas: participants' beliefs about the true thetas
    % gamma: the temporal discount factor (but before applying a sigmoid
    % function)
    % minimal_ndt: the minimum non-decision time, in seconds (assuming 20 time points per second)
    % ndt_range: maxmimal ndt minus minimal_ndt
    % softmax_temp: the softmax temperature. Higher values make the
    % decisions noisier.
    % dt: s per time point
    % ntrials: number of trials to simulate in each cell

    
    % 1. FIND POLICY
    V = nan(T*2+1, T*2+1); % Value
    A = nan(3, T*2+1, T*2+1); % Action probabilities
    V_by_A = nan(3,T*2+1, T*2+1); % The value that is associated with each action. 

    % Backward induction
    for t = T*2:-1:0
        states = 0:t; % State is the number of 1's observed so far
        LLR_at_t = states .* (log(believed_thetas(2)) - log(believed_thetas(1))) + ...
                   (t-states) .* (log(1-believed_thetas(2)) - log(1-believed_thetas(1)));
        % To avoid overflow errors later
        clipped_LLR_at_t = min(max(LLR_at_t, -500), 500);
        P_present = exp(clipped_LLR_at_t) ./ (1 + exp(clipped_LLR_at_t));
        P_absent = 1-P_present;
        
        % when deciding "absent", the expected value is the probability of an absent target
        V_by_A(1,t+1,states+1) = P_absent; 
        % when deciding "present", the expected value is the probability of a present target
        V_by_A(2,t+1,states+1) = P_present;

        % p wait
        if t == T*2
            % if this is the last step, the probability of waiting is 0
            V_by_A(3,t+1,states+1) = 0;
        else
            % Calculate value if waiting
            prob1 = P_present .* believed_thetas(2) + (1-P_present) .* believed_thetas(1);
            V_by_A(3,t+1,states+1) = gamma * (prob1 .* V(t+2, states+2) + (1-prob1) .* V(t+2, states+1));
        end
        A(:,t+1,states+1)=exp(V_by_A(:,t+1,states+1)/softmax_temp);
        if sum(isnan(A(:,t+1,states+1)))>0
            dbstop;
        end
        A(:,t+1,states+1)=A(:,t+1,states+1)./sum(A(:,t+1,states+1),1);
        V(t+1, states+1) = sum(V_by_A(:,t+1,states+1).*A(:,t+1,states+1),1);

    end
    
    % 2. RUN SIMULATION FORWARD

    ndt_indices = floor(minimal_ndt/dt):ceil((minimal_ndt+ndt_range)/dt); % Convert NDT from seconds to time points
    ndt_weights = [1-mod(minimal_ndt/dt,1), ones(1, length(ndt_indices)-2),mod((minimal_ndt+ndt_range)/dt,1)];
    ndt_weights = ndt_weights/sum(ndt_weights);

    simulated_data = zeros(2, 2, T);
    % Run simulations for both target absence and presence
    for target_presence = 0:1
        for trial=1:ntrials
            t=0;
            state=0;
            p1 = true_thetas(target_presence+1);
            action=randsample( [1,2,3], 1, true, A(:,t+1,state+1));
            while action==3
                t=t+1;
                state=state+binornd(1,p1);
                action=randsample( [1,2,3], 1, true, A(:,t+1,state+1) );
            end
            RT=t+ndt_indices(randsample(length(ndt_indices),1,true,ndt_weights))+1;
            if RT<=T
                simulated_data(target_presence+1,action,RT)=simulated_data(target_presence+1,action,RT)+1;
            end
        end
    end

    return
