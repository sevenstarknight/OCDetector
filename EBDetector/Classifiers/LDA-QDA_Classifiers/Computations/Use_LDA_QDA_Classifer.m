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
