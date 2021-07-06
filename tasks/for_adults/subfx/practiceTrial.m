function practiceTrial(t)

global data
global pms
global ESC

s1 = ceil(rand*2);
stimuli = Shuffle([1 2])+2*(s1==2);
data.practice.s(t,1) = s1;
data.practice.stimuli(t,:) = stimuli;

selected = 0;

%% ITI
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(pms.ITI);

%% Earth

drawState(1,1,stimuli,selected,1);
Screen('Flip',pms.wid);

if ESC == 0
pressed = 0;
start = GetSecs;
while ~pressed
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
            
            drawState(1,1,stimuli,selected,1);
            Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;
            
        end
    end
end
end

data.practice.choice(t) = stimuli(selected);
data.practice.rt(t,1) = rt1;

WaitSecs(1);

%% ISI
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(pms.ISI);

%% planet

s2 = mod(stimuli(selected),2)+1;
data.practice.s(t,2) = s2;

stimuli = 1;
selected = 0;

drawState(2,s2,stimuli,selected,1);
Screen('Flip',pms.wid);

if ESC == 0
pressed = 0;
start = GetSecs;
while ~pressed
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
            
            drawState(2,s2,stimuli,selected,1);
            Screen(pms.wid,'Flip');
            
         elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;
            
        end
    end
end
end

WaitSecs(1);

pointsCounter(s2,points,1);

data.practice.rt(t,2) = rt2;
data.practice.points(t) = points;

