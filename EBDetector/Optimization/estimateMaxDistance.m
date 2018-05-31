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