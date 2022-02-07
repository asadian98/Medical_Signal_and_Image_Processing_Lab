%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
%% Load data

clear; clc;

load EOG_sig.mat

%% Q1
t = 0:1/fs:100;
figure('Name','EOG data time plot','NumberTitle','off');
for i = 1:2
    subplot(2, 1, i)
    plot(t(1:length(Sig(i, :))), Sig(i, :))
    xlim([0, length(Sig(i, :))/fs])
    xlabel('Time (sec)')
    ylabel('Amplitude (\muV)')
end 
sgtitle('EOG data');

figure();
plot(t(1:length(Sig(2, :))),(Sig(2,:) - Sig(1,:)));
hold on
plot(t(1:length(Sig(2, :))),zeros(1,7680));
xlabel('Time (sec)')
ylabel('Amplitude (\muV)')
title('location of eye')
%% Q2

L = {length(Sig(1, :)), length(Sig(2, :))}; % Length of signal

% Using fft
figure('Name','EOG data freq plot','NumberTitle','off');
for i=1:2
    subplot(2,1,i)
    
    T = 1/fs;                     % Sampling period
    t = (0:L{i}-1)*T;                % Time vector

    n = 2^nextpow2(L{i});
    Y = fft(Sig(i, :), n, 2);
    P2 = abs(Y/L{i});
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    plot(0:(fs/n):(fs/2-fs/n), pow2db(P1(1:n/2)))
    title(['EOG data', num2str(i) , ' in the Frequency Domain'])
    xlabel('Frequency (Hz)');
    ylabel('|X(f)| (dB)')
    xlim([0, fs/2])
end

% Power Spectrum using pspectrum
figure('Name','EOG data power spec plot','NumberTitle','off');
for i = 1:2
    subplot(2, 1, i)
    pspectrum(Sig(i, :))    
end

% Using pwelch
figure('Name','EOG data pwelch plot','NumberTitle','off');
for i = 1:2
    subplot(2, 1, i)
    [p1 ,f] = pwelch(Sig(i, :),[],[],[],fs);
    plot(f, pow2db(p1),'LineWidth',1);
    title(['Pwelch for EOG', num2str(i), ' (dB)'])
    ylabel('Power (dB)')
    xlabel('Frequency (Hz)')
    xlim([0, fs/2])
end

figure('Name','EOG data spectrogram plot','NumberTitle','off');
subplot(2, 1, 1)
spectrogram(Sig(1, :),128,64,128,fs,'yaxis')
title('EOG 1')
subplot(2, 1, 2)
spectrogram(Sig(2, :),128,64,128,fs,'yaxis')
title('EOG 2')
% We can use Signal Analyzer App too --> Saved Files: Q3_2_....mldatx