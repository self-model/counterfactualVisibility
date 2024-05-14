function simulated_data = simulate_data_vt_csv(true_thetas, believed_thetas, gamma, minimal_ndt, ndt_range, softmax_temp, dt, T, ntrials)
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
V = nan(T*2+1, T*2+1,size(true_thetas,1)); % Value
A = nan(3, T*2+1, T*2+1,size(true_thetas,1)); % Action probabilities
V_by_A = nan(3,T*2+1, T*2+1,size(true_thetas,1)); % The value that is associated with each action.

% Backward induction
for t = T*2:-1:0
    states = 0:t; % State is the number of 1's observed so far
    LLR_at_t = states .* (log(believed_thetas(:,2)) - log(believed_thetas(:,1))) + ...
        (t-states) .* (log(1-believed_thetas(:,2)) - log(1-believed_thetas(:,1)));
    % To avoid overflow errors later
    clipped_LLR_at_t = min(max(LLR_at_t, -500), 500);
    P_present = max(min(exp(clipped_LLR_at_t) ./ (1 + exp(clipped_LLR_at_t)),0.999),0);
    P_absent = 1-P_present;

    V_by_A(1,t+1,states+1,:) = P_absent';
    V_by_A(2,t+1,states+1,:) = P_present';

    % p wait
    if t == T*2
        % if this is the last step, the probability of waiting is 0
        V_by_A(3,t+1,states+1,:) = 0;
    else
        % Calculate value if waiting
        prob1 = P_present .* believed_thetas(:,2) + (1-P_present) .* believed_thetas(:,1);
        if t
            V_by_A(3,t+1,states+1,:) = gamma * (prob1' .* squeeze(V(t+2, states+2,:)) + (1-prob1)' .* squeeze(V(t+2, states+1,:)));
        else
            V_by_A(3,t+1,states+1,:) = gamma * (prob1' .* squeeze(V(t+2, states+2,:))' + (1-prob1)' .* squeeze(V(t+2, states+1,:))');
        end
    end
    A(:,t+1,states+1,:)=exp(V_by_A(:,t+1,states+1,:)/softmax_temp);
    % A(:,t+1,states+1)=max(min(A(:,t+1,states+1),10^30),10^-30);
    A(:,t+1,states+1,:)=A(:,t+1,states+1,:)./sum(A(:,t+1,states+1,:),1);
    % The expected value is the weighted sum of probabilities and the
    % actions associated with them.
    V(t+1, states+1,:) = sum(V_by_A(:,t+1,states+1,:).*A(:,t+1,states+1,:),1);
end

 % 2. RUN SIMULATION FORWARD
occlusion = [];    
rt = [];
correct = [];
present = [];
confidence = [];


true_thetas_3d = cat(3,true_thetas(1:5,:),true_thetas(6:10,:));
% Run simulations for both target absence and presence
for occlusion_is_low=0:1
    for target_presence = 0:1
        for trial=1:round(ntrials/5)
            for difficulty=1:5
                t=0;
                state=0;
                p1 = true_thetas_3d(difficulty,target_presence+1,occlusion_is_low+1);
                action=randsample( [1,2,3], 1, true, A(:,t+1,state+1,occlusion_is_low*5+difficulty));
                while action==3
                    t=t+1;
                    state=state+binornd(1,p1);
                    action=randsample( [1,2,3], 1, true, A(:,t+1,state+1,occlusion_is_low*5+difficulty) );
                end
                rt(end+1)=t*dt+minimal_ndt+rand()*ndt_range; 
                present(end+1) = 2*(target_presence-0.5);
                correct(end+1) = target_presence+1==action;
                confidence(end+1) = V_by_A(action,t+1,state+1);
                occlusion(end+1) = occlusion_is_low;
            end
        end
    end
end

simulated_data = [present' rt' correct' confidence' occlusion'];

return
