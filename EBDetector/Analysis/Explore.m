for i = 1:1:length(structReductSOI)
    x = structReductSOI(i).foldedData(:,1);
    y = structReductSOI(i).foldedData(:,2);

    plot(x, y , '.r')
    hold on
end

for i = 1:1:length(structReductNONSOI)
    x = structReductNONSOI(i).foldedData(:,1);
    y = structReductNONSOI(i).foldedData(:,2);

    plot(x, y , '.b')
    hold on
end

hold off

%% ===================================================
figure()
for idx = 1:1:length(structReductNONSOI)
   singleSet = structReductNONSOI(idx).singleSet;
   plot(singleSet, '-r')
   hold on
    
end

for idx = 1:1:length(structReductSOI)
   singleSet = structReductSOI(idx).singleSet;
   plot(singleSet, '-b')
   hold on
    
end
hold off
grid on


%% ======================================
figure()
for idx = indexA
    
   singleSet = structReductNONSOI(idx).foldedData;
   plot(singleSet(:,1), singleSet(:,2), '.r')
   title(structReductNONSOI(idx).label)
   pause()
   
    
end