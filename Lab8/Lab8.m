%% Lab Num              8
%% modified             1400/10/01
%% Navid Naderi         96102556
%% Amirhossein Asadian  96101187
%% Initialize
clc; clear; close all;

addpath(genpath('S3_Q1_utils'));
addpath(genpath('S3_Q2_utils'));
addpath(genpath('Snakes_demo'));

%% Q1

S3_Q1 = imread('thorax_t1.jpg');
S3_Q1 = double(S3_Q1(:,:,1));

% lung0
lung_p1 = S3_Q1(92, 92);
lung_p2 = S3_Q1(73, 168);

u_th_lung = 30;
l_th_lung = 0;
r_lung = region_finder(73+168*256,S3_Q1, u_th_lung, l_th_lung);
l_lung = region_finder(96+96*256,S3_Q1, u_th_lung, l_th_lung);
lung = r_lung + l_lung;

Overlay(S3_Q1,lung)
title('lung region')

% liver
liver_int = S3_Q1(70, 147)
u_th_liver = 110;
l_th_liver = 70;
liver = region_finder(70*256+147,S3_Q1, u_th_liver, l_th_liver);

figure();
Overlay(S3_Q1,liver)
title('liver regoin')

%% Q2 Using imsegkmeans function

t1 = imread('t1.jpg');
t2 = imread('t2.jpg');
pd = imread('pd.jpg');

t1 = double(t1(:,:,1));
t2 = double(t2(:,:,1));
pd = double(pd(:,:,1));

img(1:249, 1:213, 1) = t1;
img(1:249, 1:213, 2) = t2;
img(1:249, 1:213, 3) = pd;

num_Clus = 4;

[L,Centers] = imsegkmeans(uint8(img), num_Clus);

img_clustered = zeros(249, 213, num_Clus);

figure()
for i = 1:num_Clus
    img_clustered(:, :, i) = (L == i) * 255;
    
    subplot(ceil(num_Clus/2), 2, i)
    imshow(img_clustered(:, :, i), []);
end

%% Q2 Using kmeans function

t1 = imread('t1.jpg');
t2 = imread('t2.jpg');
pd = imread('pd.jpg');

t1 = double(t1(:,:,1));
t2 = double(t2(:,:,1));
pd = double(pd(:,:,1));

img(1:249, 1:213, 1) = t1;
img(1:249, 1:213, 2) = t2;
img(1:249, 1:213, 3) = pd;

num_Clus = 6;

[m, n, d] = size((img));
N = m*n;
X = reshape((img), N, d);

[L,Centers] = kmeans(X, num_Clus);

L = reshape(L, m, n, []);

img_clustered = zeros(249, 213, num_Clus);

figure()
for i = 1:num_Clus
    img_clustered(:, :, i) = (L == i) * 255;
    
    subplot(ceil(num_Clus/2), 2, i)
    imshow(img_clustered(:, :, i), []);
end

%% Q3

t1 = imread('t1.jpg');
t2 = imread('t2.jpg');
pd = imread('pd.jpg');

t1 = double(t1(:,:,1));
t2 = double(t2(:,:,1));
pd = double(pd(:,:,1));

img(1:249, 1:213, 1) = t1;
img(1:249, 1:213, 2) = t2;
img(1:249, 1:213, 3) = pd;

num_Clus = 6;

[m, n, d] = size((img));
N = m*n;
X = reshape((img), N, d);

L = Kmeans(X', num_Clus, randperm(200, 6));

L = reshape(L, m, n, []);

img_clustered = zeros(249, 213, num_Clus);

figure()
for i = 1:num_Clus
    img_clustered(:, :, i) = (L == i) * 255;
    
    subplot(ceil(num_Clus/2), 2, i)
    imshow(img_clustered(:, :, i), []);
end

%% Q4

t1 = imread('t1.jpg');
t2 = imread('t2.jpg');
pd = imread('pd.jpg');

t1 = double(t1(:,:,1));
t2 = double(t2(:,:,1));
pd = double(pd(:,:,1));

img(1:249, 1:213, 1) = t1;
img(1:249, 1:213, 2) = t2;
img(1:249, 1:213, 3) = pd;

num_Clus = 6;

[m, n, d] = size((img));
N = m*n;
X = reshape((img), N, d);

[Centers, U] = fcm(X, num_Clus);

[~, U] = max(U, [], 1);

L = reshape(U, m, n, []);

img_clustered = zeros(249, 213, num_Clus);

figure()
for i = 1:num_Clus
    img_clustered(:, :, i) = (L == i) * 255;
    
    subplot(ceil(num_Clus/2), 2, i)
    imshow(img_clustered(:, :, i), []);
end
