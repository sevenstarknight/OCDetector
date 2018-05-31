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
function [periodogramLS, periodEst, phaseArray, normAmp]  ...
    = findPeriodWithLS(x, y, optionsLS)

periods = optionsLS.periods;
frequencies = fliplr(1./periods);
%% =====================================================
% dump the outliers
isNotAOutlier = abs(y - median(y))/mad(y) <= 3.0;
y = y(isNotAOutlier);
x = x(isNotAOutlier);

y = y(:)';
x = x(:)';

x = x - min(x);

%% ======================================================
data = [x;(y - min(y))./(max(y) - min(y))]';

[periodogramLS, ~] = plomb(y, x, frequencies);
%% ======================================================
[~, idx] = max(periodogramLS);
periodEst = 1/frequencies(idx);

[~, idy] = max(y);

phaseArray = getPhaseTimes(data(:,1), periodEst);

zeroPhase = phaseArray(idy);

%% ======================================================
%% Make the maxima of the waveform, the zero point
phaseArray = phaseArray - zeroPhase;
isNeg = phaseArray < 0.0;
phaseArray(isNeg) = 1.0 + phaseArray(isNeg);

%% ======================================================
normAmp = data(:,2);

end
