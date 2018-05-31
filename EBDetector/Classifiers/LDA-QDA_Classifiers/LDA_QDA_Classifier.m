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
function [errorProb, classEstimate, structParaEst, fltResponse] = LDA_QDA_Classifier(...
    fltPatternArray_Training, grpSource_Training, fltPatternArray_CrossVal, grpSource_CrossVal, switch_expr)
% function [errorProb, classEstimate, structParaEst] = LDA_QDA_Classifier(...
%     fltPatternArray_Training, grpSource_Training, fltPatternArray_CrossVal, grpSource_CrossVal, ...
%      switch_expr)
%
% Author: Kyle Johnston     14 Jan 2010
%
% Usage: This function generates class estimates based on the LDA/QDA
%   algorithm. This function acts as a "traffic guard"
% 
% Input: 
%       fltPatternArray_Training: the training dataset
%       grpSource_Training: the labels for the training dataset
%       fltPatternArray_CrossVal: used to estimate error
%       grpSource_CrossVal: used to estimate error
%       switch_expr: select the LDA/QDA flavor of your choice

% Output:
%       errorProb: estimated probabiltiy of misclassification
%       classEstimate: estimated labels of fltPatternArray_CrossVal
%       structParaEst: paramters estimated by the LDA/QDA routine
%% LDA QDA Classification Routines
[structParaEst] = Train_LDA_QDA_Classification(fltPatternArray_Training, grpSource_Training, switch_expr);

[classEstimate, fltResponse] = Use_LDA_QDA_Classifer(fltPatternArray_CrossVal, structParaEst);

TF = strcmp(classEstimate,grpSource_CrossVal);
errorProb = 1 - sum(TF)/length(classEstimate);

end

%% Traffic Cop for LDA/QDA Classification
function [structParaEst] = Train_LDA_QDA_Classification(fltPatternArray_Training, grpSource_Training, switch_expr)

    if(switch_expr == 1)
        structParaEst = GenerateQDAParams(fltPatternArray_Training, grpSource_Training, 1); %General QDA
    elseif(switch_expr == 2)
        structParaEst = GenerateQDAParams(fltPatternArray_Training, grpSource_Training, 2); %Naive QDA
    elseif(switch_expr == 3)
        structParaEst = GenerateQDAParams(fltPatternArray_Training, grpSource_Training, 3); %Iso QDA
    elseif(switch_expr == 4)
        structParaEst = GenerateLDAParams(fltPatternArray_Training, grpSource_Training, 1); %General LDA
    elseif(switch_expr == 5)
        structParaEst = GenerateLDAParams(fltPatternArray_Training, grpSource_Training, 2); %Naive LDA
    elseif(switch_expr == 6)
        structParaEst = GenerateLDAParams(fltPatternArray_Training, grpSource_Training, 3); %Iso LDA
    else
        structParaEst = struct([]);
    end

end