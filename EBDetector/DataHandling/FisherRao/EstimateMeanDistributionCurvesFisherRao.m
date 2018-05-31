function [] = EstimateMeanDistributionCurvesFisherRao(structReduct)

origCurves = zeros(length(structReduct(1).singleSet), length(structReduct));
for i = 1:1:length(structReduct)
   
    origCurves(:,i) = structReduct(i).singleSet;
    
    if(sum(isfinite(origCurves(:,1))) ~= size(origCurves(:,1)))
        origCurves(:,1);
    end
end

[numTPts, ~]   = size(origCurves);
t              = linspace(0,1,numTPts)';

% Visualize the curves prior to alignment.
plot(t,origCurves);
xlabel('Time'); ylabel('Amplitude');
grid on
% title(['Original unaligned functions'],'Fontsize',14);
set(gcf,'Windowstyle','Docked');
% 
% % Align curves using Fisher-Rao warping.
% [alignedCurves, meanCurveViaSRVF] = fisherRaoWarp(origCurves);

% % Visualize the curves after to alignment.
% figure;
% plot(t,alignedCurves);
% grid on
% xlabel('Time'); ylabel('Amplitude');
% title(['Aligned functions'],'Fontsize',14);
% set(gcf,'Windowstyle','Docked');

% Compute cross-sectional mean and std of orig curves.
meanOrigCurve = mean(origCurves,2);
stdOrigCurve  = std(origCurves,0,2);
% 
% % Compute mean and std of aligned curves.
% alignedMeanCurve = mean(alignedCurves,2);
% alignedStdCurve  = std(alignedCurves,0,2);

% Visualize the mean and standard deviations.
figure;
plot(t,meanOrigCurve,'LineWidth',2); hold on;
plot(t,meanOrigCurve+stdOrigCurve,':r','LineWidth',2);
plot(t,meanOrigCurve-stdOrigCurve,':r','LineWidth',2);
grid on
xlabel('Phase'); ylabel('Min-Max Amplitude');
% title(['Mean and Std curves for original functions'],'Fontsize',14);
set(gcf,'Windowstyle','Docked');

figure;
plot(t,alignedMeanCurve,'LineWidth',2); hold on;
plot(t,alignedMeanCurve+alignedStdCurve,':r','LineWidth',2);
plot(t,alignedMeanCurve-alignedStdCurve,':r','LineWidth',2);
grid on
xlabel('Phase'); ylabel('Min-Max Amplitude');
% title(['Mean and Std curves for aligned functions'],'Fontsize',14);
set(gcf,'Windowstyle','Docked');