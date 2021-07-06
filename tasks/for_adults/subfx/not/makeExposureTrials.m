function makeExposureTrials

global pms
global data

for b = 1:pms.nrBlocks
    tripletorder = Shuffle(repmat(1:(pms.nrtriplets/2),1,pms.nrExposureTripletsPerBlock));
    x = data.triplets{data.congruenceOrdering(b)}(tripletorder,:)';
    data.block{b}.trialList = x(:);
    data.block{b}.congruence = rand(length(data.block{b}.trialList),1)<pms.pCongruent(data.congruenceOrdering(b));
    data.block{b}.correctResponse = data.buttonMapping(pms.assym(data.block{b}.trialList)+1); % 1 == assym, 2 == sym
    data.block{b}.assym = pms.assym(data.block{b}.trialList)';
    data.block{b}.position = data.block{b}.correctResponse;
    data.block{b}.position(data.block{b}.congruence==0) = mod(data.block{b}.position(data.block{b}.congruence==0),2)+1;
end

end