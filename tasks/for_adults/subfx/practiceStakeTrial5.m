function practiceStakeTrial5(t)

global data
global pms 
global ESC

s2 = ceil(rand*2);
stake = randsample([1 5],1);
selected = 0;
points = round(unifrnd(pms.bounds(1),pms.bounds(2)));

green = [1 113 1];
% red = [181 23 0];

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
            
           
            drawState(2,s2,stimuli,selected,stake);
           
            Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;           
        end
    end
end
end

WaitSecs(0.5);
guess = '+?';

if points == 0
    drawThings(0,points,0,s2,1,stake,jitter); % draw the stake?
elseif points > 0 && stake == 1 % points is not 0
    text = -1;
    drawThings(points,points,text,s2,0,stake,jitter); % draw the stake?
elseif points > 0 && stake == 5
    text = -1;
    drawThings2(points,points,text,s2,stake,jitter); % draw the stake?
end
oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
DrawFormattedText(pms.wid, guess, 'center', pms.origin(2)-0.30*pms.wRect(4)); % display guess (the plus)
Screen('TextSize', pms.wid, oldSize);

Screen('Flip',pms.wid); % show the stake

WaitSecs(1);

if ESC == 0
pressed = 0;
while ~pressed
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.selectKey))
                        
            pressed = 1;
            number = points*stake;
            guess = num2str(number);
            textColor = green;
            
              if points > 0
                  max_points = max(points);
                for nrpoints = abs(points):-1:0
                    if nrpoints == max_points && stake == 5
                        drawThings2(nrpoints,points,text,s2,stake,jitter);
                        Screen('Flip',pms.wid);
                        WaitSecs(1);
                    end
                    text = text + 1;
                    drawThings(nrpoints,points,text,s2,0,stake,jitter);
                    oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                    oldColor = Screen('TextColor',pms.wid, textColor);
                    DrawFormattedText(pms.wid, ['+',guess], 'center', pms.origin(2)-0.30*pms.wRect(4));
                    Screen('TextColor',pms.wid, oldColor);
                    Screen('TextSize', pms.wid, oldSize);
                    time = Screen('Flip',pms.wid);
                    if nrpoints == abs(points)
                        rewardTime = time; %commented this out
                        WaitSecs(pms.totalRewardTime);
                    else
                        if nrpoints > 0
                            WaitSecs(pms.counterTime);
                        else
                            WaitSecs(pms.totalRewardTime);
                        end
                    end
                 end
               else % points == 0
                drawThings(0,points,0,s2,1,stake,jitter);
                oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                oldColor = Screen('TextColor',pms.wid, textColor);
                DrawFormattedText(pms.wid, ['+',number], 'center', pms.origin(2)-0.30*pms.wRect(4));
                Screen('TextColor',pms.wid, oldColor);
                Screen('TextSize', pms.wid, oldSize);
                Screen('Flip',pms.wid);
                WaitSecs(pms.totalRewardTime);
                
                drawThings(0,points,0,s2,2,stake,jitter);
                oldSize = Screen('TextSize', pms.wid, pms.scoreTextSize);
                oldColor = Screen('TextColor',pms.wid, textColor);
                DrawFormattedText(pms.wid, ['+',guess], 'center', pms.origin(2)-0.30*pms.wRect(4));
                Screen('TextColor',pms.wid, oldColor);
                Screen('TextSize', pms.wid, oldSize);
                Screen('Flip',pms.wid);
                WaitSecs(pms.totalRewardTime);
               end
            
           
%             drawState(2,s2,stimuli,selected,stake);
           
            Screen(pms.wid,'Flip');
            
        elseif any(strcmpi(keyStrokes,pms.exitKey)) % kill code
            ESC = 1;
            break;           
        end
    else
        pressed = 0;
    end
end
end

data.stakepractice.points(t,1) = points;
data.stakepractice.guess(t,1) = number;
% data.stakepractice.accuracy(t,1) = accuracy;

WaitSecs(2);

end

function drawThings(nrpoints,points,text,s,zerostage,stake,jitter)

global pms
global data
global ESC

if ESC == 0
    
pointsize = 75;
stimsize = 300;
backgroundsize = [1010 758];
stimsperrow = 5;

cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
cueRectSize = 100;
cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];

% stakeText = [num2str(stake),'x']; % left out, this is for numbered stakes

stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect);

% Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect);
oldTextSize = Screen('TextSize',pms.wid,50);
oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
        if stake  == 5 % high stakes
            Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
        else % low stakes condition
            Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
        end
% DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
Screen('TextSize',pms.wid,oldTextSize);
Screen('TextColor', pms.wid, oldTextColor);

Screen('TextSize', pms.wid, pms.scoreTextSize);

if points ~= 0
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
    
    Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
    
    if nrpoints > 0
        
        nrrows = ceil(nrpoints/stimsperrow);
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
        
        % added this
        
        if points > 0 && stake == 1 % added these here
            texture = pms.BlueTreasureTexture; % changed this
        elseif points > 0 && stake == 5
            texture = pms.GoldTreasureTexture; % added this here 
        else
            texture = pms.antimatterTexture;
        end
        
        for i = 1:nrpoints
%             WaitSecs(0.02); % added this to go slower
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
    
    if text > 0
        DrawFormattedText(pms.wid, ['+',num2str(text*stake)], 'center', pms.origin(2)-0.25*pms.wRect(4));
    end
    
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
        DrawFormattedText(pms.wid, '0', 'center', pms.origin(2)-0.25*pms.wRect(4));
        
    end
    
end

Screen('TextSize', pms.wid, pms.textSize1);
end

if ~pms.practice
    DrawFormattedText(pms.wid, ['Score: ', num2str(data.currentScore+stake*text*sign(points))], pms.origin(1)+0.35*backgroundsize(1),pms.origin(2)-0.45*backgroundsize(2));
end


%% payout



% pointsCounter(s2,points,stake);

end

function drawThings2(nrpoints,points,text,s,stake,jitter)


global pms
global data

pointsize = 75;
stimsize = 300;
backgroundsize = [1010 758];
stimsperrow = 5;

cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
cueRectSize = 100;
cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];

% stakeText = [num2str(stake),'x'];

stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect);

if ~pms.practice
%     Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect); %
%     blue rectangle
    oldTextSize = Screen('TextSize',pms.wid,50);
    oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%     Screen('DrawTexture', pms.wid, pms.BoostrayTexture,[],cueRect);
%         if stake == 5
            Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
%         else % low stakes condition
%             Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
%         end
%     DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%     % stake numbers
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
end

Screen('TextSize', pms.wid, pms.scoreTextSize);



if points ~= 0
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
    
    Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect); %rather than s+1
    
    if nrpoints > 0
        
        nrrows = ceil(nrpoints/stimsperrow);
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
         
        if points > 0 %&& stake == 1 % added these to include blue if stake is 1
            texture = pms.BlueTreasureTexture; % changed this to blue treasure
%         elseif points > 0 && stake == 5 % and to do gold if stake is 5
%             texture = pms.GoldTreasureTexture;
        else
            texture = pms.antimatterTexture; % is this important?
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
            
%             if i == 1 && stake == 5
%                 Screen('DrawTexture', pms.wid, pms.BlueTreasureTexture, [], rect);
%                 Screen('Flip',pms.wid);
%                 WaitSecs(0.5);
%             end 
            
            Screen('DrawTexture', pms.wid, texture, [], rect);
        end
        
        cueRectSize = 175;
        cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];
        Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
        
%         Screen('Flip',pms.wid);
%         WaitSecs(1);
        
    end
    
    if text > 0
        if points > 0
            DrawFormattedText(pms.wid, ['+',num2str(text*stake)], 'center', pms.origin(2)-0.28*pms.wRect(4));
        else
            DrawFormattedText(pms.wid, ['-',num2str(text*stake)], 'center', pms.origin(2)-0.28*pms.wRect(4));
        end
    end
    
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

end
