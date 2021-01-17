function affichage_profil(img_bw,profil,profil_tronque,seuil,Dlabel,X,Y)
    code_recompose=[];
    for i=1:length(profil_tronque)
        if profil_tronque(i)>seuil*255
            code_recompose=[code_recompose 255*ones(round(length(profil_tronque)/2),1)];
        else
            code_recompose=[code_recompose ones(round(length(profil_tronque)/2),1)];
        end
    end
;
    histo=hist(profil,256);
    max(histo);
    figure,subplot(1,2,1),imshow(uint8(img_bw));
    title('Image originale');
    hold on,
    plot(X,Y);
    hold off;
    subplot(1,2,2),imshow(uint8(code_recompose));
    title('Code-barre recompose');
    figure,
    subplot(1,2,1),plot(profil_tronque);
    title('Profil tronque')
    subplot(1,2,2),plot(profil);
    title('Profil brut');

    ylim([0 255]);
    figure,subplot(1,2,1),hist(profil,256);
    title('Histogramme avec seuil');
    hold on;
    plot([seuil*256 seuil*256],[1,max(histo)]);
    hold off;
    subplot(1,2,2),imshow(imbinarize(img_bw,255*seuil));
    title('Image binarisee');




end