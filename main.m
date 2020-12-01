clear;
close all;
clc;

%% ZEBARTI

img = double(imread('../code_barre.png'));

img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imshow(uint8(img_bw))

[X, Y] = ginput(2);

segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U, 2);
u = 1:U;



M(:, 1) = floor(X(1) + (u/(U-1))*(X(2) - X(1)));
M(:, 2) = floor(Y(1) + (u/(U-1))*(Y(2) - Y(1)));

for i=1:length(M)
   profil(i)=img_bw(M(i,2),M(i,1)); 

end
code=[];
for i=1:length(profil)
    if profil(i)>125
        code=[code 255*ones(500,1)];
    else
        code=[code ones(500,1)];
    end
end
size(code)
plot(profil);
figure, hist(profil,255);
figure,
imshow(graythresh(uint8(code));
ylim([0 255]);


