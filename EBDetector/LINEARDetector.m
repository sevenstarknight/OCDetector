

for i = 1:1:length(structMCReduct)
    a = split(structMCReduct(i).ID,'.');
    structMCReduct(i).name = a{1};
end

[structMCReduct] = FoldingLogic(structMCReduct);

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
for idx = 1:1:length(structMCReduct)
    
    %% ===========================================
    % Generate the Convolved Distribution Field
    [structMCReduct(idx).DF, ...
        structMCReduct(idx).DFBinCounts,...
        structMCReduct(idx).data] = ...
        findDF(...
        structMCReduct(idx).foldedData,...
        structMCReduct(idx).alignedData, optionsDF);
    
end

%% ===========================================
dfMatrixTesting = zeros(optionsDF.numXBins, optionsDF.numYBins, length(structMCReduct));

for idxk = 1:1:length(structMCReduct)
    dfMatrixTesting(:,:,idxk) = structMCReduct(idxk).DF;
end

% Testing
fltPatternArray_Testing = dfMatrixTesting;



%% ===========================================

[fltResponse, classEstimate, fltListOfNeighbors] = DF_KNN_Implement (...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_Testing, options, maxDistance*0.6);

structReductOfInterestLINEAR = [];
counter = 1;
for idx = 1:1:length(classEstimate)
    
    if(strcmp(classEstimate{idx}, 'SOI'))

        if(isempty(structReductOfInterestLINEAR))
           structReductOfInterestLINEAR = structMCReduct(idx); 
        else
            structReductOfInterestLINEAR(counter) = structMCReduct(idx);
        end
        counter = counter + 1;
       
    end
    
end

for idx = 1:1:length(structReductOfInterestLINEAR)

    [structReductOfInterestLINEAR(idx).deltaM, structReductOfInterestLINEAR(idx).OER, ...
        structReductOfInterestLINEAR(idx).LCA, structReductOfInterestLINEAR(idx).deltaMin ] = EstimateMetricsOfInterest(...
        structReductOfInterestLINEAR(idx).alignedData);
end
