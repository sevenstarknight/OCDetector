function [fltResponse, classEstimate, errorProb] = Naive_K_Nearest(...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_CrossVal, grpSource_CrossVal, ...
    intKN, metricM, strMissValue)
% function [fltResponse, classEstimate] = Naive_K_Nearest(...
%     fltPatternArray_Training, grpSource_Training, fltPatternArray_CrossVal, ...
%     intKN, p, fltSpread,  strMissValue)
%
% Author: Kyle Johnston     14 Jan 2010
%
% Usage: This function generates class estimates based on the K-NN
%   algorithm. Ties are represented by the "strMissValue" string in the
%   output labels. This particular implimentation is a weighted K-NN
%   algorithm based on the distance from the input pattern to other
%   training pattterns.
% 
% Input: 
%       fltPatternArray_Training: the training dataset
%       grpSource_Training: the labels for the training dataset
%       fltPatternArray_CrossVal: the test dataset
%       intKN: value of k
%       metricM: metric M
%       strMissValue: strnig label for rejected points (ties)
% Output:
%       fltResponse: the set of posterior probabilities
%       classEstimate: estimated labels for fltPatternArray_CrossVal


% Initialize Variables and Arrays
intNumberOfDimensionsTraining = length(fltPatternArray_Training(1,:));
intNumberOfTrainingPatterns = length(fltPatternArray_Training(:,1));

intNumberOfDimensionsTest = length(fltPatternArray_CrossVal(1,:));
intNumberOfTestPatterns = length(fltPatternArray_CrossVal(:,1));

classEstimate = cell(1,intNumberOfTestPatterns);

grpUniqueTypes = unique(grpSource_Training);
intNumberOfUnique = length(grpUniqueTypes);

fltResponse = zeros(intNumberOfTestPatterns, intNumberOfUnique);

% Check to make sure two datasets operate in the same vector space
if(intNumberOfDimensionsTest == intNumberOfDimensionsTraining)

    % Initialize distance arrays
    fltDistance = zeros(1,intNumberOfTrainingPatterns);

    % Loop through test patterns provided
    for i = 1:1:intNumberOfTestPatterns

        currentPattern = fltPatternArray_CrossVal(i,:);
        
        % Compute distance between training and test
        for j = 1:1:intNumberOfTrainingPatterns

            tmpDelta = currentPattern - fltPatternArray_Training(j,:);
            fltDistance(j) = sqrt(sum(diag(tmpDelta*metricM*tmpDelta')));
        end

        [~,I] = sort(fltDistance);
        
        nearestNeighbors = grpSource_Training(I(1:intKN));
        
        %Weighted scheme of associated based on distance
        for j = 1:1:intKN
            for k = 1:1:intNumberOfUnique
                if(strcmp(grpUniqueTypes(k),nearestNeighbors(j)))
                    fltResponse(i,k) = fltResponse(i,k) + 1;
                    break;
                end
            end
        end

        % Compute posterior probabilities
        fltResponse(i,:) = fltResponse(i,:)./sum(fltResponse(i,:));
    end

end

% Label the datasets basedon posterior probabilities

for i = 1:1:length(fltResponse(:,1))

    fltMaxProb = max(fltResponse(i,:));
    intSingle = sum(fltResponse(i,:) == fltMaxProb);
    index = fltMaxProb == fltResponse(i,:);

    if(intSingle ~= 1)
        classEstimate{i} = strMissValue;
    else
        classEstimate{i} = grpUniqueTypes{index};
    end
end

count = 0;
for k = 1:1:length(classEstimate)
    if(strcmp(classEstimate{k}, grpSource_CrossVal{k}))
        count = count + 1;
    end
end

errorProb = (length(classEstimate) - count)/length(classEstimate);

end