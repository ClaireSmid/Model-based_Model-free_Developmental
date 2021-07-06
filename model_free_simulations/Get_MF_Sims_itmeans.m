%% Get results (w means) from MF sim data

%% 6 param MF results
P6 = [];

load Model_Free_P6_Sims_it1.mat

it1 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it1(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims_it2.mat

it2 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it2(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims_it3.mat
 
it3 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it3(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

load Model_Free_P6_Sims_it4.mat

it4 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it4(i,1) = mean(sim_paramsP6{1,i}(:,4));
end


load Model_Free_P6_Sims_it5.mat

it5 = zeros(length(sim_paramsP6),1);
for i = 1:length(sim_paramsP6)
    it5(i,1) = mean(sim_paramsP6{1,i}(:,4));
end

% load Model_Free_P6_Sims_it6.mat
% 
% it6 = zeros(length(sim_paramsP6),1);
% for i = 1:length(sim_paramsP6)
%     it6(i,1) = mean(sim_paramsP6{1,i}(:,4));
% end
% 
% 
% load Model_Free_P6_Sims_it7.mat
% 
% it7 = zeros(length(sim_paramsP6),1);
% for i = 1:length(sim_paramsP6)
%     it7(i,1) = mean(sim_paramsP6{1,i}(:,4));
% end
% 
% load Model_Free_P6_Sims_it8.mat
% 
% it8 = zeros(length(sim_paramsP6),1);
% for i = 1:length(sim_paramsP6)
%     it8(i,1) = mean(sim_paramsP6{1,i}(:,4));
% end
% 
% load Model_Free_P6_Sims_it9.mat
% 
% it9 = zeros(length(sim_paramsP6),1);
% for i = 1:length(sim_paramsP6)
%     it9(i,1) = mean(sim_paramsP6{1,i}(:,4));
% end
%
% load Model_Free_P6_Sims_it10.mat
% 
% it10 = zeros(length(sim_paramsP6),1);
% for i = 1:length(sim_paramsP6)
%     it10(i,1) = mean(sim_paramsP6{1,i}(:,4));
% end

%% Combine means
P6.itmeans = vertcat(it1,it2,it3,it4,it5);
%P6.itmeans = vertcat(it1,it2,it3,it4,it5,it6,it7,it8,it9,it10);

P6.grandmean = mean(P6.itmeans);

%% Save output
MF_Means = [];
MF_Means.P6 = P6;

save MF_Means.mat MF_Means

MF_Sims = [];
MF_Sims.id = [1:length(P6.itmeans)]';
MF_Sims.P6_w = P6.itmeans;

T = struct2table(MF_Sims);

writetable(T,'MF_Sims.csv','Delimiter',',')

