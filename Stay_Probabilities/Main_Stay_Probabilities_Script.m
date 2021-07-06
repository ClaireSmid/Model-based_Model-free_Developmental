%% Wrapper for Stay Probabilities
% for both adults, kids and the two models.
% the regression was conducted in R based on the output from these script,
% using the lme4 package. 

clearvars;
clc;

% for kids and adults
for sample = 1:2
   
    fprintf('Starting with sample %d...\n\n',sample)
        
    %% for the kids
    if sample == 1 

        % load their combined data, and add some columns 
        load('../kidgroupdata.mat');
        groupdata_I = make_raw_data(kidgroupdata);

        % for the two models
        for m = 1:2
            
            fprintf('Running model no. %d...\n\n', m)
            
            % for the P6 model
            if m == 1
%                 disp('skip')

                % get their model results
                load('../RL_6ParamsModel_and_Sims/kidsresults_P6_2Oct20.mat');

                % get their stay probabilities, and fit the regression
                % model
                groupdata = Get_Stay_Probabilities(groupdata_I,kidresults,m);

                % save their data
                save Stay_Prob_Kids_P6_full.mat groupdata
                writetable(groupdata.table,'../Final_Files_for_Analysis/Stay_Prob_Kids_modelPEs_P6.csv','Delimiter',',')
                writetable(groupdata.Com,'../Final_Files_for_Analysis/W_component_Kids_modelPEs_P6.csv','Delimiter',',')
                fprintf('saving data from model %d...\n\n', m)

                % clear it
                clear groupdata

            elseif m == 2
                
                % get their model results
                load('../RL_7ParamsModel_and_Sims/kidsresults_P7_2Oct20.mat');

                % get their stay probabilities, and fit the regression
                % model
                groupdata = Get_Stay_Probabilities(groupdata_I,kidresults,m);

                % save their data
                save Stay_Prob_Kids_P7_full.mat groupdata
                writetable(groupdata.table,'../Final_Files_for_Analysis/Stay_Prob_Kids_modelPEs_P7.csv','Delimiter',',')
                writetable(groupdata.Com,'../Final_Files_for_Analysis/W_component_Kids_modelPEs_P7.csv','Delimiter',',')
                fprintf('saving data from model %d...\n\n', m)

                % clear it
                clear groupdata

            end

        end


    %% For the adults
    elseif sample == 2

        % load their combined data, and add some columns 
        load('../adltgroupdata.mat');
        groupdata_I = make_raw_data(adltgroupdata);
        
        % for the two models
        for m = 1:2
            
            fprintf('Running model no. %d...\n\n', m)

            % for the P6 model
            if m == 1
                
%                 disp('skip')

                % get their model results
                load('../RL_6ParamsModel_and_Sims/adltresults_P6_2Oct20.mat');

                % get their stay probabilities, and fit the regression
                % model
                groupdata = Get_Stay_Probabilities(groupdata_I,adltresults,m);

                % save their data
                save Stay_Prob_Adults_P6_full.mat groupdata
                writetable(groupdata.table,'../Final_Files_for_Analysis/Stay_Prob_Adults_modelPEs_P6.csv','Delimiter',',')
                writetable(groupdata.Com,'../Final_Files_for_Analysis/W_component_Adlts_modelPEs_P6.csv','Delimiter',',')
                fprintf('saving data from model %d...\n\n', m)

                % clear it
                clear groupdata
    
            elseif m == 2
                
                % get their model results
                load('../RL_7ParamsModel_and_Sims/adltresults_P7_2Oct20.mat');

                % get their stay probabilities, and fit the regression
                % model
                groupdata = Get_Stay_Probabilities(groupdata_I,adltresults,m);

                % save their data
                save Stay_Prob_Adults_P7_full.mat groupdata
                writetable(groupdata.table,'../Final_Files_for_Analysis/Stay_Prob_Adults_modelPEs_P7.csv','Delimiter',',')
                writetable(groupdata.Com,'../Final_Files_for_Analysis/W_component_Adlts_modelPEs_P7.csv','Delimiter',',')
                fprintf('saving data from model %d...\n\n', m)

            end
            
        end

    end
    
end