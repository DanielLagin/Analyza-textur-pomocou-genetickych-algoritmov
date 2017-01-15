%SEGMENTACIA POMOCOU HODNOTENIA JASU
%Porovnávacia funkcia
%Vyhodnotí po¹kodenie výseku na základe priemerného jasu a stanoveného
%prahu výpadku

function [ output] = jas_segmentacia( input, prah_cievy, prah_vypadok, krokovanie, parameter_jasu )
%Kontrólny mechanizmus, ujistím sa, ¾e obrázok je ¹edotónový
dim = ndims(input);
if(dim == 3)
    input = rgb2gray(input);
end

[X,Y] = size(input);

%Poèet pixelov cievneho rieèiska
white = sum(input(:));
black = numel(input) - white;

%Nastavenie parametrov segment?cie
parameter_jas = parameter_jasu;
jas_krokovanie = krokovanie;
velkost_okna = 4;

%Priemerovanie jasu v obraze
sucet_bodov = sum(input(:));
cievy_body  = (0 - black);
jas_priemer = sucet_bodov / cievy_body;
bod_priemer = zeros(100,100);

cakaj = waitbar(0,'Èakajte prosím, prebieha analýza');
for i = velkost_okna : jas_krokovanie : X - velkost_okna
    for j = velkost_okna : jas_krokovanie : Y - velkost_okna
        bod_priemer(i, j) = sum(sum(input(i -  parameter_jas : i + parameter_jas, j - parameter_jas : j + parameter_jas))) / (parameter_jas * 2 * parameter_jas * 2);
        %1. OBLAS« - ZDRAVÉ TKANIVO - OZNAÈÍM ZELENOU
        if bod_priemer(i,j) > (jas_priemer * prah_vypadok)
            segmentacia_maska(i + 1, j + 1, 1) = 0; 
            segmentacia_maska(i + 1, j + 1, 2) = 255; 
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        %2. OBLAS« - CIEVY - OZNAÈÍM MODROU
        elseif bod_priemer(i,j) < (jas_priemer * prah_cievy)
            segmentacia_maska(i + 1, j + 1, 1) = 0;
            segmentacia_maska(i + 1, j + 1, 2) = 0;
            segmentacia_maska(i + 1, j + 1, 3) = 255;
        %1. OBLAS« - CHORÉ TKANIVO - OZNAÈÍM ÈERVENOU
        else
            segmentacia_maska(i + 1, j + 1, 1) = 255;
            segmentacia_maska(i + 1, j + 1, 2) = 0;
            segmentacia_maska(i + 1, j + 1, 3) = 0;
        end
    end
    waitbar(i / j);
end
close(cakaj);

%Výstupná maska
[YY,XX] = size(segmentacia_maska);
output = imcrop(segmentacia_maska,[velkost_okna velkost_okna XX YY]);
end

