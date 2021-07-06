function drawInstructions(part,screen)

global pms

Screen('FillRect',pms.wid,pms.backgroundColor);

wrapat = 80;

if part == 1
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
            message = 'In this game, you are a space traveler looking for space treasure on two different planets:';
            Screen('DrawTexture',pms.wid,pms.examplePlanetsTexture);
            DrawFormattedText(pms.wid,message,'center',pms.origin(2)-0.25*pms.wRect(4), [], wrapat, [], [], 1.5);
       
        case 3
            message = 'Every time you travel, you can choose between two spaceships. Either the two on the left, or the two on the right.\n\n\n\n\n\n\nIn each pair, one ship will always take you to the red planet, and the other will always take you to the purple planet.';
            rocketsize = 200;
            rect{1} = [pms.origin(1)-1.75*rocketsize pms.origin(2)+0.1*rocketsize pms.origin(1)-0.75*rocketsize pms.origin(2)+1.1*rocketsize];
            rect{2} = [pms.origin(1)-1.25*rocketsize pms.origin(2)+0.1*rocketsize pms.origin(1)-0.25*rocketsize pms.origin(2)+1.1*rocketsize];
            rect{3} = [pms.origin(1)+0.25*rocketsize pms.origin(2)+0.1*rocketsize pms.origin(1)+1.25*rocketsize pms.origin(2)+1.1*rocketsize];
            rect{4} = [pms.origin(1)+0.75*rocketsize pms.origin(2)+0.1*rocketsize pms.origin(1)+1.75*rocketsize pms.origin(2)+1.1*rocketsize];
            for r = 1:4
                Screen('DrawTexture',pms.wid,pms.rocketTextures(r),[],rect{r}-[0 0.12*pms.wRect(4) 0 0.12*pms.wRect(4)]);
            end
            
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            message = 'OR';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 0);
            
        case 4
            message = 'You can choose a spaceship using the arrows on the computer (F and J key). When you choose a spaceship, you will see a line around it, like this:\n\n\n\n';
            
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
            message = 'You can choose a spaceship using the arrows on the computer (F and J key). When you choose a spaceship, you will see a line around it, like this:\n\n\n\n';
            
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

if part == 2
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

if part == 3
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
            

if part == 4
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

if part == 5
    switch screen
        case 1
            message = 'Well done! can you remember which spaceships took you to the red planet?\n\nAnd which spaceships took you to the purple planet?'
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 2
            message = 'Perfect! You are all ready for space travel and for collecting space treasure!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 3
            message = 'Each planet has an alien and each alien has their own space mine\n\n\n\n\n\nYou need to ask them to give you their treasure when you see them';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            aliensize = 200; % show aliens
            rect_1 = [pms.origin(1)-1.25*aliensize pms.origin(2)-0.5*aliensize ...
                pms.origin(1)-0.25*aliensize pms.origin(2)+0.5*aliensize];
            rect_2 = [pms.origin(1)+0.25*aliensize pms.origin(2)-0.5*aliensize ...
                pms.origin(1)+1.25*aliensize pms.origin(2)+0.5*aliensize];
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,1),[],rect_1);
            Screen('DrawTexture',pms.wid,pms.alienTextures(1,2),[],rect_2);
            
        case 4
            message = '\n\n\n\nThis is the very special space treasure you want to collect!\n\n\n\n\n\nYou will only find out how much treasure an alien has once you ask them for it.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            itemsize = 75;
            rect1 = [pms.origin(1)-0.5*itemsize pms.origin(2)-0.5*itemsize ...
                pms.origin(1)+0.5*itemsize pms.origin(2)+0.5*itemsize];
            Screen('DrawTexture',pms.wid,pms.treasureTexture,[],rect1+[0 0.05*pms.wRect(4) 0 0.05*pms.wRect(4)]);
            
        case 5
            message = '\n\nIf an alien is in a good part of their mine, they can give you lots of treasure!\n\n\n\n\n\nBut if they are in a bad part of their mine, they won''t have much treasure to give you.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
            treasuresize = [500 216]*0.75;
            rect1 = [pms.origin(1)-0.5*treasuresize(1) pms.origin(2)-0.5*treasuresize(2) ...
                pms.origin(1)+0.5*treasuresize(1) pms.origin(2)+0.5*treasuresize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLotsOfTreasureTexture,[],rect1+[0 -0.2*pms.wRect(4) 0 -0.2*pms.wRect(4)]);

            antimattersize = [500 216]*0.75;
            rect2 = [pms.origin(1)-0.5*antimattersize(1) pms.origin(2)-0.5*antimattersize(2) ...
                pms.origin(1)+0.5*antimattersize(1) pms.origin(2)+0.5*antimattersize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleLittleTreasureTexture,[],rect2+[0 0.03*pms.wRect(4) 0 0.03*pms.wRect(4)]);

        case 6
            message = 'Aliens will move around their mines slowly.\n\nThis means the amount of treasure they can give you will change over time';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 7
            message = 'Let''s practice asking the aliens for space treasure.\n\nWhen you see the aliens on the planet you have to press the SPACE bar quickly to ask them for treasure.\n\nLet''s try that now.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end

if part == 6
    switch screen
        case 1
            message = 'This alien started in a good part of their mine and gave you lots of treasure to begin with.\n\nBut over time, it moved to a worse part of their mine and couldn''t find much treasure to give you.\n\nLet''s go meet another alien!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end

if part == 7
    switch screen
        case 1
            message = 'Did you see that this alien''s mine changed in a different way?\n\n\nCan you say how the alien moved around in it''s mine?';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
        case 2
            message = 'Great! Now let''s try picking a spaceship to travel on, and asking the alien we find for their treasure.\n\n';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
        case 3
            message = 'Tip 1:\nTry to remember which aliens have a lot of treasure.Since they can only move slowly, an alien that gives you a lot of treasure now, will probably give you a lot of treasure for a little while longer.\n\nTip 2:\nEach alien has its own mine. Just because one alien has a bad mine does not mean the other has a good mine. Also, the aliens will always give you as much treasure as they can and they will never try to trick you.\n\nTip 3:\n The spaceship you choose is important because often the alien on one planet is better than the one on the other planet. You can find more treasure by choosing the spaceship that takes you to the right planet.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 5
            message = 'Remember that the aliens on each planet might have different amounts of treasure to give you, but that this might change over time.\n\n\n\nYou can get better at the game by thinking of which planet and alien will give you the most treasure every time.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

    end
end

if part == 8
    switch screen
        case 1
            message = 'Well done!\n\nThere''s one last thing you need to know.\n\nSometimes you will be able to boost the treasure you can collect from the aliens, using your own special boost ray.\n\nHowever, because your boost ray breaks all the time, you are not sure when you can use it!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 2
            message = '\n\nYou will now see if you can use your special boost ray before every spaceship you choose.\nThey will look like the blue boxes above';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            imgsize = [600 220]*0.5;
            rect = [pms.origin(1)-0.5*imgsize(1) pms.origin(2)-0.5*imgsize(2) ...
                pms.origin(1)+0.5*imgsize(1) pms.origin(2)+0.5*imgsize(2)];
            Screen('DrawTexture',pms.wid,pms.exampleStakesTexture,[],rect+[0 -0.12*pms.wRect(4) 0 -0.12*pms.wRect(4)]);

        case 3
            message = '\n\nIf you see the box with 5X in it, it means your boost ray is on!\n\nthis means you will get 5 times more treasure!';
            imgsize = [220 220]*0.5;
            rect = [pms.origin(1)-0.5*imgsize(1) pms.origin(2)-0.5*imgsize(2) ...
                pms.origin(1)+0.5*imgsize(1) pms.origin(2)+0.5*imgsize(2)];
            Screen('DrawTexture',pms.wid,pms.example5xTexture,[],rect+[0 -0.1*pms.wRect(4) 0 -0.1*pms.wRect(4)]);
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat+20, [], [], 1.5);


        case 4
            message = '\n\nBut if you see the box with 1X in it, it means your boost ray is off.\n\nThen you won''t get any boost for more treasure. You will still collect treasure, but only as much as the alien has for you.';
            imgsize = [220 220]*0.5;
            rect = [pms.origin(1)-0.5*imgsize(1) pms.origin(2)-0.5*imgsize(2) ...
                pms.origin(1)+0.5*imgsize(1) pms.origin(2)+0.5*imgsize(2)];
            Screen('DrawTexture',pms.wid,pms.example1xTexture,[],rect+[0 -0.1*pms.wRect(4) 0 -0.1*pms.wRect(4)]);
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat+20, [], [], 1.5);
            
        case 5
            message = 'Let''s practice this!\n\n\nThe boost ray will be on sometimes, and we will see how much treasure you can collect.\n\n\nAlso, if the alien has no treasure, then you won''t get anything, even if the boost is on!\n\nPress the SPACE bar once to see how much treasure there is, then again to collect it.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
            
    end
end

if part == 9
    switch screen
        case 1
            message = 'You''ve got this!\nWe can now start the real game.\n\nIn the real game, you will find new aliens with new mines on the two planets, but everything else will be the same.\n\nTry to collect as much space treasure as you can by flying to planets and asking the aliens for treasure.';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 2
            message = 'Remember:\n\nHow much treasure each alien has changes slowly, so try and think of which spaceships and aliens are good for you right now.\n\nOne of the aliens on the planet will probably be in a better part of their mine than the other, so try to think about this when choosing a spaceship!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 3
            message = 'Let''s think about what we''ve learned so far:\n\n\n1. A spaceship will always take you to the same planet.\n\n2. Collect treasure by asking the aliens by pressing SPACE.\n\n3.How much treasure an alien will give you changes slowly because they move slowly in their mines.\n\n4.If your booster ray works you can get 5 times more treasure!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);

        case 4
            message = 'You can use the space treasure in real life by using it as points for a prize you will get at the end!\n\nRemember, the more space treasure you collect, the bigger your prize will be!\n\nGood luck!';
            DrawFormattedText(pms.wid,message,'center','center', [], wrapat, [], [], 1.5);
    end
end



