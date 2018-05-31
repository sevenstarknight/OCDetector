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
function [classEstimate] = KNN_CrossVal(fltPatternArray_TrainingCross, grpSource_TrainingCross, fltPatternArray_Testing, grpSource_Testing, kNN, p, width)

    %% Testing
    maxSizeA1  = max(fltPatternArray_TrainingCross);
    minSizeA1  = min(fltPatternArray_TrainingCross);
    [X,Y] = meshgrid(linspace(minSizeA1(1),maxSizeA1(1), 100),linspace(minSizeA1(2),maxSizeA1(2), 100));
    X = X(:); Y = Y(:);
    fltTesting = cat(2, X, Y);

    [~, classEstimate] = ...
        Naive_K_Nearest(fltPatternArray_TrainingCross, grpSource_TrainingCross, ...
        fltTesting, kNN, p, width, 'Miss');
    
    figure
    gscatter(fltTesting(:,1), fltTesting(:,2), classEstimate', 'brg','.', 2);
    hold on
    gscatter(fltPatternArray_Testing(:,1), fltPatternArray_Testing(:,2), grpSource_Testing, 'brg','xod', 6)
    hold off

    xlim([min(X), max(X)])
    ylim([min(Y), max(Y)])
end