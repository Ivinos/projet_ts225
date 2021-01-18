function traduction_code(profil_binarise)
        

    % Codes EAN

    Ele_A = [1 1 1 0 0 1 0; 1 1 0 0 1 1 0; 1 1 0 1 1 0 0; 1 0 0 0 0 1 0; 1 0 1 1 1 0 0; 1 0 0 1 1 1 0; 1 0 1 0 0 0 0; 1 0 0 0 1 0 0; 1 0 0 1 0 0 0; 1 1 1 0 1 0 0];
    Ele_B = [1 0 1 1 0 0 0; 1 0 0 1 1 0 0; 1 1 0 0 1 0 0; 1 0 1 1 1 1 0; 1 1 0 0 0 1 0; 1 0 0 0 1 1 0; 1 1 1 1 0 1 0; 1 1 0 1 1 1 0; 1 1 1 0 1 1 0; 1 1 0 1 0 0 0];
    Ele_C = [0 0 0 1 1 0 1; 0 0 1 1 0 0 1; 0 0 1 0 0 1 1; 0 1 1 1 1 0 1; 0 1 0 0 0 1 1; 0 1 1 0 0 0 1; 0 1 0 1 1 1 1; 0 1 1 1 0 1 1; 0 1 1 0 1 1 1; 0 0 0 1 0 1 1];

    codage_pre_chiffre = [1 1 1 1 1 1; 1 1 2 1 2 2; 1 1 2 2 1 2; 1 1 2 2 2 1; 1 2 1 1 2 2; 1 2 2 1 1 2; 1 2 2 2 1 1; 1 2 1 2 1 2; 1 2 1 2 2 1; 1 2 2 1 2 1];

    garde_normale = [0 1 0];
    garde_centrale = [1 0 1 0 1];

    % Coherence avec les gardes

    bool = 1; % booleen de coherence (si 1 c'est coherent sinon pas non)

    if ~(garde_normale == profil_binarise(1, (1:3)))
        bool = 0;
    end

    if ~(garde_centrale == profil_binarise(1, (46:50)))
        bool = 0;
    end

    if ~(garde_normale == profil_binarise(1, (93:95)))
        bool = 0;
    end
    
    disp(bool); % Il faudrait rajouter un truc si c'est pas coherent

    % Decodage

    res = zeros(1, 13);
    res_ele = zeros(1, 13); % Covention : 1 = A, 2 = B, 3 = C

    for i=4:7:45
        for j=1:10
            if (Ele_A(j, :) == profil_binarise(1, (i:i+6)))
                res(1, (i-4)/7 + 2) = j-1; % i-4 pour enelever les 3 val de la garde puis + 2 pour index matlab et decalage val
                res_ele(1, (i-4)/7 + 2) = 1;
            end

            if (Ele_B(j, :) == profil_binarise(1, (i:i+6)))
                res(1, (i-4)/7 + 2) = j-1;
                res_ele(1, (i-4)/7 + 2) = 2;
            end

            if (Ele_C(j, :) == profil_binarise(1, (i:i+6)))
                res(1, (i-4)/7 + 2) = j-1;
                res_ele(1, (i-4)/7 + 2) = 3;
            end
        end
    end

    for i=51:7:92
        for j=1:10
            if (Ele_A(j, :) == profil_binarise(1, (i:i+6)))
                res(1, (i+5)/7) = j-1; % i+ la garde de 5 divise par 7
                res_ele(1, (i+5)/7) = 1;
            end

            if (Ele_B(j, :) == profil_binarise(1, (i:i+6)))
                res(1, (i+5)/7) = j-1;
                res_ele(1, (i+5)/7) = 2;
            end

            if (Ele_C(j, :) == profil_binarise(1, (i:i+6)))
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
end