%% Lab Num              2
%% modified             1400/08/05
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;
%% Q2
x(1,1) = (load ('NewData1.mat'));
x(1,2) = (load ('NewData2.mat'));
x(1,3) = (load ('NewData3.mat'));
x(1,4) = (load ('NewData4.mat'));

load Electrodes.mat

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------
for i = 1:2
    % Plot Data
    % Use function disp_eeg(X,offset,feq,ElecName)
    offset = max(abs(x(i).EEG_Sig(:))) ;
    feq = 250;
    ElecName = Electrodes.labels ;
    disp_eeg(x(i).EEG_Sig,offset,feq,ElecName);
    title(['All EEG signals for P', num2str(i)])
end

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------

[F1,W1,K1] = COM2R(x(1).EEG_Sig, 21);
[F2,W2,K2] = COM2R(x(2).EEG_Sig, 21);

u_1 = W1 * x(1).EEG_Sig;
u_2 = W2 * x(2).EEG_Sig;

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(u_1(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(u_1,offset,feq,ElecName);
title('Independent components - P 1')
% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(u_2(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(u_2,offset,feq,ElecName);
title('Independent components - P 2')

%% ------------------------------------------------------------------------
%% Part 4
%% ------------------------------------------------------------------------

figure();
sgtitle('Pwelch of signal 1 for channels 1 - 10');
for i = 1 : 10
    subplot(5,2,i);
    [p ,f] = pwelch(u_1(i,:),[],[],[],250);
    plot(f, pow2db(p),'LineWidth',1);
    title(['Pwelch for ', num2str(ElecName{i})]);
end
figure()
sgtitle('Pwelch of signal 1 for channels 11 - 21');
for i = 11 : 21
    subplot(6,2,i-10);
    [p ,f] = pwelch(u_1(i,:),[],[],[],250);
    plot(f, pow2db(p),'LineWidth',1);
    title(['Pwelch for ', num2str(ElecName{i})]);
end
%%
figure();
sgtitle('Pwelch of signal 2 for channels 1 - 10');
for i = 1 : 10
    subplot(5,2,i);
    [p ,f] = pwelch(u_2(i,:),[],[],[],250);
    plot(f, pow2db(p),'LineWidth',1);
    title(['Pwelch for ', num2str(ElecName{i})]);
end
figure()
sgtitle('Pwelch of signal 2 for channels 11 - 21');
for i = 11 : 21
    subplot(6,2,i-10);
    [p ,f] = pwelch(u_2(i,:),[],[],[],250);
    plot(f, pow2db(p),'LineWidth',1);
    title(['Pwelch for ', num2str(ElecName{i})]);
end
%%
elocsX = Electrodes.X;
elocsY = Electrodes.Y;
elabels =  Electrodes.labels;

figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F1(:,i));
    title(['scalp map ',num2str(i),' - signal 1'])
end
figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F1(:,i+6));
    title(['scalp map ',num2str(i+6),' - signal 1'])
end
figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F1(:,i+12));
    title(['scalp map ',num2str(i+12),' - signal 1'])
end
figure()
for i = 1:3
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F1(:,i+18));
    title(['scalp map ',num2str(i+18),' - signal 1'])
end

% signal 2
figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F2(:,i));
    title(['scalp map ',num2str(i),' - signal 2'])
end
figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F2(:,i+6));
    title(['scalp map ',num2str(i+6),' - signal 2'])
end
figure()
for i = 1:6
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F2(:,i+12));
    title(['scalp map ',num2str(i+12),' - signal 2'])
end
figure()
for i = 1:3
    subplot(3,2,i)
    plottopomap(elocsX,elocsY,elabels,F2(:,i+18));
    title(['scalp map ',num2str(i+18),' - signal 2'])
end
% P_X = 
% plottopomap(1:21,1:21,ElecName,u_1(:,1));
%% ------------------------------------------------------------------------
%% Part 5
%% ------------------------------------------------------------------------
sel_1 = [1:3, 5:9, 12, 13, 14, 16, 17, 19, 21];
sel_2 = [2, 4, 6, 8:21];

X_den_1 = F1(:,sel_1) * u_1(sel_1,:);
X_den_2 = F2(:,sel_2) * u_2(sel_2,:);

%% ------------------------------------------------------------------------
%% Part 6
%% ------------------------------------------------------------------------

for i = 1:2
    % Plot Data
    % Use function disp_eeg(X,offset,feq,ElecName)
    offset = max(abs(x(i).EEG_Sig(:))) ;
    feq = 250;
    ElecName = Electrodes.labels ;
    disp_eeg(x(i).EEG_Sig,offset,feq,ElecName);
    title(['orginal EEG signals for signal', num2str(i)])
end


% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_den_1(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_den_1,offset,feq,ElecName);
title('Without noise signal 1')

% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X_den_2(:))) ;
feq = 250 ;
ElecName = Electrodes.labels ;
disp_eeg(X_den_2,offset,feq,ElecName);
title('Without noise signal 2')
