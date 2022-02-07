%% Lab Num              3
%% modified             1400/08/12
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% Q1 
load mecg1.dat
load fecg1.dat
load noise1.dat

fs = 250;
t = (1:length(fecg1))/fs;
ecg = fecg1 + mecg1 + noise1;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

subplot(4, 1, 1)
plot(t, mecg1)
xlim([0, 10.24])
title('ECG - Maternal')
ylabel('ECG (mV)')
xlabel('Time (sec)')
subplot(4, 1, 2)
plot(t, fecg1)
xlim([0, 10.24])
title('ECG - Fetal')
xlabel('Time (sec)')
ylabel('ECG (mV)')
subplot(4, 1, 3)
plot(t, noise1)
xlim([0, 10.24])
title('ECG - Noise')
xlabel('Time (sec)')
ylabel('ECG (mV)')
subplot(4, 1, 4)
plot(t, ecg)
title('ECG - Together')
xlabel('Time (sec)')
ylabel('ECG (mV)')
xlim([0, 10.24])

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

All_ecg = [fecg1, mecg1, noise1, ecg];
titles = {'Pwelch for Fetal ECG', 'Pwelch for Maternal ECG', 'Pwelch for noise'};

for i = 1:3
    subplot(3, 1, i);
    [p ,f] = pwelch(All_ecg(:, i),[],[],[],fs);
    plot(f, pow2db(p),'LineWidth',1);
    title(titles(i));
    ylabel('Power (dB)');
    xlabel('Frequency (Hz)');
end

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
disp('**************************************************')
disp('MEAN ')
disp('**************************************************')
disp(['Mean - Fetal ECG =    ', num2str(mean(fecg1))])
disp(['Mean - Maternal ECG = ', num2str(mean(mecg1))])
disp(['Mean - Noise =        ', num2str(mean(noise1))])
disp(' ')
disp('**************************************************')
disp('VARIANCE ')
disp('**************************************************')
disp(['Variance - Fetal ECG =    ', num2str(var(fecg1))])
disp(['Variance - Maternal ECG = ', num2str(var(mecg1))])
disp(['Variance - Noise =        ', num2str(var(noise1))])
disp('**************************************************')

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------

titles = {'Fetal ECG Histogram', 'Maternal ECG Histogram', 'Noise Histogram'};
for i = 1:3
    subplot(3, 1, i);
    histogram(All_ecg(:, i), 100)
    title(titles(i));
end

disp(['Kurtosis - Fetal ECG = ', num2str(kurtosis(fecg1))])
disp(['Kurtosis - Maternal ECG = ', num2str(kurtosis(mecg1))])
disp(['Kurtosis - Noise = ', num2str(kurtosis(noise1))])