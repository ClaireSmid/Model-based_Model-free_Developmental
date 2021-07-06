function [dataFileName,subNum,id]=gatherSubInfo(tag)
% GATHERSUBINFO requests information about subject number and ID code.
% Creates a unique filename for saving the data.  Also returns the entered
% subject number in case this is needed for counterbalancing.
% Input:  TAG is the experiment name to be used in the data file.  (a text
% string)

id=[];
while isempty(id)
    id=input('Subject ID:  ','s');
end
subNum=[];
while isempty(subNum)
    subNum=input('Subject number:  ');
end

if subNum<10, subStr=['s0',num2str(subNum)]; else subStr=['s',num2str(subNum)]; end

dataFileName=[tag,'_',subStr,'_',id,'.mat'];

input(['Data will be saved in ',dataFileName,' (ENTER to continue)']);

end