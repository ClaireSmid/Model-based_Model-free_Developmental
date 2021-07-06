function setup

%% make variables global
global pms
global data
global ESC

rng('shuffle')

path(path,'subFX'); % allow access to all subfunctions

data = {};
ESC = 0;

%% subject info

% dataFileName = 'test';
[dataFileName,subNum,subID] = gatherSubInfo('mbmfNovelStakes');
data.subID = subID;
data.subNum = subNum;
data.dataFileName = dataFileName;

% % check for double entries
% while true
%     if ~exist(file, 'dataFileName')
%         disp('The ID you entered already exists');
%         break
%     end
% end


%% initialize psychtoolbox

pms.mon = 0;
pms.backgroundColor = [0 0 0];
pms.textSize1 = 24; % text size for message
pms.scoreTextSize = 55;
pms.timeoutTextSize = 100;
pms.textColor = [255 255 255]; % text size for message
pms.colors = [5 157 190;
    115 34 130;
    211 0 0];

%% set up task

pms.rocketOrder = Shuffle(1:4);
pms.purpleOrder = Shuffle(1:2);
pms.redOrder = Shuffle(1:2);

% pms.nrTrialsPerBlock = 40; % so 140 trials in total, rather than 160
% pms.nrBlocks = 4;
% pms.nrTrials = pms.nrTrialsPerBlock*pms.nrBlocks;
% pms.nrPracticeTrials = 10; % was originally 25
% pms.nrTimedPracticeTrials = 3;
% pms.rocketThreshold = 4; % was originally 10
% pms.stakeThreshold = 6; % was originally 10
% pms.nrStakePracticeTrials = 6;

% % use these values for testing:
pms.nrTrialsPerBlock = 5;
pms.nrBlocks = 4;
pms.nrTrials = pms.nrTrialsPerBlock*pms.nrBlocks;
pms.nrPracticeTrials = 1;
pms.nrTimedPracticeTrials = 1;
pms.rocketThreshold = 5;
pms.stakeThreshold = 2;
pms.nrStakePracticeTrials = 4;

pms.bounds = [0 9];
pms.sd = 2;
generateRews;
data.practice.practiceRews(:,1) = [7 8 6 3 2];
data.practice.practiceRews(:,2) = [1 0 3 6 9];

pms.screenKey = 'space';
pms.leftKey = 'f';
pms.rightKey = 'j';
pms.selectKey = 'space';
pms.exitKey = 'ESCAPE'; % added to make kill code

data.block = zeros(pms.nrTrials,1);
data.s = zeros(pms.nrTrials,2);
data.stimuli = zeros(pms.nrTrials,2);
data.stake = zeros(pms.nrTrials,1);
data.choice = -1*ones(pms.nrTrials,1);
data.rt  = -1*ones(pms.nrTrials,2);
data.score  = zeros(pms.nrTrials,1);
data.points = zeros(pms.nrTrials,1);
data.timeout = zeros(pms.nrTrials,2);

data.practice.s = zeros(pms.nrPracticeTrials,2);
data.practice.stimuli = zeros(pms.nrPracticeTrials,2);
data.practice.choice = -1*ones(pms.nrPracticeTrials,1);
data.practice.rt  = -1*ones(pms.nrPracticeTrials,2);
data.practice.points = zeros(pms.nrPracticeTrials,1);

pms.startingTime = 2;
pms.endingTime = 2;
pms.ITI = 1.5;
pms.ISI = 0.75;
pms.stakeTime = 1.5;
pms.counterTime = 0.25;
pms.totalRewardTime = 1.0;
pms.totalRewardTimeBlue = 1.0;
pms.totalRewardTimeGold = pms.totalRewardTimeBlue+1.0;
pms.timeoutTime = 2;
pms.timeoutFeedbackTime = 2.0;

save(dataFileName,'data');

end
