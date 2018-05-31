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
function [structReduct] = Align(structReduct)

periods = 0.001:0.005:30; % days
optionsCE = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);

for idx = 1:1:length(structReduct)
    
    %% ===========================================
    if(isempty(structReduct(idx).parameters))
      
        % Estimate Folded Data Implementeding "Best Period"
        [periodogram, ~, phasedData, normAmp] = ...
            findPeriodWithLS(...
            structReduct(idx).timeSeries(:,1), ...
            structReduct(idx).timeSeries(:,2), optionsCE);
        
        structReduct(idx).LSFeatures = periodogram;
        structReduct(idx).foldedData = [];
        structReduct(idx).foldedData = [phasedData'; normAmp']';
        
    else
        truePeriod = 10^(structReduct(idx).parameters(5)); % days
        
        x = getPhaseTimes(structReduct(idx).timeSeries(:,1),...
            truePeriod);
        
        y = structReduct(idx).timeSeries(:,2);
        normAmp = (y - min(y))./(max(y) - min(y));
        
        smooth = supsmu(x,normAmp,'unsorted',true);
        
        %Align to the min
        [value, location] = max(smooth);
        x = x - x(location);
        boolNeg = x < 0;
        x(boolNeg) = 1 + x(boolNeg); % Wrap
        
        structReduct(idx).smoothedData = [];
        structReduct(idx).smoothedData = [x'; smooth']';
        structReduct(idx).foldedData = [];
        structReduct(idx).foldedData = [x'; normAmp']';
        
    end
    
end