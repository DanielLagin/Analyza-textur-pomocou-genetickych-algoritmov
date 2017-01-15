%SEGMENTACIA POMOCOU HRANOVEJ REPREZENTÁCIE
%Aplikuje hranovu segmentaciu na cely obsah regionu zaujmu
%Vysegmentuje detegovane oblasti do 4 tried

function [ output, maska] = hranova_segmentacia( input, sigma, minimum, klasifikator, prah_podozrenie, prah_vypadok, krokovanie )
%Kontrólny mechanizmus, ujistím sa, ¾e je obraz ¹edotónový
dim = ndims(input);
if(dim == 3)
    input = rgb2gray(input);
end

%Nastavenie vstupných hodnôt segmentácie
glaukom_prah_podozrenia = prah_podozrenie / 100; 
glaukom_prah_vypadku = prah_vypadok / 100; 
glaukom_prah_zdrave = klasifikator;

%PARAMETRE ALGORITMU
maska_krokovanie = krokovanie;
velkost_okna = 64;
[X,Y] = size(input);

hrany = edge(input, 'log', 0.0007, sigma); %hranová reprezentácia LOG
hrany = bwareaopen(hrany, minimum); %odstránenie hrán men¹ích ako minimal
maska = hrany;

maska_pixle = (velkost_okna * velkost_okna) / maska_krokovanie; %veµkos» oblasti
oblast_pocet_hran = zeros(maska_pixle, maska_pixle);

cakaj = waitbar(0,'Èakajte prosím, prebieha analýza');
%Cyklus segmentácie
for i = 1 : maska_krokovanie : X - velkost_okna
    for j = 1 : maska_krokovanie : Y - velkost_okna
        oblast = hrany(i : i + velkost_okna, j : j + velkost_okna); %aplikácia hranového klasifikátora na oblas» záujmu
        oblast_pocet_hran(i, j) = sum(oblast(:)); %poèet hranových pixelov
        %1. OBLAS« - ZDRAVÉ TKANIVO - OZNAÈÍM ZELENOU
        if oblast_pocet_hran(i, j) > glaukom_prah_zdrave
            segmentacia_maska(i + 1, j + 1, 1) = 0;
            segmentacia_maska(i + 1, j + 1, 2) = 255;
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        end
        %2. OBLAS« - ZACHOVANÉ TKANIVO - OZNAÈÍM ®LTO - ZELENOU
        if oblast_pocet_hran(i, j) > (glaukom_prah_zdrave * glaukom_prah_podozrenia) && oblast_pocet_hran(i, j) < glaukom_prah_zdrave
            segmentacia_maska(i + 1, j + 1, 1) = 200;
            segmentacia_maska(i + 1, j + 1, 2) = 255;
            segmentacia_maska(i + 1, j + 1, 3) = 100;
        end
        %3. OBLAS« - CHORÉ TKANIVO - OZNAÈÍM ÈERVENOU
        if oblast_pocet_hran(i, j) < (glaukom_prah_zdrave * (glaukom_prah_podozrenia * glaukom_prah_vypadku))
            segmentacia_maska(i + 1, j + 1, 1) = 255; 
            segmentacia_maska(i + 1, j + 1, 2) = 0; 
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        end
        %3. OBLAS« - CHORÉ TKANIVO - OZNAÈÍM BIELOU
        if oblast_pocet_hran(i, j) > (glaukom_prah_zdrave * (glaukom_prah_podozrenia * glaukom_prah_vypadku)) && oblast_pocet_hran(i, j) < (glaukom_prah_zdrave * glaukom_prah_podozrenia)
            segmentacia_maska(i + 1, j + 1, 1) = 255;
            segmentacia_maska(i + 1, j + 1, 2) = 100;
            segmentacia_maska(i + 1, j + 1, 3) = 100;
        end
    end
    waitbar(i / j);
end
close(cakaj);
output = segmentacia_maska;
end

