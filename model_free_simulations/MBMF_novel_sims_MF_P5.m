function  output = MBMF_novel_sims_MF_P5(x,rews,timeout)

% Mixed model-based / model-free simulation code for a task with
% deterministic transitions, one choice at the second level, and points for
% the second-level bandits.
%
% USAGE: output = MBMF_deterministic_1choice_rew_sim(x,rews)
%
% INPUTS:
%   x - [1 x 4] vector of parameters, where:
%       x(1) - softmax inverse temperature
%       x(2) - learning rate
%       x(3) - eligibility trace decay
%       x(4) - mixing weight
%       x(5) - stimulus stickiness
%       x(6) - response stickiness
%   rews - [N x 2] array storing the rewards, where
%       rews(n,s) is the payoff on trial n in second-level state s after 
%       taking action a, where N is the number of trials
%
% OUTPUTS:
%   output.A - [N x 1] chosen actions at first and second levels
%   R - [N x 1] second level rewards
%   S - [N x 2] first and second level states
%
% Wouter Kool, Aug 2016, based on code written by Sam Gershman
% Edited by Claire Smid, June 2020

% parameters
b = x(1);                   % softmax inverse temperature
lr = x(2);                  % learning rate
lambda = x(3);              % eligibility trace decay
w = 0;                      % mixing weight - set to 0 here
st = x(5);                  % stickiness
respst = x(6);              % stickiness

% % initialization
% Qmf = zeros(2,2);
% Q2 = zeros(2,1);            % Q(s,a): state-action value function for Q-learning

% UPDATE: resetting these to be initialised at 4.5 rather than 0.5
Qmf = ones(2,2)*4.5;
Q2 = ones(2,1)*4.5;     % Q(s,a): state-action value function for Q-learning

Tm = cell(2,1);
Tm{1} = [0 1; 1 0];         % transition matrix
Tm{2} = [0 1; 1 0];         % transition matrix
M = [0 0; 0 0];             % last choice structure for stimuli
R = [0; 0];                 % last choice structure for response

% pre-allocate
N = size(rews,1);

output.stimuli = zeros(N,2);
output.choice = zeros(N,1);
output.points = zeros(N,1);
output.s = zeros(N,2);
output.stake = zeros(N,1);
output.missed = 0;

% loop through trials
for t = 1:N
        
    % generate state
    s1 = ceil(rand*2);
    
    % generate stimuli
    if rand > 0.5
        output.stimuli(t,:) = [1 2];
    else
        output.stimuli(t,:) = [2 1];
    end
    
    if output.stimuli(t,1) == 2
        R = flipud(R);
    end
    
    % putting the same number of missed trials in the novel sims
    if any(timeout(t,:))
        output.choice(t) = -1;
        output.points(t,1) = 0;
        output.s(t,:) = [s1 0];
        output.missed = output.missed + 1;
        continue
    end
    
   % compute model based Q value which is based on Q-values and transition structure
    Qmb = Tm{s1}'*Q2;                                           
    
    % mix TD and model value
    Q = w*Qmb + (1-w)*Qmf(s1,:)' + st.*M(s1,:)' + respst.*R;  
    
    % make choice using softmax
    if rand < exp(b*Q(1))/sum(exp(b*Q))                             
        a = 1;
        s2 = 2;
    else
        a = 2;
        s2 = 1;
    end
    
    % stimulus stickiness 
    M = zeros(2,2);
    M(s1,a) = 1;                                                    
    
    % response stickiness
    R = zeros(2,1);
    if a == output.stimuli(t,1)
        R(1) = 1;                                                   % chose left
    else
        R(2) = 1;                                                   % chose right
    end
    
    % backup with actual choice (i.e. sarsa)
    dtQ(1) = Q2(s2) - Qmf(s1,a);          
    
    % update model-free Q values with learning rate 
    Qmf(s1,a) = Qmf(s1,a) + lr*dtQ(1);                              
    
    % calculate prediction error (planet reward: 2nd choice)
    dtQ(2) = rews(t,s2) - Q2(s2);                                   
    
    % update Q values with learning rate
    Q2(s2) = Q2(s2) + lr*dtQ(2);        
    
    % update model-free Q values with eligibility trace and learning rate
    Qmf(s1,a) = Qmf(s1,a) + lambda*lr*dtQ(2);                       
    
    % store stuff
    output.choice(t) = a;
    output.points(t,1) = rews(t,s2);
    output.s(t,:) = [s1 s2];

end

end