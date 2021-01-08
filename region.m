function region(img,sigma_t,sigma_g)
    [x_g y_g]=meshgrid(-3*sigma_g:3*sigma_g);
    %Filtre de Canny
    canny_horiz=-x_g.*exp(-(x_g.^2+y_g.^2)/(2*sigma_g^2)/(2^pi*sigma_g^4));
    canny_verti=-y_g.*exp(-(x_g.^2+y_g.^2)/(2*sigma_g^2)/(2^pi*sigma_g^4));


    gradx=conv2(img,canny_horiz);
    grady=conv2(img,canny_verti);
    gradx=gradx./(sum(sum(sqrt(gradx.^2+grady.^2))));
    grady=grady./(sum(sum(sqrt(gradx.^2+grady.^2))));
    %surf(gradx,'edgecolor','none')
    
    [x_t y_t]=meshgrid(-3*sigma_t:3*sigma_t);
    passe_bas=exp(-(x_t.^2+y_t.^2)/(2*sigma_t^2)/(2*pi*sigma_t^2));
    passe_bas=passe_bas/(sum(sum(passe_bas)));
    Txx=conv2(gradx.*gradx,passe_bas,'same');
    Tyy=conv2(gradx.*grady,passe_bas,'same');
    Txy=conv2(grady.*grady,passe_bas,'same');
    T=[Txx Txy;Txy Tyy];
    D=sqrt((Txx-Tyy).^2+4*(Txy.^2))/(Txx+Tyy);
    D=D./max(max(D));
    seuil=0.99*max(max(D))

    Dbin=D>0.5
    imshow(Dbin);











end