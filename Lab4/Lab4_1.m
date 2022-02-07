%% Lab Num              4
%% modified             1400/08/26
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

load ERP_EEG.mat

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

Fs = 240;
N = 100:100:2500;
t = 0:1/240:1-1/240;

figure
for N = 100:100:2500
    plot(t, mean(ERP_EEG(:, 1:N), 2))
    legend()
    hold on
end

figure
for N = 100:100:2500
    plot(t, mean(ERP_EEG(:, 1:N), 2)+N/1000)
    legend()
    hold on
end

title('Mean of N trials (N = 100:100:2500)')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

figure()
max_abs = [];
for N = 1:2550
    max_abs = [max_abs max(abs(mean(ERP_EEG(:, 1:N), 2)))];
end
plot(max_abs)
title('Absolute Amplitude')
ylabel('Absolute Amplitude (\muV)')
xlabel('N')
xlim([1, 2550])
ylim([0, max(max_abs + 0.5)])

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
figure()
RMSE = [];
for N = 2:2550
    RMSE = [RMSE, sqrt(mean((mean(ERP_EEG(:, 1:N), 2) - mean(ERP_EEG(:, 1:N-1), 2)).^2))];
end
plot(RMSE)
title('RMSE (i and i-1)')
ylabel('RMSE (\muV)')
xlabel('N')
xlim([1, 2550])
ylim([0, max(RMSE + 0.5)])

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------
N0 = 300;

%% ------------------------------------------------------------------------
%% Part 5
%% ------------------------------------------------------------------------

figure()
Mean_N0 = mean(ERP_EEG(:, 1:N0), 2);
plot(t, Mean_N0)
hold on
plot(t, mean(ERP_EEG(:, 1:2550), 2))
plot(t, mean(ERP_EEG(:, 1:floor(N0/3)), 2))
plot(t, mean(ERP_EEG(:, 1:randperm(2550, N0)), 2))
plot(t, mean(ERP_EEG(:, 1:randperm(2550, floor(N0/3))), 2))
legend('N0', '2550', 'N0/3', 'Random - N0', 'Random - N0/3')
title('Mean Signal for Different N')
ylabel('Amplitude (\muV)')
xlabel('t (sec)')
xlim([0, 1])
