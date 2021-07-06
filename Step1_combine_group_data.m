%%% first script to create the combined data files.
% Edited by CR Smid on 8 April 2021
% based on scripts written by Wouter Kool
% for questions: claire.r.smid@gmail.com

%% Description of the data
% 1. groupdata file (e.g. kidgroupdata)
%   - subdata: structure with the participant data from the task
%   - N: number of trials completed by each participant
%   - missed: percentage of missed trials for each participant
%   - age: age data as entered into Matlab
%   - id: id data as entered into Matlab
%   - points: corrected reward rate per participant for the overall task
%   - points_bystake: correcred reward rate per participant for low (1,1)
%   and high (1,2) stakes

% 2. groupdata.subdata:
%   - id: id as entered into Matlab
%   - age: age as entered into Matlab
%   - data: data and time of testing
%   - dataFileName: name of file
%   - rews: reward (divided by 9) for the 1st and 2nd planet
%   - block: 1-4 for the blocks of trials
%   - s: two values for each state. s(1,1) refers to the rocket stage, 
%   where 1 refers to the 1st pair of rockets, and 2 to the 2nd pair of 
%   rockets. s(1,2) refers to the planet stage, where a 1 refers to the 1st
%   planet, and 2 to the 2nd planet.
%   - stimuli: refers to the pair of rockets they saw for that trial, each
%   row referring to 1 trial. e.g. [1 2] means participants saw rocket 1 on
%   the left, and rocket 2 on the right, and [4 3] means they saw rocket 4
%   on the left and rocket 3 on the right
%   - stake: whether the trial was low (1) or high (5) stakes
%   - choice: which rocket a participant chose (1-4) unless they timed out
%   (-1)
%   - rt: reaction time for choosing a rocket (1,1) and for collecting
%   reward from the planet (1,2)
%   - score: cumulative points won
%   - points: points won on each trial (non-cumulative)
%   - timeout: whether a participant timed out (1) while choosing the
%   rockets (1,1) or while collecting reward on the planet (1,2). if they
%   did not time out the value is 0.
%   - rocketOrder: which stimuli was used to indicate rocket (1-4), e.g. if
%   the order was [1 2 3 4], then stimuli_1 was rocket 1, and if the order
%   was [4 3 2 1] stimuli_1 was rocket 4, etc.
%   - purpleOrder: which purple alien stimuli was used in the practice and 
%   task in the (not used)
%   - redOrder: which red alien stimuli was used in the practice and the
%   task (not used)
%   - N: the number of trials attempted
%   - missed: Boolean value for missed trials

%% combine data files into one matrix
% exclude any participant with less than 90 trials and >30% missing trials(2sd from the mean missing trials)

addpath('data')
addpath('data/child_data')
addpath('data/adult_data')

disp('Step 1. Combining data files.\n\n\n')
% need to create a log of removed participants here.
[kidgroupdata, adltgroupdata, kidlog, adultlog] = groupanalysis;


function [kidgroupdata, adltgroupdata, kidlog, adultlog] = groupanalysis

% run for both samples
for sample = 1:2
    
    fprintf('running sample %d\n\n',sample)
    
    groupdata = [];
    com_log = [];
%     subdata = [];
    
    if sample == 1
        files = dir('data/child_data/*.mat');
        disp(files)
        kidgroupdata = [];
    elseif sample == 2
        files = dir('data/adult_data/*.mat');
        disp(files)
        adltgroupdata = [];
    end

nrfiles = length(files);

s = 0;

for i = 1:nrfiles
   
    fprintf('Analysing PP %d from sample %d\n',i,sample)
    
    load([files(i).folder,'/',files(i).name]);
    
    subdata = [];
    log = [];
    log.id = str2double(data.id);
    log.trials_attempted = sum(data.block>0);
    
    if sum(data.block>0) >= 90
        
        log.init_inclusion = 1;
        
        trials = 1:sum(data.block>0);
        
        % general info
        subdata.id = str2double(data.id);
        subdata.age = data.Age;
        subdata.data = data.date;
        subdata.dataFileName = data.dataFileName;
        
        % task info
        subdata.rews = data.rews(trials,:)/9;
        subdata.block = data.block(trials);
        subdata.s = data.s(trials,:);
        subdata.stimuli = data.stimuli(trials,:);
        subdata.stake = data.stake(trials);
        subdata.choice = data.choice(trials);
        subdata.rt = data.rt(trials,:);
        subdata.score = data.score(trials)/9;
        subdata.points = data.points(trials)/9;
        subdata.timeout = data.timeout(trials,:);
        subdata.rocketOrder = data.rocketOrder;
        subdata.purpleOrder = data.purpleOrder;
        subdata.redOrder = data.redOrder;
        
        subdata.N = length(subdata.block);
        subdata.missed = any(subdata.timeout,2);
        
        if sum(subdata.timeout(:)) > 0
            Missers = sum(subdata.timeout(:));
            P_missed = (Missers*100)/max(trials);
        else
            P_missed = 0;
        end
        
        log.P_missed = P_missed;
        log.actual_trials = (sum(data.block>0) - sum(subdata.missed));

        if P_missed < 30 % so if they did 140 trials and missed less than 42 trials, they will be included
%         if mean(subdata.missed) < 0.3 % throw out participants with > 30% missed data
            
            log.mean_missed_trials = mean(subdata.missed);
            log.frst_stage_missed = sum(subdata.timeout(:,1));
            log.scnd_stage_missed = sum(subdata.timeout(:,2));
            log.final_inclusion = 1;
            
            % included subject
            s = s + 1;
            
            groupdata.subdata(s) = subdata;
%             id_num(s) = str2double(data.id);
            
        else
            
            log.mean_missed_trials = mean(subdata.missed);
            log.frst_stage_missed = sum(subdata.timeout(:,1));
            log.scnd_stage_missed = sum(subdata.timeout(:,2));
            log.final_inclusion = 0;
            
        end
        
    else
        log.init_inclusion = 0;
        log.P_missed = NaN;
        log.actual_trials = NaN;
        log.mean_missed_trials = NaN;
        log.frst_stage_missed = NaN;
        log.scnd_stage_missed = NaN;
        log.final_inclusion = 0;
        
    end
    
    % save log
    com_log = [com_log, log];
    
    
    subdata = groupdata.subdata(s);
    
    % save some info per pp
    groupdata.N(s,1) = subdata.N;
    groupdata.missed(s,1) = mean(subdata.missed);
    groupdata.age(s,1) = subdata.age;
    groupdata.id(s,1) = subdata.id;
    
    % calculate corrected reward rate here
    groupdata.points(s,1) = mean(subdata.points(~subdata.missed)) - mean(mean(subdata.rews(~subdata.missed,:)));
    groupdata.points_bystake(s,1) = mean(subdata.points(subdata.stake==1&~subdata.missed)) - mean(mean(subdata.rews(subdata.stake==1&~subdata.missed,:)));
    groupdata.points_bystake(s,2) = mean(subdata.points(subdata.stake==5&~subdata.missed)) - mean(mean(subdata.rews(subdata.stake==5&~subdata.missed,:)));
    
    % below lines are just the same as above but done separately to check. 
%     groupdata.rewardrate_rr(s,1) = mean(subdata.points(~subdata.missed)); % these are the points not counting trials where they made no decision
%     groupdata.avg_rew(s,1) = mean(mean(subdata.rews(~subdata.missed,:)));
%     groupdata.corr_rr(s,1) = groupdata.rewardrate_rr(s,1) - groupdata.avg_rew(s,1);
%     groupdata.rr_bystake(s,1) = mean(subdata.points(subdata.stake==1&~subdata.missed));
%     groupdata.rr_bystake(s,2) = mean(subdata.points(subdata.stake==5&~subdata.missed));
%     groupdata.avg_rew_bystake(s,1) = mean(mean(subdata.rews(subdata.stake==1&~subdata.missed,:)));
%     groupdata.avg_rew_bystake(s,2) = mean(mean(subdata.rews(subdata.stake==5&~subdata.missed,:)));
%     groupdata.corr_rr_bystake(s,1) = groupdata.rr_bystake(s,1) - groupdata.avg_rew_bystake(s,1);
%     groupdata.corr_rr_bystake(s,2) = groupdata.rr_bystake(s,2) - groupdata.avg_rew_bystake(s,2);
    
end

% save and rename here
all_included = sum([com_log.final_inclusion]);
    
disp('How many pps included?: ');
disp(all_included);

    if sample == 1 % children
        kidgroupdata = groupdata;
        save kidgroupdata.mat kidgroupdata
        kidlog = com_log;
        save kidlog.mat kidlog
    elseif sample == 2 % adults
        adltgroupdata = groupdata;
        save adltgroupdata.mat adltgroupdata
        adultlog = com_log;
        save adultlog.mat adultlog
    end

end

end