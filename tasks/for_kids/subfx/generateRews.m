function generateRews

global pms
global data

%% real

% data.rews = 5*ones(pms.nrTrials,2);

data.rews = zeros(pms.nrTrials,2);

middle = mean(pms.bounds);

if rand < 0.5
    data.rews(1,1) = round(unifrnd(middle, pms.bounds(2),1));
    data.rews(1,2) = round(unifrnd(pms.bounds(1), middle,1));
else
    data.rews(1,2) = round(unifrnd(middle, pms.bounds(2),1));
    data.rews(1,1) = round(unifrnd(pms.bounds(1), middle,1));
end

for t = 2:pms.nrTrials
    for s = 1:2
        d = round(normrnd(0,pms.sd));
        data.rews(t,s) = data.rews(t-1,s)+d;
        data.rews(t,s) = min(data.rews(t,s),max(pms.bounds(2)*2 - data.rews(t,s), pms.bounds(1)));
        data.rews(t,s) = max(data.rews(t,s),min(pms.bounds(1)*2 - data.rews(t,s), pms.bounds(2)));
    end
end

%% practice

% data.practice.rews = -4*ones(pms.nrPracticeTrials,2);

data.practice.rews = zeros(pms.nrPracticeTrials,2);

data.practice.rews(1,1) = round(unifrnd(middle, pms.bounds(2),1));
data.practice.rews(1,2) = round(unifrnd(pms.bounds(1), middle,1));

for t = 2:pms.nrPracticeTrials
    for s = 1:2
        d = round(normrnd(0,pms.sd));
        data.practice.rews(t,s) = data.practice.rews(t-1,s)+d;
        data.practice.rews(t,s) = min(data.practice.rews(t,s),max(pms.bounds(2)*2 - data.practice.rews(t,s), pms.bounds(1)));
        data.practice.rews(t,s) = max(data.practice.rews(t,s),min(pms.bounds(1)*2 - data.practice.rews(t,s), pms.bounds(2)));
    end
end

end

