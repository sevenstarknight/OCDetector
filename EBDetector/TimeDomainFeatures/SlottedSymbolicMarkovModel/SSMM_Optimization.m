function [errorArray] = SSMM_Optimization(...
    structMCReduct, grpSource, structPatternArray_TrainingCV)

kerArray = 0.01:0.01:0.07;
resArray = 0.05:0.02:0.15;
resArray = fliplr(resArray);

errorArray = zeros(length(resArray)*length(kerArray),4);
uniqueSources = unique(grpSource);
counter = 1;
%% ======================================================
% Cycle over resolutions, determine optimal resolution
for indexi = 1:1:length(resArray)
    
    for indexj = 1:1:length(kerArray)
    
        tic
        
        stateResolution = resArray(indexi);
        states = -2:stateResolution:2;
        optionsMC = struct('kernelSpread', kerArray(indexj), 'states', states);

        %% ======================================================
        % construct state space on the training set, for given resolution.
        for indxk = 1:1:length(structMCReduct)
            [markovChain, stateTransitionMatrix, meanAmplitude, stdAmplitude] = ...
                findSSMM(...
                structMCReduct(indxk).timeSeries(:,1), ...
                structMCReduct(indxk).timeSeries(:,2), optionsMC);

            structMCReduct(indxk).MC = markovChain;
            structMCReduct(indxk).timeDomain = [meanAmplitude, stdAmplitude];

            structMCReduct(indxk).stateTransitionMatrix = stateTransitionMatrix;
        end

        %% ======================================================
        % CV and Error Estimates
        errorProbMean = 0;

        for indxk = 1:1:length(structPatternArray_TrainingCV)

            %% ===================================
            % Approximate error based on distance estimation
            stMatrixGroup = zeros(length(states),length(states), length(uniqueSources));
            
            for indxm = 1:1:length(structPatternArray_TrainingCV)
                % Is Training
                if(indxm ~= indxk)
                    cvSet = structPatternArray_TrainingCV(indxm).indexSet;
                    for indxn = cvSet
                        stm = structMCReduct(indxn).stateTransitionMatrix;
                        % stack state transition matrix
                        jdx = strcmp(grpSource(indxn), uniqueSources);
                        stMatrixGroup(:,:,jdx) = stMatrixGroup(:,:,jdx) + stm;
                    end
                end
            end
            
            %% ===================================
            markovChainGroup = zeros(length(states), length(states), length(uniqueSources));
            for indxm = 1:1:length(uniqueSources)
                totalInState = sum(stMatrixGroup(:,:,indxm), 2);
                markovChain = zeros(length(states), length(states));
                for indxn = 1:1:length(totalInState)
                    if(totalInState(indxn) ~= 0.0)
                        markovChain(indxn,:) = (stMatrixGroup(indxn,:,indxm)./totalInState(indxn));
                    end
                end
                markovChainGroup(:,:,indxm) = markovChain;
            end
            
            %% ===================================
            % convert MC to distances to "group matrix"
            mcMatrix = zeros(length(states), length(states),...
                length(structMCReduct));
            fltPatternArray = zeros(length(structMCReduct), length(markovChainGroup(1,1,:)));
            for indxm = 1:1:length(structMCReduct)
                mcMatrix(:,:,indxn) = structMCReduct(indxn).MC;
                for indxn = 1:1:length(markovChainGroup(1,1,:))
                    delta = structMCReduct(indxm).MC - markovChainGroup(:,:,indxn);
                    fltPatternArray(indxm, indxn) = norm(delta,'fro');
                end
            end
            
            % Generate Training and Crossval Data
            [fltPatternArray_Training, grpSource_Training, ...
                fltPatternArray_CrossVal, grpSource_CrossVal] = ...
                PullTrainingAndCrossFromStruct(fltPatternArray, grpSource, ...
                structPatternArray_TrainingCV, indxk);

            % Estimate classification error using QDA
%             [errorProb, ~, ~] = LDA_QDA_Classifier(...
%                 fltPatternArray_Training, grpSource_Training', ...
%                 fltPatternArray_CrossVal, grpSource_CrossVal', 4);
            
            [~, ~, errorProb] = Naive_K_Nearest(...
                fltPatternArray_Training, grpSource_Training', ...
                fltPatternArray_CrossVal, grpSource_CrossVal,...
                1, eye(length(fltPatternArray_Training(1,:))),  'Missed');

            errorProbMean = errorProbMean + errorProb/5;

%             %% ===================================
%             % Train kNN-Metric Based on DF Directly
%             [fltPatternArray_Training, grpSource_Training, ...
%                 fltPatternArray_CrossVal, grpSource_CrossVal] = ...
%                 PullTrainingAndCrossMatrixFromStruct(mcMatrix, ...
%                 grpSource, structPatternArray_TrainingCV, indxk);
% 
%             % Optimize Matrix Based on Push/Pull Method
%             [M, ~, ~] = pushPullMethod(fltPatternArray_Training,...
%                 grpSource_Training, 1.0, 0.5);
% 
%             options = struct('kValue', 1, 'M', M);
% 
%             % Estimate classification error using k-NN
%             [~, accuracy] = DF_KNN (...
%                 fltPatternArray_Training, grpSource_Training,...
%                 fltPatternArray_CrossVal, grpSource_CrossVal, options);
% 
%             errorProbMeanMetric = errorProbMeanMetric + (1-accuracy)/5;

        end

        toc
        
        disp(resArray(indexi))
        disp(kerArray(indexj))
        
        errorArray(counter,1) = resArray(indexi);
        errorArray(counter,2) = kerArray(indexj);
        errorArray(counter,3) = errorProbMean;
%         errorArray(counter,4) = errorProbMeanMetric;
        
        counter = counter + 1;
    end
end


end

