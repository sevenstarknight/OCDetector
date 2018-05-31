function [errorArray] = DF_Optimization(...
    structReduct, grpSource, structPatternArray_TrainingCV, kNNValue)

xBins = 20:5:40;
yBins = 20:5:40;

%% ======================================================
% Convolution Parameters
kerSize = 7;            % Size of Gaussian kernel
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel
kernel = gaussian2D([kerSize 1], sigmaOfKer);
%% ======================================================
errorArray = zeros(length(xBins)*length(yBins),5);

%% ======================================================
% Cycle over resolutions, determine optimal resolution
counter = 1;
for indexi = 1:1:length(xBins)
    tic
    
    for indexj = 1:1:length(yBins)

        %% ======================================================
        optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer, 'direction', 'both', ...
            'numXBins', xBins(indexi), 'numYBins', yBins(indexj), 'kernel', kernel);

        %% ======================================================
        % construct state space on the training set, for given resolution.
        dfAll = zeros(optionsDF.numXBins, optionsDF.numYBins, length(structReduct));
        for indxk = 1:1:length(structReduct)
            
            [convDF, binCounts] = findDF(...
                structReduct(indxk).foldedData,...
                structReduct(indxk).alignedData, optionsDF);

            structReduct(indxk).DF = convDF;
            structReduct(indxk).binCounts = binCounts;
            
            dfAll(:,:,indxk) = convDF;
           
        end

        [structPsi] = K_Means_Matrix(dfAll, 6);
        
        
        %% ======================================================
        % turn counts matrix into DF
        dfGroup = zeros(optionsDF.numXBins,optionsDF.numYBins, length(structPsi));

        for indxn = 1:1:length(structPsi)
            totalInState = sum(structPsi(indxn).mean, 2);
            df = zeros(optionsDF.numXBins,optionsDF.numYBins);
            for indxm = 1:1:length(totalInState)
                if(totalInState(indxm) ~= 0.0)
                    df(indxm,:) = (structPsi(indxn).mean(indxm,:)./totalInState(indxm));
                end
            end
            dfGroup(:,:,indxn) = df;
        end

        %% ===================================
        % convert DF to distances to "group matrix"
        dfMatrix = zeros(optionsDF.numXBins, optionsDF.numYBins,...
            length(structReduct));
        fltPatternArray = zeros(length(structReduct), length(dfGroup(1,1,:)));
        for indxn = 1:1:length(structReduct)
            dfMatrix(:,:,indxn) = structReduct(indxn).DF;
            for indxm = 1:1:length(dfGroup(1,1,:))
                delta = structReduct(indxn).DF - dfGroup(:,:,indxm);
                fltPatternArray(indxn, indxm) = norm(delta,'fro');
            end
        end

        
        %% ======================================================
        % CV and Error Estimates
        errorProbMeanQDA = 0;
        errorProbMeanMetric = 0;
        errorProbMeanKNN = 0;

        for indxk = 1:1:length(structPatternArray_TrainingCV)

            
%             gplotmatrix(fltPatternArray(:,2:4), fltPatternArray(:,2:4), grpSource',...
%                 'br','.o',[],'on','');
            
            %% ===================================
            % Train QDA Based On Distances to Mean DF
            [fltPatternArray_Training, grpSource_Training, ...
                fltPatternArray_CrossVal, grpSource_CrossVal] = ...
                PullTrainingAndCrossFromStruct(fltPatternArray, grpSource, ...
                structPatternArray_TrainingCV, indxk);

            % Estimate classification error using QDA
            [errorProb, ~, ~] = LDA_QDA_Classifier(...
                fltPatternArray_Training, grpSource_Training', ...
                fltPatternArray_CrossVal, grpSource_CrossVal', 4);

            errorProbMeanQDA = errorProbMeanQDA + errorProb/5;
            
            [~, ~, errorProb] = Naive_K_Nearest(...
                fltPatternArray_Training, grpSource_Training, ...
                fltPatternArray_CrossVal, grpSource_CrossVal, ...
                kNNValue, eye(length(structPsi)), "Missed");

            errorProbMeanKNN = errorProbMeanKNN + errorProb/5;

            %% ===================================
            % Train kNN-Metric Based on DF Directly
            [fltPatternArray_Training, grpSource_Training, ...
                fltPatternArray_CrossVal, grpSource_CrossVal, ~, ~] = ...
                PullTrainingAndCrossMatrixFromStruct(dfMatrix, ...
                grpSource, structPatternArray_TrainingCV, indxk);

            % Optimize Matrix Based on Push/Pull Method
            [M] = pushPullMethod(fltPatternArray_Training,...
                grpSource_Training, 1.0, 0.5);

            options = struct('kValue', kNNValue, 'M', M);

            % Estimate classification error using k-NN
            [~, ~,  errorProb, ~] = DF_KNN (...
                fltPatternArray_Training, grpSource_Training,...
                fltPatternArray_CrossVal, grpSource_CrossVal, options);

            errorProbMeanMetric = errorProbMeanMetric + errorProb/5;  
            
        end
      
        errorArray(counter,1) = xBins(indexi);
        errorArray(counter,2) = yBins(indexj);
        errorArray(counter,3) = errorProbMeanQDA;
        errorArray(counter,4) = errorProbMeanMetric;
        errorArray(counter,5) = errorProbMeanKNN;

        counter = counter + 1;
    end
    toc
end

end

