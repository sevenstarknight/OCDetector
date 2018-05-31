phasedX = getPhaseTimes(Julian_Day, .45);
plot(phasedX, VC1, '.r')

%% =========================
[x, idx] = sort(Julian_Day);
y = VC1(idx);

[uniquex, idxa, idxc] = unique(x);
uniquey = y(idxa);

periods = 0.1:0.00005:0.9; % days
optionsLS = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);

[periodogram, periodEst, phasedData, normAmp] = ...
            findPeriodWithLS(uniquex, uniquey, optionsLS);

figure()
plot(phasedData, normAmp, '.r')

%% =================================
data = (uniquey - min(uniquey))./(max(uniquey) - min(uniquey));
xPhased = getPhaseTimes(uniquex, periodEst*2.0);

figure()
plot(xPhased, data, '.r')
grid on
xlabel('Phase')
ylabel('Normalized Amplitude')

%% =============================================
% Initialize Gaussian Convolution & DF Options
kerSize = 7;            % Size of Gaussian kernel
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel
kNeigh = 3; lambda = 0.75;
kernel = gaussian2D([kerSize 1], sigmaOfKer);

optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer,...
    'direction', 'both', 'numXBins', 15, 'numYBins', 15, 'kernel', kernel, ...
    'kNeigh', 3, 'lambda', 0.75);

xSpace = linspace(0, 1, optionsDF.numXBins+1);
ySpace = linspace(0, 1, optionsDF.numYBins+1);

[convDF, binCounts] = findDF(xPhased, data, optionsDF);

figure()
histogram2(xPhased, data, xSpace, ySpace,'DisplayStyle','tile','ShowEmptyBins','on', 'Normalization', 'probability');
hold on
plot(xPhased, data, '.r')
hold off
grid on
xlabel('Phase')
ylabel('Normalized Amplitude')

%% =================================
figure()
plot(periods, periodogram,'-.r')
        
optionsCE = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);
[periodogram, periodEst, phasedData, normAmp]  ...
    = findPeriodWithCE(uniquex, uniquey, optionsCE);
