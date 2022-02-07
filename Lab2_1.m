%% Lab Num              2
%% modified             1400/08/05
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

%% Load Data
load('X_org.mat')

% 32-channel data
load('Electrodes') ;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_org(:))) ;
feq = 250;
ElecName = Electrodes.labels ;
disp_eeg(X_org,offset,feq,ElecName);
title('All EEG signals')

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

load('X_noise.mat')

% 32-channel data
load('Electrodes') ;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_noise(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_noise,offset,feq,ElecName);
title('All noise signals')

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------

SNR = -5;

power_Xorg = norm(X_org,2);
power_Xnoise = norm(X_noise,2);
sigma_5 = power_Xorg / 10^(SNR/10);
SNR = -15;
sigma_15 = power_Xnoise / 10^(SNR/10);
X_org_M5dB = X_org + sqrt(sigma_5) * X_noise;
X_org_M15dB = X_org + sqrt(sigma_15) * X_noise;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_org_M5dB(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_org_M15dB,offset,feq,ElecName);
title('All EEG noisy signals - SNR = -5dB')

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_org_M15dB(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_org_M15dB,offset,feq,ElecName);
title('All EEG noisy signals - SNR = -15dB')

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------

[F5,W5,K5] = COM2R(X_org_M5dB, 32);
[F15,W15,K15] = COM2R(X_org_M15dB, 32);

u_5 = W5 * X_org_M5dB;
u_15 = W15 * X_org_M15dB;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(u_5(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(u_5,offset,feq,ElecName);
title('Independent components - SNR = -5 dB')
% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(u_15(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(u_15,offset,feq,ElecName);
title('Independent components - SNR = -15 dB')

%% ------------------------------------------------------------------------
%% Part 5
%% ------------------------------------------------------------------------

for i = 1:32
    [M, I] = maxk(W15(i, :), 5);
    disp(['i = ', num2str(i), ' MAX indx = ', num2str(I)])
end

uo5 = u_5;
fil = [1, 2, 13];
uo5(fil, :) = [];
uo15 = u_15;
uo15(fil, :) = [];

%% ------------------------------------------------------------------------
%% Part 6
%% ------------------------------------------------------------------------
F5n = F5;
F5n(:, fil) = [];
F15n = F15;
F15n(:, fil) = [];
X_den5 = F5n*uo5;
X_den15 = F15n*uo15;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_den5(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_den5,offset,feq,ElecName);
title('Observations signals after ICA - SNR = -5 dB')
% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_den15(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_den15,offset,feq,ElecName);
title('Observations signals after ICA - SNR = -15 dB')

%% ------------------------------------------------------------------------
%% Part 7
%% ------------------------------------------------------------------------

% For: - 15 dB, channel#:13
[N K] = size(X_den15);
t = (1:K)/feq;
figure()
subplot(3, 1, 3)
plot(t, X_den15(13, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('After removing noise');
subplot(3, 1, 1)
plot(t, X_org(13, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('X-org');
subplot(3, 1, 2)
plot(t, X_org_M15dB(13, :))
xlabel('Time (seconds)');
title('noisy Signal');
xlim([0, 41])
sgtitle('Channel 13 - (SNR was: -15 dB)');
ylabel('Amplitude (\muV)')
% For: 5 dB, channel#:13
[N K] = size(X_den5);
t = (1:K)/feq;
figure()
subplot(3, 1, 3)
plot(t, X_den5(13, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('After removing noise');
subplot(3, 1, 1)
plot(t, X_org(13, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('X-org');
subplot(3, 1, 2)
plot(t, X_org_M5dB(13, :))
xlabel('Time (seconds)');
title('noisy Signal');
xlim([0, 41])
sgtitle('Channel 13 - (SNR was: -5 dB)');
ylabel('Amplitude (\muV)')
% For: - 15 dB, channel#:24
[N K] = size(X_den15);
t = (1:K)/feq;
figure()
subplot(3, 1, 3)
plot(t, X_den15(24, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('After removing noise');
subplot(3, 1, 1)
plot(t, X_org(24, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('X-org');
subplot(3, 1, 2)
plot(t, X_org_M15dB(24, :))
xlabel('Time (seconds)');
title('noisy Signal');
xlim([0, 41])
sgtitle('Channel 24 - (SNR was: -15 dB)');
ylabel('Amplitude (\muV)')
% For: 5 dB, channel#:24
[N K] = size(X_den5);
t = (1:K)/feq;
figure()
subplot(3, 1, 3)
plot(t, X_den5(24, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('After removing noise');
subplot(3, 1, 1)
plot(t, X_org(24, :))
xlim([0, 41])
xlabel('Time (seconds)');
ylabel('Amplitude (\muV)')
title('X-org');
subplot(3, 1, 2)
plot(t, X_org_M5dB(24, :))
xlabel('Time (seconds)');
title('noisy Signal');
xlim([0, 41])
sgtitle('Channel 24 - (SNR was: -5 dB)');
ylabel('Amplitude (\muV)')

%% ------------------------------------------------------------------------
%% Part 8
%% ------------------------------------------------------------------------

RRMSE_5 = sqrt(sum(sum(X_org - X_den5).^2)) / sqrt(sum(sum(X_org).^2))
RRMSE_15 = sqrt(sum(sum(X_org - X_den15).^2)) / sqrt(sum(sum(X_org).^2)) 


