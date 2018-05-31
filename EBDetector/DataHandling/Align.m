function [structReduct] = Align(structReduct)

periods = 0.001:0.005:30; % days
optionsCE = struct('periods', periods, ...
    'numXBins', 10, 'numYBins', 11);

for idx = 1:1:length(structReduct)
    
    %% ===========================================
    if(isempty(structReduct(idx).parameters))
      
        % Estimate Folded Data Implementeding "Best Period"
        [periodogram, ~, phasedData, normAmp] = ...
            findPeriodWithLS(...
            structReduct(idx).timeSeries(:,1), ...
            structReduct(idx).timeSeries(:,2), optionsCE);
        
        structReduct(idx).LSFeatures = periodogram;
        structReduct(idx).foldedData = [];
        structReduct(idx).foldedData = [phasedData'; normAmp']';
        
    else
        truePeriod = 10^(structReduct(idx).parameters(5)); % days
        
        x = getPhaseTimes(structReduct(idx).timeSeries(:,1),...
            truePeriod);
        
        y = structReduct(idx).timeSeries(:,2);
        normAmp = (y - min(y))./(max(y) - min(y));
        
        smooth = supsmu(x,normAmp,'unsorted',true);
        
        %Align to the min
        [value, location] = max(smooth);
        x = x - x(location);
        boolNeg = x < 0;
        x(boolNeg) = 1 + x(boolNeg); % Wrap
        
        structReduct(idx).smoothedData = [];
        structReduct(idx).smoothedData = [x'; smooth']';
        structReduct(idx).foldedData = [];
        structReduct(idx).foldedData = [x'; normAmp']';
        
    end
    
end