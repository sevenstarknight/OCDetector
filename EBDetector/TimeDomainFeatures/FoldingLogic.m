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
function [structReduct] = FoldingLogic(structReduct)

%% ===========================================
% Initialize Optimal Options for Conditional Entropy & Lomb-Scargle
% from Graham et al. x bins ~ 10 is best?
periods = 0.001:0.005:30; % days
optionsLS = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);

for idx = 1:1:length(structReduct)
    
    %% ===========================================
    if(isempty(structReduct(idx).parameters))
      
        % Estimate Folded Data Implementeding "Best Period"
        [periodogram, periodEst, phasedData, normAmp] = ...
            findPeriodWithLS(...
            structReduct(idx).timeSeries(:,1), ...
            structReduct(idx).timeSeries(:,2), optionsLS);
        structReduct(idx).LSFeatures = periodogram;
        
        structReduct(idx).truePeriodEst = log10(periodEst);
        
        structReduct(idx).foldedData = [];
        structReduct(idx).foldedData = [phasedData'; normAmp']';
        
    else
        truePeriod = 10^(structReduct(idx).parameters(5)); % days
        
        structReduct(idx).truePeriodEst = structReduct(idx).parameters(5);
        
        x = getPhaseTimes(structReduct(idx).timeSeries(:,1),...
            truePeriod);
        
        y = structReduct(idx).timeSeries(:,2);
        
        % Smooth
        smo = supsmu(x,y,'unsorted',true);

        % Normalize
        scale = (smo - min(smo))./(max(smo) - min(smo));

        % Find Min and Align
        [~, location] = min(scale);
        x = x - x(location);
        boolNeg = x < 0;
        x(boolNeg) = 1 + x(boolNeg); % Wrap

        % Align Smoothed Data (Re-smooth with new alignment)
        smo = supsmu(x,y,'unsorted',true);
        scale = (smo - min(smo))./(max(smo) - min(smo));
        structReduct(idx).alignedData = [x,scale];

        % Generate Unique Set for Phased Data
        [~, ia, ~] = unique(x);
        xUnique = x(ia);
        scaleUnique = scale(ia);

        xSet = 0:0.0005:1;    
        vq = spline(xUnique,scaleUnique,xSet);

        structReduct(idx).singleSet = vq;

        % Align Scaled Data
        scale = (y - min(y))./(max(y) - min(y));
        structReduct(idx).foldedData = [x,scale];
        
    end
    
end