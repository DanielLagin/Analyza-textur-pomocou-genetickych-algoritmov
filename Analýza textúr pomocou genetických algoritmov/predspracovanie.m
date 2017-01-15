%PREDSPRACOVANIE
%Prevedie obrázok do ¹edotónovej formy, zvýrazní hrany, vyrovná jas
%Zabezpeèená je selekcia oblasti záujmu
%Segmentácia cievneho rieèiska

function [ region ] = predspracovanie( Image, maska )
%Zvýraznenie oblastí staty ¾íhania sietnice
[XX,YY,ZZ] = size(Image);

upraveny = zeros(XX,YY,ZZ);
upraveny = uint8(upraveny);

upraveny(:,:,1) = round(Image(:,:,3) / 2 + Image(:,:,2) / 2);
upraveny(:,:,2) = upraveny(:,:,1);
upraveny(:,:,3) = upraveny(:,:,1);

dim = ndims(upraveny);
if(dim == 3)
    %Image je farebný obrázok, prevediem do ¹edotónového
    gray = uint8(zeros(size(upraveny, 1), size(upraveny, 2)));

    for i = 1 : size(upraveny, 1)
      for j = 1 : size(upraveny, 2)
          gray(i, j)=0.2989 * upraveny(i, j, 1)+0.5870 * upraveny(i, j, 2)+0.1140 * upraveny(i, j, 3);
      end
    end
    gray = 0.2989 * upraveny(:,:,1) + 0.5870 * upraveny(:,:,2) + 0.1140 * upraveny(:,:,3);
else
    %Image je ¹edotónový obrázok
    gray = upraveny;
end

%Zobrazenie obrázkov
figure('units','normalized','outerposition',[0 0 1 1]), title('Snímka oènej sietnice');
set(gcf, 'name', 'Retinal Images');

%Zobrazenie a ulo¾enie upraveného obrázka
imwrite(gray, 'Vysledky/glaukom_gray.jpg');

%Vymaskovanie cievneho rieèiska sietnice
cievy_maska = maska;
vymaskovane = gray;
vymaskovane(cievy_maska) = 0;

%Zobrazenie vstupného obrázka
imshow(vymaskovane, []), title('Prosím urète my¹ou región záujmu');
imwrite(vymaskovane, 'Vysledky/glaukom_cievy_vymaskovane_okolie.jpg');

%Do súboru zapí¹em aj vysegmentované cievy
vymaskovane_cievy = gray;
vymaskovane_cievy(~cievy_maska) = 0;
imwrite(vymaskovane_cievy, 'Vysledky/glaukom_cievy_vymaskovane_cievy.jpg');

%Výber oblasti záujmu voµnou rukou
    %maska_vyrez = roipoly(vymaskovane);
    %region = vymaskovane;
    %region(~maska_vyrez) = 0;
    %imwrite(region, 'Vysledky/glaukom_region_zaujmu.jpg');

%Výber oblasti pre analýzu dát
region = imcrop(vymaskovane);
end
