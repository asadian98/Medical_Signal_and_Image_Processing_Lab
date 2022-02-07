%% Lab Num              9
%% modified             1400/10/08
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

load('ElecPosXYZ.mat')

%Forward Matrix
ModelParams.R = [8 8.5 9.2] ; % Radius of diffetent layers
ModelParams.Sigma = [3.3e-3 8.25e-5 3.3e-3]; 
ModelParams.Lambda = [.5979 .2037 .0237];
ModelParams.Mu = [.6342 .9364 1.0362];

Resolution = 1 ;
[LocMat,GainMat] = ForwardModel_3shell(Resolution, ModelParams) ;

%% A)
scatter3(LocMat(1,:), LocMat(2,:), LocMat(3,:))
title('Dipoles positions')

%% B)
for i = 1:21
    XYZ = ElecPos{i}.XYZ * ModelParams.R(3);
    hold on
    scatter3(XYZ(1), XYZ(2), XYZ(3))
    text(XYZ(1), XYZ(2), XYZ(3), ElecPos{i}.Name)
end

%% C
% Idx = 1073;
Idx = 97; %randperm(1317, 1);
Idx = 1299; %randperm(1317, 1);
Idx = 104; %randperm(1317, 1);

% LocMat(3,Idx) = ModelParams.R(1);
scatter3(LocMat(1,Idx), LocMat(2,Idx), LocMat(3,Idx), 'r*')

%% D)
load('Interictal.mat')

e = [LocMat(1,Idx), LocMat(2,Idx), LocMat(3,Idx)] ;
e = e / norm(e, 2);
data = Interictal(1, :);
m = [];
for i = 1:10240
    q = e * data(i);
    g = GainMat(:, 3*Idx-2:3*Idx);
    m = [m, g * q'];
end

% Plot Data
for i = 1:21
    lab{i} = ElecPos{i}.Name;
end

offset = max(abs(m(:))) ;
feq = 256;
disp_eeg(m,offset,feq,lab);
title('All EEG signals')

%% E)
len = 5;
for j = 1:21
    [pks,locs] = findpeaks(m(j, :)', 'MinPeakHeight',max(m(j, :))/2);

    for i = 1 : length(locs)
        a_mean(i) = mean(m(j,locs(i)-len: locs(i)+len));
    end
    channel_mean_spike(j) = mean(a_mean);
end

Display_Potential_3D(ModelParams.R(3),channel_mean_spike)
%% F)

Qp = lsqminnorm(GainMat, channel_mean_spike');
Q = GainMat'*inv(GainMat*GainMat' + 0.1*eye(21))*channel_mean_spike';
Q = Qp
amp = [];
er = [];
for i = 1:1317
   amp = [amp, sqrt((Q(3*i-2)).^2 + (Q(3*i-1)).^2 + (Q(3*i)).^2)];
   e = [Q(3*i-2), Q(3*i-1), Q(3*i)];
   e = e / norm(e, 2);
   er = [er; e];
end

[m , I] = max(amp)

e1 = [Q(3*I-2), Q(3*I-1), Q(3*I)];
e2 = [LocMat(1,Idx), LocMat(2,Idx), LocMat(3,Idx)];

CosTheta = max(min(dot(e1,e2)/(norm(e1)*norm(e2)),1),-1);
ThetaInDegrees = real(acosd(CosTheta))

error = sqrt(((Q(3*I-2))-LocMat(1,Idx)).^2 + ((Q(3*I-1))-LocMat(2,Idx)).^2 + ((Q(3*I))-LocMat(3,Idx)).^2)
