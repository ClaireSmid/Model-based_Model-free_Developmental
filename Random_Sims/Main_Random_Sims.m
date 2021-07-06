%% Create random sims
% used for a chance baseline of performance for the children.

% for each simulation, do this: 
% 1. use real rewards children saw
% 2. use real stimuli 
% 3. create random sims and calculate their corrected reward rate. 

clear variables;
close all;
clc;

rng shuffle

% Insert actual data from the children. e.g. amount of trials and drifting
% reward rates
% for each participant. as well as the stimuli


%% Model 0. Random responding
Model0_Sim_M = [];

load ../kidgroupdata.mat
%load adltgroupdata.mat

mix = kidgroupdata.subdata;
%mix = [kidgroupdata.subdata, adltgroupdata.subdata];
 
PPs = length(mix);

Nrits = 1000;


for sub = 1:PPs

    fprintf('Now on random sub: %d\n', sub)

    % get true rewards and trials for each subject
    
    Trews = mix(sub).rews; % = trials, differs, depends on rewards
    
    % include timeouts - else randoms get more tries
    Missed = mix(sub).timeout;
    Trials = length(Trews);
    Points = mix(sub).points;
    
    for tt = 1:Nrits

        % make random simulation
        [AA, RR, RWR, MSS] = Sim_Model_0_Random(Trials,Trews,Missed);

        % save results
        Model0_Sim(tt).sub = sub;
        Model0_Sim(tt).Kool_Pts = mean(RR(~MSS)) - mean(mean(RWR(~MSS,:)));
        
        [AA, RR, RWR, MSS] = Real_Rews(Trials,Trews,Missed,Points);
        Model0_Sim(tt).Real_Pts = mean(RR(~MSS)) - mean(mean(RWR(~MSS,:)));


    end
    
    % save outputs
    Model0_Sim_M(sub).id = mix(sub).id;
    Model0_Sim_M(sub).actual_Avg_Pts = kidgroupdata.points(sub);
    Model0_Sim_M(sub).check_actual_Avg_Pts = mean([Model0_Sim.Real_Pts]);
    Model0_Sim_M(sub).Random_Kool_Pts = mean([Model0_Sim.Kool_Pts]);
    
end


save Model0_Sim_M.mat Model0_Sim_M
T = struct2table(Model0_Sim_M);
writetable(T,'../RandomSims_Performance.csv','Delimiter',',');
