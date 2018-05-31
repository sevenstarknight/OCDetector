function [fltResponse, classEstimate, fltListOfNeighbors] = DF_KNN_Implement (...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_Testing, options, maxDistance)
           
strMissValue = 'Missed';

kValue = options.kValue;
metric = options.M;

grpUniqueTypes = unique(grpSource_Training);
intNumberOfUnique = length(grpUniqueTypes);

intNumberOfTrainingPatterns = length(grpSource_Training);
intNumberOfTestPatterns = length(fltPatternArray_Testing);

classEstimate = cell(1,intNumberOfTestPatterns);

fltResponse = zeros(intNumberOfTestPatterns, intNumberOfUnique);
fltListOfNeighbors = zeros(intNumberOfTestPatterns, kValue);

%% ===================================================================

for indxi = 1 : intNumberOfTestPatterns
    tempDist = zeros(1,intNumberOfTrainingPatterns);
    temp1 = fltPatternArray_Testing(:,:,indxi);
    parfor indxm = 1 : intNumberOfTrainingPatterns
        temp = temp1 - fltPatternArray_Training(:,:,indxm);
        tempDist(1,indxm) = sqrt(sum(diag(temp'*metric*temp)));
    end

    [distanceSort, index] = sort(tempDist);
    if(distanceSort(1) < maxDistance)
        nearestNeighbors = grpSource_Training(index(1:kValue));
    else
        tmpList = grpSource_Training(index(1:kValue));
        nearestNeighbors = strMissValue;
    end

    fltListOfNeighbors(indxi, :) = index(1:kValue);
    
    %Weighted scheme of associated based on distance
    for indxj = 1:1:kValue
        for indxk = 1:1:intNumberOfUnique
            if(strcmp(grpUniqueTypes(indxk),nearestNeighbors(indxj)))
                fltResponse(indxi,indxk) = fltResponse(indxi,indxk) + 1;
                break;
            end
        end
    end

    % Compute posterior probabilities
    fltResponse(indxi,:) = fltResponse(indxi,:)./sum(fltResponse(indxi,:));

end

% Label the datasets basedon posterior probabilities
for indxi = 1:1:intNumberOfTestPatterns

    fltMaxProb = max(fltResponse(indxi,:));
    intSingle = sum(fltResponse(indxi,:) == fltMaxProb);
    index = fltMaxProb == fltResponse(indxi,:);

    if(intSingle ~= 1)
        classEstimate{indxi} = strMissValue;
    else
        classEstimate{indxi} = grpUniqueTypes{index};
    end
end


end
