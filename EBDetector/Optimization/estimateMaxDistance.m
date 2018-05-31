function [maxDistance] = estimateMaxDistance(fltPatternArray_Training, ...
    grpSource_Training, options)



kValue = options.kValue;
metric = options.M;

intNumberOfTrainingPatterns = length(grpSource_Training);

%% ===================================================================

maxDistance = 0;

for indxi = 1 : intNumberOfTrainingPatterns
    
    if(strcmp(grpSource_Training(indxi), 'NON-SOI'))
        continue;
    end
    
    tempDist = zeros(1,intNumberOfTrainingPatterns - 1);
    temp1 = fltPatternArray_Training(:,:,indxi);
    
    % less the self
    indxSet = 1:1:intNumberOfTrainingPatterns;
    indxSet = indxSet(indxSet ~= indxi);
    
    for indxm = 1:1:length(indxSet)
        temp = temp1 - fltPatternArray_Training(:,:,indxSet(indxm));
        tempDist(1,indxm) = sqrt(sum(diag(temp'*metric*temp)));
    end

    [distanceSort, ~] = sort(tempDist);
    
    if(distanceSort(kValue) > maxDistance)
        maxDistance = distanceSort(kValue);
    end
   
end



end