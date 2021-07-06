function loadTextures

global pms;

%% rockets

rocketFileNames = {'rocket_1.png';
    'rocket_2.png';
    'rocket_3.png';
    'rocket_4.png'};

pms.rocketFileNames = rocketFileNames(pms.rocketOrder);

for r = 1:4
    [image, ~, alpha] = imread(['img/',pms.rocketFileNames{r}]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.rocketTextures(r) = Screen('MakeTexture', pms.wid, image);
end

%% space traveller % added CS

pms.traveller = 'astronaut.png';
[image,~,alpha] = imread(['img/',pms.traveller]);
image(:,:,4) = alpha(:,:); % transparency?
pms.travellerTexture = Screen('MakeTexture', pms.wid, image);

%% arrow texture

pms.arrow = 'arrow.png';
[image,~,alpha] = imread(['img/',pms.arrow]);
image(:,:,4) = alpha(:,:); % transparency?
pms.arrowTexture = Screen('MakeTexture', pms.wid, image);

%% boost ray % added CS , STAKE CUE REPLACEMENT
% We went from (1x) to (5x) visualised stakes, to the boostray, to now gold
% and blue treasure.

% Gold treasure, with red 5 (x5 stakes condition)

pms.GoldTreasure = 'treasuregold4nr5.png';
[image,~,alpha] = imread(['img/',pms.GoldTreasure]);
image(:,:,4) = alpha(:,:);
pms.GoldTreasureTexture = Screen('MakeTexture', pms.wid, image);

% Blue treasure, with red 1 (x1 stakes condition)

pms.BlueTreasure = 'treasureblue3.png';
[image,~,alpha] = imread(['img/',pms.BlueTreasure]);
image(:,:,4) = alpha(:,:);
pms.BlueTreasureTexture = Screen('MakeTexture', pms.wid, image);

%% Boostray in again

pms.Boostray = 'boostray.png';
[image,~,alpha] = imread(['img/',pms.Boostray]);
image(:,:,4) = alpha(:,:);
pms.BoostrayTexture = Screen('MakeTexture', pms.wid, image);

% pms.BoostrayOn = 'boostrayOn2.png';
% [image,~,alpha] = imread(['img/',pms.BoostrayOn]);
% image(:,:,4) = alpha(:,:);
% pms.BoostrayOnTexture = Screen('MakeTexture', pms.wid, image);

pms.BoostrayOn = 'boostrayactive3.png';
[image,~,alpha] = imread(['img/',pms.BoostrayOn]);
image(:,:,4) = alpha(:,:);
pms.BoostrayOnTexture = Screen('MakeTexture', pms.wid, image);

pms.BoostrayOff = 'boostrayInactive3.png';
[image,~,alpha] = imread(['img/',pms.BoostrayOff]);
image(:,:,4) = alpha(:,:);
pms.BoostrayOffTexture = Screen('MakeTexture', pms.wid, image);

%% gift texture

pms.gift = 'gift.png';
[image,~,alpha] = imread(['img/',pms.gift]);
image(:,:,4) = alpha(:,:);
pms.giftTexture = Screen('MakeTexture', pms.wid, image);

% equals sign

pms.equals = 'equals.png';
[image,~,alpha] = imread(['img/',pms.equals]);
image(:,:,4) = alpha(:,:);
pms.equalsTexture = Screen('MakeTexture', pms.wid, image);

%% space cave % added CS, two colours

pms.cave1 = 'cave1.png';
[image,~,alpha] = imread(['img/',pms.cave1]);
image(:,:,4) = alpha(:,:);
pms.caveTexture1 = Screen('MakeTexture', pms.wid, image);

pms.cave2 = 'cave2.png';
[image,~,alpha] = imread(['img/',pms.cave2]);
image(:,:,4) = alpha(:,:);
pms.caveTexture2 = Screen('MakeTexture', pms.wid, image);

%% sleepy alien texture

pms.sleepyalien = 'sleepy.png';
[image,~,alpha] = imread(['img/',pms.sleepyalien]);
image(:,:,4) = alpha(:,:);
pms.sleepyAlienTexture = Screen('MakeTexture', pms.wid, image);


%% stake cue

% now we have the two colours of treasure here

% pms.exampleStakes = 'exampleStakesTreasure.png';
% [image,~,alpha] = imread(['img/',pms.exampleStakes]);
% image(:,:,4) = alpha(:,:); % transparency
% pms.exampleStakesTexture = Screen('MakeTexture', pms.wid, image);

pms.exampleStakes = 'stakesexample3.png';
[image,~,alpha] = imread(['img/',pms.exampleStakes]);
image(:,:,4) = alpha(:,:); % transparency
pms.exampleStakesTexture = Screen('MakeTexture', pms.wid, image);

% pms.stakeCueName = 'stakeCue.png';
% 
% [image,~,alpha] = imread(['img/',pms.stakeCueName]);
% image(:,:,4) = alpha(:,:); % transparency
% pms.stakeCueTexture = Screen('MakeTexture', pms.wid, image);

% guns version % example_stakes3.png is the transparent one
%     [image,~,alpha] = imread('img/example_stakes3.png');
%     image(:,:,4) = alpha(:,:); % transparency
%     pms.exampleStakesTexture = Screen('MakeTexture',pms.wid, image);


%% planets

pms.planetFileNames = {'earth_planet.png';
    'red_planet.png';
    'purple_planet.png'};

for p = 1:3
    image = imread(['img/',pms.planetFileNames{p}]);
    pms.planetTextures(p) = Screen('MakeTexture', pms.wid, image);
end

% small planets

pms.example_planetsSmall = 'example_planetsSmall.png';

[image,~,alpha] = imread(['img/',pms.example_planetsSmall]);
image(:,:,4) = alpha(:,:); % transparency
pms.examplePlanetsSmallTexture = Screen('MakeTexture',pms.wid, image);

%% rects

pms.rectFileNames = {'earth_rect.png';
    'red_rect.png';
    'purple_rect.png'};

for p = 1:3
    [image,~,alpha] = imread(['img/',pms.rectFileNames{p}]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.rectTextures(p) = Screen('MakeTexture', pms.wid, image);
end

%% red aliens

index = pms.redOrder;

name_part = 'red_alien_';
% emotion_parts = {'','_happy','_sad'};

for p = 1:2
    fileName = [name_part,num2str(index(p)),'.png'];
    [image, ~, alpha] = imread(['img/',fileName]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.alienFileNames{p,1} = fileName;
    pms.alienTextures(p,1) = Screen('MakeTexture', pms.wid, image);
end

%% purple aliens

index = pms.purpleOrder;

name_part = 'purple_alien_';
% emotion_parts = {'','_happy','_sad'};

for p = 1:2
    fileName = [name_part,num2str(index(p)),'.png'];
    [image, ~, alpha] = imread(['img/',fileName]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.alienFileNames{p,2} = fileName;
    pms.alienTextures(p,2) = Screen('MakeTexture', pms.wid, image);
end

%% points

[image,~,alpha] = imread('img/treasure.png');
image(:,:,4) = alpha(:,:); % transparency
pms.treasureTexture = Screen('MakeTexture',pms.wid, image);



% [image,~,alpha] = imread('img/antimatter.png');
% image(:,:,4) = alpha(:,:); % transparency
% pms.antimatterTexture = Screen('MakeTexture',pms.wid, image);

[image,~,alpha] = imread('img/noreward.png');
image(:,:,4) = alpha(:,:); % transparency
pms.norewardTexture = Screen('MakeTexture',pms.wid, image);

% if pms.practice==1
    
    [image,~,alpha] = imread('img/example_planets.png');
    image(:,:,4) = alpha(:,:); % transparency
    pms.examplePlanetsTexture = Screen('MakeTexture',pms.wid, image);
    
    [image,~,alpha] = imread('img/example_lotsoftreasure.png');
    image(:,:,4) = alpha(:,:); % transparency
    pms.exampleLotsOfTreasureTexture = Screen('MakeTexture',pms.wid, image);
    
    [image,~,alpha] = imread('img/example_littletreasure.png');
    image(:,:,4) = alpha(:,:); % transparency
    pms.exampleLittleTreasureTexture = Screen('MakeTexture',pms.wid, image);
    
%     [image,~,alpha] = imread('img/example_stakes.png'); % commented out
%     to replace with guns, temporarily, CS
%     image(:,:,4) = alpha(:,:); % transparency
%     pms.exampleStakesTexture = Screen('MakeTexture',pms.wid, image);
    
%     [image,~,alpha] = imread('img/example_5x.png');
%     image(:,:,4) = alpha(:,:); % transparency
%     pms.example5xTexture = Screen('MakeTexture',pms.wid, image);
%     
%     % added
%     [image,~,alpha] = imread('img/example_1x.png');
%     image(:,:,4) = alpha(:,:); % transparency
%     pms.example1xTexture = Screen('MakeTexture',pms.wid, image);
% end

end

