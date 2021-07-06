% combine parameter recovery results
%%% ugly script but w/e

addpath('../Final_Files_for_Analysis')

% %% 6 params recov data
% % load sim data + initial parameters
% load simulated_data_P6_200sims_IT0.2_s-0.5.0.5.mat
% 
% % load results
% load parameter_recovery_P6_200sims_IT0.2_s-0.5.0.5.mat
% 
% a = cell2mat({results.x}.');
% 
% Cdata = [];
% 
% Cdata.sim = [Sdata.sim]';
% Cdata.init_it = [Sdata.init_it]';
% Cdata.res_it = a(:,1);
% Cdata.init_lr = [Sdata.init_lr]';
% Cdata.res_lr = a(:,2);
% Cdata.init_et = [Sdata.init_et]';
% Cdata.res_et = a(:,3);
% Cdata.init_w = [Sdata.init_w]';
% Cdata.res_w = a(:,4);
% Cdata.init_st = [Sdata.init_st]';
% Cdata.res_st = a(:,5);
% Cdata.init_repst = [Sdata.init_repst]';
% Cdata.res_repst = a(:,6);
% 
% Cdata_T = struct2table(Cdata);
% writetable(Cdata_T,'../Final_Files_for_Analysis/Param_recovery_P6_200sims_IT01_s-0505.csv','Delimiter',',')
% 

%% 7 params recov data
% load simulated_data_P7_200Sims.mat
% All_data = Sdata;
% load simulated_data_P7_200Sims_2.mat
% Sdata.sim = [Sdata.sim].*1000;
% 
% All_data = [All_data;Sdata];
% 
% Sdata = All_data;

% load results
load parameter_recovery_P7_200Sims.mat
All_data = Pdata;
load parameter_recovery_P7_200Sims_2.mat
% z = 201:400';
% Pdata.sim(1,:) = z;

All_data = [All_data,Pdata];


columnstoremove = {'stimuli','choice','points','s','stake'};
Cdata = rmfield(All_data,columnstoremove);


% Cdata.sim = [Sdata.sim]';
% Cdata.init_it = [Sdata.init_it]';
% Cdata.res_it = a(:,1);
% Cdata.init_lr = [Sdata.init_lr]';
% Cdata.res_lr = a(:,2);
% Cdata.init_et = [Sdata.init_et]';
% Cdata.res_et = a(:,3);
% Cdata.init_w_lo = [Sdata.init_w_lo]';
% Cdata.res_w_lo = a(:,4);
% Cdata.init_w_hi = [Sdata.init_w_hi]';
% Cdata.res_w_hi = a(:,5);
% Cdata.init_st = [Sdata.init_st]';
% Cdata.res_st = a(:,6);
% Cdata.init_repst = [Sdata.init_repst]';
% Cdata.res_repst = a(:,7);



Cdata_T = struct2table(Cdata);
writetable(Cdata_T,'../Final_Files_for_Analysis/Param_recovery_P7_400Sims_4Nov20.csv','Delimiter',',')