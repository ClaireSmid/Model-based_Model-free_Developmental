%% Parameter recovery 6-parameter model
% parameter recovery for the 6-parameter model (1 w) 

addpath('../mfit-master'); 
rng default

%% Step 1. Generate random parameters
% these results have been created with 100 iterations of the optimizer
% rather than 25
num_agents = 500;
trials = 140;
Sdata = [];

% x1 inverse temperature
itbounds = linspace(0,2,num_agents);
it = (unifrnd(itbounds(1),itbounds(num_agents),num_agents,1));

% x2 learning rate 
lrbounds = linspace(0,1,num_agents); % create uniformally distributed values between 0 and 1
lr = (unifrnd(lrbounds(1),lrbounds(num_agents),num_agents,1)); % sample

% x3 eligibility trace
etbounds = linspace(0,1,num_agents);
et = (unifrnd(etbounds(1),etbounds(num_agents),num_agents,1));

% x4 w mixing weight
wbounds = linspace(0,1,num_agents);
w_lo = (unifrnd(wbounds(1),wbounds(num_agents),num_agents,1));

% x5 sticky 1
sbounds = linspace(-0.5,0.5,num_agents);
st = (unifrnd(sbounds(1),sbounds(num_agents),num_agents,1));

% x6 sticky 2
sbounds = linspace(-0.5,0.5,num_agents);
repst = (unifrnd(sbounds(1),sbounds(num_agents),num_agents,1));

%% Step 2. Generate behaviour based on those parameters
for i = 1:num_agents % for every simulation
    
    fprintf('Now simulating sim %d\n\n', i)
    
    rews = zeros(trials,2);

    % 2.1 generate drifting rewards for each participant
    middle = 4.5;
    bounds = [0 9];
    sd = 2;

    % set 1st reward as a fixed value, one lower, one higher
    if rand < 0.5
        rews(1,1) = round(unifrnd(middle, bounds(2),1));
        rews(1,2) = round(unifrnd(bounds(1), middle,1));
    else
        rews(1,2) = round(unifrnd(middle, bounds(2),1));
        rews(1,1) = round(unifrnd(bounds(1), middle,1));
    end

    % here we generate drifting reward, from the first trial that is
    % fixed
    for t = 2:length(rews)
        for z = 1:2 % one planet at a time
            d = round(normrnd(0,sd));
            rews(t,z) = rews(t-1,z)+d;
            rews(t,z) = min(rews(t,z),max(bounds(2)*2 - rews(t,z), bounds(1)));
            rews(t,z) = max(rews(t,z),min(bounds(1)*2 - rews(t,z), bounds(2)));
        end
    end

    % and then divide by 9
    rews = rews./9;
    
    % 2.2 get parameter values for this sim
    x(1) = it(i);
    x(2) = lr(i);
    x(3) = et(i);
    x(3) = w(i);
    x(5) = st(i);
    x(6) = repst(i);
      
    % 2.3 generate behaviour with the 7-param model
    data = MBMF_generate_sim_6Params(i,x,rews);
    
    % 2.4 save the parameters used for later 
    data.P6_init_it = it(i);
    data.P6_init_lr = lr(i);
    data.P6_init_et = et(i);
    data.P6_init_w = w(i);
    data.P6_init_st = st(i);
    data.P6_init_repst = repst(i);
    
    % 2.5 save data
    Sdata = [Sdata; data];
end

save simulated_data_P6.mat Sdata
clear Sdata

%% Step 2. Start simulations
nstarts = 100;   % to avoid local optima % increased this to 25

load simulated_data_P6.mat
fprintf('Starting fitting now.\n\n');
a = [];
Pdata = [];

parfor z = 1:num_agents  
        %% 2.3 fit simulated data to model
        % run optimization
        % needs a likelihood script as well as data (which is output)
        
        data = Sdata(z);
        fprintf('Now model fitting sim %d\n', z)
        
        params = set_simulation_params6;
        f = @(x,data) MB_MF_llik_simulation_6Params(x,data);
        results = mfit_optimize(f,params,data,nstarts);
               
        a = cell2mat({results.x}.');
        data.P6_res_it = a(1);
        data.P6_res_lr = a(2);
        data.P7_res_et = a(3);
        data.P6_res_w = a(4);
        data.P6_res_st = a(5);
        data.P6_res_repst = a(6);
        
        Pdata = [Pdata, data]; 

end 

save parameter_recovery_P6.mat Pdata

load gong
sound(y,Fs)
    

        


