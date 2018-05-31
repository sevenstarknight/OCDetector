function[markovChain, stateTransitionMatrix, meanAmplitude, stdAmplitude] ...
    = findSSMM(x, y, optionsMC)

y = y(:)';
x = x(:)';

%% ======================================================
% Standardize the amplitude
timeSet = x;
ampSet = y;

meanAmplitude = mean(ampSet);
stdAmplitude = std(ampSet);

ampSet = (ampSet - meanAmplitude)/stdAmplitude;

x = ampSet;
t = timeSet - min(timeSet);

%% ======================================================
% initialize slotting kernel
dt = diff(t);
windowWidth = 2*median(dt);
kernelSpread = optionsMC.kernelSpread;

% initialize kernel centers in an array
kernelCenterArray = [];
start = 0;
for i = 1:1:length(dt)
    if(dt(i) >= windowWidth)
        kernelCenterArray = horzcat(...
            kernelCenterArray, start:windowWidth:t(i)); 
        start = t(i + 1);
    end
end

if(isempty(kernelCenterArray))
    kernelCenterArray = horzcat(...
        kernelCenterArray, start:windowWidth:t(i));
end

%% =====================================================
% Generate center estimates based on gaussian kernel
structSampleAreas = [];
gaussianMeanSet = [];
count = 1;

i = 1;
while(i < length(kernelCenterArray))
    % Generate Logical for those points in current window
    idx = t > kernelCenterArray(i) - windowWidth & t < kernelCenterArray(i) + windowWidth;
    inKernelX = x(idx);
    inKernelT = t(idx);
    
    if(isempty(inKernelX));
        % If nothing is in the kernel....
        if(isempty(gaussianMeanSet))
            % and nothing is in the current set, make a new start
            currentPt = find(t > kernelCenterArray(i) + windowWidth, 1);
            
            % new start (hop points)
            i = find(t(currentPt) > kernelCenterArray, 1, 'last');
            
        else
            % otherwise store the current grouping and restart 
            structSampleAreas(count).set = gaussianMeanSet;
            count = count + 1;
            gaussianMeanSet = [];
        end
    else  
        % if something is in the kernel, generate weights
        weights = exp(-(((inKernelT - kernelCenterArray(i)).^2)./kernelSpread));
        % estimate a mean amp
        gaussianMean = sum(weights.*inKernelX)/sum(weights);
        % store to the set
        gaussianMeanSet = vertcat(gaussianMeanSet, gaussianMean);
    end
    
    % move to the next kernel Center
    i = i + 1;
end

% add the last one
structSampleAreas(count).set = gaussianMeanSet;

%% ================================================================ 
% Construct the STM
states = optionsMC.states;
stateTransitionMatrix = zeros(length(states), length(states));
for i = 1:1:length(structSampleAreas)
        [stateTransitionMatrixNew] = ConstructSTM(structSampleAreas(i).set, states);
        stateTransitionMatrix = stateTransitionMatrix + stateTransitionMatrixNew;
end

%% ================================================================
% turn stm into mc
totalInState = sum(stateTransitionMatrixNew, 2);
markovChain = zeros(length(states), length(states));
for i = 1:1:length(totalInState)
    if(totalInState(i) ~= 0.0)
        markovChain(i,:) = (stateTransitionMatrixNew(i,:)./totalInState(i));
    end
end


end


function [stateTransitionMatrix] = ConstructSTM(seqX, states)

%% Construct the MC
stateTransitionMatrix = zeros(length(states), length(states));

for i = 2:1:length(seqX)
    %CURRENT
    [indexStart] = findIndex(seqX(i - 1), states);

    %NEXT
    [indexStop] = findIndex(seqX(i), states);

    stateTransitionMatrix(indexStart, indexStop) ...
        = stateTransitionMatrix(indexStart, indexStop) + 1;
end

end