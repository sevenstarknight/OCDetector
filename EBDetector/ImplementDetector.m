folderPathKnown = strcat('/Users/kjohnston/Google Drive/VarStarData/Raw Kepler Data/');
[structReductUnknown] = ReadInLCDATA(folderPathKnown);

tic
[structReductUnknown] = makeSmoothedData(structReductUnknown);


%% ===========================================
% Initialize Gaussian Convolution & DF Options Based on Optim
kerSize = 7;            % Size of Gaussian kernel
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel
kNeigh = 3; lambda = 0.75;
kernel = gaussian2D([kerSize 1], sigmaOfKer);

optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer,...
    'direction', 'both', 'numXBins', 25, 'numYBins', 35, 'kernel', kernel, ...
    'kNeigh', kNeigh, 'lambda', lambda);

%% =======================================================
for idx = 1:1:length(structReductUnknown)
    
    %% ===========================================
    % Generate the Convolved Distribution Field
    [structReductUnknown(idx).DF, ...
        structReductUnknown(idx).DFBinCounts,...
        ~] = ...
        findDF(...
        structReductUnknown(idx).foldedData,...
        structReductUnknown(idx).alignedData, optionsDF);
    
end

%% ===================================
dfMatrixTraining = zeros(optionsDF.numXBins, optionsDF.numYBins, length(structReduct));

for idxk = 1:1:length(structReduct)
    dfMatrixTraining(:,:,idxk) = structReduct(idxk).DF;
end

% Train on all
fltPatternArray_Training = dfMatrixTraining;
grpSource_Training = grpSource;

%% ===================================
dfMatrixTesting = zeros(optionsDF.numXBins, optionsDF.numYBins, length(structReductUnknown));

for idxk = 1:1:length(structReductUnknown)
    dfMatrixTesting(:,:,idxk) = structReductUnknown(idxk).DF;
end

% Testing
fltPatternArray_Testing = dfMatrixTesting;

%% ===================================
% Optimize Matrix Based on Push/Pull Method
[M] = pushPullMethod(fltPatternArray_Training,...
    grpSource_Training, 1.0, optionsDF.lambda);

options = struct('kValue', optionsDF.kNeigh, 'M', M);

[maxDistance] = estimateMaxDistance(fltPatternArray_Training, ...
    grpSource_Training, options);

%% ======================

[fltResponse, classEstimate, fltListOfNeighbors] = DF_KNN_Implement (...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_Testing, options, maxDistance*0.75);

% toc
% 
% save('/Users/kjohnston/Desktop/AstroData/Raw Kepler Data/classEstimates' ,'classEstimate')

structReductOfInterest= [];
counter = 1;
for idx = 1:1:length(classEstimate)
    
    if(strcmp(classEstimate{idx}, 'SOI'))
        
        isTraining = false;
        for jdx = 1:1:length(structReduct)
            if(strfind(structReductUnknown(idx).label, structReduct(jdx).label))
                isTraining = true;                
            end            
        end
        
        if(~isTraining)
            if(isempty(structReductOfInterest))
               structReductOfInterest = structReductUnknown(idx); 
            else
                structReductOfInterest(counter) = structReductUnknown(idx);
            end
            counter = counter + 1;
        end
    end
    
end



for idx = 1:1:length(structReductOfInterest)

    [structReductOfInterest(idx).deltaM, structReductOfInterest(idx).OER, ...
        structReductOfInterest(idx).LCA, structReductOfInterest(idx).deltaMin] = EstimateMetricsOfInterest(...
        structReductOfInterest(idx).alignedData);
end
