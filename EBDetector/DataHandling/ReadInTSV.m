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
function [structReduct] = ReadInTSV(folderName)

cd(folderName)

listing = dir;

structReduct = [];
count = 1;

for idx = 1:1:length(listing)  

    strFile = listing(idx).name;
    
    if(strcmp(strFile,'.') || strcmp(strFile, '..') || strcmp(strFile, '.DS_Store'))
        continue
    end
    
    
    fid = fopen(strcat(strFile, filesep, strFile, '.tsv'));

    tline = fgetl(fid);
    header = strsplit(tline,'\t');

    timeSeries = [];
    jdx = 1;

    while ~feof(fid)
        tline = fgetl(fid);
        results = strsplit(tline,'\t');

        timeSeries(jdx,:) = [str2double(results{1}), str2double(results{2}),...
             str2double(results{7})];
        jdx = jdx + 1;
        
        fgets(fid);
    end
    fclose(fid);

    structReduct(count).timeSeries = timeSeries;
    structReduct(count).parameters = [];
    structReduct(count).label = strFile;
    count = count + 1;

end