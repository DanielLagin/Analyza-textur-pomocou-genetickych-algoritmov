%SEGMENTACIA POMOCOU HRANOVEJ REPREZENT�CIE
%Aplikuje hranovu segmentaciu na cely obsah regionu zaujmu
%Vysegmentuje detegovane oblasti do 4 tried

function [ output, maska] = hranova_segmentacia( input, sigma, minimum, klasifikator, prah_podozrenie, prah_vypadok, krokovanie )
%Kontr�lny mechanizmus, ujist�m sa, �e je obraz �edot�nov�
dim = ndims(input);
if(dim == 3)
    input = rgb2gray(input);
end

%Nastavenie vstupn�ch hodn�t segment�cie
glaukom_prah_podozrenia = prah_podozrenie / 100; 
glaukom_prah_vypadku = prah_vypadok / 100; 
glaukom_prah_zdrave = klasifikator;

%PARAMETRE ALGORITMU
maska_krokovanie = krokovanie;
velkost_okna = 64;
[X,Y] = size(input);

hrany = edge(input, 'log', 0.0007, sigma); %hranov� reprezent�cia LOG
hrany = bwareaopen(hrany, minimum); %odstr�nenie hr�n men��ch ako minimal
maska = hrany;

maska_pixle = (velkost_okna * velkost_okna) / maska_krokovanie; %ve�kos� oblasti
oblast_pocet_hran = zeros(maska_pixle, maska_pixle);

cakaj = waitbar(0,'�akajte pros�m, prebieha anal�za');
%Cyklus segment�cie
for i = 1 : maska_krokovanie : X - velkost_okna
    for j = 1 : maska_krokovanie : Y - velkost_okna
        oblast = hrany(i : i + velkost_okna, j : j + velkost_okna); %aplik�cia hranov�ho klasifik�tora na oblas� z�ujmu
        oblast_pocet_hran(i, j) = sum(oblast(:)); %po�et hranov�ch pixelov
        %1. OBLAS� - ZDRAV� TKANIVO - OZNA��M ZELENOU
        if oblast_pocet_hran(i, j) > glaukom_prah_zdrave
            segmentacia_maska(i + 1, j + 1, 1) = 0;
            segmentacia_maska(i + 1, j + 1, 2) = 255;
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        end
        %2. OBLAS� - ZACHOVAN� TKANIVO - OZNA��M �LTO - ZELENOU
        if oblast_pocet_hran(i, j) > (glaukom_prah_zdrave * glaukom_prah_podozrenia) && oblast_pocet_hran(i, j) < glaukom_prah_zdrave
            segmentacia_maska(i + 1, j + 1, 1) = 200;
            segmentacia_maska(i + 1, j + 1, 2) = 255;
            segmentacia_maska(i + 1, j + 1, 3) = 100;
        end
        %3. OBLAS� - CHOR� TKANIVO - OZNA��M �ERVENOU
        if oblast_pocet_hran(i, j) < (glaukom_prah_zdrave * (glaukom_prah_podozrenia * glaukom_prah_vypadku))
            segmentacia_maska(i + 1, j + 1, 1) = 255; 
            segmentacia_maska(i + 1, j + 1, 2) = 0; 
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        end
        %3. OBLAS� - CHOR� TKANIVO - OZNA��M BIELOU
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

