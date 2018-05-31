function [fltResponse, classEstimate, errorProb, fltListOfNeighbors, maxDistance] = DF_KNN (...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_CrossVal, grpSource_CrossVal, options)
           
strMissValue = 'Missed';

kValue = options.kValue;
metric = options.M;

grpUniqueTypes = unique(grpSource_Training);
intNumberOfUnique = length(grpUniqueTypes);

intNumberOfTrainingPatterns = length(grpSource_Training);
intNumberOfTestPatterns = length(grpSource_CrossVal);

classEstimate = cell(1,intNumberOfTestPatterns);

fltResponse = zeros(intNumberOfTestPatterns, intNumberOfUnique);
fltListOfNeighbors = zeros(intNumberOfTestPatterns, kValue);

%% ===================================================================

maxDistance = 0;

for indxi = 1 : intNumberOfTestPatterns
    tempDist = zeros(1,intNumberOfTrainingPatterns);
    temp1 = fltPatternArray_CrossVal(:,:,indxi);
    parfor indxm = 1 : intNumberOfTrainingPatterns
        temp = temp1 - fltPatternArray_Training(:,:,indxm);
        tempDist(1,indxm) = sqrt(sum(diag(temp'*metric*temp)));
    end

    [distanceSort, index] = sort(tempDist);
    
    
    boolSOI = strcmp(grpSource_Training(index(1)), 'SOI');
    
    if(distanceSort(1) > maxDistance && boolSOI)
        maxDistance = distanceSort(1);
    end
    
    nearestNeighbors = grpSource_Training(index(1:kValue));

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
% 
% plotAnalysis(fltPatternArray_Training, ...
%     fltPatternArray_CrossVal,grpSource_Training, grpSource_CrossVal,...
%     fltListOfNeighbors)

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

count = 0;
for indxk = 1:1:intNumberOfTestPatterns
    if(strcmp(classEstimate{indxk}, grpSource_CrossVal{indxk}))
        count = count + 1;
    end
end

errorProb = (length(classEstimate) - count)/length(classEstimate);

end
