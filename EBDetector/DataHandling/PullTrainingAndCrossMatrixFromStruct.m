function [fltPatternArray_Training, grpSource_Training, ...
    fltPatternArray_CrossVal, grpSource_CrossVal, cvSet, trainSetTotal] = ...
    PullTrainingAndCrossMatrixFromStruct(fltPatternArray, grpSource, ...
    structPatternArray_TrainingCV, index)

fltPatternArray_Training = [];
grpSource_Training = {};

cvSet = [];
trainSetTotal = [];

fltPatternArray_CrossVal = [];
grpSource_CrossVal = {};

for i = 1:1:length(structPatternArray_TrainingCV) 
    
   if(i == index)
       cvSet = structPatternArray_TrainingCV(i).indexSet;
       fltPatternArray_CrossVal = fltPatternArray(:,:, cvSet);
       grpSource_CrossVal = grpSource(cvSet);
   else
       trainSet = structPatternArray_TrainingCV(i).indexSet;
       newSet = fltPatternArray(:,:, trainSet);
       grpNewSet = grpSource(trainSet);
       fltPatternArray_Training = cat(3,fltPatternArray_Training, newSet);
       grpSource_Training = horzcat(grpSource_Training, grpNewSet);
       
       trainSetTotal = horzcat(trainSetTotal, trainSet);
       
   end
    
    
end

end