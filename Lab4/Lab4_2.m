%% Lab Num              4
%% modified             1400/08/26
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

load SSVEP_EEG.mat
fs = 250;
t = (0:length(SSVEP_Signal(1, :))-1)*1/fs;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

SSVEP_filtered = zeros(6, length(SSVEP_Signal(1, :))); 

for i = 1:6
    SSVEP_filtered(i, :) = bandpass(SSVEP_Signal(i, :),[1 400],fs);
    figure()
    subplot(2, 1, 1)
    plot(t, SSVEP_Signal(i, :))
    xlim([0, max(t)])
    ylabel('Amplitude (\muV)')
    xlabel('t (sec)')
    title('Original Signal')
    subplot(2, 1, 2)
    plot(t, SSVEP_filtered(i, :))
    xlim([0, max(t)])
    ylabel('Amplitude (\muV)')
    xlabel('t (sec)')
    title('Filtered Signal')
    sgtitle([num2str(i), 'th SSVEP Signal'])
end

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

% 5(s) --> fs * 5 samples
T = zeros(6, 15, fs * 5);
for i = 1:15
    T(:, i, :) = SSVEP_filtered(:, Event_samples(i):Event_samples(i) + 5*fs - 1);
end

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------

for i = 1:15
    figure();
    sgtitle(['Pwelch of all channel, Trial #', num2str(i)]);
    for j = 1:6
        subplot(6, 1, j);
        [p ,f] = pwelch(reshape(T(j, i,:), 1,fs * 5) ,[],[],[],fs);
        plot(f, pow2db(p),'LineWidth',1);
        xlim([0, fs/2])
        xlabel('Frequency (Hz)')
        ylabel('PSD (dB/Hz)')
    end
end
