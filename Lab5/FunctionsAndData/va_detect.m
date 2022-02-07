function [alarm] = va_detect(ecg_data,Fs, threshold, u_threshold_label, l_threshold_label, feature_index)
%VA_DETECT  ventricular arrhythmia detection skeleton function
%  [ALARM,T] = VA_DETECT(ECG_DATA,FS) is a skeleton function for ventricular
%  arrhythmia detection, designed to help you get started in implementing your
%  arrhythmia detector.
%
%  This code automatically sets up fixed length data frames, stepping through 
%  the entire ECG waveform with 50% overlap of consecutive frames. You can customize 
%  the frame length  by adjusting the internal 'frame_sec' variable and the overlap by
%  adjusting the 'overlap' variable.
%
%  ECG_DATA is a vector containing the ecg signal, and FS is the sampling rate
%  of ECG_DATA in Hz. The output ALARM is a vector of ones and zeros
%  corresponding to the time frames for which the alarm is active (1) 
%  and inactive (0). T is a vector the same length as ALARM which contains the 
%  time markers which correspond to the end of each analyzed time segment. If Fs 
%  is not entered, the default value of 250 Hz is used. 

  %  Template Last Modified: 3/4/06 by Eric Weiss, 1/25/07 by Julie Greenberg


%  Processing frames: adjust frame length & overlap here
%------------------------------------------------------
frame_sec = 10;  % sec
overlap = 0.5;    % 50% overlap between consecutive frames


% Input argument checking
%------------------------
if nargin < 2
    Fs = 250;  % default sample rate
end
if nargin < 1
    error('You must enter an ECG data vector.');
end
ecg_data = ecg_data(:);  % Make sure that ecg_data is a column vector
 

% Initialize Variables
%---------------------
frame_length = round(frame_sec*Fs);  % length of each data frame (samples)
frame_step = round(frame_length*(1-overlap));  % amount to advance for next data frame
ecg_length = length(ecg_data);  % length of input vector
frame_N = floor((ecg_length-(frame_length-frame_step))/frame_step); % total number of frames
alarm = zeros(frame_N,1);	% initialize output signal to all zeros
t = ([0:frame_N-1]*frame_step+frame_length)/Fs;

% Analysis loop: each iteration processes one frame of data
%----------------------------------------------------------

for i = 1:frame_N
    %  Get the next data segment
    seg = ecg_data(((i-1)*frame_step+1):((i-1)*frame_step+frame_length));
    %  Perform computations on the segment . . .
    %  Decide whether or not to set alarm . . .
    
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
    feature(7, i) = max(seg); 
    feature(8, i) = min(seg);
    feature(9, i) = max(seg) - min(seg);
    feature(10, i) = mean(findpeaks(seg, 'MinPeakHeight',100,'MinPeakDistance',200));
    feature(11, i) = sum(seg == 0);
    feature(12, i) = var(seg);
    
    if feature(feature_index, i) > threshold
        alarm(i) = u_threshold_label;
    else
        alarm(i) = l_threshold_label;
    end
end
