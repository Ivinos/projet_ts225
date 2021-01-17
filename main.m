clear;
close all;
clc;
%% ZEBARTI


img = double(imread('code_barre_vache.jpg'));
[width height]=size(img);

img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

%imshow(uint8(img_bw))

%[X, Y] = ginput(2);

seuil=otsu(img_bw);

D=region(img_bw,2,14);
seuil_binarisation = max(max(D))*0.99;
Dbin= D>seuil_binarisation;

image_bin=Dbin.*img_bw;
Dlabel=label(Dbin);
[X Y]=orientation_forme(Dlabel);


segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U, 2);
u = 1:U;



M(:, 1) = floor(X(1) + (u/(U-1))*(X(2) - X(1)));
M(:, 2) = floor(Y(1) + (u/(U-1))*(Y(2) - Y(1)));

for i=1:length(M)
   
   profil(i)=img_bw(M(i,2),M(i,1)); 
end




profil_tronque=troncage_profil(profil,seuil);
affichage_profil(img_bw,profil,profil_tronque,seuil,Dlabel,X,Y);