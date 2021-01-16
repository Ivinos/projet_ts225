function D=region(img, sigma_g, sigma_t)

    [X, Y] = meshgrid(-3*sigma_g:3*sigma_g);
    canny_horiz = -X.*exp(-(X.^2+Y.^2)/(2*sigma_g^2))/(2^pi*sigma_g^4);
    canny_verti = -Y.*exp(-(X.^2+Y.^2)/(2*sigma_g^2))/(2^pi*sigma_g^4);
    gradx = conv2(img,canny_horiz, 'same');
    grady = conv2(img,canny_verti, 'same');
    gradx_norm=gradx./sum(sum(sqrt(gradx.^2 + grady.^2)));
    grady_norm=grady./sum(sum(sqrt(gradx.^2 + grady.^2)));
    [X, Y] = meshgrid(-3*sigma_t:3*sigma_t);
    passe_bas = exp((-X.^2-Y.^2)/(2*sigma_t^2))/(2*pi*sigma_t^2); 
    passe_bas = passe_bas/(sum(sum(passe_bas)));
    Txx=conv2(gradx_norm.^2, passe_bas, 'same');
    Tyy=conv2(grady_norm.^2, passe_bas,'same');
    Txy=conv2(grady_norm.*gradx_norm, passe_bas, 'same');
    D=sqrt((Txx-Tyy).^2 + 4*Txy.^2)./(Txx+Tyy);
    seuil_binarisation = max(max(D))*0.99
    Dbin= D>seuil_binarisation;
    Dbin(1,1)
    figure,
    imshow(Dbin)
    


end

