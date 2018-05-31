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
function [M] = pushPullMethod(trainConvDF, trainLabels, gamma, lambda)


%% Split Matrixes of different classes. 
uniqueClasses = unique(trainLabels);
Index = strmatch('SOI', uniqueClasses);

if(length(uniqueClasses) == 2 && sum(Index) == 2)
    %% Detector
    convDFCell = cell(length(uniqueClasses),1);
    for c = 1 : length(uniqueClasses)
        convDFCell{c,1} = trainConvDF(:,:,strcmp(uniqueClasses(c),trainLabels));
    end

    %% Pull Terms
    [B, ~, N] = size(trainConvDF);
    totalPull = zeros(B);
    for c = 1 : length(uniqueClasses)
%         if(strcmp(uniqueClasses{c},'SOI')) 
            N_c = size(convDFCell{c,1},3);
            tempMatrix = convDFCell{c,1};
            for i = 1 : N_c
                tmpSubMatrix = tempMatrix(:,:,i);
                parfor j = 1 : N_c
                    temp = tmpSubMatrix - tempMatrix(:,:,j);
                    totalPull = totalPull + (temp*temp');
                end
            end
            totalPull = totalPull/(N_c - 1);
%         end
    end
    totalPull = totalPull/gamma;

    %% Computing the Push terms 
    totalPush = zeros(B);
    for c = 1 : length(uniqueClasses)
        total = zeros(B);
        N_c = size(convDFCell{c,1},3);
        tempMatrixC = convDFCell{c,1};
        for i = 1 : N_c
            tempMatrixCI = tempMatrixC(:,:,i);
            for k = 1 : length(uniqueClasses)
                if (c ~= k) % not the same class
                    N_k = size(convDFCell{k,1},3);
                    tempMatrixK = convDFCell{k,1};
                    parfor j = 1 : N_k
                        temp = tempMatrixCI - tempMatrixK(:,:,j);
                        total = total + (temp*temp');
                    end
                end
            end
        end
        totalPush = totalPush + (total/(N-N_c));
    end
    totalPush = totalPush/gamma;

    %% Process
    M = lambda*totalPush - (1-lambda)*totalPull;

    %% Project to PSD Space
    [U, D] = eig(M);
    D(D<0)=0;
    M = U*D*U'; 

else
    convDFCell = cell(length(uniqueClasses),1);
    for c = 1 : length(uniqueClasses)
        convDFCell{c,1} = trainConvDF(:,:,strcmp(uniqueClasses(c),trainLabels));
    end

    %% Pull Terms
    [B, ~, N] = size(trainConvDF);
    totalPull = zeros(B);
    
    for c = 1 : length(uniqueClasses)
        N_c = size(convDFCell{c,1},3);
        tempMatrix = convDFCell{c,1};
        for i = 1 : N_c
            tmpSubMatrix = tempMatrix(:,:,i);
            parfor j = 1 : N_c
                temp = tmpSubMatrix - tempMatrix(:,:,j);
                totalPull = totalPull + (temp*temp');
            end
        end
        totalPull = totalPull/(N_c - 1);
    end
    totalPull = -totalPull/gamma;
    

    %% Computing the Push terms 
    
    totalPush = zeros(B);
    for c = 1 : length(uniqueClasses)
        total = zeros(B);
        N_c = size(convDFCell{c,1},3);
        tempMatrixC = convDFCell{c,1};
        for i = 1 : N_c
            tempMatrixCI = tempMatrixC(:,:,i);
            for k = 1 : length(uniqueClasses)
                if (c ~= k) % not the same class
                    N_k = size(convDFCell{k,1},3);
                    tempMatrixK = convDFCell{k,1};
                    parfor j = 1 : N_k
                        temp = tempMatrixCI - tempMatrixK(:,:,j);
                        total = total + (temp*temp');
                    end
                end
            end
        end
        totalPush = totalPush + (total/(N-N_c));
    end
    totalPush = totalPush/gamma;
    

    %% Process
    M = (1-lambda)*totalPull + lambda*totalPush;

    %% Project to PSD Space
    [U, D] = eig(M);
    D(D<0)=0;
    M = U*D*U'; 

end
