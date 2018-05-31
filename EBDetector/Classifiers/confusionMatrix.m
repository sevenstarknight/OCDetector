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