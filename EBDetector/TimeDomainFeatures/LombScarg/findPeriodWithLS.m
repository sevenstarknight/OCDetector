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
