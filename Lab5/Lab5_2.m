%% Lab Num              5
%% modified             1400/09/03
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

% must comment one of these
% -------------------------------------------------------------------------
% n_422
data = load('n_422.mat');
Data = data.n_422;

lables =         [1, 3, 1 , 3, 4, 2];
Samples_data =  [1, 10711, 11211, 11442, 59711, 61288, length(Data)];
Parts_data = {};
number_of_parts = 6;
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% % n_424
% 
% fs = 250;
% data = load('n_424.mat');
% Data = data.n_424;
% 
% lables =         [1, 2, 4, 5, 6];
% Samples_data =  [1, 27249, 53673, 55134, 58288, length(Data)];
% Parts_data = {};
% number_of_parts = 5;
% 
% % -------------------------------------------------------------------------

fs = 250;

%% ------------------------------------------------------------------------
%% Part 1
%% ------------------------------------------------------------------------

for i = 1:number_of_parts
    Parts_data{i} = Data(Samples_data(i):Samples_data(i+1)); % Data should be changed
end

%% Filtering

N = 99;
Fstop1 = 5;
Fstop2 = 50;

Fpass1 = 10;
Fpass2 = 45;

% bpFilt = designfilt('bandpassfir','FilterOrder',N, ...
% 'StopbandFrequency1',Fstop1,...
% 'StopbandFrequency2',Fstop2,...
% 'PassbandFrequency1',Fpass1,...
% 'PassbandFrequency2',Fpass2,...
% 'SampleRate',fs);

Parts_data_filtered = {};

for i = 1:number_of_parts
    Parts_data_filtered{i} = Parts_data(i);%filter(bpFilt,cell2mat(Parts_data(i)));
end

titles_data = {'Normal','Ventricular tachycardia', 'Normal', 'ventricular tachycardia',...
    'Noise', 'Ventricular fibrillation'};

figure 
for i = 1:number_of_parts
    sgtitle('Pwelch of all Parts');
    [p ,f] = pwelch(Parts_data_filtered{i} ,[],[],[],fs);
    subplot(ceil(number_of_parts/2), 2, i)
    plot(f, pow2db(p),'LineWidth',1);
    xlim([0, fs/2])
    xlabel('Frequency (Hz)')
    ylabel('PSD (dB/Hz)')
    title(titles_data(i))
end

figure 
for i = 1:number_of_parts
    sgtitle('Diffrent parts');
    subplot(ceil(number_of_parts/2), 2, i)
    t = (0:length(cell2mat(Parts_data_filtered{i}))-1)*1/fs;
    plot(t, cell2mat(Parts_data_filtered{i}));
    xlabel('Time (ms)')
    ylabel('Amplitude (mV)')
    title(titles_data(i))
end

%% ------------------------------------------------------------------------
%% Part 3
%% ------------------------------------------------------------------------

dummy_arr = zeros(1,length(Data));

for i = 1:length(Samples_data)-1
    dummy_arr(Samples_data(i):Samples_data(i+1)) = lables(i);
end


frame_sec = 10;  % sec
overlap = 0.5;    % 50% overlap between consecutive frames
Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames

data_index = 1;

for i = 1:frame_N
    
    
    index_s = ((i-1)*frame_step+1);
    index_e = ((i-1)*frame_step+frame_length);
    indexes (1,i) = index_s;
    indexes (2,i) = index_e;
    
    for j = index_s+1 :index_e
        if (dummy_arr(j-1) ~= dummy_arr(j))
            label(1,i) = 0;
            break
        end
        label(1,i) = dummy_arr(index_s);
    end
       
end

%% ------------------------------------------------------------------------
%% Part 4  
%% ------------------------------------------------------------------------
% Feature Extraction - Frequency Features

Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames
alarm = zeros(frame_N,1);	% initialize output signal to all zeros
t = ([0:frame_N-1]*frame_step+frame_length)/Fs;

for i = 1:frame_N

    seg = Data(((i-1)*frame_step+1):((i-1)*frame_step+frame_length));
    
    N = length(seg);
    xdft = fft(seg);
    % I only need to search 1/2 of xdft for the max because x is real-valued
    xdft(1:N/2+1);
    [Y,I] = max(abs(xdft));
    freq = 0:Fs/N:Fs/2;
    feature(1, i) = freq(I); % Max freq
    feature(2, i) = meanfreq(seg, Fs); % Mean freq
    feature(3, i) = medfreq(seg, Fs); % Med freq
    feature(4, i) = bandpower(seg, Fs, [0 6]); % Band power 0 6
    feature(5, i) = bandpower(seg, Fs, [25 35]);% Band power 25 35
    feature(6, i) = bandpower(seg, Fs, [35 45]);% Band power 35 45
    
end

cell_Feature{12, 2} = {};

for i = 1:6
    cell_Feature{i, 1} = feature(i, find(label == 2)); 
    cell_Feature{i, 2} = feature(i, find(label == 1)); 
end

%% ------------------------------------------------------------------------
%% Part 5 À
%% ------------------------------------------------------------------------
% Histogram

titles = {'Max Frequency', 'Mean Frequency', 'Median Frequency', 'BandPower 0-6 Hz', ...
    'BandPower 25-35 Hz', 'BandPower 35-45 Hz'};

for i = 1:6

    figure()
    subplot(2, 1, 1)
    min1 = min(min(cell_Feature{i, 1}), min(cell_Feature{i, 2}));
    max1 = max(max(cell_Feature{i, 1}), max(cell_Feature{i, 2}));
    
    histogram(cell_Feature{i, 1}, min1:max1);
    title('VFIB')
    subplot(2, 1, 2)
    histogram(cell_Feature{i, 2}, min1:max1);
    title('Normal')
    sgtitle(titles{i});

end

%% ------------------------------------------------------------------------
%% Part 6 Ã
%% ------------------------------------------------------------------------
% feature selected 3 & 5
alarm_3 = va_detect(Data,fs, 2.75, 2, 1, 3)';
alarm_5 = va_detect(Data,fs, 80, 1, 2, 5)';

%% ------------------------------------------------------------------------
%% Part 7 ç
%% ------------------------------------------------------------------------
% confusionmatrix 
golden_label = label;
golden_label(find(golden_label== 0)) = NaN;
golden_label(find(golden_label== 3)) = NaN;
golden_label(find(golden_label== 4)) = NaN;
golden_label(find(golden_label== 5)) = NaN;
golden_label(find(golden_label== 6)) = NaN;

figure()
C_3 = confusionmat(golden_label,alarm_3);
confusionchart(C_3,{'Normal(negative)','VFIB(positive)'});
title('Median freq feture')
disp(' ')
disp('*********************************************')
disp('Median freq feture')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_3(1,1)+C_3(2,2))/(C_3(1,1)+C_3(2,2)+C_3(1,2)+C_3(2,1)))])
disp(['Sensitivity  = ', num2str((C_3(2,2))/(C_3(2,2)+C_3(2,1)))])
disp(['Specificity  = ', num2str((C_3(1,1))/(C_3(1,1)+C_3(1,2)))])


figure()
C_5 = confusionmat(golden_label,alarm_5);
confusionchart(C_5,{'Normal(negative)','VFIB(positive)'});
title('Band power 25-35 feture')
disp(' ')
disp('*********************************************')
disp('Band power 25-35 feture')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_5(1,1)+C_5(2,2))/(C_5(1,1)+C_5(2,2)+C_5(1,2)+C_5(2,1)))])
disp(['Sensitivity  = ', num2str((C_5(2,2))/(C_5(2,2)+C_5(2,1)))])
disp(['Specificity  = ', num2str((C_5(1,1))/(C_5(1,1)+C_5(1,2)))])

figure()
plot(alarm_3)
hold on
plot(alarm_5)
plot(label)
legend ('feture 3 (Median) classification', 'feture 5 (Band Power) classification', 'golden labels')
xlabel('number of frame')
ylabel ('label index')

%% ------------------------------------------------------------------------
%% Part 8 Õ
%% ------------------------------------------------------------------------
% Feature Extraction - Morphologic Features

Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames
alarm = zeros(frame_N,1);	% initialize output signal to all zeros
t = ([0:frame_N-1]*frame_step+frame_length)/Fs;

for i = 1:frame_N

    seg = Data(((i-1)*frame_step+1):((i-1)*frame_step+frame_length));
    
    N = length(seg);

    feature(7, i) = max(seg); 
    feature(8, i) = min(seg);
    feature(9, i) = max(seg) - min(seg);
    feature(10, i) = mean(findpeaks(seg, 'MinPeakHeight',100,'MinPeakDistance',200));
    feature(11, i) = sum(seg == 0);
    feature(12, i) = var(seg);
    
end

for i = 7:12
    cell_Feature{i, 1} = feature(i, find(label == 2)); 
    cell_Feature{i, 2} = feature(i, find(label == 1)); 
end

%% ------------------------------------------------------------------------
%% Part 9
%% ------------------------------------------------------------------------
% Histogram

titles = {'Maximum Amplitude', 'Minimum Amplitude', 'Peak-Peak', 'Average of R-peaks Amplitude', ...
    'Number of zero crossing', 'Variance of amplitudes'};

for i = 7:12

    figure()
    subplot(2, 1, 1)
    min1 = min(min(cell_Feature{i, 1}), min(cell_Feature{i, 2}));
    max1 = max(max(cell_Feature{i, 1}), max(cell_Feature{i, 2}));
    
    histogram(cell_Feature{i, 1}, min1:max1);
    title('VFIB')
    subplot(2, 1, 2)
    histogram(cell_Feature{i, 2}, min1:max1);
    title('Normal')
    sgtitle(titles{i-6});

end

%% ------------------------------------------------------------------------
%% Part 10 œ
%% ------------------------------------------------------------------------
% Test
% Rpeaks < 250 10
% peak to peak < 600 9

% feature selected 9 & 10
alarm_9 = va_detect(Data,fs, 600, 1, 2, 9)';
alarm_10 = va_detect(Data,fs, 250, 1, 2, 10)';

%% ------------------------------------------------------------------------
%% Part 11 –
%% ------------------------------------------------------------------------
% Confusion Matrix

figure()
C_9 = confusionmat(golden_label,alarm_9);
confusionchart(C_9,{'Normal(negative)','VFIB(positive)'});
title('Peak-Peak')
disp(' ')
disp('*********************************************')
disp('Peak-Peak')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_9(1,1)+C_9(2,2))/(C_9(1,1)+C_9(2,2)+C_9(1,2)+C_9(2,1)))])
disp(['Sensitivity  = ', num2str((C_9(2,2))/(C_9(2,2)+C_9(2,1)))])
disp(['Specificity  = ', num2str((C_9(1,1))/(C_9(1,1)+C_9(1,2)))])


figure()
C_10 = confusionmat(golden_label,alarm_10);
confusionchart(C_10,{'Normal','VFIB'});
title('Average of R-peaks Amplitude')
disp(' ')
disp('*********************************************')
disp('Average of R-peaks Amplitude')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_10(1,1)+C_10(2,2))/(C_10(1,1)+C_10(2,2)+C_10(1,2)+C_10(2,1)))])
disp(['Sensitivity  = ', num2str((C_10(2,2))/(C_10(2,2)+C_10(2,1)))])
disp(['Specificity  = ', num2str((C_10(1,1))/(C_10(1,1)+C_10(1,2)))])


figure()
plot(alarm_9)
hold on
plot(alarm_10)
plot(label)
legend ('feture 3 (peak-peak) classification', 'feture 4 (R-peaks) classification', 'golden labels')
xlabel('number of frame')
ylabel ('label index')

%% ------------------------------------------------------------------------
%% Part 12 —
%% ------------------------------------------------------------------------
clc; clear; close all;
fs = 250;
% -------------------------------------------------------------------------
% % n_422
% data = load('n_422.mat');
% Data = data.n_422;
% 
% lables =         [1, 3, 1 , 3, 4, 2];
% Samples_data =  [1, 10711, 11211, 11442, 59711, 61288, length(Data)];
% Parts_data = {};
% number_of_parts = 6;
% -------------------------------------------------------------------------
% n_424

fs = 250;
data = load('n_424.mat');
Data = data.n_424;

lables =         [1, 2, 4, 5, 6];
Samples_data =  [1, 27249, 53673, 55134, 58288, length(Data)];
Parts_data = {};
number_of_parts = 5;

for i = 1:number_of_parts
    Parts_data{i} = Data(Samples_data(i):Samples_data(i+1)); % Data should be changed
end

Parts_data_filtered = {};

for i = 1:number_of_parts
    Parts_data_filtered{i} = Parts_data(i);%filter(bpFilt,cell2mat(Parts_data(i)));
end

dummy_arr = zeros(1,length(Data));

for i = 1:length(Samples_data)-1
    dummy_arr(Samples_data(i):Samples_data(i+1)) = lables(i);
end

% find label
frame_sec = 10;  % sec
overlap = 0.5;    % 50% overlap between consecutive frames
Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames

data_index = 1;

for i = 1:frame_N
    
    index_s = ((i-1)*frame_step+1);
    index_e = ((i-1)*frame_step+frame_length);
    indexes (1,i) = index_s;
    indexes (2,i) = index_e;
    
    for j = index_s+1 :index_e
        if (dummy_arr(j-1) ~= dummy_arr(j))
            label(1,i) = 0;
            break
        end
        label(1,i) = dummy_arr(index_s);
    end
       
end

% Feature Extraction - Frequency Features
Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames
alarm = zeros(frame_N,1);	% initialize output signal to all zeros
t = ([0:frame_N-1]*frame_step+frame_length)/Fs;

for i = 1:frame_N

    seg = Data(((i-1)*frame_step+1):((i-1)*frame_step+frame_length));
    
    N = length(seg);
    xdft = fft(seg);
    % I only need to search 1/2 of xdft for the max because x is real-valued
    xdft(1:N/2+1);
    [Y,I] = max(abs(xdft));
    freq = 0:Fs/N:Fs/2;
    feature(1, i) = freq(I); % Max freq
    feature(2, i) = meanfreq(seg, Fs); % Mean freq
    feature(3, i) = medfreq(seg, Fs); % Med freq
    feature(4, i) = bandpower(seg, Fs, [0 6]); % Band power 0 6
    feature(5, i) = bandpower(seg, Fs, [25 35]);% Band power 25 35
    feature(6, i) = bandpower(seg, Fs, [35 45]);% Band power 35 45
    
end

cell_Feature{12, 2} = {};

for i = 1:6
    cell_Feature{i, 1} = feature(i, find(label == 2)); 
    cell_Feature{i, 2} = feature(i, find(label == 1)); 
end

% Histogram

titles = {'Max Frequency', 'Mean Frequency', 'Median Frequency', 'BandPower 0-6 Hz', ...
    'BandPower 25-35 Hz', 'BandPower 35-45 Hz'};

for i = 1:6

    figure()
    subplot(2, 1, 1)
    min1 = min(min(cell_Feature{i, 1}), min(cell_Feature{i, 2}));
    max1 = max(max(cell_Feature{i, 1}), max(cell_Feature{i, 2}));
    
    histogram(cell_Feature{i, 1}, min1:max1);
    title('VFIB')
    subplot(2, 1, 2)
    histogram(cell_Feature{i, 2}, min1:max1);
    title('Normal')
    sgtitle(titles{i});

end

% feature selected 2 & 5
alarm_2 = va_detect(Data,fs, 1, 2, 1, 2)';
alarm_5 = va_detect(Data,fs, 14, 1, 2, 5)';

% confusionmatrix 
golden_label = label;
golden_label(find(golden_label== 0)) = NaN;
golden_label(find(golden_label== 3)) = NaN;
golden_label(find(golden_label== 4)) = NaN;
golden_label(find(golden_label== 5)) = NaN;
golden_label(find(golden_label== 6)) = NaN;

figure()
C_3 = confusionmat(golden_label,alarm_2);
confusionchart(C_3,{'Normal(negative)','VFIB(positive)'});
title('Mean Frequency')
disp(' ')
disp('*********************************************')
disp('Mean Frequency')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_3(1,1)+C_3(2,2))/(C_3(1,1)+C_3(2,2)+C_3(1,2)+C_3(2,1)))])
disp(['Sensitivity  = ', num2str((C_3(2,2))/(C_3(2,2)+C_3(2,1)))])
disp(['Specificity  = ', num2str((C_3(1,1))/(C_3(1,1)+C_3(1,2)))])


figure()
C_5 = confusionmat(golden_label,alarm_5);
confusionchart(C_5,{'Normal(negative)','VFIB(positive)'});
title('Band power 25-35 feture')
disp(' ')
disp('*********************************************')
disp('Band power 25-35 feture')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_5(1,1)+C_5(2,2))/(C_5(1,1)+C_5(2,2)+C_5(1,2)+C_5(2,1)))])
disp(['Sensitivity  = ', num2str((C_5(2,2))/(C_5(2,2)+C_5(2,1)))])
disp(['Specificity  = ', num2str((C_5(1,1))/(C_5(1,1)+C_5(1,2)))])

figure()
plot(alarm_2)
hold on
plot(alarm_5)
plot(label)
legend ('feture 3 (Mean) classification', 'feture 5 (Band Power) classification', 'golden labels')
xlabel('number of frame')
ylabel ('label index')

% Feature Extraction - Morphologic Features
Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames
alarm = zeros(frame_N,1);	% initialize output signal to all zeros
t = ([0:frame_N-1]*frame_step+frame_length)/Fs;

for i = 1:frame_N

    seg = Data(((i-1)*frame_step+1):((i-1)*frame_step+frame_length));
    
    N = length(seg);

    feature(7, i) = max(seg); 
    feature(8, i) = min(seg);
    feature(9, i) = max(seg) - min(seg);
    feature(10, i) = mean(findpeaks(seg, 'MinPeakHeight',100,'MinPeakDistance',200));
    feature(11, i) = sum(seg == 0);
    feature(12, i) = var(seg);
    
end

for i = 7:12
    cell_Feature{i, 1} = feature(i, find(label == 2)); 
    cell_Feature{i, 2} = feature(i, find(label == 1)); 
end

% Histogram

titles = {'Maximum Amplitude', 'Minimum Amplitude', 'Peak-Peak', 'Average of R-peaks Amplitude', ...
    'Number of zero crossing', 'Variance of amplitudes'};

for i = 7:12

    figure()
    subplot(2, 1, 1)
    min1 = min(min(cell_Feature{i, 1}), min(cell_Feature{i, 2}));
    max1 = max(max(cell_Feature{i, 1}), max(cell_Feature{i, 2}));
    
    histogram(cell_Feature{i, 1}, min1:max1);
    title('VFIB')
    subplot(2, 1, 2)
    histogram(cell_Feature{i, 2}, min1:max1);
    title('Normal')
    sgtitle(titles{i-6});

end

% Rpeaks < 250 10
% peak to peak < 600 9

% feature selected 9 & 11
alarm_9 = va_detect(Data,fs, 320, 1, 2, 9)';
alarm_11 = va_detect(Data,fs, 10, 2, 1, 11)';

% Confusion Matrix

figure()
C_9 = confusionmat(golden_label,alarm_9);
confusionchart(C_9,{'Normal(negative)','VFIB(positive)'});
title('Peak-Peak')
disp(' ')
disp('*********************************************')
disp('Peak-Peak')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_9(1,1)+C_9(2,2))/(C_9(1,1)+C_9(2,2)+C_9(1,2)+C_9(2,1)))])
disp(['Sensitivity  = ', num2str((C_9(2,2))/(C_9(2,2)+C_9(2,1)))])
disp(['Specificity  = ', num2str((C_9(1,1))/(C_9(1,1)+C_9(1,2)))])


figure()
C_10 = confusionmat(golden_label,alarm_11);
confusionchart(C_10,{'Normal','VFIB'});
title('Number of zero crossing')
disp(' ')
disp('*********************************************')
disp('Number of zero crossing')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_10(1,1)+C_10(2,2))/(C_10(1,1)+C_10(2,2)+C_10(1,2)+C_10(2,1)))])
disp(['Sensitivity  = ', num2str((C_10(2,2))/(C_10(2,2)+C_10(2,1)))])
disp(['Specificity  = ', num2str((C_10(1,1))/(C_10(1,1)+C_10(1,2)))])


%% ------------------------------------------------------------------------
%% Part 14 ”
%% ------------------------------------------------------------------------
clc; clear; close all;
fs = 250;

% n_426
fs = 250;
data = load('n_426.mat');
Data = data.n_426;

lables =         [1, 2];
Samples_data =  [1, 26432, length(Data)];
Parts_data = {};
number_of_parts = 2;

for i = 1:number_of_parts
    Parts_data{i} = Data(Samples_data(i):Samples_data(i+1)); % Data should be changed
end

Parts_data_filtered = {};

for i = 1:number_of_parts
    Parts_data_filtered{i} = Parts_data(i);%filter(bpFilt,cell2mat(Parts_data(i)));
end

dummy_arr = zeros(1,length(Data));

for i = 1:length(Samples_data)-1
    dummy_arr(Samples_data(i):Samples_data(i+1)) = lables(i);
end

% find label
frame_sec = 10;  % sec
overlap = 0.5;    % 50% overlap between consecutive frames
Fs = 250;
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(Data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames

data_index = 1;

for i = 1:frame_N
    
    index_s = ((i-1)*frame_step+1);
    index_e = ((i-1)*frame_step+frame_length);
    indexes (1,i) = index_s;
    indexes (2,i) = index_e;
    
    for j = index_s+1 :index_e
        if (dummy_arr(j-1) ~= dummy_arr(j))
            label(1,i) = 0;
            break
        end
        label(1,i) = dummy_arr(index_s);
    end
       
end


% confusionmatrix 
golden_label = label;
golden_label(find(golden_label== 0)) = NaN;
golden_label(find(golden_label== 3)) = NaN;
golden_label(find(golden_label== 4)) = NaN;
golden_label(find(golden_label== 5)) = NaN;
golden_label(find(golden_label== 6)) = NaN;

% Rpeaks < 250 10
% peak to peak < 600 9

alarm_9 = va_detect(Data,fs, 600, 1, 2, 9)';

% Confusion Matrix

figure()
C_9 = confusionmat(golden_label,alarm_9);
confusionchart(C_9,{'Normal(negative)','VFIB(positive)'});
title('Peak-Peak')
disp(' ')
disp('*********************************************')
disp('Peak-Peak')
disp('*********************************************')
disp(['Accuracy     = ', num2str((C_9(1,1)+C_9(2,2))/(C_9(1,1)+C_9(2,2)+C_9(1,2)+C_9(2,1)))])
disp(['Sensitivity  = ', num2str((C_9(2,2))/(C_9(2,2)+C_9(2,1)))])
disp(['Specificity  = ', num2str((C_9(1,1))/(C_9(1,1)+C_9(1,2)))])


% alarm_5 = va_detect(Data,fs, 80, 1, 2, 5)';
% 
% 
% figure()
% C_5 = confusionmat(golden_label,alarm_5);
% confusionchart(C_5,{'Normal(negative)','VFIB(positive)'});
% title('Band power 25-35 feture')
% disp(' ')
% disp('*********************************************')
% disp('Band power 25-35 feture')
% disp('*********************************************')
% disp(['Accuracy     = ', num2str((C_5(1,1)+C_5(2,2))/(C_5(1,1)+C_5(2,2)+C_5(1,2)+C_5(2,1)))])
% disp(['Sensitivity  = ', num2str((C_5(2,2))/(C_5(2,2)+C_5(2,1)))])
% disp(['Specificity  = ', num2str((C_5(1,1))/(C_5(1,1)+C_5(1,2)))])


