function setup

%% make variables global
global pms
global data
global ESC

rng('shuffle')

path(path,'subFX'); % allow access to all subfunctions


% data = {};
ESC = 0;

%% subject info

% t = datetime;
% d = char(t);
% data.date = d;


% id = input('Subject ID:  ','s');
% age = input('Age:  ');
% 
% 
% data.Age = age;
% 
% t = datetime;
% d = char(t);
% date = d(1:11);
% data.date = d;
% 
% dataFileName = ['mbmfNovelStakes_',date,'_',id,'.mat'];
% 
% %if id<10, subStr=['s0',num2str(subNum)]; else subStr=['s',num2str(subNum)]; end
% 
% % dataFileName=[tag,'_',date,'_',id,'.mat'];
% 
% if exist (dataFileName, 'file') ~= 0
%     cont = input('File already exists. Continue? (1 = yes, 2 = no): ');
%     if cont ~= 1
%         return
%     end
% end
% 
% input(['Data will be saved in ',dataFileName,' (ENTER to continue)']);

% dataFileName = 'test';
% [dataFileName,subID,date] = gatherSubInfo('mbmfNovelStakes');
% data.date = date;
% data.subID = subID;
% data.dataFileName = dataFileName;

% if exist (dataFileName, 'file') ~= 0
%     cont = input('File already exists. Continue? (1 = yes, 2 = no): ');
%     if cont ~= 1
%         return
%     end
% end

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
pms.textSize1 = 36; % text size for message
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

% 9/01/19 old values
% pms.nrTrialsPerBlock = 40; % so 140 trials in total, rather than 160
% pms.nrBlocks = 4;
% pms.nrTrials = pms.nrTrialsPerBlock*pms.nrBlocks;
% pms.nrPracticeTrials = 10; % was originally 25
% pms.nrTimedPracticeTrials = 3;
% pms.rocketThreshold = 4; % was originally 10
% pms.stakeThreshold = 6; % was originally 10
% pms.nrStakePracticeTrials = 6;

% 9/01/19 current values:
pms.nrTrialsPerBlock = 2;
pms.nrBlocks = 4;
pms.nrTrials = pms.nrTrialsPerBlock*pms.nrBlocks;
pms.nrPracticeTrials = 6;
pms.nrTimedPracticeTrials = 1; % this will show both stages (excluded in final version)
pms.rocketThreshold = 5;
pms.stakeThreshold = 2;
pms.nrStakePracticeTrials = 6;

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

% 08/01/19 new, shortened timing versions
pms.startingTime = 1; % halved
pms.endingTime = 1; % halved
pms.ITI = 0.75; % halved
pms.ISI = 0.5; % -0.25
pms.stakeTime = 1.5; % 09/01/19 didn't change this, because it seems too big a change
pms.counterTime = 0.125; % halved
pms.totalRewardTime = 1.0; % same
pms.totalRewardTimeBlue = 1.0;
pms.totalRewardTimeGold = pms.totalRewardTimeBlue+1.0;
pms.timeoutTime = 2; % same
pms.timeoutFeedbackTime = 1; % halved

% 08/01/19 original timing values commented out
% pms.startingTime = 2;
% pms.endingTime = 2;
% pms.ITI = 1.5;
% pms.ISI = 0.75;
% pms.stakeTime = 1.5;
% pms.counterTime = 0.25;
% pms.totalRewardTime = 1.0;
% pms.totalRewardTimeBlue = 1.0;
% pms.totalRewardTimeGold = pms.totalRewardTimeBlue+1.0;
% pms.timeoutTime = 2;
% pms.timeoutFeedbackTime = 2.0;

% % 9/01/19 put this here
% pms = data.pms;

save(data.dataFileName,'data');

end
