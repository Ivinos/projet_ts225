clear;
close all;
clc;

%% ZEBARTI

img = double(imread('code_barre_ref.png'));

img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imshow(uint8(img_bw))

[X, Y] = ginput(2);

%X = [90, 460];
%Y = [145, 130];

segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U+1, 2); % Pas sûr sur le +1 ajouté
u = 1:U+1; % Pas sûr sur le +1 ajouté

M(:, 1) = floor(X(1) + (u/(U-1))*(X(2) - X(1)));
M(:, 2) = floor(Y(1) + (u/(U-1))*(Y(2) - Y(1)));


for i=1:length(M)
    profil(i) = img_bw(M(i,2), M(i,1));
end

figure, plot(profil)

% Un histo établit des intervalles de valeurs
N = 256;
histogram = hist(profil, N);
% figure, plot(histogram);
len = length(profil);

for k=1:N
    somme1 = 0; somme2 = 0;
    for i=1:k
        somme1 = somme1 + histogram(i);
        somme2 = somme2 + i*histogram(i);
    end
    omega(k) = somme1/len;
    mu(k) = somme2/len;
end

for k=1:N
   crit(k) = omega(k)*((mu(N)-mu(k))^2) + (1-omega(k))*(mu(k)^2); % Pas mu(N-1) car matlab
end

[val_max, index_max] = max(crit);
%index_max = 128;

profil_binarise(profil > index_max) = 1;
profil_binarise(profil <= index_max) = 0;

index_zeros = find(~profil_binarise);
index_premiere_val = index_zeros(1);
index_derniere_val = index_zeros(end);

disp(M(index_derniere_val, 1))

X_ = [M(index_premiere_val, 1), M(index_derniere_val, 1)];
Y_ = [M(index_premiere_val, 2), M(index_derniere_val, 2)];

%% Extraction de la deuxième signature

L = 95; % Points à extraire

M = zeros(L, 2);
u = 1:L;

M(:, 1) = floor(X_(1) + (u/(L-1))*(X_(2) - X_(1)));
M(:, 2) = floor(Y_(1) + (u/(L-1))*(Y_(2) - Y_(1)));


for i=1:length(M)
    profil2(i) = img_bw(M(i,2), M(i,1));
end

figure, plot(profil2)

% On réutilise le même seuil
profil_binarise2(profil2 > index_max) = 1;
profil_binarise2(profil2 <= index_max) = 0;

img_verif = zeros(100, length(profil_binarise2));

for i=1:length(profil_binarise2)
   img_verif(:, i) = profil_binarise2(i); 
end

img_verif = imresize(img_verif, 3);

figure, imshow(img_verif);

