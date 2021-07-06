function responseTime = showMessage(message,key,time)

global pms

Screen('TextSize',pms.wid,pms.textSize1);
Screen(pms.wid,'TextColor',[255 255 255]);

msg = sprintf(message);

Screen('FillRect', pms.wid, pms.backgroundColor);

DrawFormattedText(pms.wid, msg,'center', 'center', [], 80, [], [], 1.5);

if ~exist('key','var') || isempty(key)
    key = 'space';
end

% show it
Screen('Flip', pms.wid);

WaitSecs(1);

response = 0;

if time == 0 

    while response == 0
        
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            keyStrokes = KbName(keyCode);
            if any(strcmpi(keyStrokes,key))
                response = 1;
                responseTime = GetSecs;
            end
        end
        
    end
        
else
    
    WaitSecs(time);
    
end

end