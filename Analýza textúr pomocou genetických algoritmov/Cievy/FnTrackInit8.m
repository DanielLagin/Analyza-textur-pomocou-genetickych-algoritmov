function [GreenChannel,AreaTrackingWhite,AreaTrackingGray,Vs,AreaTrackingWhite2,VsModif,dilateEdge] = FnTrackInit8(LS,Property) 
%Rôzne vstupy funckie, RGB, grayscale
if(Property == 1) %RGB
  I = imresize(LS, 1);
  IG = I(:, :, 2);  
elseif(Property == 2) %Grayscale
  IG = LS;
elseif(Property == 3) %RGB z intervalu 0..1
  IG = uint8(LS * 255);
end

edgeRetina = edge(IG, 'sobel', 0.15); %spracovanie hrán
se = strel('disk', 10);
dilateEdge = imdilate(edgeRetina, se);
GreenChannel = IG;


[baris, kolom] = size(IG);
[counts, x] = imhist(IG, 256);
bykPixel = baris * kolom;

%Tlow and Thigh poèítanie pixelov
TlowProsen = 0;
ThighProsen = 100;
jmlPixTlow = floor((TlowProsen/100) * bykPixel);
jmlPixThigh = bykPixel - ceil((ThighProsen/100) * bykPixel);

jmlPix = 0;
index1 = 1;
while(jmlPix < jmlPixTlow)
    jmlPix = jmlPix+counts(index1);
    index1 = index1 + 1;
end
TlowI = x(index1);

%poèítanie z opaènej strany spracovávaného obrazu
jmlPix = 0;
index2 = 256;
while(jmlPix < jmlPixThigh)
    jmlPix = jmlPix + counts(index2);
    index2 = index2 - 1;
end
ThighI = x(index2);

%Inicializácia matice
IG_1 = zeros(baris, kolom);
IG_2 = IG;
IG_3 = zeros(baris, kolom);

% Definícia då¾ky ciev
Vs = find(IG <= ThighI & IG >= TlowI); 
elseVs1 = find(IG < TlowI); 
elseVs2 = find(IG > ThighI);
IG_1(Vs) = IG_1(Vs) + 1;

IG_2(elseVs1) = IG_2(elseVs1) * 0; 
IG_2(elseVs2) = IG_2(elseVs2) * 0;

AreaTrackingWhite = IG_1;
AreaTrackingGray = IG_2;

VsModif = Vs;

IG_3(VsModif) = IG_3(VsModif) + 1;
AreaTrackingWhite2 = IG_3;