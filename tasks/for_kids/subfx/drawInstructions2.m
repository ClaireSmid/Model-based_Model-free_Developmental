function drawInstructions2(part,screen)

global pms

% Screen('FillRect',pms.wid,pms.backgroundColor);

wrapat = 80;

if part == 1 % 7 screens
    switch screen
        case 1
            message = 'Welcome to the Space Treasure game!\n\n\n\n\n\n\n Press the SPACE bar to start.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            aliensize = 200; % show aliens for fun
            rect_1 = [pms.origin(1)-1.25*aliensize pms.origin(2)-0.5*aliensize ...
                pms.origin(1)-0.25*aliensize pms.origin(2)+0.5*aliensize];
            rect_2 = [pms.origin(1)+0.25*aliensize pms.origin(2)-0.5*aliensize ...
                pms.origin(1)+1.25*aliensize pms.origin(2)+0.5*aliensize];
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,1),[],rect_1);
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,2),[],rect_2);
            
        case 2
            message = 'In this game, you are a space traveler and you are looking for space treasure on two different planets.';
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.25*pms.wRect(4), [], wrapat, [], [], 1.5);
            
            Screen('DrawTexture',pms.wid,pms.travellerTexture); % show the traveller    
            
        case 3
            message = 'The two planets are a red and a purple planet:';
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.25*pms.wRect(4), [], wrapat, [], [], 1.5);
            
            Screen('DrawTexture',pms.wid,pms.examplePlanetsTexture); % show planets
            
            
        case 4
            message = 'Each planet has one alien on it,\n\n\n\n\n\nand each alien has its own space treasure cave.\n\n\n\n\n\nWhen you arrive to a planet, you need to ask the alien to give you their treasure';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            aliensize = 200; % draw two aliens
            rect1 = [pms.origin(1)-1.25*aliensize pms.origin(2)-1.5*aliensize ...
                pms.origin(1)-0.25*aliensize pms.origin(2)-0.5*aliensize];
            rect2 = [pms.origin(1)+0.25*aliensize pms.origin(2)-1.5*aliensize ...
                pms.origin(1)+1.25*aliensize pms.origin(2)-0.5*aliensize];
            
            cavesize = 200; % draw two caves
            cave1 = [pms.origin(1)-1.5*cavesize pms.origin(2)+0.05*cavesize ... % added
                pms.origin(1)-0.5*cavesize pms.origin(2)+1.05*cavesize];
            cave2 = [pms.origin(1)+0.5*cavesize pms.origin(2)+0.05*cavesize ... % added
                pms.origin(1)+1.5*cavesize pms.origin(2)+1.05*cavesize];
            
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,1),[],rect1);
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,2),[],rect2);
            
            Screen('DrawTexture',pms.wid,pms.caveTexture2,[],cave1); % added
            Screen('DrawTexture',pms.wid,pms.caveTexture1,[],cave2);
            
            
        case 5
            message = 'This is the very special space treasure you want to collect!\n\n\n\n\nYou will only find out how much treasure an alien has once you ask them for it.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
           
            itemsize = 125; % show blue treasure (x1)
            rect1 = [pms.origin(1)-0.5*itemsize pms.origin(2)-0.7*itemsize ...
                pms.origin(1)+0.5*itemsize pms.origin(2)+0.3*itemsize];
            Screen('DrawTexture',pms.wid,pms.BlueTreasureTexture,[],rect1);%rect1+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
                        
        case 6
            message = 'Aliens move around in the caves on their planet. If they are in a good part of their cave, they can give you lots of treasure!\n\n\n\n\nBut if they are in a bad part of their cave, they won''t have much treasure to give you:';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            treasuresize = [500 216]*0.75; 
            rect1 = [pms.origin(1)-0.5*treasuresize(1) pms.origin(2)-0.2*treasuresize(2) ...
                pms.origin(1)+0.5*treasuresize(1) pms.origin(2)+0.8*treasuresize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLotsOfTreasureTexture,[],rect1+[0 -0.047*pms.wRect(4) 0 -0.047*pms.wRect(4)]);

%             antimattersize = [500 216]*0.75; 
            rect2 = [pms.origin(1)-0.5*treasuresize(1) pms.origin(2)-0.2*treasuresize(2) ...
                pms.origin(1)+0.5*treasuresize(1) pms.origin(2)+0.8*treasuresize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLittleTreasureTexture,[],rect2+[0 +0.2*pms.wRect(4) 0 +0.2*pms.wRect(4)]);
            
        case 7
            message = 'Aliens will move around in their caves slowly. This means that they can only walk from a good to a bad part slowly, or from a bad to a good part slowly.\n\n\n\n\n\n\n\n\nSo, how much treasure aliens give you will change slowly.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            % these two were the latest versions
             aliensize = 200;
            rect_4 = [pms.origin(1)-1.5*aliensize pms.origin(2)-0.5*aliensize ...
                pms.origin(1)-0.5*aliensize pms.origin(2)+0.5*aliensize];
            Screen('DrawTexture',pms.wid,pms.sleepyAlienTexture,[],rect_4);

              cavesize = 200;
            cave1 = [pms.origin(1)-0.1*cavesize pms.origin(2)-0.5*cavesize ... % added
                pms.origin(1)+1.1*cavesize pms.origin(2)+0.5*cavesize];
            Screen('DrawTexture',pms.wid,pms.caveTexture1,[],cave1); % added

            %%% this is without the sleepy alien, only the cave

%             cavesize = 200;
%             cave1 = [pms.origin(1)-0.5*cavesize pms.origin(2)-0.5*cavesize ... % added
%                 pms.origin(1)+0.5*cavesize pms.origin(2)+0.5*cavesize];
%             Screen('DrawTexture',pms.wid,pms.caveTexture1,[],cave1); % added
                      
        case 8
            message = 'The space treasure that you collect in this game you can use for a real prize at the end!\n\n\n\n\n\n\n\nMake sure you try to collect as much treasure as you can!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            treasuresize = [500 216]*0.75;
            rect1 = [pms.origin(1)-1.2*treasuresize(1) pms.origin(2)+0.75*treasuresize(2) ...
                pms.origin(1)-0.2*treasuresize(1) pms.origin(2)+1.75*treasuresize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLotsOfTreasureTexture,[],rect1+[0 -0.2*pms.wRect(4) 0 -0.2*pms.wRect(4)]);
            
            giftsize = 300;
            gift1 = [pms.origin(1)+0.2*giftsize pms.origin(2)-0.5*giftsize ...
                pms.origin(1)+1.2*giftsize pms.origin(2)+0.5*giftsize];
            Screen('DrawTexture',pms.wid,pms.giftTexture,[],gift1);
                      
            equalssize = 150;
            equals1 = [pms.origin(1)-0.5*equalssize pms.origin(2)-0.5*equalssize ...
                pms.origin(1)+0.5*equalssize pms.origin(2)+0.5*equalssize];
            Screen('DrawTexture',pms.wid,pms.equalsTexture,[],equals1);
                      
        case 9
            message = 'Let''s practice asking the aliens for space treasure.\n\nWhen you see the aliens on the planet you have to press the SPACE bar quickly to ask them for treasure.\n\nLet''s try that now.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
 
    end
end

if part == 2
    switch screen
        case 1
            message = 'This alien started in a good part of their cave and gave you lots of treasure to begin with.\n\nBut it slowly moved to a worse part of their cave and couldn''t find much treasure to give you.\n\nLet''s go meet another alien!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end
 
if part == 3 % 6 screens
    switch screen
        case 1
                   
            message = 'Did you see that how much treasure this alien could give you changed in a different way?\n\n\nHow did the amount of treasure it gave you changed?';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 2
            message = 'Great!\n\nNow that you know about the aliens and treasure, let''s learn how to travel to the two planets.\n\nYou will travel from earth to one of two planets: a red planet or a purple planet:';
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.4*pms.wRect(4), [], wrapat, [], [], 1.5);
            
            planetsize = [600 200];
            rect = [pms.origin(1)-0.5*planetsize(1) pms.origin(2)-0.2*planetsize(2) ...
                pms.origin(1)+0.5*planetsize(1) pms.origin(2)+0.8*planetsize(2)];
            Screen('DrawTexture',pms.wid,pms.examplePlanetsTexture,[],rect);
            
        case 3
            message = 'Every time you travel, you can choose between two spaceships. Either the two on the left, or the two on the right.\n\n\n\n\n\n\n\n\nIn each pair, one ship will always take you to the red planet, and the other will always take you to the purple planet.';
            rocketsize = 300;
            rect{1} = [pms.origin(1)-1.75*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)-0.75*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{2} = [pms.origin(1)-1.25*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)-0.25*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{3} = [pms.origin(1)+0.25*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)+1.25*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{4} = [pms.origin(1)+0.75*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)+1.75*rocketsize pms.origin(2)+0.5*rocketsize];
            for r = 1:4
                Screen('DrawTexture',pms.wid,pms.rocketTextures(r),[],rect{r});
%                 Screen('DrawTexture',pms.wid,pms.rocketTextures(r),[],rect{r}-[0 0.12*pms.wRect(4) 0 0.12*pms.wRect(4)]);
            end
            
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            message = 'OR';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 0);
            
        case 4
            message = 'You can choose a spaceship using the F and J key on the computer. When you choose a spaceship, you will see a line around it, like this:\n\n\n\n';
            
            % method 1
            Screen('DrawTexture', pms.wid, pms.planetTextures(1));
            stimsize = 300;
            stimcenter{1} = [pms.origin(1)-pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
            stimcenter{2} = [pms.origin(1)+pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
            stimrect{1} = [stimcenter{1}(1)-stimsize/2 stimcenter{1}(2)-stimsize/2 stimcenter{1}(1)+stimsize/2 stimcenter{1}(2)+stimsize/2];
            stimrect{2} = [stimcenter{2}(1)-stimsize/2 stimcenter{2}(2)-stimsize/2 stimcenter{2}(1)+stimsize/2 stimcenter{2}(2)+stimsize/2];
            
            Screen('DrawTexture', pms.wid, pms.rocketTextures(1),[],stimrect{1});
            Screen('DrawTexture', pms.wid, pms.rocketTextures(2),[],stimrect{2});

            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.25*pms.wRect(4), [], wrapat, [], [], 1.5);
            
        case 5
            message = 'You can choose a spaceship using the F and J key on the computer. When you choose a spaceship, you will see a line around it, like this:\n\n\n\n';
            
            % method 1
            Screen('DrawTexture', pms.wid, pms.planetTextures(1));
            stimsize = 300;
            stimcenter{1} = [pms.origin(1)-pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
            stimcenter{2} = [pms.origin(1)+pms.wRect(3)/6 pms.origin(2)+0.1*pms.wRect(4)];
            stimrect{1} = [stimcenter{1}(1)-stimsize/2 stimcenter{1}(2)-stimsize/2 stimcenter{1}(1)+stimsize/2 stimcenter{1}(2)+stimsize/2];
            stimrect{2} = [stimcenter{2}(1)-stimsize/2 stimcenter{2}(2)-stimsize/2 stimcenter{2}(1)+stimsize/2 stimcenter{2}(2)+stimsize/2];
            
            Screen('DrawTexture', pms.wid, pms.rocketTextures(1),[],stimrect{1});
            Screen('DrawTexture', pms.wid, pms.rocketTextures(2),[],stimrect{2});
            Screen('DrawTexture', pms.wid, pms.rectTextures(1),[],stimrect{1});

            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.25*pms.wRect(4), [], wrapat, [], [], 1.5);

        case 6
            message = 'Let''s practice flying to the planets!\n\nFirst, try to pick the spaceship in each pair that will get you to the purple planet:';
            planetsize = [1010 758]*0.5;
            rect = [pms.origin(1)-0.5*planetsize(1) pms.origin(2)-0.5*planetsize(2) ...
                pms.origin(1)+0.5*planetsize(1) pms.origin(2)+0.5*planetsize(2)];
            Screen('DrawTexture',pms.wid,pms.planetTextures(3),[],rect);
          
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.35*pms.wRect(4), [], wrapat, [], [], 1.5);
    end
end

if part == 4
    switch screen
        case 1
            message = 'Remember, try to pick the spaceships that will get you to the purple planet:';
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.3*pms.wRect(4), [], wrapat, [], [], 1.5);
            planetsize = [1010 758]*0.5;
            rect = [pms.origin(1)-0.5*planetsize(1) pms.origin(2)-0.5*planetsize(2) ...
                pms.origin(1)+0.5*planetsize(1) pms.origin(2)+0.5*planetsize(2)];
            Screen('DrawTexture',pms.wid,pms.planetTextures(3),[],rect);
    end
end

if part == 5
    switch screen
        case 1
            message = 'Great job!\n\nNow can you try and pick the spaceships that will take you to the red planet?';
            
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.35*pms.wRect(4), [], wrapat, [], [], 1.5);
            planetsize = [1010 758]*0.5;
            rect = [pms.origin(1)-0.5*planetsize(1) pms.origin(2)-0.5*planetsize(2) ...
                pms.origin(1)+0.5*planetsize(1) pms.origin(2)+0.5*planetsize(2)];
            Screen('DrawTexture',pms.wid,pms.planetTextures(2),[],rect);
    end
end

if part == 6 
    switch screen
        case 1
            message = 'Remember, try to pick the spaceships that will get you to the red planet:';
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.3*pms.wRect(4), [], wrapat, [], [], 1.5);
            planetsize = [1010 758]*0.5;
            rect = [pms.origin(1)-0.5*planetsize(1) pms.origin(2)-0.5*planetsize(2) ...
                pms.origin(1)+0.5*planetsize(1) pms.origin(2)+0.5*planetsize(2)];
            Screen('DrawTexture',pms.wid,pms.planetTextures(2),[],rect);
    end
end

if part == 7 % 5 screens
    switch screen
        case 1
            message = 'Well done! Can you remember which spaceships took you to the red planet?\n\n\n\n\n\n\n\n\nAnd which spaceships took you to the purple planet?';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            rocketsize = 300;
            rect{1} = [pms.origin(1)-1.75*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)-0.75*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{2} = [pms.origin(1)-1.25*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)-0.25*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{3} = [pms.origin(1)+0.25*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)+1.25*rocketsize pms.origin(2)+0.5*rocketsize];
            rect{4} = [pms.origin(1)+0.75*rocketsize pms.origin(2)-0.5*rocketsize pms.origin(1)+1.75*rocketsize pms.origin(2)+0.5*rocketsize];
            for r = 1:4
                  Screen('DrawTexture',pms.wid,pms.rocketTextures(r),[],rect{r});

%                 Screen('DrawTexture',pms.wid,pms.rocketTextures(r),[],rect{r}-[0 0.12*pms.wRect(4) 0 0.15*pms.wRect(4)]);
            end
            
            message = 'OR';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 0);
            
        case 2
            message = 'Perfect! You are all ready for space travel and for collecting space treasure!\n\n\n\n';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            itemsize = 125;
            rect1 = [pms.origin(1)-0.5*itemsize pms.origin(2)-0.5*itemsize ...
                pms.origin(1)+0.5*itemsize pms.origin(2)+0.5*itemsize];
            Screen('DrawTexture',pms.wid,pms.BlueTreasureTexture,[],rect1+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
            
        case 3
            message = 'You now know how to fly to the planets and how to ask for space treasure, so you are ready to practice them together.\n\nEach time, you will pick a spaceship to fly to a planet and then ask the alien to mine for you.\n\nTry to get as much treasure as you can!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 4
            message = 'A few tips for you!\n\nTip 1:\nTry to remember which aliens have a lot of treasure. Since they can only move slowly, an alien that gives you a lot of treasure now, will probably give you a lot of treasure for a little while longer.\n\nTip 2:\nThe aliens will always give you as much as they can. They never want to trick you.\n\nTip 3:\n The spaceship you choose is important. You might get more treasure from one alien than the other.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 5
            message = 'Remember that the aliens on each planet might have different amounts of treasure to give you, but that this changes over time.\n\nYou can get better at the game by thinking of which planet and alien will give you the most treasure every time.\n\nPress SPACE to try!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end

if part == 8
    switch screen
        
        case 1
            message = 'Great job on the practice!\n\nIn the real game, you will only get a little bit of time before you have to make a decision.\n\nWe''ll show you this now, so you know how fast you will have to be!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 2
            message = 'If you were too late to take a spaceship, or too late to ask treasure from the alien, you will see that they look greyed out with a white cross.\n\nLet''s see what that looks like!\n\nYou won''t be able to press anything here, this is just to show you how fast you will need to be.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        
    end
end

if part == 9 % 5 screens
    switch screen
        
        case 1
            message = 'Great!\n\nThere''s one last thing you need to know.\n\nFrom now on, everytime before you pick a spaceship, you will see one of the blue boxes below.\n\n\n\n\n\nThese boxes are called treasure boosters.';
            
            
            itemsize = [400 150];
%             rect1 = [pms.origin(1)-0.5*itemsize(1) pms.origin(2)-0.5*itemsize(2) ...
%                 pms.origin(1)+0.5*itemsize(1) pms.origin(2)+0.5*itemsize(2)];

            rect1 = [pms.origin(1)-0.5*itemsize(1) pms.origin(2)+0.1*itemsize(2) ...
                pms.origin(1)+0.5*itemsize(1) pms.origin(2)+1.1*itemsize(2)];
%             Screen('DrawTexture',pms.wid,pms.exampleStakesTexture,[],rect1+[0 +0.2*pms.wRect(4) 0 +0.2*pms.wRect(4)]);
            Screen('DrawTexture',pms.wid,pms.exampleStakesTexture,[],rect1);
            
%             Screen('DrawTexture',pms.wid,pms.exampleStakesTexture,[],rect1+[0 -0.2*pms.wRect(4) 0 -0.2*pms.wRect(4)]);
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 2
            message = 'If you see the blue box with the ''x5'' in it, it means the blue treasure you collect will turn into gold that is worth 5 TIMES MORE.\n\n\n\n\n\n\nSo, if you get 3 pieces of treasure from an alien, it will turn into gold and you will get 15 points!';
            
            
            itemsize = [200 200];
            rect1 = [pms.origin(1)-0.5*itemsize(1) pms.origin(2)-0.5*itemsize(2) ...
                pms.origin(1)+0.5*itemsize(1) pms.origin(2)+0.5*itemsize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleStake5Texture,[],rect1);
%             Screen('DrawTexture',pms.wid,pms.exampleStake5Texture,[],rect1+[0 +0.1*pms.wRect(4) 0 +0.1*pms.wRect(4)]);
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
%         case 3
%             message = 'So the blue treasure will turn into gold treasure that is worth 5 times more per treasure piece.';
% 
%             itemsize = [220 220]*0.5;
%             rect1 = [pms.origin(1)-0.5*itemsize(1) pms.origin(2)-0.5*itemsize(2) ...
%                 pms.origin(1)+0.5*itemsize(1) pms.origin(2)+0.5*itemsize(2)];
%             Screen('DrawTexture',pms.wid,pms.pms.exampleStake5Texture,[],rect1+[0 -0.1*pms.wRect(4) 0 -0.1*pms.wRect(4)]);
%             DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            

        case 3
            message = 'But, if you see the blue box with the ''x1'' in it, it means the blue treasure you collect will not be boosted.\n\n\n\n\n\n\nSo, if you get 3 pieces of treasure from an alien, you will get 3 points.';
            
            itemsize = [200 200];
            rect1 = [pms.origin(1)-0.5*itemsize(1) pms.origin(2)-0.5*itemsize(2) ...
                pms.origin(1)+0.5*itemsize(1) pms.origin(2)+0.5*itemsize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleStake1Texture,[],rect1);

%             Screen('DrawTexture',pms.wid,pms.exampleStake1Texture,[],rect1+[0 -0.1*pms.wRect(4) 0 -0.1*pms.wRect(4)]);
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 4
            message = 'Let''s see how that works next!\n\nWe''ll have another practice, everytime before the spaceship you will either see a blue box with ''x1'' or ''x5'' in it.\n\nIf you see ''x5'', the treasure you can collect that time will be worth 5 times more.\n\nIf you see ''x1'', the treasure will be worth the same as before.\n\nLet''s try that now!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
%             % show Earth
%             Screen('DrawTexture', pms.wid, pms.planetTextures(1));
%            
            % show Blue treasure
%             itemsize = 150;
%             rect1 = [pms.origin(1)-0.55*itemsize pms.origin(2)-0.5*itemsize ...
%                 pms.origin(1)+0.55*itemsize pms.origin(2)+0.5*itemsize];
%             Screen('DrawTexture',pms.wid,pms.BoostrayOffTexture,[],rect1+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
%             
%         case 5
%             message = 'Let''s see how this works. .\n\nIt is important to know that whether your boost ray works or not on each trial is chosen COMPLETELY RANDOMLY. This means that there is no way to predict what it will be on the next trial.';
%             itemsize = 150;
%             rect = [pms.origin(1)-0.55*itemsize pms.origin(2)-0.5*itemsize ...
%                 pms.origin(1)+0.55*itemsize pms.origin(2)+0.5*itemsize];
%             Screen('DrawTexture',pms.wid,pms.BoostrayOnTexture,[],rect+[0 -0.1*pms.wRect(4) 0 -0.1*pms.wRect(4)]);
%             DrawFormattedText(pms.wid,message,'center','center', [], wrapat+20, [], [], 1.5);
%             
%         case 6
%             message = 'Let''s see how this affects the treasure!\n\n\nYou will now see whether your boostray works or not before you pick a spaceship. Let''s see how much treasure you can collect!\n\n\nAlso, if the alien has no treasure, then you won''t get anything, even if your boost ray was on!\n\n\nPress the SPACE bar once to see how much treasure there is, then again to collect it.';
%             DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end

if part == 10 % 3 screens
    switch screen
        case 1
            message = 'Well done! You''ve now finished the practice!\n\nLet''s go over everything one last time before the real game with your missions begins.\n\nYou will have 4 missions where you can collect space treasure, and you can take a break between each mission. One mission will take about 6 minutes.\n\nYou will get a little time to decide which spaceship to take, if you are too slow, you will see a cross, and you cannot take a spaceship.\n\n';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            aliensize = 200; % show aliens for fun
            rect_1 = [pms.origin(1)-1.25*aliensize pms.origin(2)+1.3*aliensize ...
                pms.origin(1)-0.25*aliensize pms.origin(2)+2.3*aliensize];
            rect_2 = [pms.origin(1)+0.25*aliensize pms.origin(2)+1.3*aliensize ...
                pms.origin(1)+1.25*aliensize pms.origin(2)+2.3*aliensize];
            Screen('DrawTexture',pms.wid,pms.greyalienTexture,[],rect_1);
            Screen('DrawTexture',pms.wid,pms.greyrocketTexture,[],rect_2);

        case 2
            message = 'Remember:\n\n1. Choose a spaceship to take you to the red or the purple planet. Each spaceship will always take you to the same planet.\n\n2. Press SPACE to ask the aliens for the treasure they have collected.\n\n3. The amount of treasure each alien collects changes over time. Try to think about which alien will give you the most treasure every time.\n\n4. Your treasure booster can turn the treaure you collect into gold treasure that is worth 5 TIMES more than the blue treasure!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            planetsize = 75;
            rect1 = [pms.origin(1)-9.5*planetsize pms.origin(2)-4*planetsize ...
                pms.origin(1)-8*planetsize pms.origin(2)-3.2*planetsize];
            Screen('DrawTexture',pms.wid,pms.examplePlanetsSmallTexture,[],rect1+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
            
            itemsize = 75;
            rect2 = [pms.origin(1)+7.75*itemsize pms.origin(2)-1.9*itemsize ...
                pms.origin(1)+8.75*itemsize pms.origin(2)-0.9*itemsize];
            Screen('DrawTexture',pms.wid,pms.BlueTreasureTexture,[],rect2+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
            
            arrowsize = [150 40]*0.75;
            rect3 = [pms.origin(1)-6.5*arrowsize(1) pms.origin(2)+1*arrowsize(2) ... % arrow
                pms.origin(1)-5.5*arrowsize(1) pms.origin(2)+2*arrowsize(2)];
            Screen('DrawTexture',pms.wid,pms.arrowTexture,[],rect3+[0 0.03*pms.wRect(4) 0 0.03*pms.wRect(4)]);
            
            stakesize = 75;
            rect4 = [pms.origin(1)+8*stakesize pms.origin(2)+2*stakesize ...
                pms.origin(1)+9*stakesize pms.origin(2)+3*stakesize];
            Screen('DrawTexture',pms.wid,pms.exampleStake5Texture,[],rect4+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);

        case 3
            message = 'Remember, the space treasure that you collect in this game you can use for a real prize at the end!\n\n\n\n\n\n\n\nMake sure you try to collect as much treasure as you can!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            
            treasuresize = [500 216]*0.75;
            rect1 = [pms.origin(1)-1.2*treasuresize(1) pms.origin(2)+0.75*treasuresize(2) ...
                pms.origin(1)-0.2*treasuresize(1) pms.origin(2)+1.75*treasuresize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLotsOfTreasureTexture,[],rect1+[0 -0.2*pms.wRect(4) 0 -0.2*pms.wRect(4)]);
            
            giftsize = 300;
            gift1 = [pms.origin(1)+0.2*giftsize pms.origin(2)-0.5*giftsize ...
                pms.origin(1)+1.2*giftsize pms.origin(2)+0.5*giftsize];
            Screen('DrawTexture',pms.wid,pms.giftTexture,[],gift1);
                      
            equalssize = 150;
            equals1 = [pms.origin(1)-0.5*equalssize pms.origin(2)-0.5*equalssize ...
                pms.origin(1)+0.5*equalssize pms.origin(2)+0.5*equalssize];
            Screen('DrawTexture',pms.wid,pms.equalsTexture,[],equals1);
    end
end
