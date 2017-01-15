%CIEVY
%Funkcia spracuje obrázok a vysegmentuje masku cievneho rieèiska
%Cievne rieèisko spojí s maskou okrajov
%Výstup tvorí binárna maska èastí, ktoré nepodliehajú segmentácií

function [ vysledok ] = cievy( Image )
%Cesta k pou¾itým funkciám
addpath(genpath('Cievy'));

%Funkcia segmentácie ciev
[GC, ATW, ATG, Vs, ATW2, VsM, dilateEdge] = FnTrackInit8(Image, 1);
cievy = FnTrack21(GC, VsM, dilateEdge);

hrany = bwareaopen(cievy, 400); %odstránim z obrazu ospojité blasti men¹ie ako 400pixelov

dilate = strel('line', 2, 90); %nastavenie diletaèného filtra
dilate_obr = imdilate(hrany, dilate); %aplikácia filtra

maska_okraje = Imfill(dilate_obr, 'holes');
maska_okraje_inv = ~maska_okraje; %invertovaný obraz

%Vyplnenie vnútorných èastí ciev
    regiony = maska_okraje & ~dilate_obr;
    velke_regiony = bwareaopen(regiony, 200);
    male_regiony = regiony & ~velke_regiony;
    bez_regionov = dilate_obr | male_regiony;
    
%Odstránenie ¹umu z obrazu
    sum = medfilt2(bez_regionov, [10 10], 'symmetric'); 
    segment_cievy = bwareaopen(sum, 15);
    
%Prekrytie masky pozadia s vysegmentovany cievnym rieciskom
    vysledok = segment_cievy | maska_okraje_inv;
    vysledok = im2bw(vysledok, 0.5);
    
%Zápis binárnych masiek do výsledkov
    imwrite(vysledok, 'Vysledky/glaukom_maska_cievy.jpg');
end

