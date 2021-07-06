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

% parameters
b = x(1);                   % softmax inverse temperature
lr = x(2);                  % learning rate
lambda = x(3);              % eligibility trace decay
w = 0;                   % mixing weight
st = x(5);              % stickiness
respst = x(6);          % stickiness

% p_bounds = [0 1];
% sd = 0.001;
% d = normrnd(0,sd);
% 
% w = 0 + d;

% initialization
Qmf = zeros(2,2);
Q2 = zeros(2,1);            % Q(s,a): state-action value function for Q-learning
Tm = cell(2,1);
Tm{1} = [0 1; 1 0];         % transition matrix
Tm{2} = [0 1; 1 0];         % transition matrix
M = [0 0; 0 0];             % last choice structure for stimuli
R = [0; 0];                 % last choice structure for response

N = size(rews,1);

output.stimuli = zeros(N,2);
output.choice = zeros(N,1);
output.points = zeros(N,1);
output.s = zeros(N,2);
output.stake = zeros(N,1);
output.missed = 0;

% create stakes
loS = 1+zeros(floor(N/2),1);
hiS = 5+zeros(ceil(N/2),1);
stakes = [loS;hiS];
stakes = stakes(randperm(length(stakes)));
% stakes = Shuffle(stakes);
% stakes = Shuffle(stakes); % shuffle twice?

% loop through trials
for t = 1:N
        
    s1 = ceil(rand*2);
    
    if rand > 0.5
        output.stimuli(t,:) = [1 2];
    else
        output.stimuli(t,:) = [2 1];
    end
    
    
    if output.stimuli(t,1) == 2
        R = flipud(R);
    end
    
        % also putting the same number of missed trials in the novel sims
    if any(timeout(t,:))
        output.choice(t) = -1;
        output.points(t,1) = 0;
        output.s(t,:) = [s1 0];
        output.missed = output.missed + 1;
        continue
    end
    
    Qmb = Tm{s1}'*Q2;                                               % compute model-based value function
    
    Q = w*Qmb + (1-w)*Qmf(s1,:)' + st.*M(s1,:)' + respst.*R;        % mix TD and model value
    
    if rand < exp(b*Q(1))/sum(exp(b*Q))                             % make choice using softmax
        a = 1;
        s2 = 2;
    else
        a = 2;
        s2 = 1;
    end
    
    % stimulus stickiness 
    M = zeros(2,2);
    M(s1,a) = 1;                                                    % make the last choice sticky
    
    % response stickiness
    R = zeros(2,1);
    if a == output.stimuli(t,1)
        R(1) = 1;                                                   % chose left
    else
        R(2) = 1;                                                   % chose right
    end
    
    dtQ(1) = Q2(s2) - Qmf(s1,a);                                    % backup with actual choice (i.e., sarsa)
    Qmf(s1,a) = Qmf(s1,a) + lr*dtQ(1);                              % update TD value function
    
    dtQ(2) = rews(t,s2) - Q2(s2);                                   % prediction error (2nd choice)
    
    Q2(s2) = Q2(s2) + lr*dtQ(2);                                    % update TD value function
    Qmf(s1,a) = Qmf(s1,a) + lambda*lr*dtQ(2);                       % eligibility trace
    
    % store stuff
    output.choice(t) = a;
    output.points(t,1) = rews(t,s2);
    output.s(t,:) = [s1 s2];
    output.stake(t) = stakes(t);
end

end