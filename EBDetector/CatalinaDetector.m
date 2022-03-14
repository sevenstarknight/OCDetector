

counter = 1;
for i = 1:1:length(structMCReduct)
    structMCReduct(i).name = string(structMCReduct(i).ID);
    structMCReduct(i).tmpParams = structMCReduct(i).parameters;  
    
end
structMCReductTmp = struct();
for i = 1:1:length(structMCReduct)
    pt = structMCReduct(i).tmpParams;
    
    parameters = [pt.Amplitude, ...
        pt.Number_Obs, pt.RA_J2000, pt.V_mag, log10(pt.Period_days)];
    
    if(length(parameters) == 5 && ~isnan(pt.Period_days) && ~isinf(pt.Period_days) && pt.Number_Obs > 100)
        structMCReductTmp(counter).ID = structMCReduct(i).ID;
        structMCReductTmp(counter).parameters = parameters;
        structMCReductTmp(counter).class = structMCReduct(i).class;
        structMCReductTmp(counter).timeSeries = structMCReduct(i).timeSeries;
        structMCReductTmp(counter).name = structMCReduct(i).name;
        grpSourceTmp(counter) = grpSource(i);
        counter = counter + 1;
    end
        
end

structMCReduct = structMCReductTmp;
grpSource = grpSourceTmp;
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
    fltPatternArray_Testing, options, maxDistance*0.5);

structReductOfInterestCatalina = [];
counter = 1;
for idx = 1:1:length(classEstimate)
    
    if(strcmp(classEstimate{idx}, 'SOI'))

        if(isempty(structReductOfInterestCatalina))
           structReductOfInterestCatalina = structMCReduct(idx); 
        else
            structReductOfInterestCatalina(counter) = structMCReduct(idx);
        end
        counter = counter + 1;
       
    end
    
end

for idx = 1:1:length(structReductOfInterestCatalina)

    [structReductOfInterestCatalina(idx).deltaM, structReductOfInterestCatalina(idx).OER, ...
        structReductOfInterestCatalina(idx).LCA, structReductOfInterestCatalina(idx).deltaMin ] = EstimateMetricsOfInterest(...
        structReductOfInterestCatalina(idx).alignedData);
end



