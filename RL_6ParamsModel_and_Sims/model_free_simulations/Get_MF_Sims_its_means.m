%% Get results (w means) from MF sim data
% to improve speed / reduce computing power, multiple iterations were run
% for the model-free simulations. this script extracts the means from
% multiple files and combines them.

addpath('../../Final_Files_for_Analysis/')

%% 6 param MF results
P6 = [];

load Model_Free_P6_Sims2_it1.mat

it1 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it1(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims2_it2.mat

it2 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it2(i,1) = mean(sim_paramsP6{1,i}(:,4));
end


load Model_Free_P6_Sims2_it3.mat

it3 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it3(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims2_it4.mat

it4 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it4(i,1) = mean(sim_paramsP6{1,i}(:,4));
end


load Model_Free_P6_Sims2_it5.mat

it5 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it5(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims2_it6.mat

it6 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it6(i,1) = mean(sim_paramsP6{1,i}(:,4));
end


load Model_Free_P6_Sims2_it7.mat

it7 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it7(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims2_it8.mat

it8 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it8(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims2_it9.mat

it9 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it9(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

P6.itmeans = vertcat(it1,it2,it3,it4,it5,it6,it7,it8,it9);
P6.grandmean = mean(P6.itmeans);

MF_Means = [];
MF_Means.P6 = P6;

save MF_Means.mat MF_Means

MF_Sims = [];
MF_Sims.id = [1:length(P6.itmeans)]';
MF_Sims.P6_w = P6.itmeans;

T = struct2table(MF_Sims);

writetable(T,'../../Final_Files_for_Analysis/MF_Sims2_12Oct20.csv','Delimiter',',')

