clear;
close all;
clc;

%% ZEBARTI

img = double(imread('code_barre_livre.jpg'));

%img_bw = img; % Si l'image est d�j� en noir et blanc
img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

figure('name', 'image de base en noir et blanc'), imshow(uint8(img_bw));

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

%figure('Name', 'z'), plot(profil);

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

X_ = [M(index_premiere_val, 1)+2, M(index_derniere_val, 1)]; % !!!!!! le "+2" est un test mais wola c'est ça
Y_ = [M(index_premiere_val, 2)-2, M(index_derniere_val, 2)]; % !!!!! pareil le -2 est douteux mais c'est pour centrer

%% Extraction de la deuxième signature

L = 95; % Points à extraire

M = zeros(L, 2);
u = 0:L-1;

M(:, 1) = floor(X_(1) + (u/(L-1))*(X_(2) - X_(1)));
M(:, 2) = floor(Y_(1) + (u/(L-1))*(Y_(2) - Y_(1)));


for i=1:length(M)
    profil2(i) = img_bw(M(i,2), M(i,1));
end

%figure('Name', 't'), plot(profil2);

% On réutilise le même seuil
profil_binarise2(profil2 > index_max) = 1;
profil_binarise2(profil2 <= index_max) = 0;

img_verif = zeros(100, length(profil_binarise2));

for i=1:length(profil_binarise2)
   img_verif(:, i) = profil_binarise2(i); 
end

img_verif = imresize(img_verif, 3);

figure('Name', 'Résultat (WIP)'), imshow(img_verif);

figure;
imshow(uint8(img_bw));
hold on;
scatter(M(:,1), M(:,2));
hold off;


%% Décodage

Ele_A = [1 1 1 0 0 1 0; 1 1 0 0 1 1 0; 1 1 0 1 1 0 0; 1 0 0 0 0 1 0; 1 0 1 1 1 0 0; 1 0 0 1 1 1 0; 1 0 1 0 0 0 0; 1 0 0 0 1 0 0; 1 0 0 1 0 0 0; 1 1 1 0 1 0 0];
Ele_B = [1 0 1 1 0 0 0; 1 0 0 1 1 0 0; 1 1 0 0 1 0 0; 1 0 1 1 1 1 0; 1 1 0 0 0 1 0; 1 0 0 0 1 1 0; 1 1 1 1 0 1 0; 1 1 0 1 1 1 0; 1 1 1 0 1 1 0; 1 1 0 1 0 0 0];
Ele_C = [0 0 0 1 1 0 1; 0 0 1 1 0 0 1; 0 0 1 0 0 1 1; 0 1 1 1 1 0 1; 0 1 0 0 0 1 1; 0 1 1 0 0 0 1; 0 1 0 1 1 1 1; 0 1 1 1 0 1 1; 0 1 1 0 1 1 1; 0 0 0 1 0 1 1];

codage_pre_chiffre = [1 1 1 1 1 1; 1 1 2 1 2 2; 1 1 2 2 1 2; 1 1 2 2 2 1; 1 2 1 1 2 2; 1 2 2 1 1 2; 1 2 2 2 1 1; 1 2 1 2 1 2; 1 2 1 2 2 1; 1 2 2 1 2 1];

garde_normale = [0 1 0];
garde_centrale = [1 0 1 0 1];

% Cohérence avec les gardes

bool = 1; % booléen de cohérence (si 1 c'est cohérent sinon pas non)

if ~(garde_normale == profil_binarise2(1, (1:3)))
    bool = 0;
end
    
if ~(garde_centrale == profil_binarise2(1, (46:50)))
    bool = 0;
end
 
if ~(garde_normale == profil_binarise(1, (93:95)))
    bool = 0;
end

% Décodage

res = zeros(1, 13);
res_ele = zeros(1, 13); % Covention : 1 = A, 2 = B, 3 = C

for i=4:7:45
    for j=1:10
        if (Ele_A(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i-4)/7 + 2) = j-1; % i-4 pour enelever les 3 val de la garde puis + 2 pour index matlab et décalage val
            res_ele(1, (i-4)/7 + 2) = 1;
        end
        
        if (Ele_B(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i-4)/7 + 2) = j-1;
            res_ele(1, (i-4)/7 + 2) = 2;
        end
        
        if (Ele_C(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i-4)/7 + 2) = j-1;
            res_ele(1, (i-4)/7 + 2) = 3;
        end
    end
end

for i=51:7:92
    for j=1:10
        if (Ele_A(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i+5)/7) = j-1; % i+ la garde de 5 divisé par 7
            res_ele(1, (i+5)/7) = 1;
        end
        
        if (Ele_B(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i+5)/7) = j-1;
            res_ele(1, (i+5)/7) = 2;
        end
        
        if (Ele_C(j, :) == profil_binarise2(1, (i:i+6)))
            res(1, (i+5)/7) = j-1;
            res_ele(1, (i+5)/7) = 3;
        end
    end
end

for i=1:10
   if (codage_pre_chiffre(i, 1:6) == res_ele(1, (2:7)))
       res(1,1) = i-1;
   end
end


    
    
% bwlabel pour labélliser (suite du sujet)
