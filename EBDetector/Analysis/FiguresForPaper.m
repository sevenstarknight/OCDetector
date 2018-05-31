structTmp = structReduct;

idxA = 3;
idxB = 6;
idxC = 70;

subplot(2,3,1)
plot(structTmp(idxA).alignedData(:,1), ...
        structTmp(idxA).alignedData(:,2), '.r')
ylabel('Min-Max Amplitude')
xlabel('Phase')
grid minor

subplot(2,3,2)
plot(structTmp(idxB).alignedData(:,1), ...
        structTmp(idxB).alignedData(:,2), '.r')
ylabel('Min-Max Amplitude')
xlabel('Phase')
grid minor
 
subplot(2,3,3)
plot(structTmp(idxC).alignedData(:,1), ...
        structTmp(idxC).alignedData(:,2), '.r')
ylabel('Min-Max Amplitude')
xlabel('Phase')
grid minor

subplot(2,3,4)
imagesc(structTmp(idxA).DF')
ylabel('Min-Max Amplitude')
xlabel('Phase')
set(gca,'YDir','normal')

subplot(2,3,5)
imagesc(structTmp(idxB).DF')
ylabel('Min-Max Amplitude')
xlabel('Phase')
set(gca,'YDir','normal')

subplot(2,3,6)
imagesc(structTmp(idxC).DF')
ylabel('Min-Max Amplitude')
xlabel('Phase')
set(gca,'YDir','normal')
    
