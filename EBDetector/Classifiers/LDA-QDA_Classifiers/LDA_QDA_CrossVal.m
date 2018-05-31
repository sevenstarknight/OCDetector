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
function [classEstimate] = LDA_QDA_CrossVal(fltPatternArray_CrossVal, grpSource_CrossVal, structParaEst)

    %% Testing
    maxSizeA1  = max(fltPatternArray_CrossVal);
    minSizeA1  = min(fltPatternArray_CrossVal);
    [X,Y] = meshgrid(linspace(minSizeA1(1),maxSizeA1(1), 100),linspace(minSizeA1(2),maxSizeA1(2), 100));
    X = X(:); Y = Y(:);
    fltTesting = cat(2, X, Y);

    [classEstimate] = Use_LDA_QDA_Classifer(fltTesting, structParaEst);
    
    figure
    gscatter(fltTesting(:,1), fltTesting(:,2), classEstimate, 'br','.', 2);
    hold on
    gscatter(fltPatternArray_CrossVal(:,1), fltPatternArray_CrossVal(:,2), grpSource_CrossVal, 'br','xo', 6)
    hold off

end