%SELEKCIA A REPRODUKCIA
%Algoritmus vyselektuje jedincov do príslu¹ných tried
%Pomocou turmanentu porovná a vyberie lep¹ích jedincov z porovnávaných dvojíc
%Reprodukène pomocou dedenia vytvorí z otcov a matiek nových jedincov
%Vytvorí novú generáciu jedincov z rodièov a zmutovaných detí
%Cyklus opakuje, pokiaµ nedosiahnem podmienku maximálneho poètu generácií alebo
%nevyprodukuje ideálneho jedinca, teda takého , ktorého sila je maximálna.

%Vstupy funkcie okrem  iného menia veµkos» populácie, poèet generácií a
%parameter mutácie, ktorý urèuje ako moc sa zmení jedinec po mutácií.

function [ vitaz, pocitadlo ] = selekcia_reprodukcia( jedinec, velkost_populacie, pocet_generacii, parameter_mutacie )
%Naèítanie trénpvacích vzoriek, Inicializácia premenných 
trenovacie_vzorky;
vitaz = chromozom(0, 0, 0); %vytvorím prázdenho jedinca
pocitadlo = 1; %pocitadlo geneácii

cakaj = waitbar(0,'Èakajte prosím, generuje sa najlep¹í jedinec');
while (pocitadlo < pocet_generacii)
    %Inicializácia prázdnych polí chromozómov
    for i = 1 : ((velkost_populacie / 100) * 20) 
        impotent(i) = chromozom(0, 0, 0); %20 percent jedincov zachovávam v samostatnom poli
        otec(i) = chromozom(0, 0, 0); %20 percent jedincov budú tvori» otcovia
        matka(i) = chromozom(0, 0, 0); %20 percent jedincov budú tvori» matky
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40) 
        super_1(i) = chromozom(0, 0, 0); %40 percent jedincov tvoria súperi jedného tímu
        super_2(i) = chromozom(0, 0, 0); %40 percent jedincov tvoria súperi druhého tímu
        rodic(i) = chromozom(0, 0, 0); %40 percent predstavujú rodièia, teda otcovia a matky spolu
        dieta(i) = chromozom(0, 0, 0); %40 percent, rovnaký poèet bude aj potomkov
    end
    
    disp(['---------------------------' num2str(pocitadlo + 1) '. GENERÁCIA--------------------------']);
    
    %Kvázi náhodnos» zabezpeèím poprehadzovaním jedincov
    shuffle = randperm(velkost_populacie);
    jedinec = jedinec(shuffle); 
    
    %Pole jedincov rozdelím do polí obsahujúcich zápasníkov a tých, ktorý nevstupujú do selekcie 
    for i = 1 : ((velkost_populacie / 100) * 20)
        impotent(i) = jedinec(i);
        impotent(i).fitness = 0; %do dal¹ej generácie budú vstupova» s nulovým fitness. Ohodnotia sa znova.
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40)
        super_1(i) = jedinec(i + ((velkost_populacie / 100) * 20));
    end
    
    for i = 1 : ((velkost_populacie / 100) * 40)
        super_2(i) = jedinec(i + ((velkost_populacie / 100) * 60));
    end    
    
    %Kvázi náhodnos» v poliach vstupujúcich do selekcie
    shuffle = randperm(((velkost_populacie / 100) * 40));
    super_1 = super_1(shuffle);
    shuffle = randperm(((velkost_populacie / 100) * 40));
    super_2 = super_2(shuffle);
    
    %Selekcia, porovnanie síl súperov. Vznikne nové pole rodièov
    for i = 1 : ((velkost_populacie / 100) * 40)
        turnament(rodic(i), super_1(i), super_2(i));
        rodic(i).fitness = 0; %do dal¹ej generácie budú vstupova» s nulovým fitness. Ohodnotia sa znova.
    end
    
    %Poprehazdujem rodièov a rozdelím pole na otcov a matky
    shuffle = randperm(((velkost_populacie / 100) * 40));
    rodic = rodic(shuffle);
    
    for i = 1 : ((velkost_populacie / 100) * 20)
        otec(i) = rodic(i);
    end
    
    for i = 1 : ((velkost_populacie / 100) * 20)
        matka(i) = rodic(i + ((velkost_populacie / 100) * 20));
    end
    
    %Poprehazdujem polia otcov a matiek. Dedením vytvorím nových jedincov
    %Proces opakujem dva krát, vytváram ïal¹ích jedincov z iných náhodných
    %dvojíc. Rodièia sa navzájom "podvádzajú".
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
    
    %Nových jedincov, deti podrobím mutácií.
    for i = 1 : ((velkost_populacie / 100) * 40)
        mutacia(dieta(i), parameter_mutacie)
    end
    
    %Vynulujem pole jedincov, ktoré následne naplním rodièmi, de»mi a
    %jedincami, ktoré nevstupovali do selekcie.
    %Poèet jedincov sa tým pádom zachováva
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
    
    %Novo vzniknutej populácii vynulujem hodnoty fitness. Jedince sa
    %následne ohodnotia znova.
    for i = 1 : velkost_populacie
        jedinec(i).fitness = 0;
        waitbar(pocitadlo / velkost_populacie);
    end    

    for i = 1 : velkost_populacie              
        %Ohodnotenie v¹etkých jedincov novej populácie
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
            
        if jedinec(i).fitness == 20 %pokiaµ nájdem najlep¹ieho jedinca pred skonèením cyklu
            pocitadlo = pocet_generacii; %tak cyklus ukonèím
            vitaz = jedinec(i);
        end
    end
    pocitadlo = pocitadlo + 1;
end
close(cakaj);
 
%Pokial neexistuje ideálny ví»az, nájdem jedinca s najväè¹ou fitness
for i = 1 : (velkost_populacie - 1)
    if jedinec(i).fitness > jedinec(i + 1).fitness
        jedinec(i + 1) = jedinec(i);
    end    
end
 
vitaz = jedinec(velkost_populacie); %posledný jedinec v poli má najväè¹iu fitness

disp('------------------------------VITAZ------------------------------');
disp('-----------------------------------------------------------------');
disp(vitaz); %zobrazím najlep¹ieho jedinca, jeho parametre a výslednú hodnotu fitness
disp('-------------------VITAZ BOL ULOZENY DO SUBORU-------------------');
end

