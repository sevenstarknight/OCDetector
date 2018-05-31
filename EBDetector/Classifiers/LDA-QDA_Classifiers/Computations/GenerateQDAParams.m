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
function [structQDAParam] = GenerateQDAParams(fltPatternArray_Training,...
    grpSource_Training, switch_expr)
% function [structQDAParam] = GenerateQDAParams(fltPatternArray_Training, grpSource_Training,
% switch_expr)
%
% Author: Kyle Johnston     14 Jan 2010
%
% Usage: This function generates class estimates based on the QDA
%   algorithm. Ties are represented by the "missValue" string in the
%   output labels. 
% 
% Input: 
%       fltPatternArray_Training: the training dataset
%       grpSource_Training: the labels for the training dataset
%       crit_alpha: int representing the kernel selected

% Output:
%       structQDAParam: distribution parameters 
%% Initialize Parameters
uniqueGrp = unique(grpSource_Training);
intNumberGroups = length(uniqueGrp);

structQDAParam= struct([]);

% Estimate and store parameters
for i = 1:1:intNumberGroups
    boolDecision =  strcmp(uniqueGrp{i},grpSource_Training);
    
    fltReducedSet = fltPatternArray_Training(boolDecision,:);
    
    structQDAParam(i).mean = mean(fltReducedSet, 1);
    
    % Posterior Probabilities
    structQDAParam(i).n = sum(boolDecision);
    
    % Select method for generation of covariance matrix
    if(switch_expr == 1)
        [covMatrix] = GenerateGeneralCaseQDA(fltReducedSet);
    elseif(switch_expr == 2)
        [covMatrix] = GenerateNaiveCaseQDA(fltReducedSet);
    elseif(switch_expr == 3)
        [covMatrix] = GenerateIsotropicQDA(fltReducedSet);
    else
        covMatrix = [];
    end
    
    structQDAParam(i).cov = covMatrix;
    structQDAParam(i).invCov = inv(structQDAParam(i).cov);
    structQDAParam(i).logDet = log(det(structQDAParam(i).cov));
    
    structQDAParam(i).constant = log(structQDAParam(i).n/length(grpSource_Training)) - 0.5*structQDAParam(i).logDet;
    structQDAParam(i).type = uniqueGrp(i);
    
end

end


%% Subfunction General QDA
function [covMatrix] = GenerateGeneralCaseQDA(fltReducedSet)

    covMatrix = cov(fltReducedSet);

end

%% Subfunction Naive QDA
function [covMatrix] = GenerateNaiveCaseQDA(fltReducedSet)

    dimen = length(fltReducedSet(1,:));
    covMatrix = zeros(dimen);
    
    for i = 1:1:dimen
        covMatrix(i,i) = var(fltReducedSet(:,i));
    end

end

%% Subfunction Isotropic QDA
function [covMatrix] = GenerateIsotropicQDA(fltReducedSet)

    dimen = length(fltReducedSet(1,:));
    varMatrix = zeros(1,dimen);
    
    for i = 1:1:dimen
        varMatrix(i) = var(fltReducedSet(:,i));
    end

    estVar = mean(varMatrix);
    covMatrix = eye(dimen)*estVar;
end