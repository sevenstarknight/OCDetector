clc 
clear

% https://www.mathworks.com/help/matlab/ref/matlab.io.fits.openfile.html

folderPathNONSOI = strcat('/Users/kjohnston/Desktop/AstroData/Raw Kepler Data/NONSOI');

folderPathSOI = strcat('/Users/kjohnston/Desktop/AstroData/Raw Kepler Data/SOI');

[structReductNONSOI] = ReadInTSV(folderPathNONSOI);
[structReductSOI] = ReadInTSV(folderPathSOI);

folderPath = strcat('/Users/kjohnston/Desktop/AstroCode/EBDetector');
cd(folderPath);

[structReductNONSOI] = ConstructNonVariableStars(50, structReductNONSOI);

%% ===============================================================

[structReductNONSOI] = makeSmoothedData(structReductNONSOI);
[structReductSOI] = makeSmoothedData(structReductSOI);

%% ===============================================================
% Generate Combined Dataset 
structReduct = structReductSOI;
grpSource = cell(1,length(structReductSOI)+ length(structReductNONSOI));

counter = 1;
for idx = 1:1:length(structReductSOI)
    grpSource{counter} = 'SOI';
    counter = counter + 1;
end

for idx = 1:1:length(structReductNONSOI)
    structReduct(counter) = structReductNONSOI(idx);
    grpSource{counter} = 'NON-SOI';
    counter = counter + 1;
end

[structPatternArray_TrainingCV, indexTraining, indexTesting] = ...
    Generate_5FoldCrossVal(grpSource);

%% ===========================================
% Run Cross-validation Optim
structError = [];
linSet = linspace(1,9,5);
for idx = 1:1:length(linSet)
    [errorArray] = DF_Optimization(...
        structReduct, grpSource, structPatternArray_TrainingCV, linSet(idx));
    structError(idx).errorArray = errorArray;
end

errorSetKNN = [];
for idx = 1:1:length(linSet)
    tic
    errorSetKNN(idx) = SmoothWaveform_Optimization(...
        structReduct, grpSource, structPatternArray_TrainingCV, linSet(idx));
    toc
end

%% ===========================================
% Initialize Gaussian Convolution & DF Options Based on Optim
kerSize = 7;            % Size of Gaussian kernel
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel
kNeigh = 3; lambda = 0.75;
kernel = gaussian2D([kerSize 1], sigmaOfKer);

optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer,...
    'direction', 'both', 'numXBins', 25, 'numYBins', 35, 'kernel', kernel, ...
    'kNeigh', kNeigh, 'lambda', lambda);

for idx = 1:1:length(structReduct)
    
    %% ===========================================
    % Generate the Convolved Distribution Field
    [structReduct(idx).DF, structReduct(idx).DFBinCounts, ~] = ...
        findDF(...
        structReduct(idx).foldedData,...
        structReduct(idx).alignedData, optionsDF);
    
end


[fltResponse, classEstimate, errorProb, grpSource_Testing, fltListOfNeighbors, maxDistance] = ...
    DF_Testing(indexTraining, indexTesting, ...
    structReduct, grpSource, optionsDF);

[errorSetKNN] = SmoothWaveform_Test(...
        structReduct, grpSource, indexTraining, indexTesting, 3);

[structPerformance] = generateDetectorPerformance('SOI', ...
    classEstimate, grpSource_Testing);


for idx = 1:1:length(structReduct)

    [structReduct(idx).deltaM, structReduct(idx).OER, ...
        structReduct(idx).LCA, structReduct(idx).deltaMin] = EstimateMetricsOfInterest(...
        structReduct(idx).alignedData);
end