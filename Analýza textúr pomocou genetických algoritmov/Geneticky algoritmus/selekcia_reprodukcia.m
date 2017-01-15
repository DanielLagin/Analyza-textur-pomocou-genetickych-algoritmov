%SELEKCIA A REPRODUKCIA
%Algoritmus vyselektuje jedincov do pr�slu�n�ch tried
%Pomocou turmanentu porovn� a vyberie lep��ch jedincov z porovn�van�ch dvoj�c
%Reproduk�ne pomocou dedenia vytvor� z otcov a matiek nov�ch jedincov
%Vytvor� nov� gener�ciu jedincov z rodi�ov a zmutovan�ch det�
%Cyklus opakuje, pokia� nedosiahnem podmienku maxim�lneho po�tu gener�ci� alebo
%nevyprodukuje ide�lneho jedinca, teda tak�ho , ktor�ho sila je maxim�lna.

%Vstupy funkcie okrem  in�ho menia ve�kos� popul�cie, po�et gener�ci� a
%parameter mut�cie, ktor� ur�uje ako moc sa zmen� jedinec po mut�ci�.

function [ vitaz, pocitadlo ] = selekcia_reprodukcia( jedinec, velkost_populacie, pocet_generacii, parameter_mutacie )
%Na��tanie tr�npvac�ch vzoriek, Inicializ�cia premenn�ch 
trenovacie_vzorky;
vitaz = chromozom(0, 0, 0); %vytvor�m pr�zdenho jedinca
pocitadlo = 1; %pocitadlo gene�cii

cakaj = waitbar(0,'�akajte pros�m, generuje sa najlep�� jedinec');
while (pocitadlo < pocet_generacii)
    %Inicializ�cia pr�zdnych pol� chromoz�mov
    for i = 1 : ((velkost_populacie / 100) * 20) 
        impotent(i) = chromozom(0, 0, 0); %20 percent jedincov zachov�vam v samostatnom poli
        otec(i) = chromozom(0, 0, 0); %20 percent jedincov bud� tvori� otcovia
        matka(i) = chromozom(0, 0, 0); %20 percent jedincov bud� tvori� matky
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40) 
        super_1(i) = chromozom(0, 0, 0); %40 percent jedincov tvoria s�peri jedn�ho t�mu
        super_2(i) = chromozom(0, 0, 0); %40 percent jedincov tvoria s�peri druh�ho t�mu
        rodic(i) = chromozom(0, 0, 0); %40 percent predstavuj� rodi�ia, teda otcovia a matky spolu
        dieta(i) = chromozom(0, 0, 0); %40 percent, rovnak� po�et bude aj potomkov
    end
    
    disp(['---------------------------' num2str(pocitadlo + 1) '. GENER�CIA--------------------------']);
    
    %Kv�zi n�hodnos� zabezpe��m poprehadzovan�m jedincov
    shuffle = randperm(velkost_populacie);
    jedinec = jedinec(shuffle); 
    
    %Pole jedincov rozdel�m do pol� obsahuj�cich z�pasn�kov a t�ch, ktor� nevstupuj� do selekcie 
    for i = 1 : ((velkost_populacie / 100) * 20)
        impotent(i) = jedinec(i);
        impotent(i).fitness = 0; %do dal�ej gener�cie bud� vstupova� s nulov�m fitness. Ohodnotia sa znova.
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40)
        super_1(i) = jedinec(i + ((velkost_populacie / 100) * 20));
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40)
        super_2(i) = jedinec(i + ((velkost_populacie / 100) * 60));
    end    
    
    %Kv�zi n�hodnos� v poliach vstupuj�cich do selekcie
    shuffle = randperm(((velkost_populacie / 100) * 40));
    super_1 = super_1(shuffle);
    shuffle = randperm(((velkost_populacie / 100) * 40));
    super_2 = super_2(shuffle);
    
    %Selekcia, porovnanie s�l s�perov. Vznikne nov� pole rodi�ov
    for i = 1 : ((velkost_populacie / 100) * 40)
        turnament(rodic(i), super_1(i), super_2(i));
        rodic(i).fitness = 0; %do dal�ej gener�cie bud� vstupova� s nulov�m fitness. Ohodnotia sa znova.
    end
    
    %Poprehazdujem rodi�ov a rozdel�m pole na otcov a matky
    shuffle = randperm(((velkost_populacie / 100) * 40));
    rodic = rodic(shuffle);
    
    for i = 1 : ((velkost_populacie / 100) * 20)
        otec(i) = rodic(i);
    end
    
    for i = 1 : ((velkost_populacie / 100) * 20)
        matka(i) = rodic(i + ((velkost_populacie / 100) * 20));
    end
    
    %Poprehazdujem polia otcov a matiek. Deden�m vytvor�m nov�ch jedincov
    %Proces opakujem dva kr�t, vytv�ram �al��ch jedincov z in�ch n�hodn�ch
    %dvoj�c. Rodi�ia sa navz�jom "podv�dzaj�".
    shuffle = randperm(((velkost_populacie / 100) * 20));
    otec = otec(shuffle);
    shuffle = randperm(((velkost_populacie / 100) * 20));
    matka = matka(shuffle);
    for i = 1 : ((velkost_populacie / 100) * 20)
        dedenie1(dieta(i), otec(i), matka(i));
    end
    
    shuffle = randperm(((velkost_populacie / 100) * 20));
    otec = otec(shuffle);
    shuffle = randperm(((velkost_populacie / 100) * 20));
    matka = matka(shuffle);
    for i = 1 : ((velkost_populacie / 100) * 20)
        dedenie(dieta(i + ((velkost_populacie / 100) * 20)), otec(i), matka(i));
    end
    
    %Nov�ch jedincov, deti podrob�m mut�ci�.
    for i = 1 : ((velkost_populacie / 100) * 40)
        mutacia(dieta(i), parameter_mutacie)
    end
    
    %Vynulujem pole jedincov, ktor� n�sledne napln�m rodi�mi, de�mi a
    %jedincami, ktor� nevstupovali do selekcie.
    %Po�et jedincov sa t�m p�dom zachov�va
    for i = 1 : velkost_populacie
        jedinec(i) = chromozom(0, 0, 0);       
    end
    
    for i = 1 : ((velkost_populacie / 100) * 20)
        jedinec(i) = impotent(i);
    end
    
    for i = (((velkost_populacie / 100) * 20) + 1) : ((velkost_populacie / 100) * 40)
        jedinec(i) = otec(i - ((velkost_populacie / 100) * 20));
    end
    
    for i = (((velkost_populacie / 100) * 40) + 1) : ((velkost_populacie / 100) * 60)
        jedinec(i) = matka(i - ((velkost_populacie / 100) * 40));
    end
    
    for i = (((velkost_populacie / 100) * 60) + 1) : velkost_populacie
        jedinec(i) = dieta(i - ((velkost_populacie / 100) * 60));
    end 
    
    %Novo vzniknutej popul�cii vynulujem hodnoty fitness. Jedince sa
    %n�sledne ohodnotia znova.
    for i = 1 : velkost_populacie
        jedinec(i).fitness = 0;
        waitbar(pocitadlo / velkost_populacie);
    end    

    for i = 1 : velkost_populacie              
        %Ohodnotenie v�etk�ch jedincov novej popul�cie
            hrany(jedinec(i), vzorka_1);
            hrany(jedinec(i), vzorka_2); 
            hrany(jedinec(i), vzorka_3);
            hrany(jedinec(i), vzorka_4); 
            hrany(jedinec(i), vzorka_5);
            hrany(jedinec(i), vzorka_6);
            hrany(jedinec(i), vzorka_7);
            hrany(jedinec(i), vzorka_8); 
            hrany(jedinec(i), vzorka_9);
            hrany(jedinec(i), vzorka_10);

            hrany(jedinec(i), vzorka_11);
            hrany(jedinec(i), vzorka_12); 
            hrany(jedinec(i), vzorka_13);
            hrany(jedinec(i), vzorka_14);
            hrany(jedinec(i), vzorka_15);
            hrany(jedinec(i), vzorka_16); 
            hrany(jedinec(i), vzorka_17);
            hrany(jedinec(i), vzorka_18);
            hrany(jedinec(i), vzorka_19);
            hrany(jedinec(i), vzorka_20);
            
            disp(jedinec(i));
            
        if jedinec(i).fitness == 20 %pokia� n�jdem najlep�ieho jedinca pred skon�en�m cyklu
            pocitadlo = pocet_generacii; %tak cyklus ukon��m
            vitaz = jedinec(i);
        end
    end
    pocitadlo = pocitadlo + 1;
end
close(cakaj);
 
%Pokial neexistuje ide�lny v�az, n�jdem jedinca s najv��ou fitness
for i = 1 : (velkost_populacie - 1)
    if jedinec(i).fitness > jedinec(i + 1).fitness
        jedinec(i + 1) = jedinec(i);
    end    
end
 
vitaz = jedinec(velkost_populacie); %posledn� jedinec v poli m� najv��iu fitness

disp('------------------------------VITAZ------------------------------');
disp('-----------------------------------------------------------------');
disp(vitaz); %zobraz�m najlep�ieho jedinca, jeho parametre a v�sledn� hodnotu fitness
disp('-------------------VITAZ BOL ULOZENY DO SUBORU-------------------');
end

