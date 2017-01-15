%CIEVY
%Funkcia spracuje obr�zok a vysegmentuje masku cievneho rie�iska
%Cievne rie�isko spoj� s maskou okrajov
%V�stup tvor� bin�rna maska �ast�, ktor� nepodliehaj� segment�ci�

function [ vysledok ] = cievy( Image )
%Cesta k pou�it�m funkci�m
addpath(genpath('Cievy'));

%Funkcia segment�cie ciev
[GC, ATW, ATG, Vs, ATW2, VsM, dilateEdge] = FnTrackInit8(Image, 1);
cievy = FnTrack21(GC, VsM, dilateEdge);

hrany = bwareaopen(cievy, 400); %odstr�nim z obrazu ospojit� blasti men�ie ako 400pixelov

dilate = strel('line', 2, 90); %nastavenie dileta�n�ho filtra
dilate_obr = imdilate(hrany, dilate); %aplik�cia filtra

maska_okraje = Imfill(dilate_obr, 'holes');
maska_okraje_inv = ~maska_okraje; %invertovan� obraz

%Vyplnenie vn�torn�ch �ast� ciev
    regiony = maska_okraje & ~dilate_obr;
    velke_regiony = bwareaopen(regiony, 200);
    male_regiony = regiony & ~velke_regiony;
    bez_regionov = dilate_obr | male_regiony;
    
%Odstr�nenie �umu z obrazu
    sum = medfilt2(bez_regionov, [10 10], 'symmetric'); 
    segment_cievy = bwareaopen(sum, 15);
    
%Prekrytie masky pozadia s vysegmentovany cievnym rieciskom
    vysledok = segment_cievy | maska_okraje_inv;
    vysledok = im2bw(vysledok, 0.5);
    
%Z�pis bin�rnych masiek do v�sledkov
    imwrite(vysledok, 'Vysledky/glaukom_maska_cievy.jpg');
end

