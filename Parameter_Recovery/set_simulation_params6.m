function [param] = set_simulation_params6

% create parameter structure
% g = [4.82 0.88];  % parameters of the gamma prior
param(1).name = 'inverse temperature';
param(1).logpdf = @(x) 0;%sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
param(1).lb = 0;   % lower bound
param(1).ub = 40; % increase this following reviewer comments? %20;  % upper bound

param(2).name = 'learning rate';
param(2).logpdf = @(x) 0;
param(2).lb = 0;
param(2).ub = 1;

param(3).name = 'eligibility trace decay';
param(3).logpdf = @(x) 0;
param(3).lb = 0;
param(3).ub = 1;

param(4).name = 'w mixing weight';
param(4).logpdf = @(x) 0;
param(4).lb = 0;
param(4).ub = 1;

% mu = 0.15; sd = 1.42;   % parameters of choice stickiness
param(5).name = 'choice stickiness';
param(5).logpdf = @(x) 0;%sum(log(normpdf(x,mu,sd)));
param(5).lb = -20;
param(5).ub = 20;

% mu = 0.15; sd = 1.42;    % parameters of response stickiness
param(6).name = 'response stickiness';
param(6).logpdf = @(x) 0;%sum(log(normpdf(x,mu,sd)));
param(6).lb = -20;
param(6).ub = 20;

end
