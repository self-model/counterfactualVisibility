function model_predictions = get_model_predictions_softmax(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, softmax_temp, dt, T)
    % true thetas: [p(1|absent), p(1|present)]
    % believed thetas: participants' beliefs about the true thetas
    % gamma: the temporal discount factor 
    % minimal_ndt: the minimum non-decision time, in seconds (assuming 20 time points per second)
    % ndt_range: maxmimal ndt minus minimal_ndt
    % softmax_temp: the softmax temperature. Higher values make the
    % decisions noisier.
    % dt: s per time point
    % T: number of time points to simulate


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
        
        V_by_A(1,t+1,states+1) = P_absent;
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
        % A(:,t+1,states+1)=max(min(A(:,t+1,states+1),10^30),10^-30);
        A(:,t+1,states+1)=A(:,t+1,states+1)./sum(A(:,t+1,states+1),1);
         % The expected value is the weighted sum of probabilities and the
         % actions associated with them.
        V(t+1, states+1) = sum(V_by_A(:,t+1,states+1).*A(:,t+1,states+1),1);

    end
    
    % 2. RUN SIMULATION FORWARD
    
    ndt_indices = floor(minimal_ndt/dt):ceil((minimal_ndt+ndt_range)/dt); % Convert NDT from seconds to time points
    ndt_weights = [1-mod(minimal_ndt/dt,1), ones(1, length(ndt_indices)-2),mod((minimal_ndt+ndt_range)/dt,1)];
    ndt_weights = ndt_weights/sum(ndt_weights);
    ndt_weights = reshape(ndt_weights,[1,1,length(ndt_weights)]);

    model_predictions = zeros(2, 2, T + max(ndt_indices));
    % Run simulations for both target absence and presence
    for target_presence = 0:1
        prob = zeros(1,T+1,T+1);
        prob(1,1,1) = 1;
        for t = 0:T-1
            states = 0:t;
            % answer no
            model_predictions(target_presence+1,1,t+ndt_indices+1)=model_predictions(target_presence+1,1,t+ndt_indices+1)+sum(prob(1,t+1,states+1).*A(1,t+1,states+1)).*ndt_weights;
            % answer yes
            model_predictions(target_presence+1,2,t+ndt_indices+1)=model_predictions(target_presence+1,2,t+ndt_indices+1)+sum(prob(1,t+1,states+1).*A(2,t+1,states+1))*ndt_weights;
            % wait
            prob(1,t+2, states+1) = prob(1,t+2, states+1) + ...
                prob(1,t+1, states+1).*A(3,t+1,states+1)*(1 - true_thetas(target_presence+1));
            prob(1,t+2, states+2) = prob(1,t+2, states+2) + ...
                prob(1,t+1, states+1).*A(3,t+1,states+1)*true_thetas(target_presence+1);            
        end
    end
    
    model_predictions = model_predictions(:,:,1:T)+(10^-10); 

    return
