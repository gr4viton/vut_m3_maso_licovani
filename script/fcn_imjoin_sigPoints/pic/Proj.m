close all;
clear all;
clc

%% nacteni obrazku
% i1 = rgb2gray(im2double(imread('Infra1_orez3.jpg')));
% v1 = rgb2gray(im2double(imread('Vidit1_orez.jpg')));
% i1 = rgb2gray(im2double(imread('iStrom.jpg')));
% v1 = (im2double(imread('vStrom.jpg')));
 i1 = rgb2gray(im2double(imread('i3.JPG')));
 v1 = rgb2gray(im2double(imread('v3.bmp')));

%% filtrace sumu
i1 = medfilt2(i1,[5 5],'symmetric');
v1 = medfilt2(v1,[5 5],'symmetric');
 
%% zobrazeni vstupu
figure(1);
subplot(1,2,1);
imshow(v1);

subplot(1,2,2);
imshow(i1);

%% korelacni metoda
% method = 'GPU';
method = 'CPU';
scale = 0.5:0.1:2.5;

% vys = imjoin(v1, i1, 1.8:0.1:2.2, method);
% vys = imjoin(v1, i1, 1:0.05:1.5, method);

[vys, x, y, scale] = imjoin(v1, i1, scale, method);
x
y
scale

%% zobrazeni vysledku
figure(2);
imshow(vys,[]);