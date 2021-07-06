
function drawThings2(nrpoints,s)

global pms

pointsize = 75;
stimsize = 300;
backgroundsize = [1010 758];
stimsperrow = 5;
jitter = ceil(rand(1,pms.bounds(2))*10)-5;

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
    Screen('DrawTexture', pms.wid, pms.BoostrayOnTexture,[],cueRect);
%     DrawFormattedText(pms.wid,stakeText,'center','center',[],[],[],[],[],[],cueRect);
%     % stake numbers
    Screen('TextSize',pms.wid,oldTextSize);
    Screen('TextColor', pms.wid, oldTextColor);
end

Screen('TextSize', pms.wid, pms.scoreTextSize);

Screen('DrawTexture', pms.wid, pms.alienTextures(pms.practice+1,s),[],stimrect);

Screen('DrawTexture', pms.wid, pms.rectTextures(s+1),[],stimrect);
    
    if nrpoints > 0
        
        nrrows = ceil(nrpoints/stimsperrow);
        
        pointsorigin = [pms.origin(1) pms.origin(2)-0.2*pms.wRect(4)];
        
%             texture = pms.BlueTreasureTexture; % changed this to blue treasure
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
            Screen('DrawTexture', pms.wid, pms.BlueTreasureTexture, [], rect);
       end
       
    end
    
    disp(nrpoints);
    
end

