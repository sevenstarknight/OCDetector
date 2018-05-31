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