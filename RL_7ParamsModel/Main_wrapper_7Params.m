%% Fit the 7-parameter model to the participant data
% this model has 2 w-parameters for stakes (high and low)


%% 1. fit participant data to model
addpath('../mfit-master')
addpath('helper_scripts')

fprintf('Step 2. Fitting model to participant data.\n\n\n')
% cd .. % need to be in main folder
disp(pwd)
[kidresults, adltresults] = Fit_model_wrapper_parfor_P7;
% play a sound cause finished
load gong
sound(y,Fs)
