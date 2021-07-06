function accuracy = practiceStakeTrial(t)

global data
global pms

s2 = ceil(rand*2);
stake = randsample([1 5],1);
selected = 0;
points = round(unifrnd(pms.bounds(1),pms.bounds(2)));
% points = 0;

green = [1 113 1];
red = [181 23 0];

jitter = ceil(rand(1,pms.bounds(2))*10)-5;

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

stimuli = 1;
selected = 0;

drawState(2,s2,stimuli,selected,stake);
Screen('Flip',pms.wid);

pressed = 0;

while ~pressed
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.selectKey))

            selected = 1;
            pressed = 1;
            
            drawState(2,s2,stimuli,selected,stake);
            Screen(pms.wid,'Flip');
            
        end
    end
end

WaitSecs(0.5);
guess = '+?';
finished = 0;

if points == 0
    drawThings(0,points,0,s2,1,stake,jitter);
else
    text = -1;
    drawThings(points,points,text,s2,0,stake,jitter);
end
oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
DrawFormattedText(pms.wid, guess, 'center', pms.origin(2)-0.35*pms.wRect(4));
Screen('TextSize', pms.wid, oldSize);

Screen('Flip',pms.wid);

while ~finished
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        number = points*stake;
        finished = 1;
%         keyStrokes = KbName(keyCode);
%         if iscell(keyStrokes)
%             keyStrokes = keyStrokes{1};
%         end
%         if any(strcmpi(keyStrokes,pms.selectKey)) && ~strcmp(guess,'+?')
%             finished = 1;
%             number = points*stake
%             if number == points*stake
                accuracy = 1;
                textColor = green;
%             else
%                 accuracy = 0;
%                 textColor = red;
%             end
            if points > 0
                for nrpoints = abs(points):-1:0
                    text = text + 1;
                    drawThings(nrpoints,points,text,s2,0,stake,jitter);
                    oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                    oldColor = Screen('TextColor',pms.wid, textColor);
                    DrawFormattedText(pms.wid, ['+',number], 'center', pms.origin(2)-0.35*pms.wRect(4)); % added number here
                    Screen('TextColor',pms.wid, oldColor);
                    Screen('TextSize', pms.wid, oldSize);
                    time = Screen('Flip',pms.wid);
                    if nrpoints == abs(points)
                        rewardTime = time;
                        WaitSecs(pms.totalRewardTime);
                    else
                        if nrpoints > 0
                            WaitSecs(pms.counterTime);
                        else
                            WaitSecs(pms.totalRewardTime);
                        end
                    end
                end
            else
                drawThings(0,points,0,s2,1,stake,jitter);
                oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                oldColor = Screen('TextColor',pms.wid, textColor);
                DrawFormattedText(pms.wid, ['+',number], 'center', pms.origin(2)-0.35*pms.wRect(4)); % added number instead of guess in ['+',guess]
                Screen('TextColor',pms.wid, oldColor);
                Screen('TextSize', pms.wid, oldSize);
                Screen('Flip',pms.wid);
                WaitSecs(pms.totalRewardTime);
                
                drawThings(0,points,0,s2,2,stake,jitter);
                oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                oldColor = Screen('TextColor',pms.wid, textColor);
                DrawFormattedText(pms.wid, ['+',number], 'center', pms.origin(2)-0.35*pms.wRect(4));
                Screen('TextColor',pms.wid, oldColor);
                Screen('TextSize', pms.wid, oldSize);
                Screen('Flip',pms.wid);
                WaitSecs(pms.totalRewardTime);
            end
        else
            
%             [number, numeric] = str2num(keyStrokes(1));
%             if numeric && isreal(number) % prevents j and i from being valid inputs
%                 
%                 if strcmp(guess,'+?') || strcmp(guess,'0')
%                     guess = keyStrokes(1);
%                 elseif length(guess) == 1
%                     guess = [guess, keyStrokes(1)];
%                 elseif length(guess) == 2
%                     guess = guess(2);
%                     if strcmp(guess,'0')
%                         guess = keyStrokes(1);
%                     else
%                         guess = [guess, keyStrokes(1)];
%                     end
%                 end
%             end
%             if any(strcmpi(keyStrokes,'DELETE')) && ~strcmp(guess,'+?')
%             
%                 guess = '+?';
%             end
%             
            if points == 0
                drawThings(0,points,0,s2,1,stake,jitter);
            else
                text = -1;
                drawThings(points,points,text,s2,0,stake,jitter);
            end
            oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
            
            number = points*stake;
            
%             if ~strcmp(number,'+?')
%                 DrawFormattedText(pms.wid,['+',number], 'center', pms.origin(2)-0.35*pms.wRect(4));
%             else
                DrawFormattedText(pms.wid,number, 'center', pms.origin(2)-0.35*pms.wRect(4));
%             end
            Screen('TextSize', pms.wid, oldSize);
            Screen('Flip',pms.wid);
            WaitSecs(0.25);
            
        end
end

data.stakepractice.points(t,1) = points;
data.stakepractice.guess(t,1) = number;
data.stakepractice.accuracy(t,1) = accuracy;

WaitSecs(2);

function drawThings(nrpoints,points,text,s,zerostage,stake,jitter)

global pms
global data

pointsize = 75;
stimsize = 300;
backgroundsize = [1010 758];
stimsperrow = 5;

cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
cueRectSize = 100;
cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];

stakeText = [num2str(stake),'x'];

stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect);

Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect);
oldTextSize = Screen('TextSize',pms.wid,50);
oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
Screen('TextSize',pms.wid,oldTextSize);
Screen('TextColor', pms.wid, oldTextColor);

Screen('TextSize', pms.wid, pms.scoreTextSize);

if points ~= 0
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
    
    Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
    
    if nrpoints > 0
        
        nrrows = ceil(nrpoints/stimsperrow);
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
        
        if points > 0
            texture = pms.treasureTexture;
        else
            texture = pms.antimatterTexture;
        end
        
        for i = 1:nrpoints
            row = ceil(i/stimsperrow);
            row_index = i - stimsperrow*(row-1);
            
            if row == nrrows
                stimsinrow = nrpoints-stimsperrow*(row-1);
            else
                stimsinrow = stimsperrow;
            end
            
            startingpoint = pointsorigin(1)-0.5*pointsize*stimsinrow;
            
            
            rect = [startingpoint+(pointsize)*(row_index-1) pointsorigin(2)+pointsize*(row-1)-pointsize/2+jitter(i) ...
                startingpoint+pointsize*row_index pointsorigin(2)+pointsize*(row-1)+pointsize/2+jitter(i)];
            Screen('DrawTexture', pms.wid, texture, [], rect);
        end
        
    end
    
%     if text > 0
%         DrawFormattedText(pms.wid, ['+',num2str(text*stake)], 'center', pms.origin(2)-0.28*pms.wRect(4));
%     end
    
else
    
    if zerostage==1
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.15*pms.wRect(4)];
        rect = [pointsorigin(1)-pointsize/2 pointsorigin(2)-pointsize/2 ...
            pointsorigin(1)+pointsize/2 pointsorigin(2)+pointsize/2];
        Screen('DrawTexture', pms.wid, pms.norewardTexture, [], rect);
        Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s,1),[],stimrect);
        Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
        
    else
        
        Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s,1),[],stimrect);
        Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
        DrawFormattedText(pms.wid, '0', 'center', pms.origin(2)-0.28*pms.wRect(4));
        
    end
    
end

Screen('TextSize', pms.wid, pms.textSize1);

if ~pms.practice
    DrawFormattedText(pms.wid, ['Score: ', num2str(data.currentScore+stake*text*sign(points))], pms.origin(1)+0.35*backgroundsize(1),pms.origin(2)-0.45*backgroundsize(2));
end