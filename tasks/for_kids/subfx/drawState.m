function drawState(part,s,stimuli,selected,stake)

global pms
global data

stimsize = 300;
backgroundsize = [1010 758];
cueRectSize = 100;

cueCenter = [pms.origin(1)-0.3*pms.wRect(3) pms.origin(2)-0.35*pms.wRect(4)];
cueRect = [cueCenter(1)-cueRectSize*0.5 cueCenter(2)-cueRectSize*0.5 cueCenter(1)+cueRectSize*0.5 cueCenter(2)+cueRectSize*0.5];

stakeText = [num2str(stake),'x'];

switch part
    case 0 % earth with stake 
        
        Screen('FillRect',pms.wid,pms.backgroundColor);
%         Screen('DrawTexture', pms.wid, pms.planetTextures(1)); % put 1
%         here, leave out
        Screen('DrawTexture', pms.wid, pms.planetTextures(s)); % original
        Screen('DrawTexture', pms.wid, pms.stakeCueTexture); % blue rectangle stakes
        
        oldTextSize = Screen('TextSize',pms.wid,100);
        oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%         if stake  == 5 % high stakes % boostray
%             Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture); % replaced from BoostrayOnTexture
%         else % low stakes condition
%             Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture); % replaced from BoostrayOffTexture
%         end
        DrawFormattedText(pms.wid,stakeText,'center','center'); % numbers in the stake
        Screen('TextSize',pms.wid,oldTextSize);
        Screen('TextColor', pms.wid, oldTextColor);
        
    case 1 % two rockets
        
        stimcenter{1} = [pms.origin(1)-pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
        stimcenter{2} = [pms.origin(1)+pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
        stimrect{1} = [stimcenter{1}(1)-stimsize/2 stimcenter{1}(2)-stimsize/2 stimcenter{1}(1)+stimsize/2 stimcenter{1}(2)+stimsize/2];
        stimrect{2} = [stimcenter{2}(1)-stimsize/2 stimcenter{2}(2)-stimsize/2 stimcenter{2}(1)+stimsize/2 stimcenter{2}(2)+stimsize/2];
        
        Screen('FillRect',pms.wid,pms.backgroundColor);
        
        Screen('DrawTexture', pms.wid, pms.planetTextures(s));
        
        if ~pms.noStakeCue % if not a no stake cue?
            Screen('DrawTexture', pms.wid,pms.stakeCueTexture,[],cueRect); % blue rectangle for stakes
            oldTextSize = Screen('TextSize',pms.wid,50);
            oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%             if stake == 5 % added to show stake types %% boostray
%                 Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
%             else % low stakes condition
%                 Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
%             end
            DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%             % stakes number
            Screen('TextSize',pms.wid,oldTextSize);
            Screen('TextColor', pms.wid, oldTextColor);
        end
        
        Screen('DrawTexture', pms.wid, pms.rocketTextures(stimuli(1)),[],stimrect{1});
        Screen('DrawTexture', pms.wid, pms.rocketTextures(stimuli(2)),[],stimrect{2});
        
        if selected
            notselected = [1 2];
            notselected(selected) = [];
            Screen('DrawTexture', pms.wid, pms.rectTextures(s),[],stimrect{selected});
            Screen('DrawTexture', pms.wid, pms.rocketTextures(stimuli(notselected)),[],stimrect{notselected},[],[],[],[75 75 75]);
        end
        
    case 2 % alien textures. showing alien on planet
        
        stimcenter = [pms.origin(1) pms.origin(2)+0.1*pms.wRect(4)];
        stimrect = [stimcenter(1)-stimsize/2 stimcenter(2)-stimsize/2 stimcenter(1)+stimsize/2 stimcenter(2)+stimsize/2];
        
        Screen('FillRect',pms.wid,pms.backgroundColor);
        Screen('DrawTexture', pms.wid, pms.planetTextures(s+1));
        
        Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);
        
        if ~pms.noStakeCue
            Screen('DrawTexture', pms.wid,pms.stakeCueTexture,[],cueRect); % blue rectangle
            oldTextSize = Screen('TextSize',pms.wid,50);
            oldTextColor=Screen('TextColor', pms.wid, [191 230 236]);
%             if stake == 5 %% boostray
%                 Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
%             else % low stakes condition
%                 Screen('DrawTexture', pms.wid, pms.BoostrayOffTexture,[],cueRect);
%             end
            DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%             % type of stake
            Screen('TextSize',pms.wid,oldTextSize);
            Screen('TextColor', pms.wid, oldTextColor);
        end
        
        if selected
            Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
        end
        
end

if ~pms.practice
    DrawFormattedText(pms.wid, ['Score: ', num2str(data.currentScore)] , pms.origin(1)+0.35*backgroundsize(1),pms.origin(2)-0.45*backgroundsize(2));
end

