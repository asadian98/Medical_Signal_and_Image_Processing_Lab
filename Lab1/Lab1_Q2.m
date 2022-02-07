%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------
%% Load data
clear; clc;

load ECG_sig.mat

%% Q1 

fs = sfreq;
t = 0:1/fs:2000;

figure('Name','ECG data time plot','NumberTitle','off');

for i = 1:2
    subplot(2, 1, i)
    plot(t(1:length(Sig(:, i))), Sig(:, i))
    xlim([0, length(Sig(:, i))/fs])
    title(['ECG - lead', num2str(i)]);
    xlabel('Time (sec)')
    ylabel('Amplitude (mV)')
end 


figure('Name','ECG data time plot magnified','NumberTitle','off');
for i = 1:2
    subplot(2, 1, i)
    plot(t(1:length(Sig(:, i))), Sig(:, i))
    xlim([1, 10])
    title(['ECG - lead', num2str(i), 'Magnified']);
    xlabel('Time (sec)')
    ylabel('Amplitude (mV)')
end 

figure('Name','Sample 1 - PQRST','NumberTitle','off');
plot(t(floor(4.23*fs):floor(4.8*fs)), Sig(floor(4.23*fs):floor(4.8*fs), 1))
xlim([4.23, 4.8])
xlabel('Time (sec)')
ylabel('Amplitude (mV)')
title('Sample 1 - PQRST - ANNOTD(8) = 1')
text(4.32, -0.12, '\downarrow P') % (4.32, -0.15)
text(4.45, -0.35, '\uparrow Q') % (4.45, -0.32)
text(4.50, 0.75, '\downarrow R') % (4.50, 0.72)
text(4.50, 0.75, '\downarrow R') % (4.50, 0.72)
text(4.60, -0.35, '\uparrow S') % (4.60, -0.33)
text(4.74, -0.09, '\downarrow T') % (4.74, -0.115)

figure('Name','Sample 2 - PQRST','NumberTitle','off');
plot(t(floor(1104.84*fs):floor(1105.4*fs)), Sig(floor(1104.84*fs):floor(1105.4*fs), 1))
xlabel('Time (sec)')
ylabel('Amplitude (mV)')
title('Sample 2 - PQRST - ANNOTD(12052) = 8')
text(1104.86, -0.91, '\downarrow P') % (1104.86, -0.935)
text(1104.93, -1.17, '\uparrow Q') % (1104.94, -1.155)
text(1105.055, -0.03, '\downarrow R') % (1105.06, -0.055)
text(1105.155, -1.155, '\uparrow S') % (1105.16, -1.15)
text(1105.335, -0.85, '\downarrow T') % (1105.34, -0.875)

%% Q2

figure('Name','ANNOTD time plot','NumberTitle','off');
for i = 1:2
    subplot(2, 1, i)
    plot(t(1:length(Sig(:, i))), Sig(:, i))
    xlim([0, 40])
    xlabel('Time (sec)')
    ylabel('Amplitude (mV)')
    title(['ECG - lead', num2str(i), 'Annotated']);
    for j = 1:59
        text(ATRTIMED(j), 0, num2str(ANNOTD(j))); 
    end
end 

%% Q3

for i = 1:37
    arr = find(ANNOTD == i);
    if length(arr) > 1
        figure()
        
        for j = 1:2
            subplot(2, 1, j)
            plot(t(1:length(Sig(:, j))), Sig(:, j))
            xlim([ATRTIMED(arr(1))-0.3, ATRTIMED(arr(1))+0.3])
            title(['ECG - lead', num2str(j)]);
            xlabel('Time (sec)')
            ylabel('Amplitude (mV)')
        end
        sgtitle(['Annotation number: ', num2str(i)]) 
    end
end

%% Q4

x11 = Sig((ATRTIMED(5)-0.2)*fs:(ATRTIMED(7)+0.2)*fs, 1);
x12 = Sig((ATRTIMED(5)-0.2)*fs:(ATRTIMED(7)+0.2)*fs, 2);

x21 = Sig((ATRTIMED(641)-0.2)*fs:(ATRTIMED(643)+0.2)*fs, 1);
x22 = Sig((ATRTIMED(641)-0.2)*fs:(ATRTIMED(643)+0.2)*fs, 2);

figure('Name','Normal segment','NumberTitle','off');

subplot(2,1,1)

T = 1/fs;                     % Sampling period
t = (0:length(x11)-1)*T;                % Time vector

n = 2^nextpow2(length(x11));
Y = fft(x11, n, 2);
P2 = abs(Y/length(x11));
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(0:(fs/n):(fs/2-fs/n), pow2db(P1(1:n/2)))
title(['ECG data lead', num2str(1) , ' in the Frequency Domain - Normal'])
xlabel('Frequency (Hz)');
ylabel('|X(f)| (dB)')
xlim([0, fs/2])

subplot(2,1,2)

T = 1/fs;                     % Sampling period
t = (0:length(x12)-1)*T;                % Time vector

n = 2^nextpow2(length(x12));
Y = fft(x12, n, 2);
P2 = abs(Y/length(x12));
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(0:(fs/n):(fs/2-fs/n), pow2db(P1(1:n/2)))
title(['ECG data lead', num2str(2) , ' in the Frequency Domain - Normal'])
xlabel('Frequency (Hz)');
ylabel('|X(f)| (dB)')
xlim([0, fs/2])



figure('Name','Arrhythmia segment','NumberTitle','off');

subplot(2,1,1)

T = 1/fs;                     % Sampling period
t = (0:length(x21)-1)*T;                % Time vector

n = 2^nextpow2(length(x21));
Y = fft(x21, n, 2);
P2 = abs(Y/length(x21));
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(0:(fs/n):(fs/2-fs/n), pow2db(P1(1:n/2)))
title(['ECG data lead', num2str(1) , ' in the Frequency Domain - Arrhythmia'])
xlabel('Frequency (Hz)');
ylabel('|X(f)| (dB)')
xlim([0, fs/2])

subplot(2,1,2)

T = 1/fs;                     % Sampling period
t = (0:length(x22)-1)*T;                % Time vector

n = 2^nextpow2(length(x22));
Y = fft(x22, n, 2);
P2 = abs(Y/length(x22));
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

plot(0:(fs/n):(fs/2-fs/n), pow2db(P1(1:n/2)))
title(['ECG data lead', num2str(2) , ' in the Frequency Domain - Arrhythmia'])
xlabel('Frequency (Hz)');
ylabel('|X(f)| (dB)')
xlim([0, fs/2])


% time_frequency
figure('Name','Normal segment','NumberTitle','off');
subplot(2,1,1)
spectrogram(x11,128,64,128,fs,'yaxis')
title(['ECG data lead', num2str(1) , ' Time-Freq Spectrum - Normal'])

subplot(2,1,2)
spectrogram(x12,128,64,128,fs,'yaxis')
title(['ECG data lead', num2str(2) , ' Time-Freq Spectrum - Normal'])

figure('Name','Arrhythmia segment','NumberTitle','off');

subplot(2,1,1)
spectrogram(x21,128,64,128,fs,'yaxis')
title(['ECG data lead', num2str(1) , ' Time-Freq Spectrum - Arrhythmia'])

subplot(2,1,2)
spectrogram(x22,128,64,128,fs,'yaxis')
title(['ECG data lead', num2str(2) , ' Time-Freq Spectrum - Arrhythmia'])