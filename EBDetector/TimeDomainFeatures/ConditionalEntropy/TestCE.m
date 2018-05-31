%% ======================================================
% Test Data
A = 2;
p = 2.;
phi = 0.5*pi;
nin = 2000;
fract_points = 0.2;

rSelect = unique((randi(nin,round(nin*fract_points), 1)));

x = linspace(0.01,20*pi,nin);
x = x(rSelect);

y = A*cos(2*pi*x/p + phi);
y = y + rand(1, length(y))*std(y);

figure()
plot(x,y, '.r')
xlabel('Time')
ylabel('Amplitude')

timeSeries = [x;y]';

%% ======================================================
% Min period 0.1, max is about a quarter of the max time 
periods = 0.1:0.01:max(x)/2;
optionsCE = struct('periods', periods, 'numXBins', 10, 'numYBins', 5);

% from Graham et al. x bins ~ 10 is best?
[periodogram, periodEst, phasedData, normAmp] = ...
    findPeriodWithCE(x,y, optionsCE);

%% ======================================================
figure()
plot(periods, periodogram, '.r')
xlabel('Period')
ylabel('Conditional Entropy')

%% ======================================================
figure()
plot(phasedData, normAmp, '.r')
xlabel('Phase')
ylabel('Normalized Amplitude')