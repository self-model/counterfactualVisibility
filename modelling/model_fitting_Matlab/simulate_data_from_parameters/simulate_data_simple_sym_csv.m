function simulated_data = simulate_data_simple_sym_csv(parameters, T, ntrials)

    true_thetas = parameters(1:2);
    believed_thetas = parameters(3:4);
    gamma = parameters(5);

    % 1. FIND POLICY
    V = nan(T*2+1, T*4+1); % Value. The third dimension is state, which goes from -(T*2+1) to t*2+1 
    A = nan(3, T*2+1, T*4+1); % Action probabilities
    V_by_A = nan(3,T*2+1, T*4+1); % The value that is associated with each action. 

    % the information in seeing an asymmetric activation pattern
    LLR_diff = log(believed_thetas(2))+log((1-believed_thetas(1)))-log(believed_thetas(1))-log((1-believed_thetas(2)));

    % Run simulations for both target absence and presence
    bel_probs_absent = [believed_thetas(1)*(1-believed_thetas(2)), (1-believed_thetas(1))*believed_thetas(2)];
    bel_probs_absent(3)=1-sum(bel_probs_absent);
    bel_probs_present = bel_probs_absent([2,1,3]);

    % Backward induction
    for t = T*2:-1:0
        states = -t:t; % State is the number of presence activations without absence activations minus the number of absence activations without presence activations
        LLR_at_t = states*LLR_diff;
        % To avoid overflow errors later
        P_present = exp(LLR_at_t) ./ (1 + exp(LLR_at_t));
        P_absent = 1-P_present;
        
        % in transitioning to matrix coordinates, we add 1 to time so that 
        % it starts with 1 rather than 0. We also add t+1 to state so that
        % the state of -t is now 1 and the state of t is now t*2+1
        % when deciding "absent", the expected value is the probability of an absent target
        V_by_A(1,t+1,states+t+1) = P_absent; 
        % when deciding "present", the expected value is the probability of a present target
        V_by_A(2,t+1,states+t+1) = P_present;

        % p wait
        if t == T*2
            % if this is the last step, the probability of waiting is 0
            V_by_A(3,t+1,states+t+1) = 0;
        else
            % Calculate value if waiting
            signal_probs = P_present .* (bel_probs_present')+(1-P_present).*(bel_probs_absent');
            V_by_A(3,t+1,states+t+1) = gamma * (signal_probs(1,:) .* V(t+2, states+t+2+1) + ...
                signal_probs(2,:) .* V(t+2, states+t+2-1)+ ...
                signal_probs(3,:) .* V(t+2, states+t+2));
        end
        A(:,t+1,states+t+1)=V_by_A(:,t+1,states+t+1)==repmat(max(V_by_A(:,t+1,states+t+1),[],1),3,1,1);
        if sum(isnan(A(:,t+1,states+t+1)))>0
            dbstop;
        end
        V(t+1, states+t+1) = sum(V_by_A(:,t+1,states+t+1).*A(:,t+1,states+t+1),1);

    end
    
    % 2. RUN SIMULATION FORWARD
    rt = [];
    correct = [];
    present = [];
    confidence = [];
    
    % Run simulations for both target absence and presence
    probs_absent = [true_thetas(1)*(1-true_thetas(2)), (1-true_thetas(1))*true_thetas(2)];
    probs_absent(3)=1-sum(probs_absent);
    probs_present = probs_absent([2,1,3]);
    probs = [probs_absent; probs_present];

    for target_presence = 0:1
        trial_probs = probs(target_presence+1,:);
        for trial=1:ntrials
            t=0;
            state=0;
            action=randsample( [1,2,3], 1, true, A(:,t+1,state+1));
            while action==3
                t=t+1;
                state=state+randsample([1,-1,0],1,true, trial_probs);
                action=randsample( [1,2,3], 1, true, A(:,t+1,state+t+1));
            end
            rt(end+1)=t; 
            present(end+1) = 2*(target_presence-0.5);
            correct(end+1) = target_presence+1==action;
            confidence(end+1) = V_by_A(action,t+1,state+t+1);
            % if RT<=T
            %     simulated_data(target_presence+1,action,RT)=simulated_data(target_presence+1,action,RT)+1;
            % end
        end
    end

    simulated_data = [present' rt' correct' confidence'];

    return
end