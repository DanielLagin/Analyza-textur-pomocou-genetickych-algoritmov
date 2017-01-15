%PREDSPRACOVANIE
%Prevedie obr�zok do �edot�novej formy, zv�razn� hrany, vyrovn� jas
%Zabezpe�en� je selekcia oblasti z�ujmu
%Segment�cia cievneho rie�iska

function [ region ] = predspracovanie( Image, maska )
%Zv�raznenie oblast� staty ��hania sietnice
[XX,YY,ZZ] = size(Image);

upraveny = zeros(XX,YY,ZZ);
upraveny = uint8(upraveny);

upraveny(:,:,1) = round(Image(:,:,3) / 2 + Image(:,:,2) / 2);
upraveny(:,:,2) = upraveny(:,:,1);
upraveny(:,:,3) = upraveny(:,:,1);

dim = ndims(upraveny);
if(dim == 3)
    %Image je farebn� obr�zok, prevediem do �edot�nov�ho
    gray = uint8(zeros(size(upraveny, 1), size(upraveny, 2)));

    for i = 1 : size(upraveny, 1)
      for j = 1 : size(upraveny, 2)
          gray(i, j)=0.2989 * upraveny(i, j, 1)+0.5870 * upraveny(i, j, 2)+0.1140 * upraveny(i, j, 3);
      end
    end
    gray = 0.2989 * upraveny(:,:,1) + 0.5870 * upraveny(:,:,2) + 0.1140 * upraveny(:,:,3);
else
    %Image je �edot�nov� obr�zok
    gray = upraveny;
end

%Zobrazenie obr�zkov
figure('units','normalized','outerposition',[0 0 1 1]), title('Sn�mka o�nej sietnice');
set(gcf, 'name', 'Retinal Images');

%Zobrazenie a ulo�enie upraven�ho obr�zka
imwrite(gray, 'Vysledky/glaukom_gray.jpg');

%Vymaskovanie cievneho rie�iska sietnice
cievy_maska = maska;
vymaskovane = gray;
vymaskovane(cievy_maska) = 0;

%Zobrazenie vstupn�ho obr�zka
imshow(vymaskovane, []), title('Pros�m ur�te my�ou regi�n z�ujmu');
imwrite(vymaskovane, 'Vysledky/glaukom_cievy_vymaskovane_okolie.jpg');

%Do s�boru zap�em aj vysegmentovan� cievy
vymaskovane_cievy = gray;
vymaskovane_cievy(~cievy_maska) = 0;
imwrite(vymaskovane_cievy, 'Vysledky/glaukom_cievy_vymaskovane_cievy.jpg');

%V�ber oblasti z�ujmu vo�nou rukou
    %maska_vyrez = roipoly(vymaskovane);
    %region = vymaskovane;
    %region(~maska_vyrez) = 0;
    %imwrite(region, 'Vysledky/glaukom_region_zaujmu.jpg');

%V�ber oblasti pre anal�zu d�t
region = imcrop(vymaskovane);
end
