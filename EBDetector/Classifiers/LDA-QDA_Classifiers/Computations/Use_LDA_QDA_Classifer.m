function [intLabelArray, fltResponse] = Use_LDA_QDA_Classifer(...
    fltPatternArray, structParaEst)
%% Use Classifier
intNumberTesting = length(fltPatternArray(:,1));
intLabelArray = cell(intNumberTesting,1);

fltResponse = zeros(intNumberTesting, length(structParaEst));

for i = 1:1:intNumberTesting
    [structProb] = DetermineDistanceEstimates(fltPatternArray(i,:), structParaEst);
    
    tmpLikelihood = zeros(1,length(structProb));
    for j = 1:1:length(structProb)
        tmpLikelihood(1,j) = structProb(j).prob;
    end
    
    fltResponse(i,:) = exp(tmpLikelihood)./sum(exp(tmpLikelihood));
    
    maxProb = structProb(1).prob;
    
    for j = 1:1:length(structProb)
        if(maxProb <= structProb(j).prob)
            maxProb = structProb(j).prob;
            currentType = structProb(j).type;
        end
    end
    
    
    intLabelArray{i} = cell2mat(currentType);
end


end
