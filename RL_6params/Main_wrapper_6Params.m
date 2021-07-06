%% Fit the 6-parameter model to the participant data
% this model has one w-parameter (no stakes)


%% 1. fit participant data to model
addpath('../mfit-master')
addpath('helper_scripts')

fprintf('Step 2. Fitting model to participant data.\n\n\n')

% cd .. % need to be in main folder
disp(pwd)
[kidresults, adltresults] = Fit_model_wrapper_parfor_P6;

% play a sound when finished
load gong
sound(y,Fs)