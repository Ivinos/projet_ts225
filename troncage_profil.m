function profil_tronque=troncage_profil(profil,seuil)
        n1=1;
    while (profil(n1)>seuil*256)
       n1=n1+1;
       if n1==length(profil)
          n1=1; 
          break;
       end
    end
    n2=length(profil);
    while (profil(n2)>seuil*256)
        n2=n2-1;
        if n2==1
           n2=length(profil);
           break;
        end
    end
    profil_tronque=[];
    for i=1:length(profil)
        if profil(i)>seuil*255
            profil_tronque=[profil_tronque 255*ones(500,1)];
        else
            profil_tronque=[profil_tronque ones(500,1)];
        end
    end
    figure,plot(profil_tronque);
    n1
    n2
end