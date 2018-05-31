% Graham, M. J., Drake, A. J., Djorgovski, 
% S. G., Mahabal, A. A., & Donalek, C. (2013). 
% Using conditional entropy to identify periodicity. 
% Monthly Notices of the Royal Astronomical Society, 434(3), 2629-2635.
%
function [periodogram, periodEst, phasedData, normAmp]  ...
    = findPeriodWithCE(x, y, optionsCE)

periods = optionsCE.periods;

%% =====================================================
% dump the outliers
isNotAOutlier = abs(y - median(y))/mad(y) <= 3.0;
y = y(isNotAOutlier);
x = x(isNotAOutlier);

y = y(:)';
x = x(:)';

%% ======================================================
data = [x;(y - min(y))./(max(y) - min(y))]';

periodogram = zeros(1,length(periods));
for i = 1:1:length(periods)
   periodogram(i) = conditionalEntropy(periods(i), data, optionsCE);
end
%% ======================================================
[~, idx] = min(periodogram);
[~, idy] = max(y);

periodEst = periods(idx);
phasedData = getPhaseTimes(data(:,1), periodEst);

zeroPhase = phasedData(idy);

%% ======================================================
%% Make the maxima of the waveform, the zero point
phasedData = phasedData - zeroPhase;
isNeg = phasedData < 0.0;
phasedData(isNeg) = 1.0 + phasedData(isNeg);

%% ======================================================
normAmp = data(:,2);

end

function output = conditionalEntropy(period, data, optionsCE)

rephaseData = getPhaseTimes(data(:,1), period);

binCounts = histcounts2(rephaseData, data(:,2), ...
    linspace(0, 1, optionsCE.numXBins+1) ,...
    linspace(0, 1, optionsCE.numYBins+1));

size = length(rephaseData);

divided_bins = binCounts./size;
arg_positive = divided_bins > 0;

%% ===========
column_sums = sum(divided_bins, 1);
column_sums = repmat(column_sums', 2, optionsCE.numYBins);

%% ===========
select_divided_bins = divided_bins(arg_positive);
select_column_sums = column_sums(arg_positive);

A = select_divided_bins...
    .*log(select_column_sums./select_divided_bins);

output = sum(sum(A));

end