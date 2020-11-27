clear;
close all;
clc;

%% ZEBARTI

img = double(imread('code_barre.png'));

img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imshow(uint8(img_bw))

[X, Y] = ginput(2);

segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U, 2);
u = 1:U;



M(:, 1) = X(1) + (u/(U-1))*(X(2) - X(1));
M(:, 2) = Y(1) + (u/(U-1))*(Y(2) - Y(1));






