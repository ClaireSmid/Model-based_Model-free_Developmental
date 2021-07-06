 function showInstructions(part)

global pms
global ESC
% global data

% nrscreens = [7 1 3 1 1 1 3 3 3];
%nrscreens = [6 1 1 1 7 1 4 5 3];
nrscreens = [9 1 6 1 1 1 5 2 4 3]; % for drawInstructions2 (the number of parts in drawInstructions2

screen = 1;
while screen <= nrscreens(part)
    if ESC == 0
    drawInstructions2(part,screen);
    Screen('Flip',pms.wid);
    WaitSecs(0.5);
    pressed = 0;
    while ~pressed
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown
            keyStrokes = KbName(keyCode);
            if any(strcmpi(keyStrokes,pms.leftKey))
                pressed = 1;
                screen = screen - 1;
                if screen < 1
                    screen = 1;
                end
            elseif any(strcmpi(keyStrokes,pms.rightKey)) || any(strcmpi(keyStrokes,pms.selectKey))
                pressed = 1;
                screen = screen + 1;
            elseif any(strcmpi(keyStrokes,pms.exitKey)) % added in for kill code
                ESC = 1;
                break;
            end
        end
    end
    else
        break;
    end
end

end

