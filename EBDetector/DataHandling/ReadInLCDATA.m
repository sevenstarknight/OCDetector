function [structReduct] = ReadInLCDATA(folderName)

cd(folderName)

listing = dir;

structReduct = [];
count = 1;

for idx = 1:1:length(listing)  

    strFile = listing(idx).name;
    
    if(strcmp(strFile,'.') || strcmp(strFile, '..'))
        continue
    end
    
    
    fid = fopen(strFile);

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
    end
    fclose(fid);

    structReduct(count).timeSeries = timeSeries;
    structReduct(count).parameters = [];
    structReduct(count).label = strFile;
    count = count + 1;

end