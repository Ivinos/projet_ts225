function affichage_profil(img_bw,profil,profil_tronque,seuil,Dlabel,X,Y)
    figure,
    subplot(2,3,5),plot(profil_tronque);
    title('Profil tronque');
    histo=hist(profil,256);
    max(histo);
    subplot(2,3,1),imshow(uint8(img_bw));
    title('Image originale');
    hold on,
    plot(X,Y);
    hold off;
    subplot(2,3,2),plot(profil);
    title('Profil brut');
    subplot(2,3,3),hist(profil,256);
    title('Histogramme avec seuil');
    hold on;
    plot([seuil*256 seuil*256],[1,max(histo)]);
    hold off;
    subplot(2,3,4),imshow(uint8(Dlabel));
    title('Code-barre recompose');
    ylim([0 255]);
    subplot(2,3,6),imshow(imbinarize(img_bw,255*seuil));
    title('Image binarisee');




end