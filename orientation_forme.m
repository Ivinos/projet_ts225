function [x1, y1]=orientation_forme(Dlabel)
    mode(mode(Dlabel))
    liste=Dlabel(:);
    Dlabel=(Dlabel==mode(mode(nonzeros(liste))));
    figure,imshow(Dlabel);
    taille=size(Dlabel);
    moy_x=0;
    moy_y=0;
    points=0;
    for i=1:taille(1)
       for j=1:taille(2) 
            if Dlabel(i,j)>0
                moy_x=moy_x+i;
                moy_y=moy_y+j;
                points=points+1;
            end         
       end
    end
    moy_x=moy_x/points;
    moy_y=moy_y/points;
    somme_xx=0;
    somme_yy=0;
    somme_xy=0;
    somme_yx=0;
    for i=1:taille(1)
       for j=1:taille(2)
           if Dlabel(i,j)>0
            somme_xx=somme_xx+(i-moy_x)^2;
            somme_yy=somme_yy+(j-moy_y)^2;
            somme_xy=somme_xy+(i-moy_x)*(j-moy_y);
%            somme_yx=somme_yx+(j-moy_x);
           end
       end
    end
     T=[somme_xx somme_xy;somme_xy somme_yy]
     [val_p, vect_p]=eig(T);
     incr_x=vect_p(1,1)/max(max(vect_p))
     incr_y=vect_p(2,2)/max(max(vect_p))
     figure,imshow(1-Dlabel);
     axis on;
     hold on
     plot(moy_y,moy_x, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
     plot([moy_y-vect_p(2,2) moy_y+vect_p(2,2)],[moy_x-vect_p(1,1) moy_x+vect_p(1,1)]);
     i1=moy_x;
     j1=moy_y;
     i2=moy_x;
     j2=moy_y;
     while Dlabel(round(i1),round(j1))~=0
         i1=i1-incr_x;
         j1=j1+incr_y;
         if i1<1||j1<1
             i1=round(max(1,i1));
             j1=round(max(1,j1));
            break; 
         end
     end
      while Dlabel(round(i2),round(j2))~=0
         i2=i2+incr_x;
         j2=j2-incr_y;
         if i2>taille(1)||j2>taille(2)
             i2=round(min(i2,taille(1)));
             j2=round(min(j2,taille(2)));
             break;
     end
     plot(j1,i1, 'r+', 'MarkerSize', 30, 'LineWidth', 2);
     %plot(j2,i2, 'g+', 'MarkerSize', 30, 'LineWidth', 2);
     x1=[j1 j2];
     y1=[i1 i2];
end