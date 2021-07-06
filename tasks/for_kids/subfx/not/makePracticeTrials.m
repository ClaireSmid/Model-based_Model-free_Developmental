function makePracticeTrials

global pms
global data

a = fullfact([length(data.pracShapes) pms.practiceRepetitions]); % 4 triplets, 2 streams, 4 foils, 2 repetitions
a= a(randperm(length(a)),:);
data.prac.trialList = data.pracShapes(a(:,1));
data.prac.congruence = rand(length(data.prac.trialList),1)<0.5;
data.prac.correctResponse = data.buttonMapping(pms.assym(data.prac.trialList)+1); % 1 == assym, 2 == sym
data.prac.assym = pms.assym(data.prac.trialList)';
data.prac.position = data.prac.correctResponse;
data.prac.position(data.prac.congruence==0) = mod(data.prac.position(data.prac.congruence==0),2)+1;

end