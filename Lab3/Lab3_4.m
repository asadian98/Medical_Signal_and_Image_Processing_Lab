%% Lab Num              3
%% modified             1400/08/12
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

%% Q4
load('Part3.mat')
% load('Part2.mat')
load('Part2_.mat')


%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------
% 
% uiopen('Part3_s.fig',1)
uiopen('Part2_s.fig',1)

disp(['scatter value V 1,1 = ', num2str(dot(V(:,1),V(:,1)))])
disp(['scatter value V 1,2 = ', num2str(dot(V(:,1),V(:,2)))])
disp(['scatter value V 1,3 = ', num2str(dot(V(:,1),V(:,3)))])

disp(['scatter value V 2,2 = ', num2str(dot(V(:,2),V(:,2)))])
disp(['scatter value V 2,3 = ', num2str(dot(V(:,2),V(:,3)))])

disp(['scatter value V 3,3 = ', num2str(dot(V(:,3),V(:,3)))])


% W -1
disp(['scatter value W_1 1,1 = ', num2str(dot(W_1(:,1),W_1(:,1)))])
disp(['scatter value W_1 1,2 = ', num2str(dot(W_1(:,1),W_1(:,2)))])
disp(['scatter value W_1 1,3 = ', num2str(dot(W_1(:,1),W_1(:,3)))])

disp(['scatter value W_1 2,2 = ', num2str(dot(W_1(:,2),W_1(:,2)))])
disp(['scatter value W_1 2,3 = ', num2str(dot(W_1(:,2),W_1(:,3)))])

disp(['scatter value W_1 3,3 = ', num2str(dot(W_1(:,3),W_1(:,3)))])

% norm
disp(['norm value V 1 = ', num2str(norm(V(:,1)))])
disp(['norm value V 2 = ', num2str(norm(V(:,2)))])
disp(['norm value V 3 = ', num2str(norm(V(:,3)))])


disp(['norm value W_1 1 = ', num2str(norm(W_1(:,1)))])
disp(['norm value W_1 2 = ', num2str(norm(W_1(:,2)))])
disp(['norm value W_1 3 = ', num2str(norm(W_1(:,3)))])

%% ------------------------------------------------------------------------
%% Part 2
%% ------------------------------------------------------------------------
load 'fecg2.dat'

t = (1:length(X(:, 1)))/fs;

subplot(3, 1, 1)
plot(t, fecg2)
title('Orginal signal')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

subplot(3, 1, 2)
plot(t, Fetal(:, 2))
title('Output of SVD Part2')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

subplot(3, 1, 3)
plot(t, X_re(2, :))
title('Output of ICA Part3')
xlim([0, 10.24])
xlabel('Time (sec)')
ylabel('Magnitude (mV)')

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------
SVD_corr = corrcoef(fecg2, Fetal(:, 2));
ICA_corr = corrcoef(fecg2, X_re(2, :)');
disp(['Correlation coefficient of Ideal & SVD = ', num2str(SVD_corr(1,2))])
disp(['Correlation coefficient of Ideal & ICA = ', num2str(ICA_corr(1,2))])

