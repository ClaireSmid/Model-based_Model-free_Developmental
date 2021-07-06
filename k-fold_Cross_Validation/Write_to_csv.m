%% write to csv file for kfold data
% ugly script but w/e
% saves in Final_Files_for_Analysis folder for kids and adults separately

addpath('../Final_Files_for_Analysis')

% for kids
load('k_fold_CV_test_kids_2Oct20.mat')
load('k_fold_CV_train_kids_2Oct20.mat')

Kdata = []; %zeros(length(train),1);

for p = 1:length(train)
    a = [train(p).fold.id];
%     disp(a(1));
    Kdata(p).id = a(1);
    Kdata(p).group = 1;
    Kdata(p).M1_acc = test(p).mean_accuracyP6;
    Kdata(p).M2_acc = test(p).mean_accuracyP7;
end

Kdata_T = struct2table(Kdata);
writetable(Kdata_T,'../Final_Files_for_Analysis/Kids_k-fold_cross_validation.csv','Delimiter',',')

clear Kdata
clear Kdata_T

Kdata = []; %zeros(length(train),1);

% for adults
load('k_fold_CV_test_adlts_2Oct20.mat')
load('k_fold_CV_train_adlts_2Oct20.mat')

Kdata = []; %zeros(length(train),1);

for p = 1:length(train)
    a = [train(p).fold.id];
%     disp(a(1));
    Kdata(p).id = a(1);
    Kdata(p).group = 2;
    Kdata(p).M1_acc = test(p).mean_accuracyP6;
    Kdata(p).M2_acc = test(p).mean_accuracyP7;
end

Kdata_T = struct2table(Kdata);
writetable(Kdata_T,'../Final_Files_for_Analysis/Adults_k-fold_cross_validation.csv','Delimiter',',')
