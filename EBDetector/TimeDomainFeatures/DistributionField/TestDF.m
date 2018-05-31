%% ======================================================
% Test Data
A = 2;
w = 1.;
phi = 0.5*pi;
nin = 2000;
fract_points = 0.2;

rSelect = unique((randi(nin,round(nin*fract_points), 1)));

x = linspace(0.01,20*pi,nin);
x = x(rSelect);

y = A*cos(w*x + phi);
y = y + rand(1, length(y))*std(y);

%% ======================================================
% Min period 0.1, max is about a quarter of the max time 
periods = 0.1:0.01:max(x)/2;
optionsCE = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);

% from Graham et al. x bins ~ 10 is best?
[periodogram, periodEst, phasedData, normAmp] = ...
    findPeriodWithCE(x, y, optionsCE);

%% ======================================================
kerSize     = 11;      % Size of kernel(1 = no convolution)
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel

kernel = gaussian2D([kerSize 1], sigmaOfKer);

optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer, 'direction', 'both', ...
    'numXBins', 50, 'numYBins', 60, 'kernel', kernel);

%% ======================================================
figure()
plot(phasedData, normAmp, '.r')
xlabel('Phase')
ylabel('Normalized Amplitude')

[convDF, binCounts] = findDF(phasedData, normAmp, optionsDF);

xDim = linspace(0, 1, optionsDF.numXBins+1);
yDim = linspace(0, 1, optionsDF.numYBins+1);
imagesc(xDim, yDim, convDF')