function thresh=otsu(Image)
    imshow(uint8(Image));
    %Image = imread('../code_barre.png');
    [Colonne Ligne] = size(Image);
    NBTotal = Colonne*Ligne;
    img_hist = imhist(uint8(Image))';
    Proba= img_hist/NBTotal;
    for i = 1 : 255    
        proba1 = Proba(1:i);
        proba2 = Proba(i+1:256);
        p1 = sum(proba1);
        p2 = sum(proba2);
        n1 = 0:i-1;
        n2 = i:255;
        moyenne1 = sum( n1.*proba1)/p1;
        moyenne2 = sum( n2.*proba2)/p2;
        variance1 = sum(((n1-moyenne1).^2).*proba1);
        variance2 = sum(((n2-moyenne2).^2).*proba2);
        Var_Intra_Classe(i) = variance1 + variance2;
    end
    [Val,Indice] = min(Var_Intra_Classe(1:255));
    thresh = (Indice-1)/255
end