function [AA, RR, RWR, MSS] = Real_Rews(Trials,Trews,Missed,Points)

AA = zeros(Trials,1);
RR = zeros(Trials,1);
%PP(t,:) = p;
MSS = zeros(Trials,1);
RWR = zeros(Trials,1);

for t = 1:Trials
    
    if sum(Missed(t,:)) >= 1
        Miss = 1;
        r = 0;
        a = 0;
        rwr = 0;
        %rwr = mean(rrews(t,:));
    else
        Miss = 0;
    
        % random choice probability
        p = rand(1,2);

        % pick maximum probability
        if p(1) < 0.5
            a = 1;
        else
            a = 2;
        end

        % match action with true rewards
        r = Points(t);
        rwr = mean(Trews(t,:));
    
    end
    
    % save all actions and rewards for each sim
    AA(t,:) = a;
    RR(t,:) = r;
    %PP(t,:) = p;
    MSS(t,:) = Miss;
    RWR(t,:) = rwr;
    

end
