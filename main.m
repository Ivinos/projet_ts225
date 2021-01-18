clear;
close all;
clc;
%% ZEBARTI

img = double(imread('code_barre_jus2.png'));
[width, height]=size(img);

img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imshow(uint8(img_bw))

%[X, Y] = ginput(2);

seuil=otsu(img_bw);
D=region(gradient(img_bw),2,14);
seuil_binarisation = max(max(D))*0.99;
Dbin= D>seuil_binarisation;

image_bin=Dbin.*img_bw;
Dlabel=label(Dbin);
[X, Y]=orientation_forme(Dlabel);

segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U, 2);
u = 1:U;

disp(X)
disp(Y)
M(:, 1) = floor(X(1) + (u/(U-1))*(X(2) - X(1)));
M(:, 2) = floor(Y(1) + (u/(U-1))*(Y(2) - Y(1)));
for i=1:length(M)
   profil(i)=img_bw(M(i,2),M(i,1)); 
end

profil_tronque=troncage_profil(profil,seuil);
profil_binarise=profil_tronque>seuil*255;
affichage_profil(img_bw,profil,profil_tronque,seuil,Dlabel,X,Y);

%% Extraction de la deuxieme signature

index_zeros = find(~profil_binarise);
index_premiere_val = index_zeros(1);
index_derniere_val = index_zeros(end);

disp(M(index_derniere_val, 1))

X_ = [M(index_premiere_val, 1)+2, M(index_derniere_val, 1)]; % !!!!!! le "+2" est un test mais wola c'est ca
Y_ = [M(index_premiere_val, 2)-2, M(index_derniere_val, 2)]; % !!!!! pareil le -2 est douteux mais c'est pour centrer

L = 95; % Points a extraire

M = zeros(L, 2);
u = 0:L-1;

M(:, 1) = floor(X_(1) + (u/(L-1))*(X_(2) - X_(1)));
M(:, 2) = floor(Y_(1) + (u/(L-1))*(Y_(2) - Y_(1)));


for i=1:length(M)
    profil2(i) = img_bw(M(i,2), M(i,1));
end

%figure('Name', 't'), plot(profil2);

% On reutilise le meme seuil
profil_binarise2(profil2 > seuil) = 1;
profil_binarise2(profil2 <= seuil) = 0;

img_verif = zeros(100, length(profil_binarise2));

for i=1:length(profil_binarise2)
   img_verif(:, i) = profil_binarise2(i); 
end

img_verif = imresize(img_verif, 3);

figure('Name', 'R�sultat (WIP)'), imshow(img_verif);

figure;
imshow(uint8(img_bw));
hold on;
scatter(M(:,1), M(:,2));
hold off;

%% Decodage

traduction_code(profil_binarise2)

