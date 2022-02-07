%% Lab Num              1
%% modified             1400/07/28
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------
%% Load Data
load('EEG_sig.mat')

%% Q1

fs = des.samplingfreq;
time = (1:length(Z))/fs;

plot(time, Z(5,:));

ylim([-50 50])
xlim([0 64])

ylabel('Amplitude (\muV)')
xlabel('Time (sec)')
title('Channle 5 (C3) of EEG Signal')

%% Q2
fs = des.samplingfreq;
time = (1:length(Z))/fs;

subplot(4,1,1);
plot(time, Z(5,:));
xlim([0 15])
ylabel('Amplitude (\muV)')
title({'Channle 5 (C3) of EEG Signal';'time [0 15]'})
xlabel('Time (sec)')

subplot(4,1,2);
plot(time, Z(5,:));
ylabel('Amplitude (\muV)')
xlim([18 40])
title('time [18 40]')
xlabel('Time (sec)')

subplot(4,1,3);
plot(time, Z(5,:));
ylabel('Amplitude (\muV)')
xlim([45 50])
title('time [45 50]')
xlabel('Time (sec)')

subplot(4,1,4);
plot(time, Z(5,:));
ylabel('Amplitude (\muV)')
xlim([50 64])
title('time [50 64]')
xlabel('Time (sec)')

%% Q3
fs = des.samplingfreq;
time = (1:length(Z))/fs;

subplot(3,1,1)
plot(time, Z(6,:))
title('Channel 6')
xlabel('Time (sec)')
ylabel('Amplitude (\muV)')
xlim([0 64])

subplot(3,1,2)
plot(time, Z(5,:))
hold on 
plot(time, Z(6,:))
legend('channle 5 (C3)', 'Channel 6 (C4)')
title('Channle 5 Vs Channel 6')
xlabel('Time (sec)')
ylabel('Amplitude (\muV)')
xlim([0 64])

subplot(3,1,3)
plot(time, abs(Z(5,:) - Z(6,:)))
title('Time domain difference between Channle 5 and 6')
xlabel('Time (sec)')
ylabel('Amplitude (\muV)')
xlim([0 64])

%% Q4
offset = max(max(abs(Z)))/5;
% offset = 50;
feq = 256 ;
ElecName = des.channelnames;
disp_eeg(Z,offset,feq,ElecName);
title('All EEG channels')
%% Q5
offset = max(max(abs(Z)))/5;
%offset = 50;
feq = 256 ;
ElecName = des.channelnames;
disp_eeg(Z(1:6, :),offset,feq,ElecName);
title('FP1-FP2-F3-F4-C3-C4')
%% Q6
part1 = Z(5, 2*256:7*256);
part2 = Z(5, 30*256:35*256);
part3 = Z(5, 42*256:47*256);
part4 = Z(5, 50*256:55*256);

t1 = linspace(2,7,length(part1));
t2 = linspace(30,35,length(part2));
t3 = linspace(42,47,length(part3));
t4 = linspace(50,55,length(part4));

y1 = 2*abs(fft(part1)/256);
y2 = 2*abs(fft(part2)/256);
y3 = 2*abs(fft(part3)/256);
y4 = 2*abs(fft(part4)/256);

f1 = (0:length(y1)-1)*256/length(y1);
f2 = (0:length(y2)-1)*256/length(y2);
f3 = (0:length(y3)-1)*256/length(y3);
f4 = (0:length(y4)-1)*256/length(y4);

figure('Name','Time domain & Frequency Domain of Channel 5 (C3) in 4 parts','NumberTitle','off');

% time plot
subplot(4,2,1)
plot(t1, part1)
ylabel('Amplitude (\muV)')
title('Time domain in [2 7](sec)')
xlabel('time (sec)')

subplot(4,2,3)
plot(t2, part2)
ylabel('Amplitude (\muV)')
title('Time domain in [30 35](sec)')
xlabel('time (sec)')

subplot(4,2,5)
plot(t3, part3)
ylabel('Amplitude (\muV)')
title('Time domain in [42 47](sec)')
xlabel('time (sec)')

subplot(4,2,7)
plot(t4, part4)
ylabel('Amplitude (\muV)')
title('Time domain in [50 55](sec)')
xlabel('time (sec)')

% Frequency plot
CutFreq = 40;
subplot(4,2,2)
plot(f1, y1, 'color', 'r')
ylabel('|X(f)|')
title('Frequency domain in [2 7](sec)')
xlabel('Frequency (Hz)')
xlim([0 CutFreq])

subplot(4,2,4)
plot(f2, y2, 'color', 'r')
title('Frequency domain in [30 35](sec)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
xlim([0 CutFreq])

subplot(4,2,6)
plot(f3, y3, 'color', 'r')
title('Frequency domain in [42 47](sec)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
xlim([0 CutFreq])

subplot(4,2,8)
plot(f4, y4, 'color', 'r')
title('Frequency domain in [50 55](sec)')
xlabel('Frequency (Hz)')
ylabel('|X(f)|')
xlim([0 CutFreq])

% % figure('Name','Compair 4 parts togther');
% % 
% % % time domain
% % subplot(2,1,1)
% % plot(t1, part1)
% % hold on
% % plot(t2, part2)
% % plot(t3, part3)
% % plot(t4, part4)
% % ylabel('voltage')
% % title('Time domain all parts')
% % xlabel('time (sec)')
% % 
% % subplot(2,1,2)
% % plot(f1, y1)
% % hold on
% % plot(f2, y2)
% % plot(f3, y3)
% % plot(f4, y4)

%% Q7
part1 = Z(5, 2*256:7*256);
part2 = Z(5, 30*256:35*256);
part3 = Z(5, 42*256:47*256);
part4 = Z(5, 50*256:55*256);

[p1 ,f] = pwelch(part1,[],[],[],256);
[p2 ,f] = pwelch(part2,[],[],[],256);
[p3 ,f] = pwelch(part3,[],[],[],256);
[p4 ,f] = pwelch(part4,[],[],[],256);

plot(f, pow2db(p1),'LineWidth',1);
hold on;
plot(f, pow2db(p2),'LineWidth',1);
plot(f, pow2db(p3),'LineWidth',1);
plot(f, pow2db(p4),'LineWidth',1);
grid on
title('Pwelch of all 4 part (dB)')
ylabel('power(dB)')
xlabel('Frequency (Hz)')
legend('part 1 sec [2 7]', 'part 2 sec [30 35]', 'part 3 sec [42 47]', 'part 4 sec [50 55]')

%% Q8
part1 = Z(5, 2*256:7*256);
part2 = Z(5, 30*256:35*256);
part3 = Z(5, 42*256:47*256);
part4 = Z(5, 50*256:55*256);

figure();
spectrogram(part1,128,64,128,256,'yaxis')
title('Part 1 [2 7](sec)')

figure();
spectrogram(part2,128,64,128,256,'yaxis')
title('Part 2 [30 35](sec)')

figure();
spectrogram(part3,128,64,128,256,'yaxis')
title('Part 3 [42 47](sec)')

figure();
spectrogram(part4,128,64,128,256,'yaxis')
title('Part 4 [50 55](sec)')
%% Q9 
% timedomain
part1 = Z(5, 2*256:7*256);
t1 = linspace(2,7,length(part1));
td = linspace(2,7,length(part1)/4+1);

OutLPF = lowpass(part2, 32,256);
OutDownSample = downsample(OutLPF, 4);

% fft
y2 = 2*abs(fft(part2)/256);
f2 = (0:length(y2)-1)*256/length(y2);
yl = 2*abs(fft(OutLPF)/256);
yd = 2*abs(fft(OutDownSample)/64);
ffd = (0:length(yd)-1)*64/length(yd);

% pwlech
[plpf ,f] = pwelch(OutLPF,[],[],[],256);
[pdown ,fd] = pwelch(OutDownSample,[],[],[],256/4);
[p2 ,f] = pwelch(part2,[],[],[],256);

% plot
% pwelch
subplot(2,1,1)
plot(f, pow2db(p2),'LineWidth',1);
hold on
plot(f, pow2db(plpf),'LineWidth',1);
title('pwelch of Orginal Signal & Out of LPF')
ylabel('power(dB)')
xlabel('Frequency (Hz)')
legend('Orginal Signal', 'OutPut of LPF')

subplot(2,1,2)
plot(fd, pow2db(pdown),'LineWidth',1);
title('Out of DownSampler')
ylabel('power(dB)')
xlabel('Frequency (Hz)')

% fft
figure();
subplot(2,1,1)
plot(f2, pow2db(y2));
hold on
plot(f2, pow2db(yl));
title('FFT of Orginal Signal & Out of LPF')
ylabel('X(f)(dB)')
xlabel('Frequency (Hz)')
legend('Orginal Signal', 'OutPut of LPF')
xlim([0 256])

subplot(2,1,2)
plot(ffd, pow2db(yd));
title('Out of DownSampler')
ylabel('X(f)(dB)')
xlabel('Frequency (Hz)')
xlim([0 64])

% time
figure()
subplot(2,1,1)
plot(t1, part2);
hold on
plot(t1, OutLPF);
plot(td, OutDownSample);
title('Orginal Signal & Out of LPF & Out of DownSampler')
ylabel('Amplitude (\muV)')
xlabel('Time (sec)')
legend('Orginal Signal', 'OutPut of LPF','Out of DownSampler')

subplot(2,1,2)
plot(td, OutDownSample);
title('Out of DownSampler')
ylabel('Amplitude (\muV)')
xlabel('Time (sec)')

% STFT
figure();
subplot(2,1,1)
spectrogram(part2,128,64,128,256,'yaxis')
title('Orginal Signal ')

subplot(2,1,2)
spectrogram(OutDownSample,128/4,64/4,128/4,256/4,'yaxis')
title('Out of DownSampler')