function testingSession

global data
global pms

%% setup

fixationRect = [pms.origin(1)-2 pms.origin(2)-2 pms.origin(1)+2 pms.origin(2)+2]; % face location

message = ['Now, the second part of the experiment starts.\n\nOn each trial you will see two sequences of THREE ' ...
    'shapes appear on screen. You won''t have to indicate whether they are symmetrical anymore.\n\n'...
    'However, you should still pay close attention to both sequences. After they appeared, you will have to indicate which '...
    'of these is most FAMILIAR to you:\nthe first or the second sequence.\n\n- press SPACE to continue -'];
showMessage(message,pms.screenKey,0);

message = ['You will press the ''F'' key if the FIRST sequence was more familiar, and the ''J''  key if the ' ...
    'SECOND sequence was more familiar. Your will have unlimited time to answer on each trial.\n\n- press SPACE to continue -'];
showMessage(message,pms.screenKey,0);

message = ['To recap, on each trial you will see two sequences of three shapes appear on screen. After '...
    'they appeared, press ''F'' if the first sequence was more familiar to you, and ''J'' '...
    ' if the second sequence was more familiar to you.\n\n- press SPACE to start with the second part -'];
showMessage(message,pms.screenKey,0);

for t = 1:length(data.test.tripIndex)
    
    data.test.tripletPos(t) = ceil(rand*2); % 1 == foil second, 2 == foil first
    
    foil = data.test.foil(t,:);
    triplet = data.test.triplet(t,:);
    
    if data.test.tripletPos(t) == 1
        shapes{1} = triplet;
        shapes{2} = foil;
    else
        shapes{1} = foil;
        shapes{2} = triplet;
    end
    
    for i = 1:2
        for j = 1:3
            Screen('FillRect',pms.wid,pms.backgroundColor);
            Screen('FillOval', pms.wid, 0, fixationRect);
            Screen('Flip',pms.wid);
            WaitSecs(pms.ISI);
            % stimulus
            Screen(pms.wid,'DrawTexture', pms.texture(shapes{i}(j)));
            Screen(pms.wid,'Flip');
            WaitSecs(pms.stimTime);
        end
        Screen('FillRect',pms.wid,pms.backgroundColor);
        Screen('FillOval', pms.wid, 0, fixationRect);
        Screen('Flip',pms.wid);
        WaitSecs(1.5);
    end
    
    %% disp probe
    DrawFormattedText(pms.wid,'Which was more familiar?','center',pms.origin(2)-100);
    DrawFormattedText(pms.wid,'FIRST sequence:\npress ''F'' key',pms.origin(1)-250,'center');
    DrawFormattedText(pms.wid,'SECOND sequence:\npress ''J'' key',pms.origin(1)+100,'center');
    start = Screen(pms.wid,'Flip');
    
    response = 0;
    while ~response
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            keyStrokes = KbName(keyCode);
            if any(strcmpi(keyStrokes,'f'))
                response = 1;
                rt = GetSecs - start;
            end
            if any(strcmpi(keyStrokes,'j'))
                response = 2;
                rt = GetSecs - start;
            end
        end
    end
    
    data.test.response(t) = response;
    data.test.acc(t) = data.test.tripletPos(t) == response;
    data.test.rt(t) = rt;
    
    %% close task
    Screen('FillRect', pms.wid, pms.backgroundColor);
    Screen('Flip', pms.wid);
    
    WaitSecs(1);
    
end

end