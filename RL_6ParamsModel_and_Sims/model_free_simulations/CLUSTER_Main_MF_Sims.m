%% Pure Model-free 5 parameter Simulations

%% UPDATE: meeting with Tobias, Wouter and Niko on 02/10/2020
% so fit a model where w does not exist to participant data - so w can only
% be 0. then take those parameters to simulate with this same 5 parameter
% model (with added noise) then fit this to full 7 parameter and also the 6
% parameter model to recreate new model free baselines. - Tobias


%%% 140 trials, one w parameter (6 parameter model) with added noise to
%%% parameters.



% Reviewers asked us to fit a simpler model, that treats w the same across
% stakes. Here, we create model-free sims using the parameters from the
% children when fitted to the 6-parameter model as another comparison with
% model-free simulations based on the simpler model.

% what this script needs to do is create pure model-free agents based on
% the children's parameters. Then it needs to fit these sims to the model
% to get a null-baseline for model-free behaviour.
% In Version 1, we only use model-based behaviour during the low stakes, which we 
% decided would be a good baseline for model-based DM. So we fit a
% model with only 6 parameters. We also only use 70 trials, since
% approximately half of the trials are low stakes.

% Now, we use 140 trials, since we treat the stakes the same.

% We want to end up with 500 iterations of the entire 85 kid sample, so
% 42500 sims. we will take the mean of each of the iterations as a null,
% pure model-free mean. 



%% Step 1. load in data
% results from the Main_wrapper_6Params.m script
% for the model-free simulations, we only use the data from the children

%% For running on local:
clear variables; clc;
rng(123,'twister'); % setting the random seed
addpath('../../mfit-master/')
addpath('../helper_scripts/');
load ../../kidgroupdata.mat
participant_data = kidgroupdata;

%% For running on cluster:
% load('kidgroupdata.mat');
% participant_data = kidgroupdata;

%% Step 2. Fit the 5 parameter model to the kids
subs = length(participant_data.subdata(:));
nstarts = 100;
nrits = 100; %100;

%% for on cluster:
% parpool(12);
% rng(123,'twister'); % setting the random seed

% Start simulations
for i = 1:nrits
    fprintf(['--- iteration ' int2str(i),' ---\n\n'])

    parfor s = 1:subs
        
        data = participant_data.subdata(s);
        fprintf('Fitting participant no. %d\n\n',s)

        % get parameter values for 5 parameter model
        params = set_params_sims_P6;
        f = @(x,data) MB_MF_llik_MF_P5(x,data);
        resultsP5(s) = mfit_optimize(f,params,data,nstarts);
        % in this data, w gets estimated at ~0.5
        fprintf('Completed fitting P5 model to pp %d\n\n',s);
        
%         %% 2.1 generate rewards
%         % use all 140 trials   
%         rews = zeros(140,2);
% 
%         % generate drifting rewards for each participant
%         middle = 4.5;
%         bounds = [0 9];
%         sd = 2;
%         
%         % set 1st reward as a fixed value, one lower, one higher
%         if rand < 0.5
%             rews(1,1) = round(unifrnd(middle, bounds(2),1));
%             rews(1,2) = round(unifrnd(bounds(1), middle,1));
%         else
%             rews(1,2) = round(unifrnd(middle, bounds(2),1));
%             rews(1,1) = round(unifrnd(bounds(1), middle,1));
%         end
% 
%         % here we generate drifting reward, from the first trial that is
%         % fixed
%         for t = 2:length(rews)
%             for z = 1:2 % one planet at a time
%                 d = round(normrnd(0,sd));
%                 rews(t,z) = rews(t-1,z)+d;
%                 rews(t,z) = min(rews(t,z),max(bounds(2)*2 - rews(t,z), bounds(1)));
%                 rews(t,z) = max(rews(t,z),min(bounds(1)*2 - rews(t,z), bounds(2)));
%             end
%         end
%         
%         % and then divide by 9
%         rews = rews./9;
        
        %% 2.1 ALTERNATIVE: just using the rews the participant saw
        rews = data.rews;
        timeouts = data.timeout;
        
       %% 2.2 Use parameters from participant for simulations
        % but we add noise to it here. (this is done similarily to how the
        % reward rate drifts)
        p_bounds = [0 40]; 
        sd = 1;
        d = normrnd(0,sd);
        it = resultsP5(s).x(1);           % get inverse temperature
        it_N = it + d;              % add noise to it
        
        if it_N > p_bounds(2)
            it_N = p_bounds(2);
        elseif it_N <p_bounds(1)
            it_N = p_bounds(1);
        end

        
        p_bounds = [0 1];
        sd = 0.01;
        d = normrnd(0,sd);
        lr = resultsP5(s).x(2);           % get learning rate
        lr_N = lr + d;              % add noise to it
        
        if lr_N > p_bounds(2)
            lr_N = p_bounds(2);
        elseif lr_N <p_bounds(1)
            lr_N = p_bounds(1);
        end
        
        d = normrnd(0,sd);
        eg = resultsP5(s).x(3);          % get eligibility trace
        eg_N = eg + d;              % add noise to it
        
        if eg_N > p_bounds(2)
            eg_N = p_bounds(2);
        elseif eg_N <p_bounds(1)
            eg_N = p_bounds(1);
        end
        
        % so first here I set w to be the estimate from the model above,
        % but w got set to 0.5 by default? so this was quite a high
        % estimate. Now I've set w to 0 again after this step.
        w = resultsP5(s).x(4);           % get eligibility trace
        
        % now also adding noise to these (not done before) 17/09/20
        p_bounds = [-20 20];          % set this from -5 to 5
        sd = 1;
        d = normrnd(0,sd);
        st = resultsP5(s).x(5);           % get rocket stickiness
        st_N = st + d;              % add noise to it
        
        if st_N > p_bounds(2)
            st_N = p_bounds(2);
        elseif st_N <p_bounds(1)
            st_N = p_bounds(1);
        end
       
        resp = resultsP5(s).x(6);         % get rocket stickiness
        resp_N = resp + d;          % add noise to it
        
        if resp_N > p_bounds(2)
            resp_N = p_bounds(2);
        elseif resp_N <p_bounds(1)
            resp_N = p_bounds(1);
        end
        
        initialX = [it; lr; eg; w; st; resp];
        noisyx = [it_N; lr_N; eg_N; w; st_N; resp_N]; % combine parameters in vector
           
        % Actually generate data. feed in parameters and generated rewards
        output = MBMF_novel_sims_MF_P5(noisyx,rews,timeouts);

        % add this info to output
        output.id = s;
        output.rews = rews;
        output.N = length(rews);
        output.initialX = initialX;
        output.NoisyX = noisyx;

        simdata(s) = output;
        
%         %% 2.3 fit the simulated data to the models
%         
%         % fit 6 parameter model
%         params = set_params_sims_P6;
%         f = @(x,data) MB_MF_llik_MF_P6(x,data);
%         resultsP6(s) = mfit_optimize(f,params,output,nstarts);
%         
%         % fit 7 parameter model
%         params = set_params_sims_P7;
%         f = @(x,data) MB_MF_llik_MF_P7(x,data);
%         resultsP7(s) = mfit_optimize(f,params,output,nstarts);
             
        
    end
    
    %% for only saving MF sims results on local
    Iterations(i).simdataP5 = simdata;
    save MF_Sims.mat Iterations
 
    
    %% reshape outcomes and store (on cluster)
%     a = cell2mat({resultsP6.x}.');
%     b = cell2mat({resultsP7.x}.');
%     
%     sim_paramsP6{i} = a;
%     sim_paramsP7{i} = b;
% 
%     Iterations(i).simdataP5 = simdata;
%     Iterations(i).simP5_results = resultsP5;
%     Iterations(i).simP6_results = resultsP6;
%     Iterations(i).simP7_results = resultsP7;
%     
%     fprintf('\n');
%     
%     save Iterations.mat Iterations
    
%     save('~/Scratch/Kool_2020_2/Model_Free_P6_Sims2_it6.mat','sim_paramsP6');
%     save('~/Scratch/Kool_2020_2/Model_Free_P7_Sims2_it6.mat','sim_paramsP7');
%     save('~/Scratch/Kool_2020_2/MF_Sims2_02Oct20_it6.mat','Iterations');


end




