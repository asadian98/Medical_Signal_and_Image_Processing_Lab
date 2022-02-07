%% Lab Num              3
%% modified             1400/08/12
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% Q2
load X.dat
fs = 250;
%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

plot3ch(X, fs, 'X ECG Sinals')

[U,S,V] = svd(X);

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------

figure()
plot3dv(V(:, 1), S(1), 'k')
title('V - Columns')
hold on
plot3dv(V(:, 2), S(2, 2), 'b')
hold on
plot3dv(V(:, 3), S(3, 3), 'r')
legend('Column 1', 'Column 2', 'Column 3') 


t = (1:length(X(:, 1)))/fs;
subplot(3, 1, 1)
plot(t, U(:,1))
title('Column 1')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 2)
plot(t, U(:,2))
title('Column 2')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 3)
plot(t, U(:,3))
title('Column 3')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

figure()
stem([S(1, 1), S(2, 2), S(3, 3)])
title('eigenspectrum')

Sr = S;
Sr(1, 1) = 0;
Sr(2, 2) = 0;
Fetal = U*Sr*V';

U1 = U(:,1);
U2 = U(:,2);
U3 = U(:,3);
disp(['Kurtosis - U1 = ', num2str(kurtosis(U1))])
disp(['Kurtosis - U2 = ', num2str(kurtosis(U2))])
disp(['Kurtosis - U3 = ', num2str(kurtosis(U3))])

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------
subplot(3, 1, 1)
plot(t, Fetal(:,1))
title('Column 1')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 2)
plot(t, Fetal(:,2))
title('Column 2')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
subplot(3, 1, 3)
plot(t, Fetal(:,3))
title('Column 3')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

disp(['Kurtosis - Fetal 1 = ', num2str(kurtosis(Fetal(:,1)))])
disp(['Kurtosis - Fetal 2 = ', num2str(kurtosis(Fetal(:,2)))])
disp(['Kurtosis - Fetal 3 = ', num2str(kurtosis(Fetal(:,3)))])

disp(['Mean - Fetal 1 = ', num2str(mean(Fetal(:,1)))])
disp(['Mean - Fetal 2 = ', num2str(mean(Fetal(:,2)))])
disp(['Mean - Fetal 3 = ', num2str(mean(Fetal(:,3)))])

disp(['var - Fetal 1 = ', num2str(var(Fetal(:,1)))])
disp(['var - Fetal 2 = ', num2str(var(Fetal(:,2)))])
disp(['var - Fetal 3 = ', num2str(var(Fetal(:,3)))])
%% ------------------------------------------------------------------------
%% Save data
%% ------------------------------------------------------------------------

% plot3ch(Fetal, fs, 'X ECG Sinals')
load 'fecg2.dat'

corr = corrcoef(fecg2, Fetal(:, 1))

subplot(2, 1, 1)
plot(t, fecg2)
title('Orginal signal')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

subplot(2, 1, 2)
plot(t, Fetal(:, 2))
title('Orginal signal')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')
