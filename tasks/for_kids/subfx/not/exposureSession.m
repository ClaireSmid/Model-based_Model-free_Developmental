function exposureSession

global data
global pms

fixationRect = [pms.origin(1)-2 pms.origin(2)-2 pms.origin(1)+2 pms.origin(2)+2];

for b = 1:pms.nrBlocks
        
    if round(rand)
        showMessage(['You are about to start block ', num2str(b), ' of 4.\n\nPut your left index finger on the ''F'' key,\nand your right index finger on the ''J'' key.\n\n- press ''J'' to start -'],'j',0);
    else
        showMessage(['You are about to start block ', num2str(b), ' of 4.\n\nPut your left index finger on the ''F'' key,\nand your right index finger on the ''J'' key.\n\n- press ''F'' to start -'],'f',0);
    end
    
    for t = 1:pms.nrExposureTrialsPerBlock;
        
        %% ITI
        Screen('FillRect',pms.wid,pms.backgroundColor);
        Screen('FillOval', pms.wid, 0, fixationRect);
        Screen('Flip',pms.wid);
        WaitSecs(pms.ISI);
        
        %% stimulus
        pressed = 0;
        Screen(pms.wid,'PutImage', pms.shape{data.block{b}.trialList(t)},pms.shapeRect{data.block{b}.position(t)});
        start = Screen(pms.wid,'Flip');
        
        while GetSecs - start < pms.stimTime
            
            [keyIsDown, ~, keyCode] = KbCheck;
            if keyIsDown && ~pressed
                keyStrokes = KbName(keyCode);
                if any(strcmpi(keyStrokes,'f')) || any(strcmpi(keyStrokes,'j'))
                    
                    pressed = 1;
                    data.block{b}.rt(t) = GetSecs-start;
                    
                    if any(strcmpi(keyStrokes,'f'))
                        data.block{b}.response(t) = 1;
                    else
                        data.block{b}.response(t) = 2;
                    end
                    
                    data.block{b}.acc(t) = data.block{b}.correctResponse(t) == data.block{b}.response(t);
                    
                    Screen(pms.wid,'DrawTexture', pms.texture(data.block{b}.trialList(t)),[],pms.shapeRect{data.block{b}.position(t)});
                    Screen('FillOval', pms.wid, [255*(~data.block{b}.acc(t)) 255*data.block{b}.acc(t) 0], fixationRect);
                    
                    Screen(pms.wid,'Flip');
                    
                end
            end
        end
        
    end
end

%% close task
Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);

WaitSecs(1);

end


