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
function [errorProb] = SmoothWaveform_Test(...
    structReduct, grpSource, indexTraining, indexTesting, knnInt)

singleSetPrime = structReduct(1).singleSet;

%% ===================================
% convert DF to distances to "group matrix"
fltPatternArray = zeros(length(structReduct), length(singleSetPrime));
for indxn = 1:1:length(structReduct)
    singleSet = structReduct(indxn).singleSet;
    fltPatternArray(indxn, :) = singleSet;
end

% Split
fltPatternArray_Training = fltPatternArray(indexTraining,:);
grpSource_Training = grpSource(indexTraining);

fltPatternArray_Testing = fltPatternArray(indexTesting,:);
grpSource_Testing = grpSource(indexTesting);


% Estimate classification error using k-NN
metricM = eye(length(singleSetPrime));

[~, ~, errorProb] = Naive_K_Nearest(...
    fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_Testing, grpSource_Testing, ...
    knnInt, metricM, "Missed");


end
