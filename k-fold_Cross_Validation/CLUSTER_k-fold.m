%% 4-fold cross validation script
% this script runs the k-fold cross validation as proposed by Tobias


% for adults
load('adltgroupdata.mat')
% for children
% load('kidgroupdata.mat')

%% Step 1. Split participant data up in blocks
% subs = length(kidgroupdata.subdata(:));
subs = length(adltgroupdata.subdata(:));

% % Tobias's comment 17/09/2020:
% So my idea of the 3-fold cross-validation is as follows:
% 
% 1. Split the subject into 4, each with 3 'train' blocks and 1 'test' block
% 101.trials ->
% 
% 101a.train = [block 1 2 3]
% 101a.test = [block 4]
% 
% 101b.train = [block 1 2 4]
% 101b.test = [block 3]
% 
% 101c.train = [block 1 3 4]
% 101c.test = [block 2]
% 
% 101d.train = [block 2 3 4]
% 101d.test = [block 1]

% these are the train and test blocks. the first 3 are train blocks, the
% last 4 is the test block.
% so for fold 1, blocks 1, 2 and 3 are training, block 4 is testing.
fold(1,:) = [1 2 3 4];
fold(2,:) = [1 2 4 3];
fold(3,:) = [1 3 4 2];
fold(4,:) = [2 3 4 1];

% subset these for each participant
for i = 1:subs
    
    fprintf('Now doing cross validation for participant %d\n', i)
    
%     testdata = kidgroupdata.subdata(i);        % get participant data
    testdata = adltgroupdata.subdata(i);        % get participant data

    trial = (1:length(testdata.rews))';     % get length of total data set, label as trials
    testdata.trial = trial;                 % add trials as a field to struct
    
    N = length(trial);
    
    % if less than 140 trials, create new block sizes for pp
    if N ~= 140
        block_length = floor(N/4);
        block_lengths = block_length*ones(4,1);

        if sum(block_lengths) ~= N
            remaining_trials = N - block_length*4;
            block_lengths(1:remaining_trials) = block_lengths(1:remaining_trials) + 1;
        end
        
        fprintf('trials are less than 140. New blocklengths are:\n%d\n%d\n%d\n%d\n',...
            block_lengths(1),block_lengths(2),block_lengths(3),block_lengths(4));

        for b = 1:4
            if b == 1
                testdata.block((1:block_lengths(b))) = b;
            else
                testdata.block((1:block_lengths(b))+sum(block_lengths(1:(b-1)))) = b;
            end
        end
    end
    
    % for each of the folds, apply the relevant mask and select relevant
    % blocks
    
    for p = 1:length(fold)
            
            

        fprintf('fold number: %d\n',p);
                
        % 3 blocks for training
        mask = (testdata.block == fold(p,1) | testdata.block == fold(p,2) | testdata.block == fold(p,3));
        rews = testdata.rews(mask,:);
        block = testdata.block(mask,:);
        stimuli = testdata.stimuli(mask,:);
        stake = testdata.stake(mask,:);
        points = testdata.points(mask,:);
        s = testdata.s(mask,:);
        choice = testdata.choice(mask,:);
        trial = testdata.trial(mask,:);
        timeout = testdata.timeout(mask,:);  
        rt =  testdata.rt(mask,:);
        
        % combine training set together
        train(i).fold(p) = struct('id',i,'fold',fold(p,1:3),'N',length(trial),'block',block,'rews',rews,'stimuli',stimuli,...
            'stake',stake,'points',points,'s',s,'choice',choice,'trial',trial,'timeout',timeout,'rt',rt); 
        
        % 1 block for testing
        mask = (testdata.block == fold(p,4));
        rews = testdata.rews(mask,:);
        block = testdata.block(mask,:);
        stimuli = testdata.stimuli(mask,:);
        stake = testdata.stake(mask,:);
        points = testdata.points(mask,:);
        s = testdata.s(mask,:);
        choice = testdata.choice(mask,:);
        trial = testdata.trial(mask,:);
        timeout = testdata.timeout(mask,:); 
        rt =  testdata.rt(mask,:);
        
        % had to enter this because some kids only had missed trials in
        % block 4.
        % (could be for a number of reasons, eg testing cut short)
%         if unique(choice) == -1
%             skip_test = 1;
% %         elseif (length(choice) - sum(choice == -1)) < 5 % if less than 5 trials done
% %             skip_test = 1;
%         else
%             skip_test = 0;      
%         end
        
        % combine testing set together
        test(i).fold(p) = struct('id',i,'fold',fold(p,4),'N',length(trial),'block',block,'rews',rews,'stimuli',stimuli,...
            'stake',stake,'points',points,'s',s,'choice',choice,'trial',trial,'timeout',timeout,'rt',rt); 

        %% Step 2. fit models to training data
        % I have hardcoded the trials that are at the start of each block, to
        % reset the Q-values to 0.5

    %     % Tobias's comment 17/09/2020:
    %     2. Fit each of these using your conventional methods (and models). Cave:
    %     reset the Q-values to the starting point for each block (this is the
    %     same trial, so I would just hard code it). You will get the best-fitting
    %     parameters for each 'fold'/'sub-subject'
    % 
    %     101a.params = fit(model(101a.train))
    %     101b.params = fit(model(101b.train))
    %     101c.params = fit(model(101c.train))
    %     101d.params = fit(model(101d.train))
    
        nstarts = 100;               % set random starting locations of optimizer to 25
        data = train(i).fold(p);    % select the testing data for this fold

        % fit 6 parameter model
        params = set_params_P6;
        f = @(x,data) MB_MF_llik_P6(x,data);
        train(i).resultsP6(p) = mfit_optimize(f,params,data,nstarts);
        
        % fit 7 parameter model
        params = set_params_P7;
        f = @(x,data) MB_MF_llik_P7(x,data);
        train(i).resultsP7(p) = mfit_optimize(f,params,data,nstarts);
        
        %% Step 3. Get predictions for left-out (test) data
        % we use the parameters from the models to get the predictions... we
        % use the choice policy (choice probability for each trial) as a metric

    %     % Tobias's comment 17/09/2020:
    %     3. Take these parameters to get the predictions for the left-out data.
    %     Use the policy (choice probability for each trial) as a metric.
    % 
    %     for t = 1:length(101#.test)
    %         if 101#.chosen(t) == A (choice/rocket A)
    %                 p#(t) = softmax(choice A; 101#.test(t))  [the probability of choosing A at that trial]
    %         elseif 101#.chosen(t) == B
    %                 p#(t) = softmax(choice B; 101#.test(t))
    %         end
    %     end
    %
    %     101#.model_accuracy = mean(p#)
    
        % testing 6-parameter model
        trainparams = train(i).resultsP6(p).x;  % getting the parameters from 6P model
        
        % just giving a NaN here in case they only had missed trials in
        % block for testing
%         if skip_test == 1
%             choiceProbs = NaN;
%         else % if all is good, get choice probabilities
        [~,choiceProbs] = MB_MF_llik_P6(trainparams,test(i).fold(p));
%         end

        % save the mean choice probability
        test(i).modelfitP6(p) = mean(choiceProbs,'omitnan');
        test(i).modelfitP6_SD(p) = std(choiceProbs,'omitnan');

        % print choice probability mean in command window
        fprintf('choice probability for 6-param model: %.2f\n',test(i).modelfitP6(p));
        
        % testing 7-parameter model
        trainparams = train(i).resultsP7(p).x; 
        
        % just giving a NaN here in case they only had missed trials in
        % block for testing
%         if skip_test == 1
%             choiceProbs = NaN;
%         else
        [~,choiceProbs] = MB_MF_llik_P7(trainparams,test(i).fold(p));
%         end

        % save the mean choice probability
        test(i).modelfitP7(p) = mean(choiceProbs,'omitnan');
        test(i).modelfitP7_SD(p) = std(choiceProbs,'omitnan');
        
        % print choice probability mean in command window
        fprintf('choice probability for 7-param model: %.2f\n',test(i).modelfitP7(p));
        
    
    end
    
    fprintf('\n\n\n');
    
    % get the mean of both model mean choice probabilities per participant
    % we used omitnan 
    test(i).mean_accuracyP6 = mean([test(i).modelfitP6(1) test(i).modelfitP6(2) ...
                test(i).modelfitP6(3) test(i).modelfitP6(4)]);
            
    test(i).mean_accuracyP7 = mean([test(i).modelfitP7(1) test(i).modelfitP7(2) ...
                test(i).modelfitP7(3) test(i).modelfitP7(4)]);
            
    
    % display which model had the larger mean per participant
    if test(i).mean_accuracyP6 > test(i).mean_accuracyP7
        test(i).winModel = 1;
    else
        test(i).winModel = 2;
    end
    
    if test(i).mean_accuracyP6 > 0.50
        test(i).P6_over50 = 1;
    else
        test(i).P6_over50 = 0;
    end
    
    if test(i).mean_accuracyP7 > 0.50
        test(i).P7_over50 = 1;
    else
        test(i).P7_over50 = 0;
    end
    
end

save('~/Scratch/Kool_2020_2/k_fold_CV_test_kids_2Oct20.mat','test');
save('~/Scratch/Kool_2020_2/k_fold_CV_train_kids_2Oct20.mat','train');
