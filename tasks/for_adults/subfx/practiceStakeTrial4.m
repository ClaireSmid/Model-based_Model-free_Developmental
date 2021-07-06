function practiceStakeTrial4(t)

global data
global pms 
global ESC

s2 = ceil(rand*2);
stake = randsample([1 5],1);
selected = 0;
points = round(unifrnd(pms.bounds(1),pms.bounds(2)));

% green = [1 113 1];
% red = [181 23 0];

% jitter = ceil(rand(1,pms.bounds(2))*10)-5;

data.stakepractice.s2(t,1) = s2;
data.stakepractice.stake(t,:) = stake;

%% ITI
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(pms.ITI);

%% Stake cue
drawState(0,1,[],selected,stake);
Screen(pms.wid,'Flip');
WaitSecs(pms.stakeTime);

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(pms.ISI);

%% planet

% stimuli = 1;
% selected = 0;
% 
% drawState(2,s2,stimuli,selected,stake);
% Screen('Flip',pms.wid);


%% stimuli on screen
stimuli = 1;
selected = 0;

drawState(2,s2,stimuli,selected,stake);

Screen('Flip',pms.wid);

if ESC == 0
pressed = 0;
while ~pressed
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.selectKey))
                        
            selected = 1;
            pressed = 1;
            
%             points = data.practice.practiceRews(t,s2);
            
            drawState(2,s2,stimuli,selected,stake);
           
            Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;           
        end
    end
end
end

WaitSecs(1);

pointsCounter(s2,points,stake);

end
