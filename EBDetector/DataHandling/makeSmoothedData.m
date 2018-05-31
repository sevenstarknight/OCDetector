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
function [structReduct] = makeSmoothedData(structReduct)

for i = 1:1:length(structReduct)
    %% Pull Time Series Data
    x = structReduct(i).timeSeries(:,2);
    y = structReduct(i).timeSeries(:,3);

    x_plus = x + 1.0;
    y_plus = y;
    
    x_minus = x - 1.0;
    y_minus = y;
    
    x_tmp = [x_minus; x; x_plus];
    y_tmp = [y_minus; y; y_plus];
    
    % Smooth
    smo = supsmu(x_tmp,y_tmp,'unsorted',true);
    smo = smo(length(x_minus) + 1:1:length(x_minus) + length(x));
    
%     smo = supsmu(x,y,'unsorted',true);
    
    % Normalize
    scale = (smo - min(smo))./(max(smo) - min(smo));
            
    % Find Min and Align
    [~, location] = min(scale);
    x = x - x(location);
    boolNeg = x < 0;
    x(boolNeg) = 1 + x(boolNeg); % Wrap
    
    % Align Smoothed Data (Re-smooth with new alignment)
    
    x_plus = x + 1.0;
    y_plus = y;
    
    x_minus = x - 1.0;
    y_minus = y;
    
    x_tmp = [x_minus; x; x_plus];
    y_tmp = [y_minus; y; y_plus];
    
    smo = supsmu(x_tmp,y_tmp,'unsorted',true);
    smo = smo(length(x_minus) + 1:1:length(x_minus) + length(x));
    
%     smo = supsmu(x,y,'unsorted',true);
    scale = (smo - min(smo))./(max(smo) - min(smo));
    structReduct(i).alignedData = [x,scale];
    
    % Generate Unique Set for Phased Data
    [~, ia, ~] = unique(x);
    xUnique = x(ia);
    scaleUnique = scale(ia);
    
    xSet = 0:0.0005:1;    
    vq = spline(xUnique,scaleUnique,xSet);
    
    structReduct(i).singleSet = vq;
    
    % Align Scaled Data
    scale = (y - min(y))./(max(y) - min(y));
    structReduct(i).foldedData = [x,scale];
    
end

