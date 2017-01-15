%SEGMENTÁCIA S POU®ITÍM PARAMTEROV VYGENEROVANÝCH GENETICKÝM ALGORITMOM

function [ output, maska_input, maska_hrany_input, maska_jas ] = geneticky_segmentacia( input, prah_podozrenie, prah_vypadok, krokovanie_hrany, prah_cievy, prah_vypadok_jas, krokovanie_jas, parameter_jasu )
%Naèítanie parametrov zo súboru najlepsi_jedinec.mat
load('Geneticky algoritmus/najlepsi_jedinec.mat', 'sigma_uloz', 'minimum_uloz', 'klasifikator_uloz');

sigma = str2double(sigma_uloz);
minimum = str2double(minimum_uloz);
klasifikator = str2double(klasifikator_uloz);

%Segmentácia pomocou detekcie hrán
[ maska_hrany_segmentacia, maska_hrany ] = hranova_segmentacia( input, sigma, minimum, klasifikator, prah_podozrenie, prah_vypadok, krokovanie_hrany )

maska_jas = jas_segmentacia(input, prah_cievy, prah_vypadok_jas, krokovanie_jas, parameter_jasu);

%Prekrytie masky_hrany a vstupného obrázka
red   = input;
green = input;
blue  = input;

red(maska_hrany)   = 0;
green(maska_hrany) = 0;
blue(maska_hrany)  = 255;

maska_hrany_input = cat(3, red, green, blue);

%Spracovanie masiek
[YY,XX,ZZ] = size(maska_hrany_segmentacia);
maska_input = imcrop(input,[1 1 (XX - 1) (YY - 1)]);
imwrite(maska_input, 'Vysledky/Segmentacia/glaukom_region_zaujmu.jpg');
maska_hrany_input = imcrop(maska_hrany_input,[1 1 (XX - 1) (YY - 1)]);
imwrite(maska_hrany_input, 'Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_hrany.jpg');
maska_jas = imcrop(maska_jas,[1 1 (XX - 1) (YY - 1)]);
imwrite(maska_jas, 'Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_jas.jpg');

imwrite(maska_hrany_segmentacia, 'Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_segmentacia.jpg');

%Transparetnos» a prekrytie masiek
prekrytie = imread('Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_jas.jpg');
vysledok = imread('Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_segmentacia.jpg');

jas = imagesc(prekrytie);
hold on;
output = imagesc(vysledok);
hold off;
axis image;
alpha(output, 0.3);

%Porovnanie
output = cat(2, maska_hrany_input, maska_hrany_segmentacia);
imwrite(output, 'Vysledky/Segmentacia/Geneticky segmentacia/glaukom_maska_segmentacia_porovnanie.jpg');

msgbox('Spracovanie prebehlo úsp¹ene','Detekcia');
end

