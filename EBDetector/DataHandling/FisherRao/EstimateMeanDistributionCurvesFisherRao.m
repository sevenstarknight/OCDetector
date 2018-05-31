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