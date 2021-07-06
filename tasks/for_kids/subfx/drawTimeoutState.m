function drawTimeoutState(s,stimuli,stake)

global pms
global data

stimsize = 300;
backgroundsize = [1010 758];
cueRectSize = 100;

cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];

stakeText = [num2str(stake),'x'];

if length(stimuli)>1
    
    
    stimcenter{1} = [pms.origin(1)-pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
    stimcenter{2} = [pms.origin(1)+pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
    stimrect{1} = [stimcenter{1}(1)-stimsize/2 stimcenter{1}(2)-stimsize/2 stimcenter{1}(1)+stimsize/2 stimcenter{1}(2)+stimsize/2];
    stimrect{2} = [stimcenter{2}(1)-stimsize/2 stimcenter{2}(2)-stimsize/2 stimcenter{2}(1)+stimsize/2 stimcenter{2}(2)+stimsize/2];
    
    Screen('FillRect',pms.wid,pms.backgroundColor);
    Screen('DrawTexture', pms.wid, pms.planetTextures(s));
    
    Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect);
%     if stake  == 5 % high stakes % boostray
%         Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect); % replaced from BoostrayOnTexture
%     else % low stakes condition
%         Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect); % replaced from BoostrayOffTexture
%     end
    oldTextSize = Screen('TextSize',pms.wid,50);
    oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
    DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
    
    Screen('DrawTexture', pms.wid, pms.rocketTextures(stimuli(1)),[],stimrect{1},[],[],[],[75 75 75]);
    Screen('DrawTexture', pms.wid, pms.rocketTextures(stimuli(2)),[],stimrect{2},[],[],[],[75 75 75]);
    
    oldTextSize = Screen('TextSize',pms.wid,pms.timeoutTextSize);
    DrawFormattedText(pms.wid, 'X', 'center','center',[],[],[],[],[],[],stimrect{1});
    DrawFormattedText(pms.wid, 'X', 'center','center',[],[],[],[],[],[],stimrect{2});
    Screen('TextSize',pms.wid,oldTextSize);
    
else
    
    stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
    stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];
    
    Screen('FillRect',pms.wid,pms.backgroundColor);
    Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
    
    Screen('DrawTexture', pms.wid, pms.stakeCueTexture,[],cueRect);
%     if stake  == 5 % high stakes % boostray
%         Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect); % replaced from BoostrayOnTexture
%     else % low stakes condition
%         Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect); % replaced from BoostrayOffTexture
%     end
    oldTextSize = Screen('TextSize',pms.wid,50);
    oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
    DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
    
    Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect,[],[],[],[75 75 75]);
    
    oldTextSize = Screen('TextSize',pms.wid,pms.timeoutTextSize);
    DrawFormattedText(pms.wid, 'X', 'center','center',[],[],[],[],[],[],stimrect);
    Screen('TextSize',pms.wid,oldTextSize);
    
end

Screen('TextSize', pms.wid, pms.scoreTextSize);
DrawFormattedText(pms.wid, num2str(pms.bounds(1)), 'center', pms.origin(2)-0.28*pms.wRect(4));
Screen('TextSize', pms.wid, pms.textSize1);
if ~pms.practice
    DrawFormattedText(pms.wid, ['Score: ', num2str(data.currentScore)] , pms.origin(1)+0.35*backgroundsize(1),pms.origin(2)-0.45*backgroundsize(2));
end