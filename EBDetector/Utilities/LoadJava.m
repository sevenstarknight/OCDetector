%% Build 'MOOS signal-conditioning-algorithms' path...
jarPath='C:\Users\514479\.m2\repository\fit\astro\variablestaranalysis';


jarGroupID = 'utilities\patternclassification';
jarArtifactID ='patternclassification';
jarVersion='0.1.0-SNAPSHOT';



%% Build absolute path to jar using MOOS naming convention...
jarPath = fullfile(jarPath,jarGroupID,jarArtifactID,jarVersion);
jarName = [jarArtifactID '-' jarVersion '.jar'];

%% Add this entry to dynamic Java class path...
javaaddpath(fullfile(jarPath,jarName),'-end');

%javaclasspath('-dynamic')

import mil.af.aftac.moos.ep.algorithms.signalconditioningservice.filters.window.*;
%methodsview('Hamming')
%methodsview('Kaiser')

%% =======================================================
keySet = [5,10,15];
valueSet = {magic(5),magic(10),magic(15)};

mapObj = containers.Map(keySet,valueSet);
