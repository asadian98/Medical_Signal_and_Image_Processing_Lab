%% Lab Num              3
%% modified             1400/08/12
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% Q3
load X.dat
fs = 250;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

[W, ZHAT] = ica(X');
W_1 = pinv(W);

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

plot3ch(X, fs, 'Input Data')

figure()
plot3dv(W_1(:, 1), 1, 'k')
title('W - Columns')
hold on
plot3dv(W_1(:, 2), 1, 'b')
hold on
plot3dv(W_1(:, 3), 1, 'r')
legend('Column 1', 'Column 2', 'Column 3') 

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
t = (1:length(X(:, 1)))/fs;
subplot(3, 1, 1)
plot(t, ZHAT(1, :))
title('Row 1')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 2)
plot(t, ZHAT(2, :))
title('Row 2')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 3)
plot(t, ZHAT(3, :))
title('Row 3')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

W_1_re = W_1;
W_1_re(:, 1) = 0;
W_1_re(:, 2) = 0;

X_re = W_1_re * ZHAT;

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------

subplot(3, 1, 1)
plot(t, X_re(1, :))
title('Lead 1')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 2)
plot(t, X_re(2, :))
title('Lead 2')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 3)
plot(t, X_re(3, :))
title('Lead 3')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

%% ------------------------------------------------------------------------
%% Save data
%% ------------------------------------------------------------------------

plot3ch(X_re', fs, 'X ECG Sinals')