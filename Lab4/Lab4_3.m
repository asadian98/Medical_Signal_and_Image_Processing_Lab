%% Lab Num              4
%% modified             1400/08/26
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

load FiveClass_EEG.mat

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------
% find each Frequency band
% ------------------------
% Alpha
% ------------------------
% Bandpass filter between 8 - 13
fs = 256; % Sampling Frequency
N = 4; % Order
Fpass1 = 8; % First Passband Frequency
Fpass2 = 13; % Second Passband Frequency
Apass = 1; % Passband Ripple (dB)
% Construct an FDESIGN object and call its CHEBY1 method.
h = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, fs);
Hd = design(h, 'cheby1');
for c=1:30
    Alpha_X(:,c) = filter(Hd,X(:,c));
end

% ------------------------
% Beta
% ------------------------
% Bandpass filter between 8 - 13
fs = 256; % Sampling Frequency
N = 4; % Order
Fpass1 = 13; % First Passband Frequency
Fpass2 = 30; % Second Passband Frequency
Apass = 1; % Passband Ripple (dB)
% Construct an FDESIGN object and call its CHEBY1 method.
h = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, fs);
Hd = design(h, 'cheby1');
for c=1:30
    Beta_X(:,c) = filter(Hd,X(:,c));
end

% ------------------------
% Delta
% ------------------------
% Bandpass filter between 8 - 13
fs = 256; % Sampling Frequency
N = 4; % Order
Fpass1 = 1; % First Passband Frequency
Fpass2 = 4; % Second Passband Frequency
Apass = 1; % Passband Ripple (dB)
% Construct an FDESIGN object and call its CHEBY1 method.
h = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, fs);
Hd = design(h, 'cheby1');
for c=1:30
    Delta_X(:,c) = filter(Hd,X(:,c));
end

% ------------------------
% Theta
% ------------------------
% Bandpass filter between 8 - 13
fs = 256; % Sampling Frequency
N = 4; % Order
Fpass1 = 4; % First Passband Frequency
Fpass2 = 8; % Second Passband Frequency
Apass = 1; % Passband Ripple (dB)
% Construct an FDESIGN object and call its CHEBY1 method.
h = fdesign.bandpass('N,Fp1,Fp2,Ap', N, Fpass1, Fpass2, Apass, fs);
Hd = design(h, 'cheby1');
for c=1:30
    Theta_X(:,c) = filter(Hd,X(:,c));
end

%% Plot wanted signal
% 5 sec --> fs * 5
t = 0:1/fs:5-1/fs;
subplot(5, 1, 1)
plot(t, X(1:fs*5, 1))
title('Original Signal')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

subplot(5, 1, 2)
plot(t, Beta_X(1:fs*5, 1))
title('Beta Band')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

subplot(5, 1, 3)
plot(t, Alpha_X(1:fs*5, 1))
title('Alpha Band')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

subplot(5, 1, 4)
plot(t, Theta_X(1:fs*5, 1))
title('Theta Band')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

subplot(5, 1, 5)
plot(t, Delta_X(1:fs*5, 1))
title('Delta Band')
xlabel('t (sec)')
ylabel('Amplitude (\muV)')

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------
% ------------------------
% Alpha
% ------------------------
for i=1:200
 Alpha_Trials(:,:,i) = Alpha_X(trial(i): trial(i)+256*10,:); 
end

% ------------------------
% Beta
% ------------------------
for i=1:200
 Beta_Trials(:,:,i) = Beta_X(trial(i): trial(i)+256*10,:); 
end

% ------------------------
% Delta
% ------------------------
for i=1:200
 Delta_Trials(:,:,i) = Delta_X(trial(i): trial(i)+256*10,:); 
end

% ------------------------
% Theta
% ------------------------
for i=1:200
 Theta_Trials(:,:,i) = Theta_X(trial(i): trial(i)+256*10,:); 
end

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
% ------------------------
% Alpha
% ------------------------
for i = 1:30
   for j = 1:200
       P_Alpha_Trials(:,i,j) = Alpha_Trials(:,i,j).^2;
   end
end
 

% ------------------------
% Beta
% ------------------------
for i = 1:30
   for j = 1:200
       P_Beta_Trials(:,i,j) = Beta_Trials(:,i,j).^2;
   end
end

% ------------------------
% Delta
% ------------------------
for i = 1:30
   for j = 1:200
       P_Delta_Trials(:,i,j) = Delta_Trials(:,i,j).^2;
   end
end

% ------------------------
% Theta
% ------------------------
for i = 1:30
   for j = 1:200
       P_Theta_Trials(:,i,j) = Theta_Trials(:,i,j).^2;
   end
end
 
%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------
% ------------------------
% Alpha
% ------------------------
for i = 1:5
   Alpha_X_avg(:,:,i) = mean(P_Alpha_Trials(:,:,find(y==i)),3);
end


% ------------------------
% Beta
% ------------------------
for i = 1:5
   Beta_X_avg(:,:,i) = mean(P_Beta_Trials(:,:,find(y==i)),3);
end

% ------------------------
% Delta
% ------------------------
for i = 1:5
   Delta_X_avg(:,:,i) = mean(P_Delta_Trials(:,:,find(y==i)),3);
end

% ------------------------
% Theta
% ------------------------
for i = 1:5
   Theta_X_avg(:,:,i) = mean(P_Theta_Trials(:,:,find(y==i)),3);
end

%% ------------------------------------------------------------------------
%% Part 5
%% ------------------------------------------------------------------------
newWin = ones(1,200)/sqrt(200);
% ------------------------
% Alpha
% ------------------------
for i = 1:30
   for j = 1:5
       S_Alpha_x_avg(:,i,j) = conv(newWin, Alpha_X_avg(:,i,j));
   end
end

% ------------------------
% Beta
% ------------------------
for i = 1:30
   for j = 1:5
       S_Beta_x_avg(:,i,j) = conv(newWin, Beta_X_avg(:,i,j));
   end
end

% ------------------------
% Delta
% ------------------------
for i = 1:30
   for j = 1:5
       S_Delta_x_avg(:,i,j) = conv(newWin, Delta_X_avg(:,i,j));
   end
end

% ------------------------
% Theta
% ------------------------
for i = 1:30
   for j = 1:5
       S_Theta_x_avg(:,i,j) = conv(newWin, Theta_X_avg(:,i,j));
   end
end

% resize signals
S_Alpha_x_avg(1:99,:,:) = [];
S_Alpha_x_avg(end-99:end,:,:) = [];

S_Beta_x_avg(1:99,:,:) = [];
S_Beta_x_avg(end-99:end,:,:) = [];

S_Delta_x_avg(1:99,:,:) = [];
S_Delta_x_avg(end-99:end,:,:) = [];

S_Theta_x_avg(1:99,:,:) = [];
S_Theta_x_avg(end-99:end,:,:) = [];


%% ------------------------------------------------------------------------
%% Part 6
%% ------------------------------------------------------------------------
selected_signal = 5;
len = length(S_Alpha_x_avg(:,1,1));
t = 0 :1/256:(len-1)/256;  
% ------------------------
% Alpha
% ------------------------
figure();
sgtitle('Alpha Signals');
for j = 1:5
    subplot(5, 1, j);
    plot(t, S_Alpha_x_avg(:,selected_signal, j));
    title(['Lable #', num2str(j)]);
    xlabel('time (sec)')
    ylabel('Amplitude (\muV)')
end


% ------------------------
% Beta
% ------------------------
figure();
sgtitle('Beta Signals');
for j = 1:5
    subplot(5, 1, j);
    plot(t, S_Beta_x_avg(:,selected_signal, j));
    title(['Lable #', num2str(j)]);
    xlabel('time (sec)')
    ylabel('Amplitude (\muV)')
end

% ------------------------
% Delta
% ------------------------
figure();
sgtitle('Delta Signals');
for j = 1:5
    subplot(5, 1, j);
    plot(t, S_Delta_x_avg(:,selected_signal, j));
    title(['Lable #', num2str(j)]);
    xlabel('time (sec)')
    ylabel('Amplitude (\muV)')
end

% ------------------------
% Theta
% ------------------------
figure();
sgtitle('Theta Signals');
for j = 1:5
    subplot(5, 1, j);
    plot(t, S_Theta_x_avg(:,selected_signal, j));
    title(['Lable #', num2str(j)]);
    xlabel('time (sec)')
    ylabel('Amplitude (\muV)')
end

