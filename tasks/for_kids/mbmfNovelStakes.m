 function mbmfNovelStakes

%% make variables global
global pms
global data
global ESC

data = {};

% 09/01/19 tried to change output to save in the 'results' folder, but left
% this due to time constraints finishing the task.

% pwd = pms.ROOT_DIR;
% 
% path(path,[pms.ROOT_DIR,'/results']);
% pms.results_path = ([pms.ROOT_DIR,'/results']);

try
    
    Screen('Preference', 'SkipSyncTests', 1); % set this to 0 for hard and robust measurements
    
    rng shuffle
    
    path(path,'subfx'); % allow access to all subfunctions
    
    KbName('UnifyKeyNames'); % added here
    
    % 7/01/19 moved this here, basically a rewrite from 'gathersubinfo' script, to
    % ensure data won't be overwritten
    id = input('Subject ID:  ','s');
    age = input('Age:  ');

    data.id = id;
    data.Age = age;

    t = datetime;
    d = char(t);
    date = d(1:11);
    data.date = d;

    data.dataFileName = ['mbmfNovelStakes_',date,'_s',id,'.mat'];

    %if id<10, subStr=['s0',num2str(subNum)]; else subStr=['s',num2str(subNum)]; end

    % dataFileName=[tag,'_',date,'_',id,'.mat'];

    % 7/01/19 check for double files
    if exist (data.dataFileName, 'file') ~= 0
        cont = input('File already exists. Continue? (1 = yes, 2 = no): ');
        if cont ~= 1
            return
        else
            data.dataFileName = ['mbmfNovelStakes_',date,'_s',id,'V2.mat'];
        end
    
    end

    input(['Data will be saved in ',data.dataFileName,' (ENTER to continue)']);
    
    save(data.dataFileName,'data');
    
    % changed order of setup and pms = data.pms
    
%             pms = data.pms; % why is this commented out? CS 07/01/19: if
    %         I comment this back in will this remove the error at the end
    %         of the task I'm getting?
    
        setup;
    
    %% initialize psychtoolbox
    
    ListenChar(2); % enables listening for keyboard input
    Priority(2); % only on macs
    HideCursor;
    
%      [pms.wid, pms.wRect] = Screen('OpenWindow', 0, pms.backgroundColor,[0 0 1100, 900]); % small screen
    
    [pms.wid, pms.wRect] = Screen('OpenWindow', 0, pms.backgroundColor); % open a psychtoolbox window % 0 is fullscreen, 1 is not full screen
    
    priorityLevel=MaxPriority(pms.wid);
    Priority(priorityLevel);
    
    Screen('BlendFunction', pms.wid,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA'); % allow for transparency
    Screen('TextFont', pms.wid, 'Arial');
    Screen('TextSize', pms.wid, pms.textSize1);
    Screen('TextColor', pms.wid, pms.textColor);
    
    pms.origin = [floor(pms.wRect(3)/2) floor(pms.wRect(4)/2)]; % center of the screen
    
    %% setup task
    pms.practice = 1;
    pms.noStakeCue = 1;
    
    loadTextures;
    
    %% initiate kill code
    % If ESC is set to 1 in any of the scripts, the task will stop (may
    % have to press ESC 2/3 times  to exit completely as the loops get
    % disrupted)
    
    while ESC == 0
        
        %% instructions
        
        showInstructions(1);
        
        
        %% Alien practice % start with this now
        %     In this practice, the participants just have to press space to see
        %     how to collect treasure. It will also show them how the amounts of
        %     treasure can change over time
        
        for t = 1:size(data.practice.practiceRews,1)
            practiceAlienTrial(t,1);
        end
        
        showInstructions(2);
        
        for t = 1:size(data.practice.practiceRews,1)
            practiceAlienTrial(t,2);
        end
        
        showInstructions(3);
        
        
        %% Do Rocket practice second
        % Here, they will only practice transitions from spaceships to either of
        % the two planets.
        
        purpleCounter = 0;
        purpleErrors = 0;
        t = 0;
        while purpleCounter < pms.rocketThreshold
            t = t+1;
            s2 = practiceRocketTrial(t);
            if s2 == 2
                purpleCounter = purpleCounter+1;
            else
                purpleCounter = 0;
                purpleErrors = purpleErrors + 1;
            end
            if purpleErrors == 3
                showInstructions(4);
                purpleErrors = 0;
            end
        end
        
        showInstructions(5);
        
        redCounter = 0;
        redErrors = 0;
        t = 0;
        while redCounter < pms.rocketThreshold
            t = t+1;
            s2 = practiceRocketTrial(t);
            if s2 == 1
                redCounter = redCounter+1;
            else
                redCounter = 0;
                redErrors = redErrors + 1;
            end
            if redErrors == 3
                showInstructions(6);
                redErrors = 0;
            end
        end
        
        %% proper practice
        % Here, they will do several practice trials, combining spaceship
        % choice and asking the aliens for treasure.
        
        showInstructions(7);
        
        for t = 1:pms.nrPracticeTrials
            practiceTrial(t);
        end
        
        
        %% timed practice example
        % this practice shows a few trials that are timed
        % 9/01/19 due to time constraints, this practice is now removed,
        % instead this is explained in the instructions.
        
%         showInstructions(8);
%         
%         for t = 1:pms.nrTimedPracticeTrials
%             timedTrial(t);
%         end
        
        %% stake practice
        %     Here, they get introduced to the stakes condition (blue and gold
        %     treasure)
        % 9/01/19 still need to make this a fixed order, so they will
        % experience both 1x and 5x conditions.
        
        showInstructions(9);
        
        for t = 1:pms.nrStakePracticeTrials
            practiceStakeTrial5(t);
        end
        
        Screen('FillRect',pms.wid,pms.backgroundColor);
        Screen('Flip',pms.wid);
        WaitSecs(0.5);
%         WaitSecs(1);
        
        
        %% actual experiment
        % Here, they start the actual trials of the experiment
        % 09/01/19 in these instructions some info about timing out with an
        % image example is shown.
        
        showInstructions(10); % show last instructions before starting actual experiment
        
        pms.noStakeCue = 0;
        pms.practice = 0;
        data.currentScore = 0;
        
        if ESC == 0 
            for b = 1:pms.nrBlocks
                
                if ESC == 1
                    break;
                end
                
                message = ['Get ready for mission ', num2str(b), '.\n\nPress SPACE to start.' ];
                showMessage(message,pms.screenKey,0);
                Screen('FillRect',pms.wid,pms.backgroundColor);
                Screen('Flip',pms.wid);
                WaitSecs(1);
                
                % run
                for i = 1:pms.nrTrialsPerBlock
                    if ESC == 0
                        t = i+(b-1)*pms.nrTrialsPerBlock;
                        trial(t,i,b);
                    else
                        break;
                    end
                end
                
                save(data.dataFileName,'data');
                
                if ESC == 0
                    Screen('FillRect',pms.wid,pms.backgroundColor);
                    Screen('Flip',pms.wid);
                    WaitSecs(pms.endingTime);
                    
                    message = ['You finished mission ', num2str(b), '.'];
                    showMessage(message,pms.screenKey,0);
                    Screen('FillRect',pms.wid,pms.backgroundColor);
                    Screen('Flip',pms.wid);
                    WaitSecs(1);
                    
                else
                    break;
                end
                
                
            end
        end
        
        %% end of experiment
        
        data.pms = pms;
        
        save(data.dataFileName,'data');
        
        if ESC == 0
            message = 'You made it to the end of the game!\n\nWell done and thank you for playing!';
            showMessage(message,pms.screenKey,0);
        end
        
        clear global pms;
        clear global data;
        Screen('CloseAll'); % close screen
        ListenChar(0); % allow keystrokes to Matlab
        Priority(0); % return Matlab's priority level to normal
        ShowCursor(0);
        
    end
    
catch ME
    
    disp(getReport(ME));
    
    data.pms = pms;
    save(data.dataFileName,'data');
    
    clear global pms;
    clear global data;
    
    ShowCursor(0);
    Screen('Close');
    Screen('CloseAll'); % close screen
    Priority(0); % return Matlab's priority level to normal
    ListenChar(0); % allow keystrokes to Matlab
    
end