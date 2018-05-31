function [structPerformance] = generateDetectorPerformance(target, ...
    classEstimate, grpSource_CrossVal)

tp = 0; tn = 0; fp = 0; fn = 0;

for idx = 1:1:length(grpSource_CrossVal)
    
    if(strcmp(target, grpSource_CrossVal(idx)))
        if(strcmp(classEstimate(idx), grpSource_CrossVal(idx)))
            tp = tp + 1;
        else
            fn = fn + 1;
        end
    else
        if(strcmp(classEstimate(idx), grpSource_CrossVal(idx)))
            tn = tn + 1;
        else
            fp = fp + 1;
        end
    end
        
end

structPerformance = struct('Precision', tp/(tp+fp), 'Recall', tp/(tp+fn), ...
    'MissRate', fp/(fp + tn), 'Accuracy', (tp + tn)/(length(grpSource_CrossVal)));


end
