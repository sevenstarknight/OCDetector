function [confusion, errorProb] = confusionMatrix(meanResponse, testLabels)

%% =================================================
classEstimate = cell(1,length(testLabels));
grpUniqueTypes = unique(testLabels);
strMissValue = 'Missed';

for indxi = 1:1:length(meanResponse(:,1))

    fltMaxProb = max(meanResponse(indxi,:));
    intSingle = sum(meanResponse(indxi,:) == fltMaxProb);
    index = fltMaxProb == meanResponse(indxi,:);

    if(intSingle ~= 1)
        classEstimate{indxi} = strMissValue;
    else
        classEstimate{indxi} = grpUniqueTypes{index};
    end
end
%% =================================================

count = 0;
for indxk = 1:1:length(classEstimate)
    if(strcmp(classEstimate{indxk}, testLabels{indxk}))
        count = count + 1;
    end
end

errorProb = (length(classEstimate) - count)/length(classEstimate);


%% =================================
confusion = zeros(length(grpUniqueTypes), length(grpUniqueTypes));

for idx = 1:1:length(classEstimate)
    
    jdx = strcmp(classEstimate(idx), grpUniqueTypes);
    kdx = strcmp(testLabels(idx), grpUniqueTypes);
            
    confusion(jdx, kdx) = confusion(jdx, kdx) + 1;
            
end

rowSum = sum(confusion, 2);

for jdx = 1:1:length(grpUniqueTypes)
    confusion(jdx,:) = confusion(jdx,:)./rowSum(jdx); 
end

disp(grpUniqueTypes)
disp(confusion)

end