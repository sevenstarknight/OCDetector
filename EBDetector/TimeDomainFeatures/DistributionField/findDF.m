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
function[convDF, binCounts, data] = findDF(foldedData, alignedData, options)

x = alignedData(:,1)';
y = alignedData(:,2)';

% 
% x = foldedData(:,1);
% y = foldedData(:,2);
% 
% deltaY = y - alignedData(:,2);
% zvalue = abs(deltaY)/std(deltaY);

%% =====================================================
% dump the outliers
% isNotAOutlier = zvalue <= 3.0;
% y = y(isNotAOutlier);
% x = x(isNotAOutlier);
% 
% y = y(:)';
% x = x(:)';
%% ======================================================
data = [x;(y - min(y))./(max(y) - min(y))]';

%% ======================================================
% Generate DF
binCounts = histcounts2(data(:,1), data(:,2), ...
    linspace(0, 1, options.numXBins+1) ,...
    linspace(0, 1, options.numYBins+1));

df = binCounts;
sumAlongColumns = sum(binCounts, 2);
for idx = 1:1:options.numXBins
    if(sumAlongColumns(idx) == 0)
        df(idx,:) = 0;
    else
        df(idx,:) = df(idx,:)/sumAlongColumns(idx);
    end
end

% sumAlongRows = sum(binCounts, 1);
% for idx = 1:1:options.numYBins
%     if(sumAlongRows(idx) == 0)
%         df(:,idx) = 0;
%     else
%         df(:,idx) = df(:,idx)/sumAlongRows(idx);
%     end
% end

%% ======================================================
 [convDF] = convolveDF(df, options);
% convDF = df;
end


function [convDF] = convolveDF(df, options)

padding = (options.kerSize - 1) / 2;

%% Along Row  
if (any(strfind(['both', 'row'], options.direction)))
    % Add columns to the DF
    paddedDF = zeros(...
        options.numXBins + options.kerSize - 1, ...
        options.numYBins);
    
    paddedDF = paddedDF + 1 / options.numYBins;
    paddedDF(padding + 1:end - padding, :) = df;

    % Perform the convolution along row
    convDF = paddedDF;
    for idx = 1:1:options.numYBins
        tmp = conv(paddedDF(:,idx), options.kernel);
        convDF(:,idx) = tmp(padding + 1:end - padding);
    end

    % Remove our padding
    convDF = convDF(padding + 1:end - padding, :);
end

%% Along Column    
if (any(strfind(['both', 'column'], options.direction)))
    % Add rows to the DF    
    paddedDF = zeros(...
        options.numXBins, ...
        options.numYBins + options.kerSize - 1);
    
    paddedDF( :, padding + 1:end - padding) = df;

    % Perform the convolution along column
    convDF = paddedDF;
    for idx = 1:1:options.numXBins
        tmp = conv(paddedDF(idx, :), options.kernel);
        convDF(idx, :) = tmp(padding + 1:end - padding);
    end

    % Remove our padding
    convDF = convDF( :, padding + 1:end - padding);
    
end

%% Enforce Distribution Field (Columns Sum to 1)
sumAlongColumns = sum(convDF, 2);
for idx = 1:1:options.numXBins
    if(sumAlongColumns(idx) == 0)
        convDF(idx, :) = 0;
    else
        convDF(idx, :) = convDF(idx, :)/sumAlongColumns(idx);
    end
end

end