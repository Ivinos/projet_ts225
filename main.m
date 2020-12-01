clear;
close all;
clc;

%% ZEBARTI

img = double(imread('../code_barre.png'));
size(img)
img_bw = (img(:,:,1) + img(:,:,2) + img(:,:,3))/3;

imshow(uint8(img_bw))

[X, Y] = ginput(2)
X=[90 460];
Y=[145 130];
segment_len = sqrt((X(1) - X(2))^2 + (Y(1) - Y(2))^2); % Distance en pixel

U = floor(2*segment_len);

M = zeros(U, 2);
u = 1:U;



M(:, 1) = floor(X(1) + (u/(U-1))*(X(2) - X(1)));
M(:, 2) = floor(Y(1) + (u/(U-1))*(Y(2) - Y(1)));

for i=1:length(M)
   profil(i)=img_bw(M(i,2),M(i,1)); 

end

seuil=graythresh(uint8(profil))
n1=1;
while profil(n1)>seuil*255
   n1=n1+1;
end
n2=length(profil);
while profil(n2)>seuil*255
    n2=n2-1;
end
figure,
subplot(2,3,5),plot(profil);
profil=profil(n1:n2);
code=[];
for i=1:length(profil)
    if profil(i)>seuil*255
        code=[code 255*ones(500,1)];
    else
        code=[code ones(500,1)];
    end
end
subplot(2,2,1),imshow(imbinarize(img_bw,255*seuil));
hold on,
plot(X,Y);
hold off;
subplot(2,3,2),plot(profil);
subplot(2,3,3), hist(profil,100);
subplot(2,3,4),imshow(uint8(code));

ylim([0 255]);


