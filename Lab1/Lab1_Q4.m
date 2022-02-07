%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------
%% Load data
clear; clc;

load EMG_sig.mat
%% Q1
t = 0:1/fs:50;
titles = {'Healthy', 'Patient with Myopathy', 'Patient with Neuropathy'};
data_emg = {emg_healthym, emg_myopathym, emg_neuropathym};
figure()

for i = 1:3
    subplot(3, 1, i)
    plot(t(1:length(data_emg{i})), data_emg{i})
    xlim([0, length(data_emg{i})/fs])
    title(titles(i))
    xlabel('Time (sec)')
    ylabel('Amplitude (\muV)')
end 

figure()
for i = 1:3
    subplot(3, 1, i)
    plot(t(1:length(data_emg{i})), data_emg{i})
    xlim([1, 1.5])
    title(titles(i))
    xlabel('Time (sec)')
    ylabel('Amplitude (\muV)')
end 

%% Q2

L = {length(data_emg{1}), length(data_emg{2}), length(data_emg{3})}; % Length of signal

% Using fft
figure('Name','EMG data freq plot','NumberTitle','off');
for i=1:3
    subplot(3,1,i)
    
    T = 1/fs;                     % Sampling period
    t = (0:L{i}-1)*T;                % Time vector

    n = 2^nextpow2(L{i});
    Y = fft(data_emg{i}, n, 2);
    P2 = abs(Y/L{i});
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
 
    plot(0:(fs/n):(fs/2-fs/n),pow2db(P1(1:n/2)))
    title([titles{i},' data in the Frequency Domain'])
    xlabel('Frequency (Hz)');
    ylabel('|X(f)| (dB)')
end

% Power Spectrum using pspectrum
figure('Name','EMG data power spec plot','NumberTitle','off');
for i = 1:3
    subplot(3, 1, i)
    pspectrum(data_emg{i})    
end

% Using pwelch
figure('Name','EMG data pwelch plot','NumberTitle','off');
for i = 1:3
    subplot(3, 1, i)
    [p1 ,f] = pwelch(data_emg{i},[],[],[],fs);
    plot(f, pow2db(p1),'LineWidth',1);
    title([titles{i},' data power spectrum using Pwelch (dB)'])
    ylabel('Power (dB)')
    xlabel('Frequency (Hz)')
    xlim([0, fs/2])
end


% Time-Frequency using pspectrum
figure('Name','EMG data spectrogram plot','NumberTitle','off');
for i = 1:3
    subplot(3, 1, i)
    spectrogram(data_emg{i},128,64,128,fs,'yaxis')
    title(titles{i})
end
% We can use Signal Analyzer App too --> Saved Files: Q4_2_....mldatx

