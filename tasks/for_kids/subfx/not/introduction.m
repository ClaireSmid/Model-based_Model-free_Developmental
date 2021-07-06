function introduction

% global data
global pms

if pms.buttonMapping==1
    message = ['Welcome to the experiment!\n\nIn this study, you will see '...
        'shapes appear on the left and right sides of the screen.'...
        '\n\nYour job is to press the ''J'' key, with your right index finger, '...
        'when the shape on screen is ASYMMETRICAL in the VERTICAL AXIS, and the ''F''' ...
        ' key, with your left index finger, when it is SYMMETRICAL.\n\n\n\n\n\n\n'...
        'ASYMMETRICAL                                 SYMMETRICAL\n\nTry to '...
        'respond as fast and as accurate as possible.\n\n- press SPACE to continue -'];
    DrawFormattedText(pms.wid, message,'center', 'center', 0, 80, [], [], 1.5);
else
    message = ['Welcome to the experiment!\n\nIn this study, you will see '...
        'shapes appear on the left and right sides of the screen.'...
        '\n\nYour job is to press the ''J'' key, with your right index finger, '...
        'when the shape on screen is SYMMETRICAL in the VERTICAL AXIS, and the ''F''' ...
        ' key, with your left index finger, when it is ASYMMETRICAL.\n\n\n\n\n\n\n'...
        'SYMMETRICAL                                 ASYMMETRICAL\n\nTry to '...
        'respond as fast and as accurate as possible.\n\n- press SPACE to continue -'];
    DrawFormattedText(pms.wid, message,'center', 'center', 0, 80, [], [], 1.5);
end


rect1 = pms.shapeRect{1};
rect2 = pms.shapeRect{2};

rect1([2,4]) = rect1([2,4])+75;
rect2([2,4]) = rect2([2,4])+75;

if pms.buttonMapping==1
    Screen(pms.wid,'PutImage', pms.shape{1},rect1);
    Screen(pms.wid,'PutImage', pms.shape{24},rect2);
else
    Screen(pms.wid,'PutImage', pms.shape{24},rect1);
    Screen(pms.wid,'PutImage', pms.shape{1},rect2);
end

Screen(pms.wid,'Flip')

response = 0;

while response == 0
    
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown
        keyStrokes = KbName(keyCode);
        if any(strcmpi(keyStrokes,'space'))
            response = 1;
        end
    end
    
end

Screen('FillRect',pms.wid,pms.backgroundColor);
Screen('Flip',pms.wid);
WaitSecs(1);


end

