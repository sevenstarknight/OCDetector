function [structMCNew] = ConstructNonVariableStars(n, structMCReduct)

for indexi = 1:1:n

    timeSeriesSize = randi([1500, 3000]);
    
    phase = rand(1,length(timeSeriesSize));
    amplitudes = randn(1, timeSeriesSize);
   
    
    timeSeries = [phase, amplitudes];

    indexNew = length(structMCReduct) + 1;
    
    %% ==================================================================
    structMCReduct(indexNew).ID = strcat('Synth ', num2str(indexi));
    structMCReduct(indexNew).parameters = [];
    structMCReduct(indexNew).timeSeries = timeSeries;

end

% copy
structMCNew = structMCReduct;

% permutate
p = randperm(length(structMCReduct));

for indexi = 1:1:length(structMCReduct)
   structMCNew(p(indexi)) = structMCReduct(indexi); 
end


end