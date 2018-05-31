% ==================================================== 
%  Copyright (C) 2016 Kyle Johnston
%  
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
% 
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
% 
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ====================================================
function [structPsi] = K_Means(fltDataIn, intClusters)

delta = 1;

intDimensions = length(fltDataIn(:,1));
intLength = length(fltDataIn(1,:));

%% Step 0
[structPsi, fltExpectation] = InitializeVariables(fltDataIn, intClusters);

intLabel = zeros(1,intLength);

count = 0;

fltMeansK1 = zeros(intClusters, intDimensions);


while(delta ~= 0)
   
    %% Initialize Convergence Estimate
    fltExpectationK = fltExpectation;
    
    
    %% Step 1
    for j = 1:1:intClusters
       expectation = fltExpectation(j,:);
       structPsi(j).mean = expectation*fltDataIn'/sum(expectation);
       structPsi(j).n = sum(expectation);
    end
    
    fltNewExpectations = zeros(intClusters,intLength);
    
    %% Step 2
    for i = 1:1:intLength
        fltCurrentData = fltDataIn(:,i);
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
    clusterLabel = 1:intClusters;
    
    for j = 1:1:intClusters
        fltMeansK1(j,:) = structPsi(j).mean;
    end
    
    gscatter(fltDataIn(1,:)', fltDataIn(2,:)', intLabel, 'rbgkm','.',5)
    hold on
    gscatter(fltMeansK1(:,1),fltMeansK1(:,2), clusterLabel, 'rbgkm','o', 10)
    hold off
    
    pause(0.1)
    

    %% Compute Delta 
    fltExpectation = fltNewExpectations;
    fltDistortion = 0;
    for i = 1:1:intLength
        for j = 1:1:intClusters
            expectation = fltExpectation(j,i);
            distance = (fltMeansK1(j,:) - fltDataIn(:,i)');
            squDistance = distance*distance';
            fltDistortion = fltDistortion + expectation*squDistance;
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
    distance = fltCurrentData' - structPsi(i).mean;
    fltProbEst(i) = sum(distance.^2);
end

end

function [structPsi, fltExpectation] = InitializeVariables(fltDataIn, intClusters)

structPsi = struct([]);
intLength = length(fltDataIn);

for j = 1:1:intClusters
   structPsi(j).mean = fltDataIn(:,j);
end

fltExpectation = zeros(intClusters,intLength);

for i = 1:1:length(fltDataIn)
    index = floor(1 + (intClusters-0).*rand(1,1));
    fltExpectation(index, i) = 1;
end

end