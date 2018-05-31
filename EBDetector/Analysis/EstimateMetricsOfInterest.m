function [deltaM, OER, LCA, deltaMin] = EstimateMetricsOfInterest(alignedData)


xBin = linspace(0.0, 1.0, 20);    
x = alignedData(:,1);
y = alignedData(:,2);


front = x < 0.5;
back = x >= 0.5;

middle = (0.25 < x) & (x < 0.75);


deltaMin = min(y(middle));

maxFront = max(y(front));
maxBack = max(y(back));

deltaM = maxFront - maxBack;

iVector = zeros(1,length(xBin));
for jdx = 2:1:length(xBin)

    boolBin = (xBin(jdx) > x) & (xBin(jdx - 1) <= x);
    iVector(jdx) = mean(y(boolBin));

end

frontI = xBin < 0.5;
backI = xBin >= 0.5;

OER = sum(iVector(frontI))/sum(iVector(backI));

LCA = 0;
for jdx = 2:1:length(xBin)/2
    bigIi = iVector(jdx);
    bigIni = iVector(length(xBin) + 1 - jdx);

    LCA = LCA + ((bigIi - bigIni)^2/bigIi^2);
end
LCA = sqrt(LCA);
end