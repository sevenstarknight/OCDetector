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
function[cellStruct] = ClusterProcess(structTmp, structPsi)

intClusters = length(structPsi);
cellStruct = cell(1,intClusters);
 
%% ===========

 structCluster = struct('group',[]);
for jdx = 1:1:intClusters
    structCluster(jdx).group = [];
end
 
%% Group Input Data Via Cluster Response
 
for idx = 1:1:length(structTmp)
    y = structTmp(idx).singleSet;
    jdx = structTmp(idx).cluster;
    
    if(isempty(cellStruct{jdx}))
        cellStruct{jdx} = structTmp(idx);
    else
        tmpStruct = cellStruct{jdx};
        tmpStruct(length(tmpStruct) + 1) = structTmp(idx);
        cellStruct{jdx} = tmpStruct;
    end
    
    if(isempty(structCluster(jdx).group))
        structCluster(jdx).group = y;
    else
        structCluster(jdx).group = [structCluster(jdx).group; y];
    end
end

cellNames = cell(1,intClusters);
colors = rand(intClusters,3);
rndMarkers = {'+','o','*','x','v','d','^','s','>','<'};
intX = length(structTmp(1).singleSet);

figure()
hold on
for idx = 1:1:intClusters
    plot(linspace(0.0, 1.0, intX),...
        mean(structCluster(idx).group), ...
        'Marker', rndMarkers{idx}, ...
        'MarkerIndices',1:50:intX,...
        'LineStyle', '-', 'color', colors(idx,:));
    cellNames{idx} = strcat("Cluster ", num2str(idx));
end


hold off
grid on

xlabel('Phase')
ylabel('Min-Max Amplitude')
legend(cellNames)


end
