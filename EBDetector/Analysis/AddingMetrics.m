
metricWithNew = zeros(1,6);
grpMetric = zeros(1,1);
labels = {'deltaMax', 'deltaMin', 'OER', 'LCA',...
    'Eff_T [K]', 'Period [log(days)]'};
counter = 1;
for idx = 1:1:8

    structTmp = cellStruct{1,idx};

    for jdx = 1:1:length(structTmp)
        if(~isempty(structTmp(jdx).EffT))
            metricWithNew(counter,:) = [structTmp(jdx).deltaM,...
                structTmp(jdx).deltaMin, structTmp(jdx).OER, ...
                structTmp(jdx).LCA, structTmp(jdx).EffT, ...
                log(structTmp(jdx).Period)];
            grpMetric(counter) = idx;
            counter = counter + 1;
        end
    end
end