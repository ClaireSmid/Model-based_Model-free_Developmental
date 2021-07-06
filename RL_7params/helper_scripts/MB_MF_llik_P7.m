function  LL = MB_MF_llik_P7(x,data)

% parameters
b = x(1);               % softmax inverse temperature
lr = x(2);              % learning rate
lambda = x(3);          % eligibility trace decay
w_lo = x(4);            % mixing weight low stakes
w_hi = x(5);            % mixing weight high stakes
st = x(6);              % stickiness
respst = x(7);          % stickiness

% initialization
% Qmf = ones(2,2)*0.5;
% Q2 = ones(2,1)*0.5;     % Q(s,a): state-action value function for Q-learning

% UPDATE 14/05/21: resetting these to be initialised at 4.5 rather than 0.5
Qmf = ones(2,2)*4.5;
Q2 = ones(2,1)*4.5;     % Q(s,a): state-action value function for Q-learning

Tm = cell(2,1);
Tm{1} = [0 1; 1 0];     % transition matrix
Tm{2} = [0 1; 1 0];     % transition matrix
M = [0 0; 0 0];         % last choice structure
R = [0; 0];             % last choice structure
LL = 0;

% loop through trials
for t = 1:data.N
    
    % skip timed out trials
    if any(data.timeout(t,:))
        continue
    end
    
    % set choice structure (convert from rockets)
    if (data.stimuli(t,1) == 2) || (data.stimuli(t,1) == 4)
        R = flipud(R);
    end
    
    % get states and action
    s1 = data.s(t,1);
    s2 = data.s(t,2);
    a = data.choice(t);
    action = a;
    a = a - (s1 == 2)*(2);
    
    % compute model based Q value which is based on Q-values and transition structure
    Qmb = Tm{s1}'*Q2;                                        
    
    % depending on stake, either use w_low or w_high
    if data.stake(t) == 1
        w = w_lo;
    else
        w = w_hi;
    end
    
    % mix TD and model value
    Q = w*Qmb + (1-w)*Qmf(s1,:)' + st.*M(s1,:)' + respst.*R;   
    
    % calculate log likelihood
    LL = LL + b*Q(a) - logsumexp(b*Q);
    
    % make the last rocket choice sticky
    M = zeros(2,2);
    M(s1,a) = 1;                                                
    
    % make the last choice sticky
    R = zeros(2,1);
    if action == data.stimuli(t,1)
        R(1) = 1;                                               
    else
        R(2) = 1;
    end
    
    % backup with actual choice (i.e. sarsa)
    dtQ(1) = Q2(s2) - Qmf(s1,a); 
    
    % update model-free Q values with learning rate 
    Qmf(s1,a) = Qmf(s1,a) + lr*dtQ(1);                          
    
    % calculate prediction error (planet reward: 2nd choice)
    dtQ(2) = data.points(t) - Q2(s2);                           
    
    % update Q values with learning rate
    Q2(s2) = Q2(s2) + lr*dtQ(2); 
    
    % update model-free Q values with eligibility trace and learning rate
    Qmf(s1,a) = Qmf(s1,a) + lambda*lr*dtQ(2);    
    
end