function practiceAlienTrial(t,s2)

global data
global pms 
global ESC

%% ITI
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(pms.ITI);

%% stimuli on screen
stimuli = 1;
selected = 0;

drawState(2,s2,stimuli,selected,1);

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
            
            points = data.practice.practiceRews(t,s2);
            
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

end
