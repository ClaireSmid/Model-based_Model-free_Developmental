function practiceSession

global data
global pms

fixationRect = [pms.origin(1)-2 pms.origin(2)-2 pms.origin(1)+2 pms.origin(2)+2];

message = 'The dot in the middle of the screen will turn green when you respond correctly, and red when you respond incorrectly.\n\n--press SPACE to continue--';
showMessage(message,'space',0);

showMessage('Let''s start with a block of practice trials.\n\nPut your left index finger on the ''F'' key,\nand your right index finger on the ''J'' key.\n\n- press ''J'' to start -','j',0);

for t = 1:pms.nrPracticeTrials;
    
    %% ITI
    Screen('FillRect',pms.wid,pms.backgroundColor);
    Screen('FillOval', pms.wid, 0, fixationRect);
    Screen('Flip',pms.wid);
    WaitSecs(pms.ISI);
    
    %% stimulus
    pressed = 0;
    Screen(pms.wid,'PutImage', pms.shape{data.prac.trialList(t)},pms.shapeRect{data.prac.position(t)});
    start = Screen(pms.wid,'Flip');
    
    while GetSecs - start < pms.stimTime
        
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && ~pressed
            keyStrokes = KbName(keyCode);
            if any(strcmpi(keyStrokes,'f')) || any(strcmpi(keyStrokes,'j'))
                
                pressed = 1;
                data.prac.rt(t) = GetSecs-start;
                
                if any(strcmpi(keyStrokes,'f'))
                    data.prac.response(t) = 1;
                else
                    data.prac.response(t) = 2;
                end
                
                data.prac.acc(t) = data.prac.correctResponse(t) == data.prac.response(t);
                
                Screen(pms.wid,'DrawTexture', pms.texture(data.prac.trialList(t)),[],pms.shapeRect{data.prac.position(t)});
                Screen('FillOval', pms.wid, [255*(~data.prac.acc(t)) 255*data.prac.acc(t) 0], fixationRect);
                
                Screen(pms.wid,'Flip');
                
            end
        end
    end
    
end


%% close task
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);

WaitSecs(1);

end


