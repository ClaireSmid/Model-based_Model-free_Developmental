function trial(t,i,b)

global data
global pms
global ESC

data.block(t) = b;

s1 = ceil(rand*2);
stimuli = Shuffle([1 2])+2*(s1==2);
stake = randsample([1 5],1);

if ~pms.practice
    data.s(t,1) = s1;
    data.stimuli(t,:) = stimuli;
    data.stake(t,1) = stake;
else
    data.practice.s(t,1) = s1;
    data.practice.stimuli(t,:) = stimuli;
end

selected = 0;

%% ITI
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);

if i > 1
    WaitSecs(pms.ITI);
else
    WaitSecs(pms.startingTime);
end

%% Stake cue
if ESC == 0 % added kill code
drawState(0,1,[],selected,stake); % case 0 drawState
Screen(pms.wid,'Flip');
WaitSecs(pms.stakeTime);
end % added kill code

%% Earth
if ESC == 0 % added for ESC
    
drawState(1,1,stimuli,selected,stake); % case 1 drawState
start = Screen('Flip',pms.wid);

pressed = 0;
timeout = 0;
while ~pressed && ((pms.practice) || (~pms.practice&&(GetSecs-start < pms.timeoutTime)))
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.leftKey)) || any(strcmpi(keyStrokes,pms.rightKey))
            
            rt1 = GetSecs-start;
            
            if any(strcmpi(keyStrokes,pms.leftKey))
                selected = 1;
            else
                selected = 2;
            end
            
            pressed = 1;
            
            drawState(1,1,stimuli,selected,stake);
            Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;
            
        end
    end
end

if pressed
    WaitSecs(pms.timeoutTime-rt1);
else
    timeout = 1;
    if ~pms.practice
        points = pms.bounds(1);
        data.currentScore = data.currentScore+points;
        data.score(t) = data.currentScore;
        data.points(t) = points;
        data.timeout(t,1) = 1;
    end
    drawTimeoutState(1,stimuli,stake);
    Screen(pms.wid,'Flip');
    WaitSecs(pms.timeoutFeedbackTime);
end


if ~(timeout)
    
    if ~pms.practice
        data.choice(t) = stimuli(selected);
        data.rt(t,1) = rt1;
    else
        data.practice.choice(t) = stimuli(selected);
        data.practice.rt(t,1) = rt1;
    end
    
    Screen('FillRect',pms.wid,pms.backgroundColor);
    Screen('Flip',pms.wid);
    WaitSecs(pms.ISI);
    
    %% planet
    
    s2 = mod(stimuli(selected),2)+1;
    
    if ~pms.practice
        data.s(t,2) = s2;
    else
        data.practice.s(t,2) = s2;
    end
    
    stimuli = 1;
    selected = 0;
    
    drawState(2,s2,stimuli,selected,stake); % case 2 drawState
    start = Screen('Flip',pms.wid);
    
    pressed = 0;
    timeout = 0;
    
    while ~pressed && ((pms.practice) || (~pms.practice&&(GetSecs-start < pms.timeoutTime)))
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            keyStrokes = KbName(keyCode);
            if any(strcmpi(keyStrokes,pms.selectKey))
                
                rt2 = GetSecs-start;
                
                selected = 1;
                pressed = 1;
                
                if ~pms.practice
                    points = data.rews(t,s2);
                else
                    points = data.practice.rews(t,s2);
                end
                
                drawState(2,s2,stimuli,selected,stake);
                Screen(pms.wid,'Flip');
                
            elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
                ESC = 1;
                break;
                
            end
        end
    end
    
    tic;
    if pressed
        WaitSecs(pms.timeoutTime-rt2);
%         if stake == 5
%             pointsCounter2(s2,points,stake);
%             pointsCounter(s2,points,stake);
%         elseif stake == 1
            pointsCounter(s2,points,stake); % need to add something in front of here
%         end
    else
        timeout = 1;
        points = pms.bounds(1);
        if ~pms.practice
            data.currentScore = data.currentScore+points*stake;
            data.score(t) = data.currentScore;
            data.points(t) = points;
            data.timeout(t,2) = 1;
        end
        drawTimeoutState(s2,stimuli,stake);
        Screen(pms.wid,'Flip');
        WaitSecs(pms.timeoutFeedbackTime);
    end
    
    if ~timeout
        if ~pms.practice
            data.currentScore = data.currentScore+points*stake;
            data.score(t) = data.currentScore;
            data.rt(t,2) = rt2;
            data.points(t) = points;
        else
            data.practice.rt(t,2) = rt2;
            data.practice.points(t) = points;
        end
    end
end
end % added for ESC
