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
function [structPsi, fltExpectation, structTmp] = plotResults(structTmp, optionsDF)

% for idx = 1:1:length(structTmp)
%     splLabel = split(structTmp(idx).label, '.');
%     structTmp(idx).name = splLabel{1};
% end

figure()
for idx = 1:1:length(structTmp)
    
    plot(structTmp(idx).alignedData(:,1), ...
        structTmp(idx).alignedData(:,2), '.r')
    hold on
    
end
grid on
xlabel('Phase')
ylabel('Min-Max Amplitude')

%%

[~, Xedges, Yedges] = histcounts2(...
    structTmp(1).alignedData(:,1),...
    structTmp(1).alignedData(:,2), ...
    linspace(0, 1, optionsDF.numXBins+1) ,...
    linspace(0, 1, optionsDF.numYBins+1));

fltDataIn = zeros(length(Xedges) - 1, length(Yedges) - 1,...
    length(structTmp));

for idx = 1:1:length(structTmp)
    
    [convDF, ~, ~] = findDF(...
        structTmp(idx).foldedData,...
        structTmp(idx).alignedData, optionsDF);
    
    fltDataIn(:,:,idx) = convDF;
    
end

%% Clustering
intClusters = 8;
 [structPsi, fltExpectation] = K_Means_Matrix(fltDataIn, intClusters); 
 
 structCluster = struct('group',[]);
for jdx = 1:1:intClusters
    structCluster(jdx).group = [];
end
 
%% Group Input Data Via Cluster Response
 
for idx = 1:1:length(structTmp)
    
    y = structTmp(idx).singleSet;
    
    fltClusterType = fltExpectation(:,idx);
    
    for jdx = 1:1:intClusters
        if(fltClusterType(jdx) == 1)
            structTmp(idx).cluster = jdx;
            if(isempty(structCluster(jdx).group))
                structCluster(jdx).group = y;
            else
                structCluster(jdx).group = [structCluster(jdx).group;y];
            end
            break;
        end
    end
end

%% Plot Clusters
figure()
cellNames = cell(1,intClusters);
colors = rand(intClusters,3);
xlim([0,1])
ylim([0,1])
hold on

for idx = 1:1:intClusters
    plot(linspace(0.0, 1.0, length(structTmp(1).singleSet)),...
        mean(structCluster(idx).group), ...
        'LineStyle', '-', 'color', colors(idx,:));
    cellNames{idx} = strcat("Cluster ", num2str(idx));
end

for idx = 1:1:intClusters
    plot(linspace(0.0, 1.0, length(structTmp(1).singleSet)),...
        mean(structCluster(idx).group) + std(structCluster(idx).group), ...
        'LineStyle', '--', 'color', colors(idx,:));
    plot(linspace(0.0, 1.0, length(structTmp(1).singleSet)),...
        mean(structCluster(idx).group) - std(structCluster(idx).group), ...
        'LineStyle', '--', 'color', colors(idx,:));
end

hold off
grid on

xlabel('Phase')
ylabel('Min-Max Amplitude')
legend(cellNames)


figure()
for idx = 1:1:intClusters
    subplot(2,intClusters/2,idx)
    plot(linspace(0.0, 1.0, length(structTmp(1).singleSet)), structCluster(idx).group', ':k')
    grid on
    xlim([0,1])
    ylim([0,1])
    xlabel('Phase')
    ylabel('Min-Max Amplitude')
end





