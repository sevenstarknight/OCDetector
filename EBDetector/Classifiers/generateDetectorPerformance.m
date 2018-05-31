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
function [structPerformance] = generateDetectorPerformance(target, ...
    classEstimate, grpSource_CrossVal)

tp = 0; tn = 0; fp = 0; fn = 0;

for idx = 1:1:length(grpSource_CrossVal)
    
    if(strcmp(target, grpSource_CrossVal(idx)))
        if(strcmp(classEstimate(idx), grpSource_CrossVal(idx)))
            tp = tp + 1;
        else
            fn = fn + 1;
        end
    else
        if(strcmp(classEstimate(idx), grpSource_CrossVal(idx)))
            tn = tn + 1;
        else
            fp = fp + 1;
        end
    end
        
end

structPerformance = struct('Precision', tp/(tp+fp), 'Recall', tp/(tp+fn), ...
    'MissRate', fp/(fp + tn), 'Accuracy', (tp + tn)/(length(grpSource_CrossVal)));


end
