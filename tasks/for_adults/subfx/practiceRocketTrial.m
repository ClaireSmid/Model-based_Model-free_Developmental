function s2 = practiceRocketTrial(t)

global pms
global ESC


s1 = mod(t,2)+1;
stimuli = Shuffle([1 2])+2*(s1==2);
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
while ~pressed
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,pms.leftKey)) || any(strcmpi(keyStrokes,pms.rightKey))
                        
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

s2 = mod(stimuli(selected),2)+1;

WaitSecs(1);

Screen('DrawTexture', pms.wid, pms.planetTextures(s2+1));
Screen(pms.wid,'Flip');
WaitSecs(pms.ITI);

end
