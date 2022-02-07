%% Lab Num              5
%% modified             1400/09/03
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

load('normal.mat')

fs = 250;
%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------
TimePeriod = 5;
clean_signal = normal(130*fs:(130+TimePeriod)*fs,2);
noisy_signal = normal(280*fs:(280+TimePeriod)*fs,2);

figure();
subplot(3,1,1)
plot(0:1/fs:5, clean_signal)
title('Clean signal 130 : 135 sec')
xlabel('t (sec)')
ylabel('Amplitude (mV)')

subplot(3,1,2)
plot(0:1/fs:5, noisy_signal)
title('Noisy signal 250 : 255 sec')
xlabel('t (sec)')
ylabel('Amplitude (mV)')

subplot(3,1,3)
plot(0:1/fs:5, noisy_signal)
hold on
plot(0:1/fs:5, clean_signal)
title('Clean signal  + noisy signal')
xlabel('t (sec)')
ylabel('Amplitude (mV)')
legend ('clean signal', 'noisy Signal')

% pwelch
figure()
subplot(3,1,1)
[p_clean ,f] = pwelch(clean_signal ,[],[],[],fs);
plot(f, pow2db(p_clean),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('Clean Signal Pwelch')

subplot(3,1,2)
[p_noisy ,f] = pwelch(noisy_signal ,[],[],[],fs);
plot(f, pow2db(p_noisy),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('Noisy Signal Pwelch')

subplot(3,1,3)
plot(f, pow2db(p_clean),'LineWidth',1);
hold on
plot(f, pow2db(p_noisy),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('clean Signal  + Noisy SignalPwelch')
legend ('clean signal', 'noisy Signal')

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------
% fl = 10; 
% fh = 40;
% x = bandpass(noisy_signal,[fl fh],fs);
% 
N = 99;
Fstop1 = 5;
Fstop2 = 50;

Fpass1 = 10;
Fpass2 = 45;


bpFilt = designfilt('bandpassfir','FilterOrder',N, ...
'StopbandFrequency1',Fstop1,...
'StopbandFrequency2',Fstop2,...
'PassbandFrequency1',Fpass1,...
'PassbandFrequency2',Fpass2,...
'SampleRate',fs);

fvtool(bpFilt,'Analysis','freq')
fvtool(bpFilt,'Analysis','impulse');

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
filterd_noisy = filter(bpFilt,noisy_signal);
filterd_clean = filter(bpFilt,clean_signal);


figure();
subplot(3,1,1)
plot(0:1/fs:5, filterd_clean)
title('Clean signal 130 : 135 sec')
xlabel('t (sec)')
ylabel('Amplitude (mV)')

subplot(3,1,2)
plot(0:1/fs:5, filterd_noisy)
title('Noisy signal 250 : 255 sec')
xlabel('t (sec)')
ylabel('Amplitude (mV)')

subplot(3,1,3)
plot(0:1/fs:5, filterd_noisy)
hold on
plot(0:1/fs:5, filterd_clean)
title('Clean signal  + noisy signal')
xlabel('t (sec)')
ylabel('Amplitude (mV)')
legend ('clean signal', 'noisy Signal')

% pwelch
figure()
subplot(3,1,1)
[p_clean ,f] = pwelch(filterd_clean ,[],[],[],fs);
plot(f, pow2db(p_clean),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('Clean Signal Pwelch')

subplot(3,1,2)
[p_noisy ,f] = pwelch(filterd_noisy ,[],[],[],fs);
plot(f, pow2db(p_noisy),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('Noisy Signal Pwelch')

subplot(3,1,3)
plot(f, pow2db(p_clean),'LineWidth',1);
hold on
plot(f, pow2db(p_noisy),'LineWidth',1);
xlim([0, fs/2])
xlabel('Frequency (Hz)')
ylabel('(dB/Hz)')
title('clean Signal  + Noisy SignalPwelch')
legend ('clean signal', 'noisy Signal')