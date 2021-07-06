function loadShapes
%LOADFACES loads shapes in dir .../shapes/ in variable "stimuli"

global pms;

shapesdir='shapes';

%% load shapes
files1 = dir([shapesdir,'/assym*.png']);
files2 = dir([shapesdir,'/sym*.png']);

index = 0;

for i = 1:length(files1)
    index = index+1;
    [image, ~, alpha] = imread([shapesdir,'/',files1(i).name]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.shape{index} = image; % this is the image
    pms.assym(index) = 1;
    pms.texture(index) = Screen('MakeTexture', pms.wid, image);
end

for i = 1:length(files2)
    index = index+1;
    [image, ~, alpha] = imread([shapesdir,'/',files2(i).name]);
    image(:,:,4) = alpha(:,:); % transparency
    pms.shape{index} = image; % this is the image
    pms.assym(index) = 0;
    pms.texture(index) = Screen('MakeTexture', pms.wid, image);
end

end

