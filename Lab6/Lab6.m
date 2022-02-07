%% Lab Num              6
%% modified             1400/09/17
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

addpath(genpath('S1_Q1_utils'));
addpath(genpath('S1_Q2_utils'));
addpath(genpath('S1_Q3_utils'));
addpath(genpath('S1_Q4_utils'));
addpath(genpath('S1_Q5_utils'));

%% Q1


S1_Q1 = imread('t1.jpg');
imshow(S1_Q1)
title('T1.jpg')

%% 
img = S1_Q1(:, :, 1);

n = 1024;
y = fft(img(128, :), n);
m = abs(y);
p = unwrap(angle(y));
f = (0: length(y) -1) * 100 / length(y);

subplot (2,1,1)
plot (f, m)
title ( 'Magnitude' )
ax = gca;
ax.XTick = [15 40 60 85];

subplot (2,1,2)
plot (f, p * 180 / pi)
title ( 'Phase' )
ax = gca;
ax.XTick = [15 40 60 85];

%%
img2D = double(img);
fft_img = fft2(img2D);

% imshow(log(abs(fftshift(fft_img))));
figure()
subplot(1, 2, 1)
imshow(img)
title('The Original Image');
subplot(1, 2, 2)
imagesc(log10(abs(fftshift(fft_img))));
title('log - abs - fftshift');

figure()
subplot(1, 2, 1)
imshow(img)
title('The Original Image');
subplot(1, 2, 2)
imagesc(log10(abs((fft_img))));
title('log - abs');

%% Q2

imageSize = size(zeros(256,256));
ci = [256/2, 256/2, 15];     % center and radius of circle ([c_row, c_col, r])
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
G = double((xx.^2 + yy.^2) < ci(3)^2);
imshow(G);
axis('on', 'image');
title('G');

F = (zeros(256,256));
F(100, 50) = 1;
F(120, 48) = 2;

subplot(1, 3, 1)
imshow(G)
title('G');
subplot(1, 3, 2)
imshow(F)
title('F');
subplot(1, 3, 3)

CFG = (conv2(F, G, 'same'));
CFG = CFG./max(max(CFG));
imshow(CFG)
title('Convolution of F and G');

%% 

S1_Q2 = imread('pd.jpg');

img2 = S1_Q2(:, :, 1);

subplot(1, 2, 1)
imshow(img2)
title('Image 2');
subplot(1, 2, 2)
CFG = conv2((img2), (G),'same');
CFG = CFG./max(max(CFG));
imshow((CFG))
title('Convolution of Image 2 and G');

%% Q3

S1_Q3 = imread('ct.jpg');
% subplot(2,1,1)
% imshow(S1_Q2);
k = fft2(S1_Q3(:, :, 1));
k = fftshift(k);
k = padarray(k,[256, 256]/8,'both');
k = ifftshift(k);
mat2 = ifft2(k);
% subplot(2,1,2)
% imshow(mat2);

subplot(1,2,1); imshow(real(mat2)); title('real part')
subplot(1,2,2); imshow(imag(mat2)); title('imaginary part')

%% Q4_1

S1_Q4 = imread('ct.jpg');
img3 = S1_Q4(:, :, 1);
H=fftshift(fft2(img3)); %// Compute 2D Fourier Transform
x0=40; %// Define shifts
y0=20;

[xF,yF] = meshgrid((1:256)-128,(1:256)-128);

H=H.*exp(-1i*2*pi.*(xF*x0+yF*y0)/256);

figure()
plot(abs(fft(exp(-1i*2*pi.*(xF*x0+yF*y0)/256))));

IF_image=ifft2(ifftshift(H));
IF_image = IF_image / max(max(IF_image));

figure;
subplot(1,2,1);
imshow(img3);
subplot(1,2,2);
imshow(real(IF_image));

%% Q4_2

F = fftshift(fft2(ifftshift(img3)));
G = imrotate(F, 30, 'bicubic','crop');
g = fftshift(ifft2(ifftshift(G)));

figure()
subplot(1, 2, 1)
imshow(img3)
subplot(1, 2, 2)
imshow(real(g),[])

%% Q5

S1_Q5 = imread('t1.jpg');
img5 = double(S1_Q5(:, :, 1));
Y1 = circshift(img5,1,1);
Y_img5_1 = (img5 - Y1)/2;
Y2 = circshift(img5,1,2);
Y_img5_2 = (img5 - Y2)/2;

subplot(1, 4, 1)
imshow(img5,[])
title('Original Image');
subplot(1, 4, 2)
imshow(Y_img5_1,[])
title('Horizental Gradian');
subplot(1, 4, 3)
imshow(Y_img5_2,[])
title('Vertical Gradian');
subplot(1, 4, 4)
imshow(sqrt(Y_img5_2.^2+ Y_img5_1.^2),[])
title('Absolute value for Gradian Vector');

%% Q6

figure();
BW1 = edge(img5,'sobel');
imshow(BW1);
title('Sobel')

figure();
BW1 = edge(img5,'canny');
imshow(BW1);
title('CAnny')