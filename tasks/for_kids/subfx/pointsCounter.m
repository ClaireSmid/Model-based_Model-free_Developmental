function rewardTime = pointsCounter(s,points,stake)

global pms

jitter = ceil(rand(1,pms.bounds(2))*10)-5;

if points == 0
    
    drawThings(0,points,0,s,1,stake,jitter);
    rewardTime = Screen('Flip',pms.wid);
    WaitSecs(pms.totalRewardTime);
    
    drawThings(0,points,0,s,2,stake,jitter);
    Screen('Flip',pms.wid);
    WaitSecs(pms.totalRewardTime);
    
else
    text = -1;
    max_points = max(points);
    for nrpoints = abs(points):-1:0
        if nrpoints == max_points && stake == 5
%         for i = 1:nrpoints
%             if i == 1 && stake == 5
                drawThings2(nrpoints,points,text,s,stake,jitter);
                Screen('Flip',pms.wid);
                WaitSecs(1);
%             end
        end
        text = text + 1;
        drawThings(nrpoints,points,text,s,0,stake,jitter);
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
end
end

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

if ~pms.practice
    Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect); %
%     blue rectangle
    oldTextSize = Screen('TextSize',pms.wid,50);
    oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%         if stake == 5
%             Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
%         else % low stakes condition
%             Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
%         end
    DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%     % stake numbers
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
end

Screen('TextSize', pms.wid, pms.scoreTextSize);



if points ~= 0
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
    
    Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
    
    if nrpoints > 0
        
        nrrows = ceil(nrpoints/stimsperrow);
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
         
        if points > 0 && stake == 1 % added these to include blue if stake is 1
            texture = pms.BlueTreasureTexture; % changed this to blue treasure
        elseif points > 0 && stake == 5 % and to do gold if stake is 5
            texture = pms.GoldTreasureTexture;
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

stakeText = [num2str(stake),'x'];

stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect);

if ~pms.practice
    Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect); %
%     blue rectangle
    oldTextSize = Screen('TextSize',pms.wid,50);
    oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%     Screen('DrawTexture', pms.wid, pms.BoostrayTexture,[],cueRect);
% %         if stake == 5
%             Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
% %         else % low stakes condition
% %             Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
% %         end
    DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%     % stake numbers
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
end

Screen('TextSize', pms.wid, pms.scoreTextSize);



if points ~= 0
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
    
    Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
    
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
        
%         cueRectSize = 175;
%         cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];
%         Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
        
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
    DrawFormattedText(pms.wid, ['Score: ', num2str(data.currentScore)], pms.origin(1)+0.35*backgroundsize(1),pms.origin(2)-0.45*backgroundsize(2));
end

end

% global pms
% 
% pointsize = 75;
% stimsize = 300;
% backgroundsize = [1010 758];
% stimsperrow = 5;
% jitter = ceil(rand(1,pms.bounds(2))*10)-5;
% 
% cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
% cueRectSize = 100;
% cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];
% 
% % stakeText = [num2str(stake),'x'];
% 
% stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
% stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];
% 
% Screen('FillRect',pms.wid,pms.backgroundColor);
% Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
% Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect);
% 
% if ~pms.practice
% %     Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect); %
% %     blue rectangle
%     oldTextSize = Screen('TextSize',pms.wid,50);
%     oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%     Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
% %     DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
% %     % stake numbers
%     Screen('TextSize',pms.wid,oldTextSize);
%     Screen('TextColor', pms.wid, oldTextColor);
% end
% 
% Screen('TextSize', pms.wid, pms.scoreTextSize);
% 
% Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
% 
% Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
%     
%         
%         nrrows = ceil(nrpoints/stimsperrow);
%         
%         pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
%         
% %             texture = pms.BlueTreasureTexture; % changed this to blue treasure
%             row_index = stimsperrow*(nrrows-1);
%             stimsinrow = nrpoints-stimsperrow*(nrrows-1);
%             
%             startingpoint = pointsorigin(1)-0.5*pointsize*stimsinrow;
%           
%             rect = [startingpoint+(pointsize)*(row_index-1) pointsorigin(2)+pointsize*(nrrows-1)-pointsize/2+jitter ...
%                 startingpoint+pointsize*row_index pointsorigin(2)+pointsize*(nrrows-1)+pointsize/2+jitter];
%             Screen('DrawTexture', pms.wid, pms.BlueTreasureTexture, [], rect);
% %             Screen('Flip');
%             WaitSecs(0.5);
%     
%     disp(nrpoints);
%     
% end
% 
