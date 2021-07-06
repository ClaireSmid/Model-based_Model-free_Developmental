function makeTestingTrials

global pms
global data

a = fullfact([pms.nrtriplets/2 2 pms.nrtriplets/2 pms.testingRepetitions]); % 4 triplets, 2 streams, 4 foils, 2 repetitions
a= a(randperm(length(a)),:);
data.test.tripIndex = a(:,1);
data.test.condition = a(:,2);
data.test.foilIndex = a(:,3);

for t = 1:length(data.test.tripIndex)
    data.test.triplet(t,:) = data.triplets{data.test.condition(t)}(data.test.tripIndex(t),:);
    data.test.foil(t,:) = data.foils{data.test.condition(t)}(data.test.foilIndex(t),:);
end

end