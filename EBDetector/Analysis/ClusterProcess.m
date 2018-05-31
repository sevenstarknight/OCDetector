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
