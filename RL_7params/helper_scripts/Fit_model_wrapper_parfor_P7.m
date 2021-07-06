%% Notes for function
% Claire Smid, August 2020
% This function starts a parfor loop to fit participants simultaneously. 

function [kidresults, adltresults] = Fit_model_wrapper_parfor_P7

%% Step 1. run for both children and adult samples
for sample = 1:2
    
    if sample == 1
        load ../kidgroupdata.mat
        participant_data = kidgroupdata;
    elseif sample == 2
        clear participant_data
        load ../adltgroupdata.mat
        participant_data = adltgroupdata;
    end

    %% Step 2. Start analysing all subjects with a parfor loop
    subs = length(participant_data.subdata(:));

    % random starting locations for optimizer
    nstarts = 100; % 100;

    parfor i = 1:subs

        data = participant_data.subdata(i);
        data.rews = data.rews.*9; % use UNSCALED rewards
        fprintf('Fitting participant no. %d of sample %d\n\n',i, sample)

        % run optimization
        params = set_params_P7;
        f = @(x,data) MB_MF_llik_P7(x,data);
        results(i) = mfit_optimize(f,params,data,nstarts);

    end

    %% Step 3. Save results per sample

    if sample == 1
        kidresults = results;
        save kidsresults_P7_PRIORS.mat kidresults
        clear participant_data
        clear results
    elseif sample == 2
        adltresults = results;
        save adltresults_P7_PRIORS.mat adltresults
    end


end

end
   