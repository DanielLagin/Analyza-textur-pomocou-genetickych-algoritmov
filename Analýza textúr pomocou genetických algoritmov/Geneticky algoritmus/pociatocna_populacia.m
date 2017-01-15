%PO�IATO�N� POPUL�CIA
%Pomocou vstupov m��em nastavi� ve�kos� popul�cie a hrani�n� parametre
%jedincov genetick�ho algoritmu

function [ jedinec ] = pociatocna_populacia( velkost_populacie, sigma_max, minimum_max, klasifikator_max )
%Na��tam tr�novacie vzorky
trenovacie_vzorky;

disp('-----------------------PO�IATO�N� POPUL�CIA----------------------');
disp('--------------------------1. GENER�CIA---------------------------');

for i = 1 : velkost_populacie
    jedinec(i) = chromozom(sigma_max, minimum_max, klasifikator_max); %nastavenie hrani�n�ch parametrov jedincov
                    
    %Ohodnotenie v�etk�ch chromoz�mov
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

    
    disp(jedinec(i)); %v�pis ohodnoten�ch jedincov po�iato�nej popul�cie
end
end

