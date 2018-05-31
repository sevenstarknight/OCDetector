function[markovChain, stateTransitionMatrix] ...
    = findSMM(x, y, optionsMC)

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
windowWidth = median(dt);

%% =====================================================
% Generate windowed
structSampleAreas = [];
count = 1;
fragSet = [];

for idx = 1:1:length(t) - 1    
    if(dt(idx) < 1)
        fragSet = vertcat(fragSet, x(idx));
    else
        % otherwise store the current grouping and restart 
        fragSet = vertcat(fragSet, x(idx));
        structSampleAreas(count).set = fragSet;
        count = count + 1;
        fragSet = [];
    end
end

% add the last one
structSampleAreas(count).set = vertcat(fragSet, x(end));

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