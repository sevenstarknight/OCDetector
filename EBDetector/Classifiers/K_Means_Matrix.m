function [structPsi, fltExpectation] = K_Means_Matrix(fltDataIn, intClusters)

delta = 1;

[intW, intH] = size(fltDataIn(:,:,1));
intLength = length(fltDataIn(1,1,:));

%% Step 0
[structPsi, fltExpectation] = InitializeVariables(fltDataIn, intClusters);

intLabel = zeros(1,intLength);

count = 0;

fltMeansK1 = zeros(intW, intH, intClusters);


while(delta ~= 0)
   
    %% Initialize Convergence Estimate
    fltExpectationK = fltExpectation;
    
    
    %% Step 1
    for j = 1:1:intClusters
       expectation = fltExpectation(j,:);
       n = sum(expectation);
       sumMatrix = sum(fltDataIn(:,:,logical(expectation)),3);
       
       structPsi(j).mean = sumMatrix/n;
       structPsi(j).n = n;
    end
    
    fltNewExpectations = zeros(intClusters, intLength);
    
    %% Step 2
    for i = 1:1:intLength
        fltCurrentData = fltDataIn(:,:,i);
        [fltProbEst] = MDistance(fltCurrentData, structPsi);
        
        index = find(min(fltProbEst) == fltProbEst);
        
        if(length(index) == 1)
            intLabel(i) = index;
            fltNewExpectations(index,i) = 1;
        else
            try
                intLabel(i) = index(1);
                fltNewExpectations(index,i) = 1;
            catch ME
                index;
            end
        end

    end
    
    %% Graph Results
    for j = 1:1:intClusters
        fltMeansK1(:, :, j) = structPsi(j).mean;
    end
    
    %% Compute Delta 
    fltExpectation = fltNewExpectations;
    fltDistortion = 0;
    for i = 1:1:intLength
        for j = 1:1:intClusters
            expectation = fltExpectation(j,i);
            delta = (fltMeansK1(:,:,j) - fltDataIn(:,:,i));
            distanceFro = norm(delta,'fro');
            
            fltDistortion = fltDistortion + expectation*distanceFro;
        end
    end
    
    count = count + 1;
    
    delta = sum(sum((fltExpectationK ~= fltExpectation)));
    
end

count = 1;
for i = 1:1:length(structPsi)
    
    tmpMean = structPsi(i).mean;
    
    if(~isnan(mean(tmpMean)))
        tmpStructPsi(count) = structPsi(i);
        count = count + 1;
    end
    
end

structPsi = tmpStructPsi;


end


function [fltProbEst] = MDistance(fltCurrentData, structPsi)

intClusters = length(structPsi);
fltProbEst = zeros(1,intClusters);

for i = 1:1:length(structPsi)
    delta = fltCurrentData - structPsi(i).mean;
    fltProbEst(i) = norm(delta,'fro');
end

end

function [structPsi, fltExpectation] = InitializeVariables(fltDataIn, intClusters)

structPsi = struct([]);
intLength = length(fltDataIn(1,1,:));

for j = 1:1:intClusters
   structPsi(j).mean = fltDataIn(:,:,j);
end

fltExpectation = zeros(intClusters,intLength);

for i = 1:1:intLength
    index = floor(1 + (intClusters-0).*rand(1,1));
    fltExpectation(index, i) = 1;
end

end