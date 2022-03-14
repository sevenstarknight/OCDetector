% Initialize Gaussian Convolution & DF Options Based on Optim
kerSize = 7;            % Size of Gaussian kernel
sigmaOfKer  = 0.4;      % Variance of Gaussian kernel
kNeigh = 3; lambda = 0.75;
kernel = gaussian2D([kerSize 1], sigmaOfKer);

optionsDF = struct('kerSize', kerSize, 'sigmaOfKer', sigmaOfKer,...
    'direction', 'both', 'numXBins', 25, 'numYBins', 35, 'kernel', kernel, ...
    'kNeigh', kNeigh, 'lambda', lambda);

% Generate the Convolved Distribution Field
    [DF, DFBinCounts,...
        ~] = ...
        findDF(...
        structReductSOI(20).foldedData,...
        structReductSOI(20).alignedData, optionsDF);

figure()

subplot(2,1,1);
plot(structReductSOI(20).foldedData(:,1), ...
    structReductSOI(20).foldedData(:,2),'.r')
xlabel('Phase')
ylabel('Min-Max Amplitude')
grid on

subplot(2,1,2); 
imagesc(DF')
ylabel('Min-Max Amplitude')
xlabel('Phase')
set(gca,'YDir','normal')