TempData = [];
for i = 1:1:length(structMCReductKepler)
x = structMCReductKepler(i).phasedData(:,1);
y = structMCReductKepler(i).phasedData(:,2);

smo = supsmu(x,y,'unsorted',true);

structMCReductKepler(i).smoothedData = [x,smo];

TempData(i).smo = (smo - min(smo))./(max(smo) - min(smo));

plot(x, TempData(i).smo , '.r')
hold on

end

for i = 1:1:length(structMCReductKepler)
x = structMCReductKepler(i).smoothedData(:,1);
y = structMCReductKepler(i).smoothedData(:,2);

plot(x, y , '.r')
hold on
end

xlabel('Phase')
ylabel('DTR Flux Smoothed')
grid on
hold off


interpX = -0.5:0.001:0.5;

for i = 1:1:length(structMCReductKepler)
    
    xArray = structMCReductKepler(i).smoothedData(:,1);
    yArray = TempData(i).smo;
    
    [~,ia,~] = unique(xArray);
    
    interpY = interp1(xArray(ia),yArray(ia),interpX,'spline');

    structMCReductKepler(i).downSample = interpY;

end

origCurves = [];
for i = 1:1:length(structMCReductKepler)
    origCurves(i,:) = structMCReductKepler(i).downSample;
end

figure;
plot(interpX,origCurves);
xlabel('Phase')
ylabel('DTR Flux Smoothed: Interp and Normalized')
grid on

[alignedCurves, meanCurveViaSRVF] = fisherRaoWarp(origCurves');

figure;
plot(interpX,alignedCurves);
xlabel('Phase')
ylabel('DTR Flux Smoothed: Interp and Normalized and Aligned')
grid on

figure;
plot(interpX,meanCurveViaSRVF);
xlabel('Phase')
ylabel('DTR Flux Smoothed: Interp and Normalized and Aligned')
grid on


% Compute cross-sectional mean and std of orig curves.
meanOrigCurve = mean(origCurves,1);
stdOrigCurve  = std(origCurves,0,1);

% Compute mean and std of aligned curves.
alignedMeanCurve = mean(alignedCurves,2);
alignedStdCurve  = std(alignedCurves,0,2);

% Visualize the mean and standard deviations.
figure;
plot(interpX,meanOrigCurve,'LineWidth',2); hold on;
plot(interpX,meanOrigCurve+stdOrigCurve,':r','LineWidth',2);
plot(interpX,meanOrigCurve-stdOrigCurve,':r','LineWidth',2);
xlabel('Phase'); ylabel('Amplitude');

figure;
plot(interpX,alignedMeanCurve,'LineWidth',2); hold on;
plot(interpX,alignedMeanCurve+alignedStdCurve,':r','LineWidth',2);
plot(interpX,alignedMeanCurve-alignedStdCurve,':r','LineWidth',2);
xlabel('Phase'); ylabel('Amplitude');

