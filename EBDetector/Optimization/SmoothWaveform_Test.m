function [errorProb] = SmoothWaveform_Test(...
    structReduct, grpSource, indexTraining, indexTesting, knnInt)

singleSetPrime = structReduct(1).singleSet;

%% ===================================
% convert DF to distances to "group matrix"
fltPatternArray = zeros(length(structReduct), length(singleSetPrime));
for indxn = 1:1:length(structReduct)
    singleSet = structReduct(indxn).singleSet;
    fltPatternArray(indxn, :) = singleSet;
end

% Split
fltPatternArray_Training = fltPatternArray(indexTraining,:);
grpSource_Training = grpSource(indexTraining);

fltPatternArray_Testing = fltPatternArray(indexTesting,:);
grpSource_Testing = grpSource(indexTesting);


% Estimate classification error using k-NN
metricM = eye(length(singleSetPrime));

[~, ~, errorProb] = Naive_K_Nearest(...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_Testing, grpSource_Testing, ...
    knnInt, metricM, "Missed");


end
