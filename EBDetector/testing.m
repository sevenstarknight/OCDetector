
for i = 1:1:length(structReductUnknown)
    
     plot(structReductUnknown(i).foldedData(:,1), structReductUnknown(i).foldedData(:,2),'.r')
     title(structReductUnknown(i).label);
     grid on
     pause()
end


for i = 1:1:length(structReductSOI)
    
     plot(structReductSOI(i).foldedData(:,1), structReductSOI(i).foldedData(:,2),'.r')
     title(structReductSOI(i).label);
     grid on
     pause()
end


for i = 1:1:length(structReductNONSOI)
    
     plot(structReductNONSOI(i).foldedData(:,1), structReductNONSOI(i).foldedData(:,2),'.r')
     title(structReductNONSOI(i).label);
     grid on
     pause()
end


plot(structReductNONSOI(65).foldedData(:,1), structReductNONSOI(65).foldedData(:,2),'.r')
xlabel("Phase")
ylabel("Min-Max Amplitude")
grid on

plot(structReductNONSOI(65).timeSeries(:,1), structReductNONSOI(65).timeSeries(:,3),'.r')
xlabel("Time [JD]")
ylabel("Normalized Flux")
grid on


plot(structMCReduct(1).timeSeries(:,1), structMCReduct(1).timeSeries(:,2),'.r')
xlabel("Time [JD]")
ylabel("V-Band Magnitude")
grid on

plot(structMCReduct(1).foldedData(:,1), -structMCReduct(1).foldedData(:,2),'.r')
xlabel("Phase")
ylabel("Min-Max Amplitude")
grid on