function timedTrial(t)

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
% timeout = 0;
start = GetSecs;
while ~pressed && (GetSecs-start < pms.timeoutTime)
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.leftKey)) || any(strcmpi(keyStrokes,pms.rightKey))
            
            rt1 = GetSecs-start;
            
%             if any(strcmpi(keyStrokes,pms.leftKey))
                selected = 1;
%             else
%                 selected = 2;
%             end
            
            % fixed this so it times out.
%             if t == 1
                pressed = 0;
%             elseif t == 2
%                 pressed = 1;
%             end
            
%             drawState(1,1,stimuli,selected,1);
%             Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;
            
        end
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
    drawTimeoutStatePractice(1,stimuli); % changed this function
    Screen(pms.wid,'Flip');
    WaitSecs(pms.timeoutFeedbackTime);
end


% WaitSecs(1);

% if ~(timeout)
    
%     if ~pms.practice
%         data.choice(t) = stimuli(selected);
%         data.rt(t,1) = rt1;
%     else
%         data.practice.choice(t) = stimuli(selected);
%         data.practice.rt(t,1) = rt1;
%     end
    
    %% ISI
    Screen('FillRect',pms.wid,pms.backgroundColor);
    Screen('Flip',pms.wid);
    WaitSecs(pms.ISI);
    
    %% planet
    
    s2 = 2;
    %s2 = mod(stimuli(selected),2)+1;
    
    data.practice.s(t,2) = s2;

    stimuli = 1;
    selected = 0;

    drawState(2,s2,stimuli,selected,1);
    Screen('Flip',pms.wid);

    

if ESC == 0
% pressed = 0;
% timeout = 0;
start = GetSecs;
while ~pressed && (GetSecs-start < pms.timeoutTime)
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.selectKey))
            
            rt2 = GetSecs-start;
            
            selected = 0;
            
            % fixed this to 0
            pressed = 0;
            
%             if ~pms.practice
%                 points = data.rews(t,s2);
%             else
%                 points = data.practice.rews(t,s2);
%             end
            
            drawState(2,s2,stimuli,selected,1);
            Screen(pms.wid,'Flip');
            
         elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;
            
        end
    end
end

 if pressed
        WaitSecs(pms.timeoutTime-rt2);
%         pointsCounter(s2,points,stake);
    else
%         timeout = 1;
        points = pms.bounds(1);
        if ~pms.practice
%             data.currentScore = data.currentScore+points*stake;
            data.score(t) = data.currentScore;
            data.points(t) = points;
            data.timeout(t,2) = 1;
        end
        drawTimeoutStatePractice(s2,stimuli); % changed this function
        Screen(pms.wid,'Flip');
        WaitSecs(pms.timeoutFeedbackTime);
 end
    
%  if ~timeout
%         if ~pms.practice
% %             data.currentScore = data.currentScore+points*stake;
%             data.score(t) = data.currentScore;
%             data.rt(t,2) = rt2;
%             data.points(t) = points;
%         else
%             pointsCounter(s2,points,1);
%             data.practice.rt(t,2) = rt2;
%             data.practice.points(t) = points;
%         end
%         
%  end
end
end

% WaitSecs(1);



% data.practice.rt(t,2) = rt2;
% data.practice.points(t) = points;


