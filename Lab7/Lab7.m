%% Lab Num              7
%% modified             1400/09/24
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

addpath(genpath('S2_Q1_utils'));
addpath(genpath('S2_Q2_utils'));
addpath(genpath('S2_Q3_utils'));
addpath(genpath('S2_Q5_utils'));

%% Q1
S2_Q1 = imread('t2.jpg');
S2_Q1 = double(S2_Q1(:,:,1));
S2_Q1 = S2_Q1/max(max(S2_Q1));

figure
imshow(S2_Q1)

var_local = 0.1;
J = imnoise(S2_Q1,'gaussian',0,var_local);
figure
imshow(J,[])

figure
subplot(1,2,1)
imshow(S2_Q1,[])
title('Orginal Image')

subplot(1,2,2)
imshow(J,[])
title('Noisy Image')

%% 
Kernel = zeros(256,256);
Kernel(128-2:128+1,128-2:128+1) = 1/16;
imshow(Kernel, [])
f_Kernel = fftshift(fft2(Kernel));

f_j = fftshift(fft2(J));
mult_j = f_j .* f_Kernel;
filterd_j = fftshift(ifft2(ifftshift(mult_j)));
figure()
imshow(real(filterd_j), [])


Iblur = imgaussfilt(J,1);


subplot(2,2,1)
imshow(S2_Q1,[])
title('Orginal Image')


subplot(2,2,2)
imshow(J,[])
title('Noisy Image')

subplot(2,2,3)
imshow(real(filterd_j), [])
title('Filtered Image')

subplot(2,2,4)
imshow(Iblur, [])
title('Filtered Image by using imgaussfilt')


%% Q2
clc; clear; close all;
S2_Q2 = imread('t2.jpg');
S2_Q2 = double(S2_Q2(:,:,1));
S2_Q2 = S2_Q2/max(max(S2_Q2));

h = Gaussian(2, [256, 256]);
figure()
imshow(h,[])

H = fftshift(fft2(h));

% H(find(abs(H)<1e-1)) = 0.1+0.1j; 

g = conv2((S2_Q2), (h),'same');
G = fftshift(fft2(g));

F = zeros(256, 256);
for i =1:256
    for j= 1:256
        if(abs(H(i,j))>0.5e-2)
            F(i,j) = G(i,j)./H(i,j);
        end
    end
end
% F = G./(H);
f = fftshift(ifft2(ifftshift(F)));

figure

subplot(2,2,1)
imshow(S2_Q2,[])
title('Orginal Image')

subplot(2,2,2)
imshow(g,[])
title('blurred Image')

subplot(2,2,3)
imshow(f,[])
title('recoverd Image')

%% add noise

var_local = 0.001;
g_noisy = imnoise(g,'gaussian',0,var_local);
G_n = fftshift(fft2(g_noisy));

F_2 = zeros(256, 256);
for i =1:256
    for j= 1:256
        if(abs(H(i,j))>0.5e-1)
            F_2(i,j) = G_n(i,j)./H(i,j);
        end
    end
end

f_2 = fftshift(ifft2(ifftshift(F_2)));

figure()
subplot(2,2,1)
imshow(S2_Q2,[])
title('Orginal Image')

subplot(2,2,2)
imshow(g,[])
title('blurred Image')

subplot(2,2,4)
imshow(g_noisy,[])
title('(blurred + noisy) Image')

subplot(2,2,3)
imshow(f_2,[])
title('recoverd Image')

%% Q3
clc; clear; close all;
S2_Q3 = imread('t2.jpg');
S2_Q3 = double(S2_Q3(:,:,1));
% S2_Q3 = S2_Q3/max(max(S2_Q3));
f = imresize(S2_Q3,1/4);

K = zeros(256, 256);
K(1:3, 1:3) = [0, 1, 0; 1, 2, 1; 0, 1, 0];

img_size = 64;
K = K(1:img_size, 1:img_size); 
K1 = reshape(K,1,[]);

D = zeros(img_size*img_size); 

for i = 1:64*64
    D(i,:) = circshift(K1,i-1);
end

f = reshape(f,1,[]);
g = D * f';

noise = 0.05 * randn(1, 64*64)';

g_n = g+noise;
inv_D = inv(D);
f_hat = inv_D * g_n;

f_hat = reshape(f_hat, 64,64);

figure()
subplot(2,2,1)
imshow(reshape(f, [64,64]),[])
title('Orginal Image')

subplot(2,2,2)
imshow(reshape(g, [64,64]),[])
title('g')

subplot(2,2,3)
imshow(reshape(g_n, [64,64]),[])
title('g + noise')

subplot(2,2,4)
imshow(f_hat,[])
title('recoverd Image')

%% Q4 

num_itr = 100;
Norm = [];
f = zeros(4096, num_itr);

for i = 2:num_itr
   f(:, i) = f(:, i-1) + 0.01 * inv_D * (g_n - D * f(:, i-1));
end

figure()
subplot(2, 1, 1)
imshow(reshape(g_n,64, 64), [])
subplot(2, 1, 2)
imshow(reshape(f(:, num_itr),64, 64), []) 

for i = 2:num_itr
   Norm(i) = norm(f(i, :) - f(i-1, :), 2) / norm(f(i-1, :), 2); 
end

figure()
plot(Norm);

