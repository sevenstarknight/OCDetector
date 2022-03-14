function [structTmp] = GenerateMembershipsDF(structTmp, optionsDF, structPsi)



for idx = 1:1:length(structTmp)

    [convDF, ~, ~] = findDF(...
        structTmp(idx).foldedData,...
        structTmp(idx).alignedData, optionsDF);

    [fltProbEst] = MDistance(convDF, structPsi);
    
    structTmp(idx).fltProbEst = fltProbEst;
    
    index = find(min(fltProbEst) == fltProbEst);
    structTmp(idx).clusterNumber = index;
end



end


function [fltProbEst] = MDistance(fltCurrentData, structPsi)

intClusters = length(structPsi);
fltProbEst = zeros(1,intClusters);

for i = 1:1:length(structPsi)
    delta = fltCurrentData - structPsi(i).mean;
    fltProbEst(i) = norm(delta,'fro');
end
fltProbEst = fltProbEst./sum(fltProbEst);
end