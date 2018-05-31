function [errorProbSmoothKNN] = SmoothWaveform_Optimization(...
    structReduct, grpSource, structPatternArray_TrainingCV, knnInt)

singleSetPrime = structReduct(1).singleSet;
errorProbSmoothKNN = 0;

for indxk = 1:1:length(structPatternArray_TrainingCV)

    %% ===================================
    % convert DF to distances to "group matrix"
    fltPatternArray = zeros(length(structReduct), length(singleSetPrime));
    for indxn = 1:1:length(structReduct)
        singleSet = structReduct(indxn).singleSet;
        fltPatternArray(indxn, :) = singleSet;
    end

    %% ===================================
    % Train QDA Based On Distances to Mean DF
    [fltPatternArray_Training, grpSource_Training, ...
        fltPatternArray_CrossVal, grpSource_CrossVal] = ...
        PullTrainingAndCrossFromStruct(fltPatternArray, grpSource, ...
        structPatternArray_TrainingCV, indxk);

    % Estimate classification error using k-NN
    metricM = eye(length(singleSetPrime));
    
    [~, ~, errorProb] = Naive_K_Nearest(...
        fltPatternArray_Training, grpSource_Training, ...
        fltPatternArray_CrossVal, grpSource_CrossVal, ...
        knnInt, metricM, "Missed");


    errorProbSmoothKNN = errorProbSmoothKNN + errorProb/5;

end


end
