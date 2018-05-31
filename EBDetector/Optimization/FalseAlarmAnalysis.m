 
boolMatch = zeros(1,length(indexTesting));
for idx = 1:1:length(indexTesting)
    
    if(~strcmp(classEstimate{idx}, grpSource_Testing{idx}))
       
        jdx = indexTesting(idx);
        
        listOfMatch = indexTraining(fltListOfNeighbors(idx,:));
                
        figure()
        plot(structReduct(jdx).alignedData(:,1),structReduct(jdx).alignedData(:,2), '*r');
        hold on
        plot(structReduct(listOfMatch(1)).alignedData(:,1),...
            structReduct(listOfMatch(1)).alignedData(:,2), '.b');
        plot(structReduct(listOfMatch(2)).alignedData(:,1),...
            structReduct(listOfMatch(2)).alignedData(:,2), '.k');
        plot(structReduct(listOfMatch(3)).alignedData(:,1),...
            structReduct(listOfMatch(3)).alignedData(:,2), '.g');
        hold off
        grid on
        
        xlabel('Phase')
        ylabel('Normalized Amplitude')
        legend(strcat(structReduct(jdx).label,' - ', grpSource{jdx}), ...
            strcat(structReduct(listOfMatch(1)).label,' - ', grpSource{listOfMatch(1)}),...
            strcat(structReduct(listOfMatch(2)).label,' - ', grpSource{listOfMatch(2)}),...
            strcat(structReduct(listOfMatch(3)).label,' - ', grpSource{listOfMatch(3)}),...
            'Location','southwest');
    end
    
end
