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
function [fltResponse, classEstimate, errorProbDFMetric, grpSource_Testing, fltListOfNeighbors, maxDistance] = ...
    DF_Testing(indexTraining, indexTesting, ...
    structReduct, grpSource, optionsDF)

%% ===================================
dfMatrix = zeros(optionsDF.numXBins, optionsDF.numYBins, length(structReduct));

for idxk = 1:1:length(structReduct)
    dfMatrix(:,:,idxk) = structReduct(idxk).DF;
end

% Split
fltPatternArray_Training = dfMatrix(:,:,indexTraining);
grpSource_Training = grpSource(indexTraining);

fltPatternArray_Testing = dfMatrix(:,:,indexTesting);
grpSource_Testing = grpSource(indexTesting);


%% ===================================
errorKMeansQDA = 0;
errorKMeansKNN = 0;
for idx = 1:1:50
    [structPsi] = K_Means_Matrix(fltPatternArray_Training, 6);

    % turn counts matrix into DF
    dfGroup = zeros(optionsDF.numXBins,optionsDF.numYBins, length(structPsi));

    for indxn = 1:1:length(structPsi)
        totalInState = sum(structPsi(indxn).mean, 2);
        df = zeros(optionsDF.numXBins,optionsDF.numYBins);
        for indxm = 1:1:length(totalInState)
            if(totalInState(indxm) ~= 0.0)
                df(indxm,:) = (structPsi(indxn).mean(indxm,:)./totalInState(indxm));
            end
        end
        dfGroup(:,:,indxn) = df;
    end

    % convert DF to distances to "group matrix"
    dfMatrix = zeros(optionsDF.numXBins, optionsDF.numYBins,...
        length(structReduct));
    fltPatternArray = zeros(length(structReduct), length(dfGroup(1,1,:)));
    for indxn = 1:1:length(structReduct)
        dfMatrix(:,:,indxn) = structReduct(indxn).DF;
        for indxm = 1:1:length(dfGroup(1,1,:))
            delta = structReduct(indxn).DF - dfGroup(:,:,indxm);
            fltPatternArray(indxn, indxm) = norm(delta,'fro');
        end
    end

    fltPArrayTraining = fltPatternArray(indexTraining,:);
    fltPArrayTesting = fltPatternArray(indexTesting,:);
    
%     figure()
%     categories = {'d1', 'd2' , 'd3', 'd4', 'd5', 'd6'};
%     gplotmatrix(fltPatternArray, fltPatternArray, grpSource',...
%         'br','o.',[],'on','',categories, categories);
    
    [errorProbQDA, ~, ~] = LDA_QDA_Classifier(...
                    fltPArrayTraining, grpSource_Training', ...
                    fltPArrayTesting, grpSource_Testing', 4);

    [~, ~, errorProbKNN] = Naive_K_Nearest(...
                    fltPArrayTraining, grpSource_Training', ...
                    fltPArrayTesting, grpSource_Testing', ...
                    5, eye(length(structPsi)), "Missed");
       
    errorKMeansQDA = errorKMeansQDA + errorProbQDA;
    errorKMeansKNN = errorKMeansKNN + errorProbKNN;
end
      
errorKMeansQDA = errorKMeansQDA/50;
errorKMeansKNN = errorKMeansKNN/50;


%% ===================================
% Optimize Matrix Based on Push/Pull Method
[M] = pushPullMethod(fltPatternArray_Training,...
    grpSource_Training, 1.0, optionsDF.lambda);

%% ==========================================================
options = struct('kValue', optionsDF.kNeigh, 'M', M);

% Estimate classification error using k-NN
[fltResponse, classEstimate, errorProbDFMetric, fltListOfNeighbors, maxDistance] = DF_KNN (...
    fltPatternArray_Training, grpSource_Training,...
    fltPatternArray_Testing, grpSource_Testing, options);

end